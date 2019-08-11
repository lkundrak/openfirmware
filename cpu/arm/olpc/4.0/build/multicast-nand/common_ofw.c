/*
 * Multicast-wireless NAND reflash program.  This file implements
 * routines for running on Open Firmware that are common to both
 * transmit and receive.
 *
 * Copyright 2008  Mitch Bradley
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

#define _GNU_SOURCE
#include "1275.h"
#include <stdlib.h>
#include <string.h>

long memtol(const char *s, int len, char **endptr, int base);

#if (BYTE_ORDER == __LITTLE_ENDIAN)
unsigned long ntohl(unsigned long n)
{
	return ((n<<24) & 0xff000000) | ((n<<8) & 0x00ff0000) | ((n>>8) & 0x0000ff00) | ((n>>24) & 0xff);
}
unsigned long htonl(unsigned long n)
{
	return ((n<<24) & 0xff000000) | ((n<<8) & 0x00ff0000) | ((n>>8) & 0x0000ff00) | ((n>>24) & 0xff);
}
unsigned short ntohs(unsigned short n)
{
	return ((n<<8) & 0xff00) | ((n>>8) & 0x00ff);
}
unsigned short htons(unsigned short n)
{
	return ((n<<8) & 0xff00) | ((n>>8) & 0x00ff);
}
#else
unsigned long ntohl(unsigned long n)
{
	return n;
}
unsigned long htonl(unsigned long n)
{
	return n;
}
unsigned short ntohs(unsigned short n)
{
	return n;
}
unsigned short htons(unsigned short n)
{
	return n;
}
#endif

unsigned char *parse_ip(const char *dotted, int dottedlen)
{
	static unsigned char mcast_ip[4];

	int i;
	const char *end;
	char *parsedend;

	for (i = 0; i < 4; i++) {
		end = memchr(dotted, '.', dottedlen);
		if (i==3) {
			if (end)
				fatal("Extra . in IP address\n");
			end = dotted+dottedlen;
		} else {
			if (!end)
				fatal("Missing . in IP address\n");
		}
		mcast_ip[i] = memtol(dotted, end-dotted, &parsedend, 10);
		if (parsedend != end)
			fatal("Non-numeric character in IP address");
		dottedlen -= (end+1)-dotted;
		dotted = end+1;
	}

	return mcast_ip;
}

static int start;

void mark_time() {
	start = OFMilliseconds();
}

int elapsed_msecs()
{
	int now;
	now = OFMilliseconds();
	return now==start ? 1 : now-start;
}
