#define _GNU_SOURCE
#include <netdb.h> 	
#include <stdio.h> 	
#include <stdlib.h> 	
#include <string.h>
#include "crc32.h"
#include "mcast_image.h"
#include "partition.h"
#include "io.h"

static int map_blocks(int total_blocks, uint32_t *good_blocks,
       	       uint32_t pages_per_block, uint32_t erasesize,
	       unsigned char *this_block,
	       struct partition_map_spec *pmap, int *partition_starts);

static int is_erased(unsigned char *block, int len);
static int has_cleanmarker(unsigned char *block);
struct partition_map_spec *partition_scan(char **partition_list, int **partition_starts);

int check_stop(void);
int kbhit(void);

int main(int argc, char **argv)
{
	struct image_pkt pktbuf;
	int writeerrors = 0;
	uint32_t erasesize;
	uint32_t block_nr, pkt_nr;
	int total_blocks, nr_blocks;
	long time_msecs;
	int pkts_per_block;
	int total_pkts_per_block;
	struct fec_parms *fec;
	unsigned char *this_block;
	uint32_t *block_crcs, totcrc;
	uint32_t *good_pages;	/* Absolute page number on source system */
	uint32_t sequence = 0;
	uint32_t total_pages, pagesize, pages_per_block;
	unsigned long amt_sent;
	int firsttime = 1;
	struct partition_map_spec *pmap;
	char **partition_list;
	int *partition_starts;
        int repeat;

	if (argc < 2) {
		printf("usage: %s <host> [<partition> ...]\n", argv[0]);
		fflush(stdout);
		exit(1);
	}

	show_flash_map();
	open_flash(&erasesize, &pagesize, &total_pages);
	repeat = open_net(argv[1]);

	if (argc > 2)
		partition_list = &argv[2];
	else
		partition_list = NULL;

	pages_per_block = erasesize / pagesize;
	total_blocks = total_pages / pages_per_block;

	pkts_per_block = (erasesize + PKT_SIZE - 1) / PKT_SIZE;
//	total_pkts_per_block = pkts_per_block * 3 / 2;
	total_pkts_per_block = pkts_per_block * 12 / 10;

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
		fflush(stdout);
		exit(1);
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
			fflush(stdout);
#else
			highlight_flash_block(good_pages[block_nr]);
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
					fflush(stdout);
					writeerrors++;
					if (writeerrors > 10) {
						printf("Too many consecutive send errors\n");
						fflush(stdout);
						exit(1);
					}
				} else
					writeerrors = 0;
			}
		}
		
		time_msecs = elapsed_msecs();

		printf("\r%ld KiB sent in %ld s (%ld KiB/s)",
		       amt_sent / 1024, (time_msecs + 500) / 1000,
		       amt_sent / 1024 * 1000 / time_msecs);
		fflush(stdout);

		if (firsttime) {
			pktbuf.hdr.totcrc = htonl(totcrc);
			firsttime = 0;
		}
	}

	printf("\n"); fflush(stdout);
	close_net();
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

static void *checked_malloc(size_t nbytes, char *err_msg)
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
struct partition_map_spec *partition_scan(char **partition_list, int **partition_starts)
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


int map_blocks(int total_blocks, uint32_t *good_pages,
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
			first_block_nr = nr_blocks;
			if (++partition_nr > nr_partitions)
				break;
			abs_block_nr = partition_starts[partition_nr];
			partition_limit = abs_block_nr + pmap->partitions[partition_nr].total_eblocks;
		}
		/* XXX need error check for abs_block_nr in a hole between partitions */

		page_nr = abs_block_nr * pages_per_block;

		if (block_bad(page_nr))
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

	if (kbhit() == 0)
		return 0;

	c = getchar();
	if (c == 'q' || c == 'Q' || c == 0x1b)  /* 1b is ESC */
		return 1;

	printf("\nStop [y/N]? "); fflush(stdout);
	c = getchar();
	putchar(c);
	putchar('\r');
	return (c == 'y' || c == 'Y');
}
