/*
 * Multicast-wireless NAND reflash program.  This file implements the
 * system-dependent transmit routines for running on Open Firmware.
 * The core system-independent transmit algorithm is in serve_image.c .
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

#include <stdio.h>
int printf(char *fmt, ...);
void fflush (FILE *fp);
long memtol(const char *s, int len, char **endptr, int base);

unsigned char *parse_ip(const char *dotted, int dottedlen);

static ihandle netih;

static int thinmac_mode = 0;
static int direct_mode = 0;
static int udp_mode = 0;
static int dstport;
static int interpacket_delay;

void close_net()
{
	OFClose(netih);
}

static unsigned char ether_packet[1600] = {
	0x01, 0x00, 0x5e, 0x7e, 0x01, 0x02,	/* Dest addr */
//	0x01, 0x00, 0x5e, 0x7e, 0x01, 0x01,	/* Src addr */
	0x08, 0x07, 0x06, 0x05, 0x04, 0x03,	/* Src addr */
	'X', 'O'				/* Protocol */
};

static unsigned char thin_ether_packet[1600] = {
	0x01,  'O',  'L',  'P',  'C', 0x02,	/* Dest addr */
	0x08, 0x07, 0x06, 0x05, 0x04, 0x03,	/* Src addr */
	'X', 'O'				/* Protocol */
};

static int open_thinmac(char *args)  /* args are ssid,channel */
{
	char *thisadr;
	char *nextadr;
	char *endadr;
	char *ssidadr;
	int ssidlen;
	int chnum;
        unsigned char *mac_adr;
        int mac_len;

	thisadr = args;
	endadr = thisadr + strlen(thisadr);

	ssidadr = thisadr;
	nextadr = memchr(thisadr, ',', endadr-thisadr);
	if (!nextadr) {
		ssidlen = endadr - thisadr;
		thisadr = endadr;
	} else {
		ssidlen = nextadr - thisadr;
		thisadr = nextadr + 1;  /* Skip the delimiter */
	}
	if (ssidlen == 0) {
		ssidadr = "OLPC-NANDblaster";
		ssidlen = strlen(ssidadr);
		printf("Using default SSID '%s'\n", ssidadr);
	}

	if (thisadr == endadr) {
		chnum = 1;
		printf("Using default channel number %d\n", chnum);
	} else {
		chnum = memtol(thisadr, endadr-thisadr, NULL, 10);
	}

	netih = OFOpen("/wlan:force");
	if (!netih)
		fatal("Can't open network\n");

	thinmac_mode = 1;

	OFCallMethodV("start-ap", netih, 3, 0, ssidlen, ssidadr, chnum);
	OFCallMethodV("set-tx-ctrl", netih, 1, 0, 0x1b);  // Data rate
	OFCallMethodV("get-mac-address", netih, 0, 2, &mac_len, &mac_adr);
//      printf("Mac adr %x mac len %d\n", (unsigned int)mac_adr, mac_len);
        if (mac_len == 6) {
//          printf("%02x %02x %02x %02x %02x %02x\n", mac_adr[0], mac_adr[1], mac_adr[2], mac_adr[3], mac_adr[4], mac_adr[5]);
        memcpy(thin_ether_packet+6, mac_adr, mac_len);
        }
	return 1;  /* Repeat */
}

static int open_adhoc(char *args)
{
	char *thisadr;
	char *nextadr;
	char *endadr;
	char *ssidadr;
	int ssidlen;
	char *ipadr;
	int iplen;
	int chnum;
	unsigned char *mcast_ip;

	thisadr = args;
	endadr = thisadr + strlen(thisadr);

	ssidadr = thisadr;
	nextadr = memchr(thisadr, ',', endadr-thisadr);
	if (!nextadr) {
		ssidlen = endadr - thisadr;
		thisadr = endadr;
	} else {
		ssidlen = nextadr - thisadr;
		thisadr = nextadr + 1;  /* Skip the delimiter */
	}
	if (ssidlen == 0) {
		ssidadr = "OLPC-NANDblaster";
		ssidlen = strlen(ssidadr);
		printf("Using default SSID '%s'\n", ssidadr);
	}

	ipadr = thisadr;
	nextadr = memchr(thisadr, ',', endadr-thisadr);
	if (!nextadr) {
		iplen = endadr - thisadr;
		thisadr = endadr;
	} else {
		iplen = nextadr - thisadr;
		thisadr = nextadr + 1;  /* Skip the delimiter */
	}
	if (iplen == 0) {
		ipadr = "239.255.1.2";
		iplen = strlen(ipadr);
		printf("Using default IP address %s\n", ipadr);
	}

	if (thisadr == endadr) {
		chnum = 1;
		printf("Using default channel number %d\n", chnum);
	} else {
		chnum = memtol(thisadr, endadr-thisadr, NULL, 10);
	}

	netih = OFOpen("/wlan:force");
	if (!netih)
		fatal("Can't open network\n");

	direct_mode = 1;

	mcast_ip = parse_ip(ipadr, iplen);

	ether_packet[3] = mcast_ip[1] & 0x7f;
	ether_packet[4] = mcast_ip[2];
	ether_packet[5] = mcast_ip[3];

	OFCallMethodV("adhoc-start", netih, 3, 0, ssidlen, ssidadr, chnum);
	OFCallMethodV("enable-multicast", netih, 0, 0);
//	OFCallMethodV("set-data-rate",   netih, 1, 0, 0xb);  // Data rate is in the TX packet
//	OFCallMethodV("set-beacon", netih, 2, 0, 0, 1000);
	return 1;  /* Repeat */
}

int open_net(char *nodename)
{
	if (memcmp(nodename, "ether:", 6) == 0) {
		char *chnum = nodename+6;
		netih = OFOpen("net:force");
		if (!netih)
			fatal("Can't open network\n");
		direct_mode = 1;
		OFCallMethodV("mesh-start", netih, 1, 0, atoi(chnum));
		OFCallMethodV("enable-multicast", netih, 0, 0);
		OFCallMethodV("mesh-set-ttl",     netih, 1, 0, 1);
		OFCallMethodV("mesh-set-bcast",   netih, 1, 0, 0xb);
//	OFCallMethodV("set-beacon", netih, 2, 0, 1, 1000);
		OFCallMethodV("set-beacon", netih, 2, 0, 0, 1000);
                return 1;  /* Repeat */
        }

	if (memcmp(nodename, "thinmac:", 8) == 0) {  /* thinmac:ssid,channel */
		return open_thinmac(nodename+8);
        }

	if (memcmp(nodename, "adhoc:", 6) == 0) {  /* adhoc:ssid,ipadr,channel */
		return open_adhoc(nodename+6);
        }

	if (memcmp(nodename, "udp:", 4) == 0) {
		char netname[14+32] = "net//obp-tftp:";
		char *tailstr;
		int nodelen;

		udp_mode = 1;
                nodename = strchr(nodename, ':') + 1;	/* Remove the "udp:" */
                tailstr = strchr(nodename, ':');
		if (tailstr) {
			dstport = atoi(tailstr+1);
			if (dstport == 0)
				dstport = 12345;
			nodelen = tailstr - nodename;
		} else {
			dstport = 12345;
			nodelen = strlen(nodename);
		}
		if (nodelen > 31)
			nodelen = 31;
		strncpy(netname+14, nodename, nodelen);
		netname[14+nodelen] = '\0';
		netih = OFOpen(netname);
		if (!netih)
			fatal("Can't open network\n");
                return 1;  /* */
	}

	/*
	 * If neither UDP mode nor direct mode, we write raw packets with no
	 * network headers.  This is for creating a file containing predigested
	 * packets with forward error correction and nandblaster protocol headers.
	*/
	netih = OFOpen(nodename);
	if (!netih)
		fatal("Can't open output file\n");
	return 0;  /* Don't repeat */
}

void set_delay(int delay_us)
{
	interpacket_delay = delay_us;
        printf("Interpacket delay is %d uSec\n", interpacket_delay);
}

static void do_delay()
{
	int remaining_delay;
	int granule = 200;

	for (remaining_delay = interpacket_delay; remaining_delay > 0; remaining_delay -= granule) {
		(void)OFCallMethodV("process-mgmt-frame", netih, 0, 0);
		OFInterpretV("us", 1, 0, granule);
	}
}

static int poll_counter = 0;

size_t put_packet(void *packet, size_t len)
{
	int status;

	if (thinmac_mode) {
		++poll_counter;
		if (poll_counter % 2 == 0) {
			(void)OFCallMethodV("process-mgmt-frame", netih, 0, 0);
		}
		if (poll_counter == 100) {
			(void)OFInterpretV("us", 1, 0, 1000);
			poll_counter = 0;
		}
		memcpy(thin_ether_packet+14, packet, len);
		status = OFWrite(netih, thin_ether_packet, len+14);
		do_delay();
		return status;
	}

	if (direct_mode) {
		memcpy(ether_packet+14, packet, len);
		status = OFWrite(netih, ether_packet, len+14);
		do_delay();
		return status;
	}

	if (udp_mode) {
		unsigned char padbuf[1600];
		cell_t argarray[] = { (cell_t)"call-method", 6,1,0,0,0,0,0,0,0,0,0,0};

		memcpy(padbuf+0x30, packet, len); /* Leave room at beginning for ether + ip + udp header */

		argarray[CIF_HANDLER_IN+LOW(0)] = (cell_t)"send-udp-packet";
		argarray[CIF_HANDLER_IN+LOW(1)] = (cell_t)netih;
		argarray[CIF_HANDLER_IN+LOW(2)] = dstport;
		argarray[CIF_HANDLER_IN+LOW(3)] = dstport;  /* srcport == dstport */
		argarray[CIF_HANDLER_IN+LOW(4)] = len;
		argarray[CIF_HANDLER_IN+LOW(5)] = (cell_t)(padbuf + 0x30);

		if (call_firmware(argarray) != 0)
			return -1;

		if (argarray[CIF_HANDLER_IN+LOW(6)])  // Catch result
			return -1;

		return len;
	}
	status = OFWrite(netih, packet, len);
	do_delay();
	return status;
}

int fileih;

void close_file()
{
	OFClose(fileih);
}

void open_file(char *name, size_t *filesize)
{
	int sizehigh;

	/* Open the device */
	fileih = OFOpen(name);

	if (fileih == 0) {
		close_net();
		fatal("Can't open file\n");
	}
	OFCallMethodV("size", fileih, 0, 2, &sizehigh, filesize);
}

void rewind_file()
{
	int result;
	OFCallMethodV("seek", fileih, 2, 1, 0, 0, &result);
}

int read_file(void *adr, size_t len)
{
	int nread;
	nread = OFRead(fileih, adr, len);
	if (nread < 0) {
		close_file();
		close_net();
		fatal("File read error");
	}
        return nread;
}
