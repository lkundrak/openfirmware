#define _POSIX_C_SOURCE 199309

#include <netdb.h> 	
#include <stdio.h> 	
#include <stdlib.h> 	
#include <string.h>
#include "mcast_image.h"
#include "io.h"

int main(int argc, char **argv)
{
	uint32_t erasesize;
	struct image_pkt pktbuf;
	uint32_t block_nr, pkt_nr;
	int nr_blocks;
	long time_msecs;
	int pkts_per_block;
	size_t imagesize;
	unsigned long kib_sent;
	int nread;
	int npkts;
	uint32_t mode;
	int writeerrors = 0;
        int delay_us;

	if (argc != 3 && argc != 4) {
		printf("usage: %s net image [delay-us]\n", argv[0]);
		exit(1);
	}

	(void) open_net(argv[1]);
	open_file(argv[2], &imagesize);
        if (argc == 4)
            delay_us = atoi(argv[3]);
        else
            delay_us = 1000;


        set_delay(delay_us);

	if (imagesize % sizeof(struct image_pkt)) {
		printf("Image size %d bytes is not a multiple of packetsize %d\n",
                       imagesize, sizeof(struct image_pkt));
		close_file();
		close_net();
		return 1;
	}

	nread = read_file(&pktbuf, sizeof(pktbuf));
	if (nread < sizeof(pktbuf)) {
		printf("File read error\n");
		close_file();
		close_net();
		return 1;
	}

	erasesize = ntohl(pktbuf.hdr.blocksize);
	if (!erasesize) {
		printf("erasesize cannot be zero\n");
		close_file();
		close_net();
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

	while (1) {
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
					if (pkt_nr == 0)
						printf("\r%5d", block_nr);
				} else {
					if (block_nr == 0)
						printf("\r%3d", pkt_nr);
				}
			}

			if (put_packet(&pktbuf, sizeof(pktbuf)) < 0) {
				writeerrors++;
				if (writeerrors > 10) {
					printf("Too many consecutive write errors\n");
					close_file();
					close_net();
					exit(1);
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
	close_file();
	close_net();
	return 0;
}
