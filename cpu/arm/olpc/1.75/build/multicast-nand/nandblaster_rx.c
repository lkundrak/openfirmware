/*
 * Multicast-wireless NAND reflash program.  This file implements the
 * core receive algorithm in a system-independent way.
 *
 * Copyright © 2007 David Woodhouse
 * Copyright © 2008 Mitch Bradley
 *
 * This code is an adaptation of rx_image.c from
 * git://git.infradead.org/mtd-utils.git , originally written by David
 * Woodhouse .  Mitch Bradley adapted it, retaining the algorithm and
 * most of the code, but factoring the OS dependencies into separate
 * functions.  The OS-dependent code is implemented in separate files -
 * rx_linux.c contains the Linux-dependent code from rx_image.c , while
 * rx_ofw.c contains Open Firmware client interface versions of those
 * routines.  The NAND Flash addressing was changed from byte addresses
 * to page addresses, paving the way for NAND devices larger than 4 GiB.
 *
 * reflash() rewrites the OLPC NAND Flash via wireless multicast.
 * It assumes that a server is continuously multicasting the NAND
 * image with forward error correction so that missed packets don't
 * require waiting until the block comes around again.  reflash()
 * must be called from an externally-defined main() routine that
 * opens the network and Flash access channels.
 */

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "crc32.h"
#include "mcast_image.h"
#include "partition.h"
#include "io.h"

static int create_block_map(int zdata_mode);

static int collect_placement_spec(struct image_pkt *spkt, int placement, int zdata_mode, char **specadr, int *speclen);
static int map_partitions(struct partition_map_spec *want);
static void alloc_partition_arrays(int nr_partitions);
static int parse_placement_partitions(char *placement_spec, size_t placement_spec_len);
static int parse_partitions(char *line, char *lineend, struct partition_map_spec *want);
static void show_partitions(struct partition_map_spec *want);
static int find_partition(char *name, char *nameend, struct partition_map_spec *want);
static char *parse_line(char *p, char *pend, char **line, char **lineend);
static char *parse_word(char *line, char *lineend, char **cmd, char **cmdend);
static int confirm_overwrite(void);
static int flash_partitions_incompatible(struct partition_map_spec *want);
static int next_hash_mismatch(char *buf, size_t len);
static void start_parser(char *spec, size_t spec_len);

uint32_t ntohl(uint32_t n);
uint32_t htonl(uint32_t n);
uint16_t ntohs(uint16_t n);
uint16_t htons(uint16_t n);

#define min(x,y) (  (x)>(y)?(y):(x) )

/* Per-eraseblock data structure to track the data reception progress */

int wbuf_size;	// 16K is a "sweet spot" granularity for the XO-1.5's SD cards

struct eraseblock {
	uint32_t flash_page;
	unsigned char *wbuf;
	int wbuf_ofs;
	int nr_pkts;
	uint32_t crc;
};
int *pkt_indices;

/* Information about the incoming block sequence*/
int *partition_block_limit = NULL; /* Partition breaks in the incoming block sequence */

/* Information about partitions as they exist on the NAND we're writing */
int nr_partitions = 0;
int *partition_start = NULL;  /* First block numbers of NAND partitions */
int *partition_end   = NULL;  /* Limit block numbers of NAND partitions */
int *partition_next  = NULL;  /* Next unused block numbers of NAND partitions */
int *partition_flags = NULL;  /* Partition flags */


struct eraseblock *eraseblocks = NULL;  /* Array of */
unsigned char *wbufs;			/* Storage for partial blocks */
uint32_t this_block = 0;
int partition_nr = 0;
int nr_blocks = 0;
int pages_per_block;

unsigned char *staging_wbuf;

int reflash(int flash_erasesize, int flash_pagesize, uint32_t flash_nblocks, int secure, int write_size, char **specadr, int *speclen)
{
	size_t len;
	unsigned char *eb_buf, *decode_buf, **src_pkts;
	int pages_per_wbuf;
	int pkts_per_block;
	uint32_t block_nr;
	uint32_t image_crc = 0;
	int total_pkts = 0;
	int ignored_pkts = 0;
	int badcrcs = 0;
	int duplicates = 0;
	struct fec_parms *fec = NULL;
	int i;
	uint32_t last_seq = 0, this_seq = 0, missed_pkts = 0;
	unsigned long fec_time = 0, flash_time = 0, crc_time = 0,
		rflash_time = 0, erase_time = 0, net_time = 0;
	struct image_pkt thispkt;
	uint32_t current_block_nr = 0xffffffff;
	int mode = 0;
	int placement_collected = 0;
	uint32_t shown_block;

	wbuf_size = write_size;
	pages_per_wbuf = wbuf_size/flash_pagesize;
	pages_per_block = flash_erasesize / flash_pagesize;

	pkts_per_block = (flash_erasesize + PKT_SIZE - 1) / PKT_SIZE;

	eb_buf = checked_malloc(pkts_per_block * PKT_SIZE, "eb_buf");
	decode_buf = checked_malloc(pkts_per_block * PKT_SIZE, "decode_buf");
	src_pkts = checked_malloc(sizeof(unsigned char *) * pkts_per_block, "decode packet pointers");

	printf("Waiting for server\r");
	while (1) {
		len = get_packet((unsigned char *)&thispkt, sizeof(thispkt));

		if (len < 0)
			break;

//		if (len < sizeof(thispkt))
//			continue;

		mode = ntohl(thispkt.hdr.mode);

		if (secure && ((mode & PLACEMENT_MODE) == 0)) {
			printf("\nSecure receiver, non-secure sender\n\n");
			return 1;
		}

		if (mode & PLACEMENT_SPEC) {	/* This packet contains placement/security info */
			if (placement_collected)
				continue;	/* Already acquired the security spec */

			placement_collected = collect_placement_spec(&thispkt, secure, mode & ZDATA_MODE, specadr, speclen);
			if (placement_collected < 0)
				return 1;
			if (placement_collected)
				partition_end[0] = flash_nblocks;
			continue;
		}

		/* In non-ZDATA mode, the placement spec determines the locations of the */
		/* data blocks, so we must collect the entire spec before any blocks. */
		/* In ZDATA mode, the placement spec contains only security information */
		/* which is used after block expansion, so we may collect the spec incrementally */
		if ((mode & PLACEMENT_MODE) && !(mode & ZDATA_MODE) && !placement_collected)
			continue;

		if (mode & PARTITION_SPEC) {
			if (partition_start)
				continue;	/* Already processed a partition spec */

			if (map_partitions((struct partition_map_spec *)&thispkt.data))
				return 1;
			continue;
		}

		if ((mode & PARTITION_MODE) && !partition_start)
			continue;	/* Wait until we have a partition spec */

                // This clause is executed once to initialize things
		if (!eraseblocks) {
			image_crc = ntohl(thispkt.hdr.totcrc);

			if (flash_erasesize != ntohl(thispkt.hdr.blocksize)) {
				printf("Erasesize mismatch (0x%x not 0x%x)\n",
					ntohl(thispkt.hdr.blocksize), flash_erasesize);
				return 1;
			}
			nr_blocks = ntohl(thispkt.hdr.nr_blocks);

			if (!partition_start) {
				alloc_partition_arrays(0);
				partition_start[0] = 0;
				partition_end[0] = flash_nblocks;
				partition_block_limit[0] = nr_blocks;
				partition_flags[0] = mode;
			}

			if (nr_blocks > partition_block_limit[nr_partitions]) {
				printf("Placement spec has too few eblock lines for the transmitted data\n");
				return 1;
			}
			printf("Expecting %d blocks, %d total packets (%d ppb)\n", nr_blocks, nr_blocks * pkts_per_block, pkts_per_block);

			if (create_block_map((mode & ZDATA_MODE) != 0))
				return 1;

			partition_next[partition_nr] = this_block;

			if (partition_flags[partition_nr] & CLEANMARKERS_MODE)
				for( ; this_block < partition_end[partition_nr]; this_block++)
					show_state(block_bad(this_block) ? BAD : WILL_CLEAN, this_block);

			for( ; this_block < flash_nblocks; this_block++)
				show_state(LEAVE_ALONE, this_block);

			pkt_indices = checked_malloc(sizeof(int) * pkts_per_block * nr_blocks, "packet indices");
			mark_time();
			last_seq = ntohl(thispkt.hdr.pkt_sequence);
//                        continue;
		}


		block_nr = ntohl(thispkt.hdr.block_nr);
		if (block_nr >= nr_blocks) {
			printf("\nErroneous block_nr %d (> %d)\n", block_nr, nr_blocks);
			return 1;
		}
 
		if ((mode & BLOCK_MODE) && (current_block_nr != block_nr)) {
			if (current_block_nr != 0xffffffff) {
				int need = pkts_per_block - eraseblocks[current_block_nr].nr_pkts;
#ifdef notdef_text
				if (need > 0)
					printf(" need %d\n", need);
#endif
				shown_block = eraseblocks[current_block_nr].flash_page / pages_per_block;
				if (need <= 0)
					show_state(READY, shown_block-1);
				else
					show_state(PARTIAL, shown_block);
			}
			current_block_nr = block_nr;
			shown_block = eraseblocks[current_block_nr].flash_page / pages_per_block;
			if (eraseblocks[current_block_nr].nr_pkts == pkts_per_block)
				shown_block--;
			highlight_flash_block(shown_block);

//			if (kbhit())
//				return 1;

//			int miss_percent;
//			miss_percent = missed_pkts * 100 / total_pkts;
//			if (miss_percent > 3)
//				printf("\r%04d %d%% miss",block_nr,miss_percent);
//			else
#ifdef notdef_text
			printf("\r%04d", block_nr);
#endif
		}

                /* Determine the number of missed packets */
		this_seq = ntohl(thispkt.hdr.pkt_sequence);
		if (this_seq > (last_seq + 1))
			missed_pkts += this_seq - (last_seq + 1);
		last_seq = this_seq;

		if (image_crc) {
			if (image_crc != ntohl(thispkt.hdr.totcrc)) {
				printf("\nImage CRC changed from 0x%x to 0x%x. Aborting\n",
				       ntohl(image_crc), ntohl(thispkt.hdr.totcrc));
				return 1;
			}
		} else {
			/* Some senders wait until the second sending pass */
			/* to send the overall CRC, because they don't know it yet */
			image_crc = ntohl(thispkt.hdr.totcrc);
		}

		for (i=0; i<eraseblocks[block_nr].nr_pkts; i++) {
			if (pkt_indices[block_nr * pkts_per_block + i] == ntohs(thispkt.hdr.pkt_nr)) {
#ifdef notdef
				printf("Discarding duplicate packet at block %d pkt %d nr_pkts %d\n",
				       block_nr, pkt_indices[block_nr * pkts_per_block + i],
				       eraseblocks[block_nr].nr_pkts
);
#endif
				duplicates++;
				break;
			}
		}
		if (i < eraseblocks[block_nr].nr_pkts)
			continue;

		if (eraseblocks[block_nr].nr_pkts >= pkts_per_block) {
			/* We have a block which we didn't really need */
			eraseblocks[block_nr].nr_pkts++;
			ignored_pkts++;
			continue;
		}

		if (crc32(-1, thispkt.data, PKT_SIZE) != ntohl(thispkt.hdr.thiscrc)) {
#ifdef notdef
			printf("\nDiscard %08x pkt %d with bad CRC (%08x not %08x)\n",
			       block_nr * flash_erasesize, ntohs(thispkt.hdr.pkt_nr),
			       crc32(-1, thispkt.data, PKT_SIZE),
			       ntohl(thispkt.hdr.thiscrc));
#endif
			badcrcs++;
			continue;
		}
	pkt_again:
		pkt_indices[block_nr * pkts_per_block + (eraseblocks[block_nr].nr_pkts++)] =
			ntohs(thispkt.hdr.pkt_nr);
		total_pkts++;

		/* Shouldn't happen ... */
		if (total_pkts > nr_blocks * pkts_per_block) {
			printf("Error:  Too many packets!  Expecting %d got %d\n",
			       nr_blocks * pkts_per_block, total_pkts);
			return 1;
		}

#ifdef notdef
		printf("\n%x %x %x %x %x %x %x %x %x %x %x\n",
		       block_nr,
		       thispkt.hdr.mode,
		       thispkt.hdr.totcrc,
		       thispkt.hdr.nr_blocks,
		       thispkt.hdr.blocksize,
		       thispkt.hdr.block_crc,
		       thispkt.hdr.block_nr,
		       thispkt.hdr.pkt_sequence,
		       thispkt.hdr.pkt_nr,
		       thispkt.hdr.nr_pkts,
		       thispkt.hdr.thiscrc);
#endif

		if ((mode & BLOCK_MODE) == 0) {
			if (!(total_pkts % 1000) || total_pkts == pkts_per_block * nr_blocks) {
#ifdef notdef
				long time_msec;

				time_msec = elapsed_msecs();
				if (time_msec == 0)
					time_msec = 1;

				printf("\rRcvd %d/%d (%d%%) in %lds @%ldKiB/s, %d lost, %d dup/xs    ",
				       total_pkts, nr_blocks * pkts_per_block,
				       total_pkts * 100 / nr_blocks / pkts_per_block,
				       time_msec / 1000,
				       total_pkts * PKT_SIZE / 1024 * 1000 / time_msec,
				       missed_pkts,
				       duplicates + ignored_pkts);
#else
				printf("\r%d %d", total_pkts, missed_pkts);
#endif
			}
		}

		if (eraseblocks[block_nr].wbuf_ofs + PKT_SIZE < wbuf_size) {
			/* New packet doesn't full the wbuf */
			memcpy(eraseblocks[block_nr].wbuf + eraseblocks[block_nr].wbuf_ofs,
			       thispkt.data, PKT_SIZE);
			eraseblocks[block_nr].wbuf_ofs += PKT_SIZE;
		} else {
			int fits = wbuf_size - eraseblocks[block_nr].wbuf_ofs;
			size_t wrotelen;
//			static int faked = 1;

			memcpy(eraseblocks[block_nr].wbuf + eraseblocks[block_nr].wbuf_ofs,
			       thispkt.data, fits);

			if ((eraseblocks[block_nr].flash_page % pages_per_block) == 0)
				erase_block(eraseblocks[block_nr].flash_page/pages_per_block);

			/* The wbuf in eraseblocks[] gets overwritten during reception */
			/* so we copy the data to another buffer for overlapped disk I/O */
			memcpy(staging_wbuf, eraseblocks[block_nr].wbuf, wbuf_size);
			wrotelen = write_flash(staging_wbuf, wbuf_size,
					  eraseblocks[block_nr].flash_page);
			
//			if (wrotelen < wbuf_size || (block_nr == 5 && eraseblocks[block_nr].nr_pkts == 5 && !faked)) {
//				faked = 1;
			if (wrotelen < wbuf_size) {
				if (wrotelen < 0)
					printf("\npacket write");
				else
					printf("\nshort write of packet wbuf\n");

				/* FIXME: Perhaps we should store pkt crcs and try
				   to recover data from the offending eraseblock */

				printf("Erasing after bad write at page %08x)\n", eraseblocks[block_nr].flash_page);
				erase_block(eraseblocks[block_nr].flash_page/pages_per_block);

				/* Find the next good block to assign in place of the bad one*/
				this_block = partition_next[partition_nr];
				while (1) {
					if (this_block >= partition_end[partition_nr]) {
						printf("Reassigned block number %d > partition limit %d\n", this_block,
							partition_end[partition_nr]);
						return 1;
					}
					if (!block_bad(this_block))
						break;
					this_block++;
				}
				eraseblocks[block_nr].flash_page = this_block*pages_per_block;

				/* Set the allocation pointer to the one after the newly-assigned one */
				partition_next[partition_nr] = this_block++;

				total_pkts -= eraseblocks[block_nr].nr_pkts;
				eraseblocks[block_nr].nr_pkts = 0;
				eraseblocks[block_nr].wbuf_ofs = 0;
				goto pkt_again;
			}
			eraseblocks[block_nr].flash_page += pages_per_wbuf;
			/* Copy the remainder into the wbuf */
			memcpy(eraseblocks[block_nr].wbuf, &thispkt.data[fits], PKT_SIZE - fits);
			eraseblocks[block_nr].wbuf_ofs = PKT_SIZE - fits;
		}

		if (eraseblocks[block_nr].nr_pkts == pkts_per_block) {
			eraseblocks[block_nr].crc = ntohl(thispkt.hdr.block_crc);
			if ((mode & BLOCK_MODE) == 0) {
				shown_block = eraseblocks[block_nr].flash_page / pages_per_block;
				show_state(READY, shown_block-1);
			}
			if (total_pkts == nr_blocks * pkts_per_block)
				break;
		}
	}

	/* Show the status of the last block to finish */
	if (mode & BLOCK_MODE) {
		show_state(READY, (eraseblocks[current_block_nr].flash_page/pages_per_block)-1);
	}

	if (secure && (mode & ZDATA_MODE) && !(placement_collected)) {
		printf("Incomplete security spec\n");
		return 1;
	}

//	printf("\n");
	net_time = elapsed_msecs();
#define SECS(n)     (n / 1000), (((n % 1000) + 50) / 100)
	printf("Net %ld.%0lds %ldKiB/s\n", SECS(net_time), total_pkts * PKT_SIZE / 1024 * 1000 / net_time);

#ifdef notdef_text
	printf("Writing\n");
#endif

	fec = fec_new(pkts_per_block, ntohs(thispkt.hdr.nr_pkts), PKT_SIZE);

	for (block_nr = 0; block_nr < nr_blocks; block_nr++) {
		size_t rwlen;
		mark_time();
		eraseblocks[block_nr].flash_page -= pages_per_block;
		rwlen = read_flash(eb_buf, flash_erasesize, eraseblocks[block_nr].flash_page);

		rflash_time += elapsed_msecs();
		if (rwlen < 0) {
			printf("read");
			/* Argh. Perhaps we could go back and try again, but if the flash is
			   going to fail to read back what we write to it, and the whole point
			   in this program is to write to it, what's the point? */
			printf("Packets we wrote to flash seem to be unreadable. Aborting\n");
			return 1;
		}

		memcpy(eb_buf + flash_erasesize, eraseblocks[block_nr].wbuf,
		       eraseblocks[block_nr].wbuf_ofs);

		for (i=0; i < pkts_per_block; i++)
			src_pkts[i] = &eb_buf[i * PKT_SIZE];

		mark_time();
		if (fec_decode(fec, src_pkts, &pkt_indices[block_nr * pkts_per_block], PKT_SIZE)) {
			/* Eep. This cannot happen */
			printf("fec_decode error\n");
			return 1;
		}
		fec_time += elapsed_msecs();
		
		for (i=0; i < pkts_per_block; i++)
			memcpy(&decode_buf[i*PKT_SIZE], src_pkts[i], PKT_SIZE);

		/* Paranoia */
		mark_time();

		if (placement_collected && !(mode & ZDATA_MODE)) {
			if (next_hash_mismatch((char *)decode_buf, flash_erasesize)) {
				printf("\nSecure hash mismatch for block #%d\n",
				       block_nr);
				return 1;
			}
		} else {
			if (crc32(-1, decode_buf, flash_erasesize) != eraseblocks[block_nr].crc) {
				printf("\nCRC mismatch for block #%d: want %08x got %08x\n",
				       block_nr, eraseblocks[block_nr].crc, 
				       crc32(-1, decode_buf, flash_erasesize));
				return 1;
			}
		}
		crc_time += elapsed_msecs();
		
		mark_time();
		erase_block(eraseblocks[block_nr].flash_page/pages_per_block);
		erase_time += elapsed_msecs();		

	write_again:
		rwlen = write_flash(decode_buf, flash_erasesize, eraseblocks[block_nr].flash_page);
		show_state(WRITTEN, eraseblocks[block_nr].flash_page/pages_per_block);
		if (rwlen < flash_erasesize) {
			if (rwlen < 0) {
				printf("\ndecoded data write");
			} else 
				printf("\nshort write of decoded data\n");

			printf("Erasing failed block %08x\n",
			       eraseblocks[block_nr].flash_page/pages_per_block);

			erase_block(eraseblocks[block_nr].flash_page/pages_per_block);

			while (block_bad(this_block))
				this_block++;

			printf("Will try again at block %08lx...", (long)this_block);
			eraseblocks[block_nr].flash_page = this_block*pages_per_block;
			this_block++;

			goto write_again;
		}

		flash_time += elapsed_msecs();

//		printf("\rwrote block %d (%d pkts)", block_nr, eraseblocks[block_nr].nr_pkts);
#ifdef notdef_text
		printf("\r%d", block_nr);
#endif
	}
#ifdef notdef_text
	printf("\n");
#endif
#ifdef notdef_text
	printf("Cleanmarkers\n");
#endif
	for (i = nr_partitions?1:0; i <= nr_partitions; i++) {
		if (partition_flags[partition_nr] & CLEANMARKERS_MODE) {
			for (this_block=partition_next[i]; this_block<partition_end[i]; this_block++) {
				if (!block_bad(this_block)) {
					erase_block(this_block);
					write_cleanmarker(this_block);
#ifdef notdef_text
					printf("\r%d", this_block);
#endif
				}
			}
		}
#ifdef notdef_text
		printf("\n");
#endif
	}
//	printf("Net %ld.%0lds  ", SECS(net_time));
	printf("Rd %ld.%0lds ", SECS(rflash_time));
	printf("FEC %ld.%0lds ", SECS(fec_time));
	printf("CRC %ld.%0lds ", SECS(crc_time));
	printf("Wr %ld.%0lds ", SECS(flash_time));
	printf("Er %ld.%0lds\n", SECS(erase_time));

	return mode & ZDATA_MODE;
}

int create_block_map(int zdata_mode)
{
	int i;
	int next_bad_block_nr = -1;

	/*
	 * Create a map assigning incoming block numbers to specific NAND blocks
	 * The map skips known bad blocks and accounts for partitions
	 */
	eraseblocks = checked_malloc(nr_blocks * sizeof(*eraseblocks), "block map");
	wbufs = checked_malloc(nr_blocks * wbuf_size, "write buffers");
	staging_wbuf = checked_malloc(wbuf_size, "staging buffer");
	if (zdata_mode) {
		this_block = partition_end[0] - nr_blocks;
		set_zdata_blocks(nr_blocks);
		next_bad_block_nr = 0;
	} else {
		this_block = 0;
		next_bad_block_nr = next_bad_block(-1);
		init_show_state();
	}
	partition_nr = 0;
	for (i = 0; i < nr_blocks; i++) {
		eraseblocks[i].wbuf = wbufs+(i*wbuf_size);
#ifdef notdef_text
		if ((i % 100) == 0) {
			printf("\r%d",i);
		}
#endif
		/*
		 * At the incoming block number that starts the next partition, switch
		 * this_block to the beginning of that NAND partition.
		 */
		if (nr_partitions && i == partition_block_limit[partition_nr]) {
			uint32_t new_block;

			partition_next[partition_nr] = this_block;

			if (partition_nr && (partition_flags[partition_nr] & CLEANMARKERS_MODE))
				for ( ; this_block < partition_end[partition_nr]; this_block++)
					show_state(block_bad(this_block) ? BAD : WILL_CLEAN, this_block);

			if (partition_nr < nr_partitions) {
				partition_nr++;
				new_block = partition_start[partition_nr];

				for ( ; this_block < new_block; this_block++)
					show_state(LEAVE_ALONE, this_block);

				this_block = new_block;

				/* Find the next bad page at or after the start of this partition */
				next_bad_block_nr = next_bad_block(-1);
				while ((next_bad_block_nr != -1) && (next_bad_block_nr < new_block))
					next_bad_block_nr = next_bad_block(next_bad_block_nr);
			}
		}
		while (this_block == next_bad_block_nr) {
			show_state(BAD, this_block);
			this_block++;
			if (this_block >= partition_end[partition_nr]) {
				printf("Block number %d > partition limit %d\n", this_block,
				       partition_end[partition_nr]);
				return 1;
			}
			next_bad_block_nr = next_bad_block(next_bad_block_nr);
		}
		show_state(PENDING, this_block);
		eraseblocks[i].flash_page = this_block*pages_per_block;
		eraseblocks[i].nr_pkts = 0;
		this_block++;
		eraseblocks[i].wbuf_ofs = 0;
	}
	return 0;
}

static int confirm_overwrite()
{
	return 1;
}

/*
 * Returns 0 if okay, 1 if FLASH is currently not partitioned,
 * -1 if partitioned but the partitions aren't compatible.
 */
static int flash_partitions_incompatible(struct partition_map_spec *want)
{
	int have_nr_partitions;
	struct partition_spec *want_part;
	int start, size, granularity, namelen, type;
	char *nameadr;
	int wantlen;
	int i, j;

	have_nr_partitions = flash_num_partitions();
	if (have_nr_partitions <= 0)
		return 1;

	if (want->nr_partitions > have_nr_partitions)
		return -1;

	/* Clear the offsets to an invalid value */
	for (j = 1; j <= want->nr_partitions; j++)
		partition_start[j] = 0xffffffff;

	/* OFW numbers the partitions 1..N, with 0 being the entire (unpartitioned) device */
	/* The partition_map_spec structure is numbered similarly */
	for (i=1; i <= have_nr_partitions; i++) {
		flash_partition_info(i, &type, &namelen, &nameadr, &granularity, &size, &start);

		/* Find the "have" partition whose name matches the "want" partition */
		for (j = 1; j <= want->nr_partitions; j++) {
			want_part = &want->partitions[j];
			if ((wantlen = strnlen(want_part->name, MAX_PARTITION_NAME)) != namelen)
				continue;
			if (memcmp(want_part->name, nameadr, namelen))
				continue;
			/* Name matches */
			if (want_part->used_eblocks > size)
				return -1;			/* Too small */
			partition_start[j] = start;
			partition_end[j] = start + size;
			partition_flags[j] = want_part->flags;
			break;
		}
	}

	/* If any offset is still invalid, we didn't find a corresponding partition */
	for (j = 1; j <= want->nr_partitions; j++)
		if (partition_start[j] == 0xffffffff)
			return -1;

	return 0;
}

char *parse_ptr, *parse_end;

static void start_parser(char *spec, size_t spec_len)
{
	parse_ptr = spec;
	parse_end = spec+spec_len;
}

static int next_hash_mismatch(char *buf, size_t len)
{
	char *line, *lineend;
	char *cmd, *cmdend;
	char *hashval;
	int hashlen;
	char *exphashval;
	int exphashlen;

	while (parse_ptr < parse_end) {
		parse_ptr = parse_line(parse_ptr, parse_end, &line, &lineend);
		line = parse_word(line, lineend, &cmd, &cmdend);
		if (match(cmd, cmdend, "eblock:", 7)) {
			line = parse_word(line, lineend, &cmd, &cmdend);  /* Block number */
			line = parse_word(line, lineend, &cmd, &cmdend);  /* Hashname */
			if ((cmdend - cmd) > 31) {
				printf("Bad hash name\n");
				return 1;
			}
			if (hash(buf, len, cmd, cmdend-cmd, &hashval, &hashlen)) {
				printf("Call to 'hash' failed\n");
				return 1;
			}
			line = parse_word(line, lineend, &cmd, &cmdend);  /* Hash value */
			if (hex_decode(cmd, cmdend-cmd, &exphashval, &exphashlen)) {
				printf("hex_decode failed\n");
				return 1;
			}
			if(hashlen != exphashlen) {
				printf("hash length mismatch\n");
				return 1;
			}
			if(memcmp(hashval, exphashval, hashlen)) {
				printf("hash mismatch\n");
				return 1;
			}
			return 0;
		}
	}
	printf("End of file on placement spec\n");
	return 1;
}


#define BIT_IS_SET(map, bitno) ((map[bitno>>3] & (1 << (bitno&7))) != 0)
#define SET_BIT(map, bitno) (map[bitno>>3] |= (1 << (bitno&7)))

void dump_placement_packet(struct image_pkt *spkt)
{
	printf("mode %x   totcrc %x   nr_blocks %x   blocksize %x   block_crc%x\n",
	       ntohl(spkt->hdr.mode), ntohl(spkt->hdr.totcrc), ntohl(spkt->hdr.nr_blocks),
	       ntohl(spkt->hdr.blocksize), ntohl(spkt->hdr.block_crc));
	printf("seq %x   pkt_nr %x   nr_pkts %x   thislen %x  thiscrc %x \n",
	       ntohl(spkt->hdr.pkt_sequence), ntohs(spkt->hdr.pkt_nr), ntohs(spkt->hdr.nr_pkts),
	       ntohl(spkt->hdr.thislen), ntohl(spkt->hdr.thiscrc));
	printf("plc_nr_pkts %x   plc_pkt_nr %x   image_len %x   sig_len %x\n",
	       ntohs(spkt->hdr.placement_nr_pkts), ntohs(spkt->hdr.placement_pkt_nr),
	       ntohl(spkt->hdr.image_len), ntohl(spkt->hdr.signature_len) );
}

static int collect_placement_spec(struct image_pkt *spkt, int secure, int zdata_mode, char **specadr, int *speclen)
{
	static char *placement_spec = NULL;
	static size_t placement_spec_len;
	static char *placement_bitmap;
	static size_t placement_bitmap_len;
	static int placement_nr_packets;
	static int placement_packets_have;
	static size_t image_len = 0;
	static size_t signature_len = 0;
	int this_pkt_nr;
	int this_nr_pkts;
	int this_signature_len;
	int this_image_len;
	int this_pkt_len;

	if (!placement_spec) {
		placement_nr_packets = ntohs(spkt->hdr.placement_nr_pkts);
		placement_packets_have = 0;
		image_len = ntohl(spkt->hdr.image_len);
		signature_len = ntohl(spkt->hdr.signature_len);
		placement_spec_len = image_len + signature_len;
		placement_spec = checked_malloc(placement_spec_len, "Placement spec");
		placement_bitmap_len = (placement_nr_packets + 7)/8;
		placement_bitmap = checked_malloc(placement_bitmap_len, "Placement bitmap");
		memset(placement_bitmap, 0, placement_bitmap_len);
		if(init_crypto()) {
			printf("Can't load the hashing code\n");
			return -1;
		}
		if (zdata_mode)
			printf("Collecting security spec - ");
		else
			printf("Waiting for placement spec\r");
	}

	this_nr_pkts = ntohs(spkt->hdr.placement_nr_pkts);
	this_pkt_nr = ntohs(spkt->hdr.placement_pkt_nr);
	this_pkt_len = ntohl(spkt->hdr.thislen);
	this_image_len = ntohl(spkt->hdr.image_len);
	this_signature_len = ntohl(spkt->hdr.signature_len);
	if (this_nr_pkts != placement_nr_packets) {
		printf("Placement spec nr_packets changed!\n");
		return -1;
	}
	if (this_pkt_nr >= placement_nr_packets) {
		printf("Placement spec packet_nr >= nr_packets!\n");
		return -1;
	}

	if (((this_pkt_nr * PKT_SIZE) + this_pkt_len) > placement_spec_len) {
		printf("Bogus placement spec packet offset!\n");
                dump_placement_packet(spkt);
		return -1;
	}

	if (BIT_IS_SET(placement_bitmap, this_pkt_nr))
		return 0;	/* Already have this one */

	SET_BIT(placement_bitmap, this_pkt_nr);

	memcpy(placement_spec+(this_pkt_nr * PKT_SIZE), &spkt->data, this_pkt_len);

	if (++placement_packets_have == placement_nr_packets) {
		// free(placement_bitmap, placement_bitmap_len);
		if (this_image_len + this_signature_len != placement_spec_len) {
			printf("Placement spec length changed!\n");
			return -1;
		}
		if (secure) {
			if(this_signature_len == 0) {
				printf("Placement spec bad signature!\n");
				return -1;
			}
			if(!spec_valid(placement_spec, this_image_len,
				       placement_spec+this_image_len, this_signature_len)) {
				printf("Placement spec bad signature!\n");
				return -1;
			}
		}
		*specadr = placement_spec;
		*speclen = image_len;
                if (zdata_mode)
			return 1;  /* Good, and omit the parsing below */
		if(parse_placement_partitions(placement_spec, image_len))
			return -1;
		start_parser(placement_spec, image_len);
		return 1;     /* Good */
	}
	return 0;
}

static void show_partitions(struct partition_map_spec *want)
{
	int i;
	struct partition_spec *part;
	if(want->nr_partitions == 0) {
		part = &(want->partitions[0]);
		printf("Unpartitioned: %d eblocks used\n", part->used_eblocks);
	} else {
		printf("Partitions:\n");
		for(i=1; i <= want->nr_partitions; i++) {
			part = &(want->partitions[i]);
			printf("%d: %s %d %d\n", i, part->name, part->used_eblocks, part->total_eblocks);
		}
	}
}

int parse_placement_partitions(char *placement_spec, size_t placement_spec_len)
{
	char *line, *lineend;
	char *cmd, *cmdend;
	
	int partition_nr = 0;
	int nr_partitions = 0;
	struct partition_map_spec *want;

	char *p, *p_end;
	size_t remlen;

	want = checked_malloc(sizeof(struct partition_map_spec) + MAX_PARTITIONS*sizeof(struct partition_spec),
			      "Placement partition map");

	memset(want, 0, sizeof(struct partition_map_spec) + MAX_PARTITIONS*sizeof(struct partition_spec));

	want->version = 1;

	p_end = placement_spec + placement_spec_len;

	for(p = placement_spec; p < p_end; ) {
		p = parse_line(p, p_end, &line, &lineend);
		line = parse_word(line, lineend, &cmd, &cmdend);

		remlen = p_end - p;
		if(match(cmd, cmdend, "eblock:", 7)) {
			want->partitions[partition_nr].used_eblocks++;
			continue;
		}
		if(match(cmd, cmdend, "partitions:", 11)) {
			nr_partitions = parse_partitions(line, lineend, want);
			continue;
		}
		if(match(cmd, cmdend, "set-partition:", 14)) {
			line = parse_word(line, lineend, &cmd, &cmdend);
			partition_nr = find_partition(cmd, cmdend, want);
			if (partition_nr < 1 || partition_nr > nr_partitions) {
				printf("Bad partition name in placement update spec\n");
				return 1;
			}
			continue;
		}
		if(match(cmd, cmdend, "cleanmarkers", 12)) {
			want->partitions[partition_nr].flags |= CLEANMARKERS_MODE;
			continue;
		}
#ifdef notdef
		if(match(cmd, cmdend, "data:", 5))
			continue;
		if(match(cmd, cmdend, "erase-all", 9))
			continue;
		if(match(cmd, cmdend, "mark_pending:", 13))
			continue;
		if(match(cmd, cmdend, "mark_complete:", 14))
			continue;
#endif
	}
	show_partitions(want);
	return map_partitions(want);
}

long hextol(char *p, char *pend)
{
	unsigned long ret, digit;
	char c;
	int negate = 0;

	ret = 0;

	if (p == pend)
		return 0;

	if (*p == '-') {
		negate = 1;
		++p;
	}

	while (p < pend) {
		c = *p++;
		if ('0' <= c && c <= '9')
			digit = c-'0';
		else if ('a' <= c && c <= 'f')
			digit = c-'a'+10;
		else if ('F' <= c && c <= 'F')
			digit = c-'A'+10;
		else {
			printf("Bad character in hex number");
			return 0;
		}
		ret = (ret << 4) + digit;
	}

	return negate ? -ret : ret;
}

/*
 * Parses a partition specification line like:
 *   partitions: boot 1a0 system 1000 user -1
 * Sets the "nr_partitions", "name", and "total_eblocks" fields of the "want"
 * structure to the parsed values.
 * Returns the number of partition name/size pairs parsed.
 * Initially, the "line" argument is the address of the character after
 * "partitionss: ".
 */

static int parse_partitions(char *line, char *lineend, struct partition_map_spec *want)
{
	int nr_partitions;
	char *name, *nameend;
	char *size, *sizeend;
	int namelen;
	int nr_blocks;

	nr_partitions = 0;
	want->version = 1;

	while (line < lineend) {
		line = parse_word(line, lineend, &name, &nameend);
		if (name == nameend)
			break;
		line = parse_word(line, lineend, &size, &sizeend);
		if (size == sizeend) {
			printf("Missing partition size value");
			nr_blocks = 0;
		} else {
			nr_blocks = hextol(size, sizeend);
		}
		nr_partitions++;
		want->partitions[nr_partitions].total_eblocks = nr_blocks;
		namelen = nameend - name;
		if (namelen > MAX_PARTITION_NAME)
			namelen = MAX_PARTITION_NAME;
		memset(want->partitions[nr_partitions].name, 0, MAX_PARTITION_NAME);
		strncpy(want->partitions[nr_partitions].name, name, namelen);
	}

	want->nr_partitions = nr_partitions;
	return nr_partitions;
}

/*
 * Parses the next line, delimited by LF or CF-LF, in the buffer from
 * [p .. pend), setting the line limits line and lineend, returning
 * the address of the character following the delimiter sequence or
 * pend if there isn't one.
 * Lineend is the address of the first delimiter or pend if there
 * isn't one.  The line as bounded by [line .. lineend) does not contain
 * a delimiter.
 */

static char *parse_line(char *p, char *pend, char **line, char **lineend)
{
	char c;

	*line = p;
	while (p < pend) {
		c = *p;
		if(c == '\n') {
			*lineend = p;
			return p+1;
		}
		if(c == '\r') {
			*lineend = p;
			if(++p < pend && *p == '\n')
				++p;
			return p;
		}
		p++;
	}
	*lineend = p;
	return p;
}

/*
 * Skips leading whitespace, parses the word, delimited by whitespace,
 * in the buffer from [p .. pend), setting the word limits cmd and cmd,
 * returning the address of the character following the post-word delimiter
 * or pend if there is no such delimiter.
 * Cmdend is the address of the post-word delimiter or pend if there
 * isn't one.  The word as bounded by [cmd .. cmdend) does not contain
 * a delimiter.
 */

static char *parse_word(char *line, char *lineend, char **cmd, char **cmdend)
{
	char c;
	int len = 0;

	/* Skip leading whitespace */
	for( ; line < lineend; line++) {
		c = *line;
		if(c != ' ' && c != '\t')
			break;
	}
	*cmd = line;
	if (line == lineend) {
		*cmdend = line;
		return line;
	}

	/* Scan to whitespace or end of line (no \n in line) */
	for( ; line < lineend; line++) {
		c = *line;
		if(c == ' ' || c == '\t') {
			*cmdend = line;
			return line+1;
		}
		len++;
	}
	*cmdend = line;
	return line;
}

/*
 * Return true if the string [p .. pend) exactly matches name .
 */

int match(char *p, char *pend, char *name, size_t namelen)
{
	if(namelen != (pend - p))
		return 0;
	return memcmp(p, name, namelen) == 0;
}

static void alloc_partition_arrays(int nr_partitions)
{
	partition_start = checked_malloc((nr_partitions+1) * sizeof(int), "Partition offsets");
	partition_end = checked_malloc((nr_partitions+1) * sizeof(int), "Partition ends");
	partition_block_limit = checked_malloc((nr_partitions+1) * sizeof(int), "Partition limits");
	partition_next = checked_malloc((nr_partitions+1) * sizeof(int), "Partition last pages");
	partition_flags = checked_malloc((nr_partitions+1) * sizeof(int), "Partition flags");
}

/*
 * Given the desired partition layout "want", determine if the existing NAND
 * partition layout is compatible (the existing partitions are at least as
 * big as the wanted"used_eblocks" values).  If so, use the existing layout.
 * If not, create new partitions with sizes according to the wanted
 * "total_eblocks" values.  In either case, then map the desired layout to
 * the NAND layout by filling in the partition_start[], partition_end[],
 * partition_next[], and partition_block_limit[] arrays.
 */
int map_partitions(struct partition_map_spec *want) {
	int status;
	int i;

	nr_partitions = want->nr_partitions;
	alloc_partition_arrays(nr_partitions);
	partition_start[0] = 0;

	if (nr_partitions == 0) {
		partition_block_limit[0] = want->partitions[0].used_eblocks;
		partition_flags[0] = want->partitions[0].flags;
		return 0;
	}

	if ((status = flash_partitions_incompatible(want)) != 0) {
	/* Status==1 means no partitions, so we overwrite without confirmation */
		if (status == -1)
			confirm_overwrite();

		printf("Making new partitions\n");
		make_new_partitions(want);

		/* Redo this to ensure that it worked and to set the offsets in "want" */
		if (flash_partitions_incompatible(want)) {
			printf("Partition creation failed\n");
			return 1;
		}
	}

	/* At this point, all the partition offset fields are valid */
	partition_block_limit[0] = 0;
	for (i = 1; i <= nr_partitions; i++) {
		printf("Partition '%s' uses %d eblocks\n",
		       want->partitions[i].name,
		       want->partitions[i].used_eblocks);
		partition_block_limit[i] = partition_block_limit[i-1] + want->partitions[i].used_eblocks;
	}
	return 0;
}

static int find_partition(char *name, char *nameend, struct partition_map_spec *want)
{
	int partition_nr;
	int partition_name_len;
	char *partition_name;

	if ((nameend - name) > MAX_PARTITION_NAME)
		nameend = name + MAX_PARTITION_NAME;

	for(partition_nr = 1; partition_nr <= want->nr_partitions; partition_nr++) {
		partition_name = want->partitions[partition_nr].name;
		partition_name_len = strnlen(partition_name, MAX_PARTITION_NAME);
		if (match(name, nameend, partition_name, partition_name_len))
			return partition_nr;
	}
	return 0;
}
