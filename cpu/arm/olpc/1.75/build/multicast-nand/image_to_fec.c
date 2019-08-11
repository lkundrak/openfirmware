// #define _POSIX_C_SOURCE 199309
// _GNU_SOURCE is needed for strcasestr()
#define _GNU_SOURCE

#include <errno.h>  	
#include <error.h> 	
#include <netdb.h> 	
#include <stdio.h> 	
#include <stdlib.h> 	
#include <string.h>
#include <unistd.h> 	
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include "crc32.h"
#include "mcast_image.h"

int put_placement_spec_packet(int ofd, struct image_pkt *pktbuf);
int open_placement_spec(char *signame, char *secname);
void write_packet(void);

#define PLACEMENT_INTERVAL 32

uint32_t sequence = 0;

// placement, ofd, pktbuf, image, erasesize, last_block, fec, PKT_SIZE, block_crcs
// placement_ctr, block_nr, pkt_nr, sequence

struct image_pkt pktbuf;
int ofd;
int placement = 0;
unsigned char *image;
uint32_t erasesize;
unsigned char *last_block;
struct fec_parms *fec;
uint32_t *block_crcs;
uint32_t block_nr, pkt_nr;
int nr_blocks;

int main(int argc, char **argv)
{
	int rfd;
	struct stat st;
	int pkts_per_block;
	int total_pkts_per_block;
	uint32_t redundancy;
	mode_t outfile_mode = S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH;
	int mode = 0;
        int namelen;

	if ((argc != 5) && (argc != 7)) {
		fprintf(stderr, "usage: image_to_fec   <image_in> <erasesize> <image_out> <redundancy> [<spec> <signature>]\n");
		fprintf(stderr, "usage: image_to_fec_i <image_in> <erasesize> <image_out> <redundancy> [<spec> <signature>]\n");
		fprintf(stderr, "  .. _i is interleaved mode, where the order is blk0p0, blk1p0, blk2p0, etc\n");
		fprintf(stderr, "  .. normally the order is blk0p0, blk0p1, blk0p2, etc\n");
		fprintf(stderr, "\nInterleaved mode completes sooner under high-error-rate conditions,\n");
		fprintf(stderr, "but its storage access pattern is non-sequential, which can cause \n");
		fprintf(stderr, "severe performance problems.  Also its progress reports are unclear.\n");
		exit(1);
	}

	namelen = strlen(argv[0]);
	if (!(namelen >= 2 && strcmp("_i", argv[0]+namelen-2) == 0))
		mode |= BLOCK_MODE;

	if (mode & BLOCK_MODE)
		fprintf(stderr, "Using block mode\n");
	else
		fprintf(stderr, "Using interleaved mode\n");

        placement = (argc == 6);

	erasesize = atol(argv[2]);
	if (!erasesize) {
		fprintf(stderr, "erasesize cannot be zero\n");
		exit(1);
	}


	printf("A\n");
        redundancy = atoi(argv[4]);

	if (redundancy < 0 || redundancy > 99) {
		printf("Redundancy must be between 0 and 99 inclusive\n");
		exit(1);
	}

	pkts_per_block = (erasesize + PKT_SIZE - 1) / PKT_SIZE;
	total_pkts_per_block = pkts_per_block * (redundancy + 100) / 100;

	/* We have to pad it with zeroes, so can't use it in-place */
	last_block = malloc(pkts_per_block * PKT_SIZE);
	if (!last_block) {
		fprintf(stderr, "Failed to allocate last-block buffer\n");
		exit(1);
	}
	
	printf("B\n");
	fec = fec_new(pkts_per_block, total_pkts_per_block, PKT_SIZE);
	if (!fec) {
		fprintf(stderr, "Error initialising FEC\n");
		exit(1);
	}

	rfd = open(argv[1], O_RDONLY);
	if (rfd < 0) {
		perror("open");
		exit(1);
	}

	if (strcasestr(".zd", argv[1]))
		mode |= ZDATA_MODE;

	printf("Using %s mode\n\n", mode & ZDATA_MODE ? "zdata" : "jffs2");
	if (fstat(rfd, &st)) {
		perror("fstat");
		exit(1);
	}

	if ((!(mode & ZDATA_MODE)) && st.st_size % erasesize) {
		fprintf(stderr, "Image size %ld bytes is not a multiple of erasesize %d bytes\n",
			st.st_size, erasesize);
		exit(1);
	}

	printf("C\n");
	image = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, rfd, 0);
	if (image == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	printf("D\n");
	ofd = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, outfile_mode);
	if (ofd < 0) {
		perror("open");
		exit(1);
	}

	if (placement) {
		if(open_placement_spec(argv[6], argv[5]))
			return 1;
		mode |= PLACEMENT_MODE;
	}

	nr_blocks = (st.st_size + erasesize - 1)/ erasesize;

	printf("E\n");
	block_crcs = malloc(nr_blocks * sizeof(uint32_t));
	if (!block_crcs) {
		fprintf(stderr, "Failed to allocate memory for CRCs\n");
		exit(1);
	}

	memset(last_block, 0, PKT_SIZE * pkts_per_block);
	memcpy(last_block, image + (nr_blocks - 1) * erasesize, st.st_size - ((nr_blocks - 1) * erasesize));

	printf("Computing overall CRC\n");
	pktbuf.hdr.mode = htonl(mode);
	pktbuf.hdr.totcrc = htonl(crc32(-1, image, st.st_size));
	pktbuf.hdr.nr_blocks = htonl(nr_blocks);
	pktbuf.hdr.blocksize = htonl(erasesize);
	pktbuf.hdr.thislen = htonl(PKT_SIZE);
	pktbuf.hdr.nr_pkts = htons(total_pkts_per_block);

	if (mode & BLOCK_MODE) {
		printf("Total blocks %d\n", nr_blocks);
		for (block_nr = 0; block_nr < nr_blocks; block_nr++) {
			unsigned char *blockptr;

			printf("%d\r", block_nr);
			fflush(stdout);
			blockptr = (block_nr == nr_blocks - 1) ? last_block : image+(block_nr*erasesize);
			block_crcs[block_nr] = crc32(-1, blockptr, erasesize);

			for (pkt_nr=0; pkt_nr < total_pkts_per_block; pkt_nr++)
				write_packet();
		}
	} else {
		for (block_nr=0; block_nr < nr_blocks; block_nr++) {
			unsigned char *blockptr;

			blockptr = (block_nr == nr_blocks - 1) ? last_block : image+(block_nr*erasesize);
			block_crcs[block_nr] = crc32(-1, blockptr, erasesize);
		}

		for (pkt_nr=0; pkt_nr < total_pkts_per_block; pkt_nr++)
			for (block_nr = 0; block_nr < nr_blocks; block_nr++)
				write_packet();
	}
	munmap(image, st.st_size);
	close(rfd);
	close(ofd);
	return 0;
}

void write_packet()
{
        unsigned char *blockptr = NULL;
	static int placement_ctr = PLACEMENT_INTERVAL;

	if(placement && --placement_ctr == 0) {
		placement_ctr = PLACEMENT_INTERVAL;
		if (put_placement_spec_packet(ofd, &pktbuf))
			exit(1);
	}

	blockptr = image + (erasesize * block_nr);
	if (block_nr == nr_blocks - 1)
		blockptr = last_block;

	fec_encode_linear(fec, blockptr, pktbuf.data, pkt_nr, PKT_SIZE);

	pktbuf.hdr.thiscrc = htonl(crc32(-1, pktbuf.data, PKT_SIZE));
	pktbuf.hdr.block_crc = htonl(block_crcs[block_nr]);
	pktbuf.hdr.block_nr = htonl(block_nr);
	pktbuf.hdr.pkt_nr = htons(pkt_nr);
	pktbuf.hdr.pkt_sequence = htonl(sequence++);

	if (write(ofd, &pktbuf, sizeof(pktbuf)) < 0) {
		perror("write");
		exit(1);
	}
}

size_t siglen;
size_t seclen;
unsigned char *secimage;
int placement_pkt_nr;
int placement_nr_pkts;
int placement_len;
int nread;

int open_placement_spec(char *signame, char *secname) {
	struct stat st;
	int sigfd;
	int secfd;

	sigfd = open(signame, O_RDONLY);
	if (sigfd < 0) {
		perror("open signature file");
		return 1;
	}
	secfd = open(secname, O_RDONLY);
	if (secfd < 0) {
		perror("open security file");
		return 1;
	}

	if (fstat(sigfd, &st)) {
		perror("sigfd fstat");
		return 1;
	}
	siglen = st.st_size;

	if (fstat(secfd, &st)) {
		perror("secfd fstat");
		return 1;
	}
	seclen = st.st_size;

	placement_len = siglen + seclen;

	if ((secimage = malloc(seclen)) == NULL) {
		perror("malloc");
		return 1;
	}

	if ((nread = read(sigfd, secimage, siglen)) != siglen) {
		printf("nread = %d\n", nread);
		perror("read signature");
		return 1;
	}
	close(sigfd);
	if ((nread = read(secfd, secimage + siglen, seclen)) != seclen) {
		printf("nread = %d\n", nread);
		perror("read placement update spec");
		return 1;
	}
	close(secfd);

	placement_pkt_nr = 0;
	placement_nr_pkts = (placement_len + PKT_SIZE - 1) / PKT_SIZE;

	return 0;
}

int put_placement_spec_packet(int ofd, struct image_pkt *pktbuf) {
	int thislen;
	int offset;
	int mode;

	offset = placement_pkt_nr * PKT_SIZE;
	thislen = placement_len - offset;

	if(thislen > PKT_SIZE)
		thislen = PKT_SIZE;

	memcpy(pktbuf->data, secimage + offset, thislen);
	memset(pktbuf->data + thislen, 0, PKT_SIZE - thislen);

	mode = ntohl(pktbuf->hdr.mode);
	pktbuf->hdr.mode = htonl(mode | PLACEMENT_SPEC);
	pktbuf->hdr.thiscrc = htonl(crc32(-1, pktbuf->data, PKT_SIZE));
	pktbuf->hdr.placement_pkt_nr = htons(placement_pkt_nr);
	pktbuf->hdr.placement_nr_pkts = htons(placement_nr_pkts);
	pktbuf->hdr.pkt_sequence = htonl(sequence++);
	pktbuf->hdr.thislen = htonl(thislen);
	pktbuf->hdr.image_len = htonl(seclen);
	pktbuf->hdr.signature_len = htonl(siglen);

	if (write(ofd, pktbuf, sizeof(*pktbuf)) < 0) {
		perror("write");
		return 1;
	}

	pktbuf->hdr.mode = htonl(mode);
	pktbuf->hdr.thislen = htonl(PKT_SIZE);

	if(++placement_pkt_nr == placement_nr_pkts)
		placement_pkt_nr = 0;
	return 0;
}
