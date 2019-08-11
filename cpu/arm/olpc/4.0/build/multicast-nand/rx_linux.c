/*
 * Multicast-wireless NAND reflash program.  This file implements the
 * system-dependent receive routines for running on Linux.  The core
 * system-independent receive algorithm is in reflash.c .
 *
 * Copyright © 2008  David Woodhouse
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#define _XOPEN_SOURCE 500

#include <errno.h>
#include <error.h>
#include <stdio.h>
#define __USE_GNU
#include <netdb.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <sys/time.h>
#include "mtd/mtd-user.h"
#include "io.h"

static int erasesize;
static int pagesize;
static int pages_per_block;
static int npages;

static void open_mtd(char *name);

int
main(int argc, char *argv[])
{
	int ret;
	if (argc != 4) {
		fprintf(stderr, "usage: %s <host[:port]> <mtddev>\n",
			(strrchr(argv[0], '/')?:argv[0]-1)+1);
		exit(1);
	}
        (void) open_net(argv[1]);

	open_mtd(argv[3]);

int reflash(int erasesize, int pagesize, int npages);

	ret = reflash(erasesize, pagesize, npages, 2048);
	close_net();
	close_flash();
	return ret;
}

int sock;

void close_net()
{
	close(sock);
}

int open_net(char *nodename)
{
	int ret;
	struct addrinfo *ai;
	struct addrinfo hints;
	struct addrinfo *runp;
        char *dstport;
	char *tailstr;
	int nodelen;
	char hostname[256];

	tailstr = strchr(nodename, ':');
	if (tailstr) {
		dstport = tailstr+1;
		nodelen = tailstr - nodename;
	} else {
		dstport = "12345";
		nodelen = strlen(nodename);
	}
	if (nodelen > 255)
		nodelen = 255;
	strncpy(hostname, nodename, nodelen);
	hostname[nodelen] = '\0';

	memset(&hints, 0, sizeof(hints));
	hints.ai_flags = AI_ADDRCONFIG;
	hints.ai_socktype = SOCK_DGRAM;
	
	ret = getaddrinfo(nodename, dstport, &hints, &ai);
	if (ret) {
		fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(ret));
		exit(1);
	}
	runp = ai;
	for (runp = ai; runp; runp = runp->ai_next) {
		sock = socket(runp->ai_family, runp->ai_socktype,
			      runp->ai_protocol);
		if (sock == -1) {
			perror("socket");
			continue;
		}
		if (runp->ai_family == AF_INET &&
		    IN_MULTICAST( ntohl(((struct sockaddr_in *)runp->ai_addr)->sin_addr.s_addr))) {
			struct ip_mreq rq;
			rq.imr_multiaddr = ((struct sockaddr_in *)runp->ai_addr)->sin_addr;
			rq.imr_interface.s_addr = INADDR_ANY;
			if (setsockopt(sock, IPPROTO_IP, IP_ADD_MEMBERSHIP, &rq, sizeof(rq))) {
				perror("IP_ADD_MEMBERSHIP"); 
				close(sock);
				continue;
			}
			
		} else if (runp->ai_family == AF_INET6 &&
			   ((struct sockaddr_in6 *)runp->ai_addr)->sin6_addr.s6_addr[0] == 0xff) {
			struct ipv6_mreq rq;
			rq.ipv6mr_multiaddr =  ((struct sockaddr_in6 *)runp->ai_addr)->sin6_addr;
			rq.ipv6mr_interface = 0;
			if (setsockopt(sock, IPPROTO_IPV6, IPV6_ADD_MEMBERSHIP, &rq, sizeof(rq))) {
				perror("IPV6_ADD_MEMBERSHIP"); 
				close(sock);
				continue;
			}
		}
		if (bind(sock, runp->ai_addr, runp->ai_addrlen)) {
			perror("bind");
			close(sock);
			continue;
		}
		break;
	}
	if (!runp)
		exit(1);
	return 1;
}

size_t get_packet(unsigned char *packet, size_t len)
{
	size_t actlen;
	actlen = read(sock, packet, len);
	if (actlen < 0)
		perror("read socket");

	if (actlen < len)
		fprintf(stderr, "Wrong length %d bytes (expected %d)\n",
			actlen, len);
	return len;
}


void *checked_malloc(size_t nbytes, char *err_msg)
{
	void *mem;
	mem = malloc(nbytes);
	if (!mem) {
		printf("malloc failed - %s\n", err_msg);
		exit(1);
	}
	return mem;
}

struct timeval start;

void mark_time() {
	gettimeofday(&start, NULL);
}

int elapsed_msecs()
{
	struct timeval now;
        int msecs;
	gettimeofday(&now, NULL);
        msecs = ((now.tv_sec - start.tv_sec)*1000) + ((now.tv_usec - start.tv_usec)/1000);
	if (msecs == 0)
		msecs = 1;	/* Avoid divide by 0 when computing data rates */
	return msecs;
}


int file_mode = 0;

int flfd;

void
close_flash()
{
	close(flfd);
}

void
static open_mtd(char *name)
{
	struct mtd_info_user meminfo;

	/* Open the device */
	flfd = open(name, O_RDWR);

	if (flfd >= 0) {
		/* Fill in MTD device capability structure */
		if (ioctl(flfd, MEMGETINFO, &meminfo) != 0) {
			perror("MEMGETINFO");
			close(flfd);
			flfd = -1;
		} else {
			erasesize = meminfo.erasesize;
			pagesize = meminfo.writesize;
			npages = meminfo.size / pagesize;
			pages_per_block = erasesize / pagesize;

			printf("Receive to MTD device %s with erasesize %d\n",
			       filename, erasesize);
		}
	}
	if (flfd == -1) {
		/* Try again, as if it's a file */
		flfd = open(filename, O_CREAT|O_TRUNC|O_RDWR, 0644);
		if (flfd < 0) {
			perror("open");
			exit(1);
		}
		erasesize = 131072;
		pagesize = 2048;
		pages_per_block = erasesize / pagesize;
		file_mode = 1;
		printf("Receive to file %s with (assumed) erasesize %d\n",
		       filename, erasesize);
	}
}

int block_bad(uint32_t flash_page)
{
	loff_t mtdoffset;

	if (file_mode)
		return 0;

	if (flash_page >= npages) {
		fprintf(stderr, "Run out of space on flash\n");
		exit(1);
	}

	mtdoffset = flash_page * pagesize;
#if 1 /* Comment out to deliberately use bad blocks... test write failures */
	if (ioctl(flfd, MEMGETBADBLOCK, &mtdoffset) > 0) {
		printf("Skipping flash bad block number %08x\n", flash_page/pages_per_block);
		return 1;
	}
#endif
	return 0;
}

void erase_block(uint32_t flash_page)
{
	struct erase_info_user erase;

	if (file_mode)
		return;

	erase.start = flash_page * pagesize;
	erase.length = erasesize;

	printf("\rErasing block number %08x...", flash_page/pages_per_block);

	if (ioctl(flfd, MEMERASE, &erase)) {
		perror("MEMERASE");
		exit(1);
	}
}

size_t write_flash(unsigned char *adr, size_t len, uint32_t flash_page)
{
	return pwrite(flfd, adr, len, flash_page * pagesize);
}

size_t read_flash(unsigned char *adr, size_t len, uint32_t flash_page)
{
	return pread(flfd, adr, len, flash_page * pagesize);
}
