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


int sock;
int interpacket_delay;

void close_net()
{
	close(sock);
}

void set_delay(int delay_us)
{
	interpacket_delay = delay_us;
        printf("Interpacket delay is %d uSec\n", interpacket_delay);
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
		if (connect(sock, runp->ai_addr, runp->ai_addrlen) == 0)
			break;
		perror("connect");
		close(sock);
	}
	if (!runp)
		exit(1);
	return 1;
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

int rfd;

void close_file()
{
	close(rfd);
}

void open_file(char *filename, size_t *imagesize)
{
	struct stat st;

	rfd = open(filename, O_RDONLY);
	if (rfd < 0) {
		perror("open");
		exit(1);
	}

	if (fstat(rfd, &st)) {
		perror("fstat");
		exit(1);
	}

	*imagesize = st.st_size;
}

int read_file(void *adr, size_t len)
{
	size_t actual;

	actual = read(rfd, adr, len);
	if (actual < 0) {
		perror("read");
		exit(1);
	}
        return actual;
}

void rewind_file()
{
	lseek(rfd, 0, SEEK_SET);
}

size_t put_packet(void *adr, size_t len)
{
	size_t actual;
	actual = write(sock, adr, len);
	if (actual < 0) {
		perror("write");
	}
        usleep(interpacket_delay);
	return actual;
}
