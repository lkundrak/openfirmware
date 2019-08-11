/*
 * Multi-purpose NANDblaster sender
 *
 * The data source can be one of
 *
 * S1) This machine's NAND contents (clone mode), either partitioned
 *     or not.  You can optionally choose a subset of the partitions.
 *
 * S2) A NAND image file (on e.g. USB or SD), optionally augmented
 *     by placement and signature info as described below.
 *
 * S3) A blaster image file, containing pre-generated NANDblast
 *     packets for faster transmission (so this machine doesn't
 *     have to do the FEC and other computations on-the-fly.
 *
 * The output can either be sent to the network (repeatedly) or
 * written to another file (once) for later use with S3 above.
 *
 * For S2, in addition to the NAND image file that contains
 * the verbatim eblock data, you can also supply:
 *
 *  a) A placement specification image in the "data.img" control format
 *     defined by  http://wiki.laptop.org/go/OFW_NAND_FLASH_Updater
 *     The placement specification defined the desired NAND partition
 *     layout, if any, and validates the image block data with hashes.
 *
 *  b) A signature image in the "data.sig" format defined by the above and
 *     http://wiki.laptop.org/go/Firmware_Security . The signature validates
 *     the placement specification (1) with a crypto signature.
 *
 * If (a) is not present, S2 can only work with unpartitioned NAND
 * images and block validation is done with CRC32 instead of a hash.
 *
 * If (b) is not present, the output will not contain a crypto signature,
 * so secure machines will refuse to receive it, but machines with
 * developer keys will receive it.  That's useful for unsigned OS images.
 *
 * For S1 and S2, the data is sent (or written) in eblock-major order
 * (BLOCK_MODE).  I.e. all of the packets for the first NAND erase block
 * are sent, then all of the packets for the second erase block, and so on.
 * That order is much easier for the sender because the source data can
 * be accessed sequentially instead of having to stride from block to block.
 * On systems (e.g. the XO) with less memory than the NAND image size,
 * that makes a huge difference in the sending speed.  But it slows down
 * reception somewhat because the receiver has to see all the redundant
 * blocks for each erase block.
 *
 * For S3, the data in the source file can be in either eblock-major
 * order or packet-major order.  In packet-major order, you send packet
 * 0 for all of the eblocks, then packet 1 for all of the eblocks, etc.
 * That's slower to compute, but it can reasonably be done off-line on
 * any Linux system with enough RAM for the entire NAND image.  Once
 * precomputed and stored in a file, the sender can transmit it just as
 * fast as eblock-major order.  Receivers can receive packet-major order
 * more quickly than eblock-major order, because they can be finished
 * as soon as they have a certain number of packets from each eblock.
 * In practice, however, that reception speed advantage sometimes doesn't
 * help much, because the forward-error-correction decoder usually has
 * to work harder when presented with the received packet distribution
 * from packet-major order.
 */

#define _GNU_SOURCE

#include <stdio.h> 	
#include <stdlib.h> 	
#include <string.h>
#include "crc32.h"
#include "mcast_image.h"
#include "partition.h"
#include "io.h"

static void *prep_placement_spec(char *specadr, int speclen, char *sigadr, int siglen);
static int send_placement_spec_packet(void *placement, struct image_pkt *pktbuf);
static struct partition_map_spec *partition_scan(char **partition_list, int **partition_starts);

static int send_image(uint32_t mode, int repeat, uint32_t redundancy,
	       size_t imagesize, uint32_t erasesize, 
	       char *specadr, int speclen, char *sigadr, int siglen);
static int send_pregenerated_packets(int repeat, size_t imagesize);
static int send_this_nand(int repeat, int redundancy, char **partition_list);

int check_stop(void);

static int map_blocks(int total_blocks, uint32_t *good_blocks,
       	       uint32_t pages_per_block, uint32_t erasesize,
	       unsigned char *this_block,
	       struct partition_map_spec *pmap, int *partition_starts);

static int is_erased(unsigned char *block, int len);
static int has_cleanmarker(unsigned char *block);

uint32_t ntohl(uint32_t n);
uint32_t htonl(uint32_t n);
uint16_t ntohs(uint16_t n);
uint16_t htons(uint16_t n);

int getchar(void);
int putchar(int c);

int main(int argc, char **argv)
{
	int repeat;
	int result;

	if (argc < 3) {
		printf("usage: %s out nand: redundancy [partition_name ...]\n", argv[0]);
		printf("usage: %s out image redundancy erasesize [specadr speclen [sigadr siglen]]\n",	argv[0]);
		printf("usage: %s out image\n", argv[0]);
		return 1;
	}

	repeat = open_net(argv[1]);

	if (strcmp(argv[2], "nand:") == 0) {
		/* Cloning mode */
		result = send_this_nand(repeat, atoi(argv[3]), argc > 4 ? &argv[4] : NULL);
	} else {
		size_t imagesize;
		uint32_t mode;

                mode = BLOCK_MODE;
                if (strcasestr(argv[2], ".zd"))
			mode |= ZDATA_MODE;

		printf("Using %s mode\n\n", mode & ZDATA_MODE ? "zdata" : "jffs2");
		open_file(argv[2], &imagesize);

		if (argc == 3) {
			/* Pregenerated packet mode */
			result = send_pregenerated_packets(repeat, imagesize);
		} else {
			/* Image file mode */
			uint32_t redundancy = atoi(argv[3]);
			uint32_t erasesize = atoi(argv[4]);
			char *specadr = argc >= 5 ? (char *)atoi(argv[5]) : NULL;
			int speclen = argc >= 5 ? atoi(argv[6]) : 0;
			char *sigadr = argc >= 7 ? (char *)atoi(argv[7]) : NULL;
			int siglen = argc >= 7 ? atoi(argv[8]) : 0;

                        if (speclen)
				mode |= PLACEMENT_MODE;

			result = send_image(mode, repeat, redundancy,
					    imagesize, erasesize, 
					    specadr, speclen, sigadr, siglen);
		}
		close_file();
	}
	close_net();

	return result;
}

static int send_pregenerated_packets(int repeat, size_t imagesize)
{
	struct image_pkt pktbuf;
	uint32_t block_nr, pkt_nr;
	int nr_blocks;
	long time_msecs;
	int pkts_per_block;
	unsigned long kib_sent;
	int nread;
	int npkts;
	uint32_t mode;
	int writeerrors = 0;

	uint32_t erasesize;

	if (imagesize % sizeof(struct image_pkt)) {
		printf("Image size %d bytes is not a multiple of packetsize\n", imagesize);
		return 1;
	}

	nread = read_file(&pktbuf, sizeof(pktbuf));
	if (nread < sizeof(pktbuf)) {
		printf("File read error\n");
		return 1;
	}

	erasesize = ntohl(pktbuf.hdr.blocksize);
	if (!erasesize) {
		printf("erasesize cannot be zero\n");
		return 1;
	}
	mode = ntohl(pktbuf.hdr.mode);

	pkts_per_block = (erasesize + PKT_SIZE - 1) / PKT_SIZE;

	nr_blocks = ntohl(pktbuf.hdr.nr_blocks);

	printf("\nImage size %ld KiB (0x%08lx). %d blocks at %d pkts/block\n",
	       (long)imagesize / 1024, (long) imagesize,
	       nr_blocks, pkts_per_block);

	if (mode & PLACEMENT_MODE)
		printf("With security signatures\n");

	while (repeat) {
		rewind_file();
		mark_time();
		npkts = 0;
		while( (nread = read_file(&pktbuf, sizeof(pktbuf))) == sizeof(pktbuf)) {
			npkts++;

			block_nr = ntohl(pktbuf.hdr.block_nr);
			pkt_nr = ntohs(pktbuf.hdr.pkt_nr);
			mode = ntohl(pktbuf.hdr.mode);

			/* Progress report */
			if (!(mode & (PLACEMENT_SPEC | PARTITION_SPEC))) {
				if (mode & BLOCK_MODE) {
					if (pkt_nr == 0) {
						printf("\r%5d", block_nr);
						if (check_stop()) {
							repeat = 0;
							break;
						}
					}
				} else {
					if (block_nr == 0) {
						printf("\r%3d", pkt_nr);
						if (check_stop()) {
							repeat = 0;
							break;
						}
					}
				}
			}

			if (put_packet(&pktbuf, sizeof(pktbuf)) < 0) {
				if (++writeerrors > 10) {
					printf("Too many consecutive write errors\n");
					return 1;
				}
			} else
				writeerrors = 0;
		}

		if (nread != 0) {
			printf("Short read\n");
			return 1;
		}

		time_msecs = elapsed_msecs();

		kib_sent = (npkts * sizeof(struct image_pkt)) / 1024;
		printf("\n%ld KiB sent in %ldms (%ld KiB/s)\n",
		       kib_sent, time_msecs,
		       kib_sent * 1000 / time_msecs);
	}
	return 0;
}

uint32_t sequence = 0;

struct placement_state {
	size_t speclen;
	size_t siglen;
	size_t totlen;
	unsigned char *image;
	uint16_t pkt_nr;
	uint16_t nr_pkts;
};

static int send_image(uint32_t mode, int repeat, uint32_t redundancy,
	       size_t imagesize, uint32_t erasesize, 
	       char *specadr, int speclen, char *sigadr, int siglen
               )
{
	struct image_pkt pktbuf;
	uint32_t block_nr, pkt_nr;
	int nr_blocks;
	long time_msecs;
	int pkts_per_block;
	unsigned long kib_sent;
	int nread;
	int npkts;
	int writeerrors = 0;

	unsigned char *image;
	int total_pkts_per_block;
	struct fec_parms *fec;
	uint32_t *block_crcs;
	void *placement = NULL;
	int placement_ctr = PLACEMENT_INTERVAL;
	int placement_init = PLACEMENT_INTERVAL;
	int first_time = 1;
	uint32_t total_crc;
	uint32_t pass;

	if (!erasesize) {
		printf("erasesize cannot be zero\n");
		return 1;
	}

	if (redundancy < 0 || redundancy > 99) {
		printf("Redundancy must be between 0 and 99 inclusive\n");
		return 1;
	}

	pkts_per_block = (erasesize + PKT_SIZE - 1) / PKT_SIZE;
	total_pkts_per_block = pkts_per_block * (redundancy + 100) / 100;

	fec = fec_new(pkts_per_block, total_pkts_per_block, PKT_SIZE);
	if (!fec) {
		printf("Error initialising FEC\n");
		return 1;
	}

	if (speclen) {
		if((placement = prep_placement_spec(specadr, speclen, sigadr, siglen)) == NULL) {
			printf("Can't prepare placement spec\n");
			return 1;
		}
		if (mode & ZDATA_MODE) {
			/* We want at least 3 copies of the security spec during each pass */
			placement_init = (imagesize / (speclen + siglen)) / 3;
			if (placement_init > PLACEMENT_INTERVAL)
				placement_init = PLACEMENT_INTERVAL;
			if (placement_init == 0)
				placement_init = 1;
			printf("Sending security packets every %d regular packets\n", placement_init);
		} else {
			placement_init = PLACEMENT_INTERVAL;
		}
		placement_ctr = placement_init;
	}

	nr_blocks = (imagesize + erasesize - 1) / erasesize;

	block_crcs = checked_malloc(nr_blocks * sizeof(uint32_t), "block_crcs");

	image = checked_malloc(erasesize, "image");

	total_crc = -1;
	pktbuf.hdr.mode = htonl(mode);
	pktbuf.hdr.totcrc = htonl(0);
	pktbuf.hdr.nr_blocks = htonl(nr_blocks);
	pktbuf.hdr.blocksize = htonl(erasesize);
	pktbuf.hdr.thislen = htonl(PKT_SIZE);
	pktbuf.hdr.nr_pkts = htons(total_pkts_per_block);

	pass = 1;
	printf("       of %d blocks, pass %d\r", nr_blocks, pass);
	while(repeat) {
		rewind_file();
		mark_time();
		++pass;
		npkts = 0;
		for (block_nr = 0; block_nr < nr_blocks; block_nr++) {
			if (check_stop()) {
				repeat = 0;
				break;
			}

			printf("%d\r", block_nr);

			nread = read_file(image, erasesize);
			if (nread == 0) {
				printf("Zero-length read of image file!\n");
				return 1;
			}
			if (nread != erasesize) {
				if (mode & ZDATA_MODE)
					memset(image+nread, ' ', erasesize-nread);
				else {
					printf("image size not multiple of block size!\n");
					return 1;
				}
			}

			// If this is the first sending pass, compute and save block checksums
			if (first_time) {
				/* If we have a placement spec in original mode, we'll use its SHA hash */
				/* In secure ZDATA mode, we still need the CRC because the SHA hash */
				/* can't be checked until after the ZDATA image is FEC-decoded */
				if (!speclen || (mode & ZDATA_MODE))
					block_crcs[block_nr] = crc32(-1, image, erasesize);
				/* The total CRC guards against restarting the sender with new info */
				total_crc = crc32(total_crc, image, erasesize);
			}

			for (pkt_nr=0; pkt_nr < total_pkts_per_block; pkt_nr++) {
				npkts++;
				if(speclen && --placement_ctr == 0) {
					placement_ctr = placement_init;
					if (send_placement_spec_packet(placement, &pktbuf))
						return 1;
				}

				fec_encode_linear(fec, image, pktbuf.data, pkt_nr, PKT_SIZE);

				pktbuf.hdr.thiscrc = htonl(crc32(-1, pktbuf.data, PKT_SIZE));
				pktbuf.hdr.block_crc = htonl(block_crcs[block_nr]);
				pktbuf.hdr.block_nr = htonl(block_nr);
				pktbuf.hdr.pkt_nr = htons(pkt_nr);
				pktbuf.hdr.pkt_sequence = htonl(sequence++);

				if (put_packet(&pktbuf, sizeof(pktbuf)) < 0) {
					writeerrors++;
					if (writeerrors > 10)
						return 1;
				} else
					writeerrors = 0;
			}
		}
		time_msecs = elapsed_msecs();
		kib_sent = (npkts * sizeof(struct image_pkt)) / 1024;
		printf("       of %d blocks, pass %d, %ld KiB/sec\r", nr_blocks, pass,
		       kib_sent * 1000 / time_msecs);

		pktbuf.hdr.totcrc = htonl(total_crc);
		first_time = 0;
	}
	printf("\n");
	return 0;
}

static void *prep_placement_spec(char *specadr, int speclen, char *sigadr, int siglen)
{
	struct placement_state *placement;

	placement = checked_malloc(sizeof(struct placement_state), "placement");
	placement->speclen = speclen;
	placement->siglen = siglen;
	placement->totlen = speclen + siglen;

	placement->image = checked_malloc(placement->totlen, "placement image");

	memcpy(placement->image, specadr, speclen);
	memcpy(placement->image+speclen, sigadr, siglen);
	
	placement->pkt_nr = 0;
	placement->nr_pkts = (placement->totlen + PKT_SIZE - 1) / PKT_SIZE;

	return placement;
}

static int send_placement_spec_packet(void *state, struct image_pkt *pktbuf)
{
	struct placement_state *placement = state;
	int thislen;
	int offset;
	int mode;

	offset = placement->pkt_nr * PKT_SIZE;
	thislen = placement->totlen - offset;

	if(thislen > PKT_SIZE)
		thislen = PKT_SIZE;

	memcpy(pktbuf->data, placement->image + offset, thislen);
	memset(pktbuf->data + thislen, 0, PKT_SIZE - thislen);

	mode = ntohl(pktbuf->hdr.mode);
	pktbuf->hdr.mode = htonl(mode | PLACEMENT_SPEC);
	pktbuf->hdr.thiscrc = htonl(crc32(-1, pktbuf->data, PKT_SIZE));
	pktbuf->hdr.placement_pkt_nr = htons(placement->pkt_nr);
	pktbuf->hdr.placement_nr_pkts = htons(placement->nr_pkts);
	pktbuf->hdr.pkt_sequence = htonl(sequence++);
	pktbuf->hdr.thislen = htonl(thislen);
	pktbuf->hdr.image_len = htonl(placement->speclen);
	pktbuf->hdr.signature_len = htonl(placement->siglen);

	if (put_packet(pktbuf, sizeof(*pktbuf)) < 0) {
		printf("send failed\n");
		return 1;
	}

	pktbuf->hdr.mode = htonl(mode);
	pktbuf->hdr.thislen = htonl(PKT_SIZE);

	if(++placement->pkt_nr == placement->nr_pkts)
		placement->pkt_nr = 0;
	return 0;
}

// Cloning code

static int send_this_nand(int repeat, int redundancy, char **partition_list)
{
	struct image_pkt pktbuf;
	int writeerrors = 0;
	uint32_t erasesize;
	uint32_t block_nr, pkt_nr;
	unsigned int total_blocks, nr_blocks;
	long time_msecs;
	int pkts_per_block;
	int total_pkts_per_block;
	struct fec_parms *fec;
	unsigned char *this_block;
	uint32_t *block_crcs, totcrc;
	uint32_t *good_pages;	/* Absolute page number on source system */
	uint32_t sequence = 0;
	uint32_t pagesize, pages_per_block;
	unsigned long amt_sent;
	int firsttime = 1;
	struct partition_map_spec *pmap;
	int *partition_starts;
	int writesize;

	show_flash_map();
	open_flash(&erasesize, &pagesize, &total_blocks, &writesize);

	pages_per_block = erasesize / pagesize;

	pkts_per_block = (erasesize + PKT_SIZE - 1) / PKT_SIZE;
	total_pkts_per_block = pkts_per_block * (redundancy + 100) / 100;

	this_block = checked_malloc(erasesize, "block buffer");
	block_crcs = checked_malloc(total_blocks * sizeof(uint32_t), "block_crcs");
	good_pages = checked_malloc(total_blocks * sizeof(uint32_t), "good_pages");
	
	totcrc = -1;

	pmap = partition_scan(partition_list, &partition_starts);

	/* Determine how many blocks are populated */
	nr_blocks = map_blocks(total_blocks, good_pages,
			       pages_per_block, erasesize,
			       this_block, pmap, partition_starts);
//	nr_blocks = 80;

	fec = fec_new(pkts_per_block, total_pkts_per_block, PKT_SIZE);
	if (!fec) {
		printf("Error initialising FEC\n");
		return 1;
	}

	amt_sent = total_pkts_per_block * nr_blocks * sizeof(pktbuf);

	pktbuf.hdr.mode = htonl(BLOCK_MODE | CLEANMARKERS_MODE);
	pktbuf.hdr.nr_blocks = htonl(nr_blocks);
	pktbuf.hdr.blocksize = htonl(erasesize);
	pktbuf.hdr.thislen = htonl(PKT_SIZE);
	pktbuf.hdr.nr_pkts = htons(total_pkts_per_block);
	pktbuf.hdr.totcrc = 0;	/* Initial value; will set when we know it */

	printf("Sending %d blocks at %d pkts/block\n", nr_blocks, pkts_per_block);

	while (repeat) {
		mark_time();
		for (block_nr = 0; block_nr < nr_blocks; block_nr++) {
			if (check_stop()) {
				repeat = 0;
				break;
			}

#ifdef notdef_text
			printf("\r%3d", block_nr);
#else
			highlight_flash_block(good_pages[block_nr]/pages_per_block);
#endif

			if(pmap->nr_partitions) {
				pktbuf.hdr.mode = htonl(BLOCK_MODE | CLEANMARKERS_MODE | PARTITION_SPEC);
				memcpy(pktbuf.data, pmap,
				       sizeof(struct partition_map_spec) +
				       (pmap->nr_partitions+1) * sizeof(struct partition_spec));
				(void)put_packet(&pktbuf, sizeof(pktbuf));
				pktbuf.hdr.mode = htonl(BLOCK_MODE | CLEANMARKERS_MODE | PARTITION_MODE);
			}

			read_flash(this_block, erasesize, good_pages[block_nr]);
			if (firsttime) {
				totcrc = crc32(totcrc, this_block, erasesize);
				block_crcs[block_nr] = crc32(-1, this_block, erasesize);
			}

			pktbuf.hdr.block_crc = htonl(block_crcs[block_nr]);
			pktbuf.hdr.block_nr = htonl(block_nr);

			for (pkt_nr=0; pkt_nr < total_pkts_per_block; pkt_nr++) {

				fec_encode_linear(fec, this_block, pktbuf.data, pkt_nr, PKT_SIZE);

				pktbuf.hdr.pkt_nr = htons(pkt_nr);
				pktbuf.hdr.pkt_sequence = htonl(sequence++);
				pktbuf.hdr.thiscrc = htonl(crc32(-1, pktbuf.data, PKT_SIZE));

				if (put_packet(&pktbuf, sizeof(pktbuf)) < 0) {
					printf("send error");
					if (++writeerrors > 10) {
						printf("Too many consecutive send errors\n");
						return 1;
					}
				} else
					writeerrors = 0;
			}
		}
		
		time_msecs = elapsed_msecs();

		printf("\r%ld KiB sent in %ld s (%ld KiB/s)",
		       amt_sent / 1024, (time_msecs + 500) / 1000,
		       amt_sent / 1024 * 1000 / time_msecs);

		if (firsttime) {
			pktbuf.hdr.totcrc = htonl(totcrc);
			firsttime = 0;
		}
	}

	printf("\n");
	close_flash();
	return 0;
}

static int is_erased(unsigned char *block, int len)
{
	unsigned long *lblock = (unsigned long *)block;
	int nlongs = len / sizeof(unsigned long);
	while (nlongs--)
		if (*lblock++ != -1)
			return 0;
	return 1;
}

static int has_cleanmarker(unsigned char *oob)
{
	unsigned long *loob = (unsigned long *)(oob + 14);
	if (loob[0] != 0x20031985)
		return 0;
	return loob[1] == 0x00000008;
}

void *checked_malloc(size_t nbytes, char *err_msg)
{
	void *mem;
	mem = malloc(nbytes);
	if (!mem) {
		close_net();
		close_flash();
		printf("malloc failed - %s\n", err_msg);
		fflush(stdout);
		exit(1);
	}
//        printf("%s %x %x\n", err_msg, mem, nbytes);
	return mem;
}

/* Ideally, we would be able to send the user partition with no contents */
void add_partition(struct partition_map_spec *pmap, int *partition_starts,
		   char *nameadr, int namelen, int start, int size)
{
	struct partition_spec *pspec;
	pmap->nr_partitions++;
	pspec = &pmap->partitions[pmap->nr_partitions];
	memset(pspec, 0, sizeof(struct partition_spec));
	strncpy(pspec->name, nameadr, MAX_PARTITION_NAME);
	pspec->total_eblocks = size;
	partition_starts[pmap->nr_partitions] = start;
}

/*
 * Returns a partition map specification listing the NAND partitions whose
 * names are in partition_list.  If partition_list is NULL or empty, returns
 * all of the NAND partitions.
 * Additionally returns, in the argument partition_starts, an array of the
 * starting block numbers of the chosen partitions.  Both lists are sorted
 * in ascending order of the starting block number.  The sorting happens
 * "for free" as a result of the fact that flash_partition_info() accesses
 * the NAND partition info in ascending order, but is necessary for correct
 * operation of the caller.
 */
static struct partition_map_spec *partition_scan(char **partition_list, int **partition_starts)
{
	int nr_partitions;
	int nr_wanted, nr_allocated;
	int i, j;
	int type, granularity, size, start, namelen;
	char *nameadr;
	struct partition_map_spec *pmap;

	nr_wanted = 0;

	if (partition_list)
		for (nr_wanted = 0; partition_list[nr_wanted]; nr_wanted++)
			;

	nr_partitions = flash_num_partitions();

	nr_allocated = (nr_wanted ? nr_wanted : nr_partitions) + 1;

	*partition_starts = checked_malloc(nr_allocated * sizeof(int), "partition starts");
	(*partition_starts)[0] = 0;

	pmap = checked_malloc(sizeof(struct partition_map_spec) + nr_allocated * sizeof(struct partition_spec), "partition map");
	pmap->version = 1;
	pmap->nr_partitions = 0;
	memset(&pmap->partitions[0], 0, sizeof(struct partition_spec));

	for (i=1; i<=nr_partitions; i++) {
		flash_partition_info(i, &type, &namelen, &nameadr,
			  &granularity, &size, &start);

		/* If the partition list is null or empty, add all the NAND partitions to the map */
		if (nr_wanted == 0) {
			add_partition(pmap, *partition_starts, nameadr, namelen, start, size);
			continue;
		}

		/* Otherwise add only the NAND partitions mentioned in the list */
		for (j = 0; j < nr_wanted; j++) {
			if (strnlen(partition_list[j], MAX_PARTITION_NAME) != namelen)
				continue;
			if (memcmp(partition_list[j], nameadr, namelen) == 0)
				add_partition(pmap, *partition_starts, nameadr, namelen, start, size);
		}
	}
	return pmap;
}


static int map_blocks(int total_blocks, uint32_t *good_pages,
	       uint32_t pages_per_block, uint32_t erasesize,
	       unsigned char *this_block,
	       struct partition_map_spec *pmap, int *partition_starts
	)
{
	uint32_t block_nr, abs_block_nr;
	int nr_blocks = 0;
	uint32_t partition_nr = 0;
	uint32_t partition_limit;
	int nr_partitions = pmap->nr_partitions;
	int first_block_nr = 0;

#ifdef notdef_text
	printf("Scanning for active blocks...\n");
	fflush(stdout);
#endif
	
	/*
	 * If we are doing partitions, we'll switch partitions at the first block
	 * If we aren't doing partitions, we'll never switch
	 */
	partition_limit = nr_partitions ? 0 : 0xffffffff;

	for (abs_block_nr = block_nr = 0;
	     abs_block_nr < total_blocks;
	     block_nr++, abs_block_nr++) {
		uint32_t page_nr;

#ifdef notdef_text
		if ((block_nr % 100) == 0) {
			printf("\r%d %d", block_nr, nr_blocks);
			fflush(stdout);
		}
#endif

		if (abs_block_nr >= partition_limit) {
			pmap->partitions[partition_nr].used_eblocks = nr_blocks - first_block_nr;
			pmap->partitions[partition_nr].flags = CLEANMARKERS_MODE;
			first_block_nr = nr_blocks;
			if (++partition_nr > nr_partitions)
				break;
			abs_block_nr = partition_starts[partition_nr];
			partition_limit = abs_block_nr + pmap->partitions[partition_nr].total_eblocks;
		}
		/* XXX need error check for abs_block_nr in a hole between partitions */

		page_nr = abs_block_nr * pages_per_block;

		if (block_bad(abs_block_nr))
			continue;

//		read_flash(this_block, 4, page_nr);
		read_oob(this_block, page_nr);
		if (*(unsigned long *)this_block == 0xffffffff) {
			if (has_cleanmarker(this_block))
				continue;

			read_flash(this_block, erasesize, page_nr);
			if (is_erased(this_block, erasesize))
				continue;
//		} else {
//			read_flash(this_block, erasesize, page_nr);
		}
		good_pages[nr_blocks] = page_nr;
		nr_blocks++;
	}	
	pmap->partitions[partition_nr].used_eblocks = nr_blocks - first_block_nr;
	pmap->partitions[partition_nr].flags = CLEANMARKERS_MODE;

#ifdef notdef_text
	printf("\n");  fflush(stdout);

	if (nr_partitions == 0) {
		printf("No partitions - %d blocks %d\n", pmap->partitions[partition_nr].used_eblocks, nr_blocks);
	} else

	for (partition_nr = 1; partition_nr <= nr_partitions; partition_nr++)
		printf("Partition '%s' starts %d uses %d of %d\n",
		       pmap->partitions[partition_nr].name,
		       partition_starts[partition_nr],
		       pmap->partitions[partition_nr].used_eblocks,
		       pmap->partitions[partition_nr].total_eblocks
			);
	fflush(stdout);
#endif

	return nr_blocks;
}

int check_stop()
{
	int c;
	int stop;

	if (kbhit() == 0)
		return 0;

	c = getchar();
	if (c == 'q' || c == 'Q' || c == 0x1b)  /* 1b is ESC */
		return 1;

	printf("\nStop [y/N]? "); fflush(stdout);
	c = getchar();
	putchar(c);
	putchar('\r');
	stop = (c == 'y' || c == 'Y');
	if (!stop)
		printf("Resuming\n");
	return stop;
}
