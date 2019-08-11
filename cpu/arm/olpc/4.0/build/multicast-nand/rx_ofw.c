/*
 * Multicast-wireless NAND reflash program.  This file implements the
 * system-dependent receive routines for running on Open Firmware.
 * The core system-independent receive algorithm is in reflash.c .
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
#include "mcast_image.h"
#include <stdlib.h>
#include <string.h>
#include "partition.h"
#include "io.h"

// XXX Make this dynamic depending on cmdline args
// Perhaps udp:<whatever> or ether:<whatever>

#define ETHER_TRANSPORT

#include <stdio.h>

int printf(char *fmt, ...);
int sprintf(char *s, char *fmt, ...);
void fflush (FILE *fp);
void exit(int code);
void *malloc(size_t nbytes);
// char *malloc(size_t nbytes);

static ihandle netih;

static int dstport;
static int direct_mode;

int
main(int argc, char *argv[])
{
	int ret;
	int secure;
        int writesize;
        unsigned int erasesize, pagesize, nblocks;
	char *specadr;
	int speclen;

	if ((argc != 2) && (argc != 3))
		fatal("usage: %s <host> [secure]\n", argv[0]);

	secure = (argc == 3);

//	show_flash_map();
	open_flash(&erasesize, &pagesize, &nblocks, &writesize);
        (void) open_net(argv[1]);

	ret = reflash(erasesize, pagesize, nblocks, secure, writesize, &specadr, &speclen);

	close_net();
	close_flash();
	if (ret == ZDATA_MODE) {
		if (secure) {
			secure_fs_update(specadr, speclen);
		} else {
			try_fs_update();
		}
	}

	return ret;
}

void close_net()
{
	OFClose(netih);
}

static void open_mesh(char *nodename)
{
	unsigned char multicast_addr[] = {
		0x01, 0x00, 0x5e, 0x7e, 0x01, 0x02,	/* Dest addr */
	};
	int status;
	int i;

	direct_mode = 1;	/* We'll use raw link level packets */

	netih = OFOpen("net:force");
	if (!netih) {
		close_flash();
		fatal("Can't open network\n");
	}
	for(i=0; i<2; i++) {
		OFCallMethodV("mesh-start", netih, 1, 1, atoi(nodename), &status);
		if (status == 0)
			break;
		printf("Mesh restart\n");
	}
	if (i == 2) {
		close_flash();
		close_net();
		fatal("Mesh didn't start\n");
	}
	
	OFCallMethodV("set-beacon", netih, 2, 0, 0, 100);  /* Disable beacon */
	OFCallMethodV("set-multicast", netih, 2, 0, 6, multicast_addr);
//	OFCallMethodV("mesh-set-ttl", netih, 1, 0, 1);     /* Possibly unnecessary */
}

static void open_ssid(char *ssidadr, int ssidlen)
{
	unsigned char multicast_mac[] = {
		0x01,  'O',  'L',  'P',  'C', 0x02,	/* Dest addr */
	};

	direct_mode = 1;	/* We'll use raw link level packets */

	OFInterpretV("$essid", 2, 0, ssidlen, ssidadr);

	netih = OFOpen("net");
	if (!netih) {
		close_flash();
		fatal("Can't open network\n");
        }

	OFCallMethodV("set-multicast", netih, 2, 0, 6, multicast_mac);
}


void open_adhoc(char *ssidadr, int ssidlen, unsigned char *mcast_ip)
{
	unsigned char multicast_mac[] = {
		0x01, 0x00, 0x5e, 0x7e, 0x01, 0x02,	/* Template */
	};
	int status;

	direct_mode = 1;	/* We'll use raw link level packets */

	multicast_mac[3] = mcast_ip[1] & 0x7f;
	multicast_mac[4] = mcast_ip[2];
	multicast_mac[5] = mcast_ip[3];

	netih = OFOpen("net:force");
	if (!netih) {
		close_flash();
		fatal("Can't open network\n");
	}
	OFInterpretV("$essid", 2, 0, ssidlen, ssidadr);

	OFCallMethodV("do-associate", netih, 0, 1, &status);
	if (status != -1) {
		printf("Adhoc restart\n");
		OFCallMethodV("do-associate", netih, 0, 1, &status);
		if (status != 0) {
			close_flash();
			close_net();
			fatal("Adhoc mode didn't start\n");
		}
	}
	
//	OFCallMethodV("set-beacon", netih, 2, 0, 0, 100);  /* Disable beacon */
	OFCallMethodV("set-multicast", netih, 2, 0, 6, multicast_mac);
}

static void open_udp(char *nodename)
{
	char netname[14+32] = "net//obp-tftp:";
	char *tailstr = strchr(nodename, ':');
	int nodelen;
	
	direct_mode = 0;

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
	if (!netih) {
		close_flash();
		fatal("Can't open network\n");
	}
}

/*
 * nodename is "ether:" for direct Ethernet transport, else a multicast IP address
 * portnum is a wireless channel number for direct, else a UDP port number
 */
int open_net(char *nodename)
{
	if (memcmp(nodename, "ether:", 6) == 0) {
		open_mesh(nodename+6);
		return 1;
	}
	if (memcmp(nodename, "ssid:", 5) == 0) { /* ssid:SSID */
		char *ssidadr;
		int ssidlen;

		ssidadr = nodename+5;
		ssidlen = strlen(ssidadr);

		open_ssid(ssidadr, ssidlen);
		return 1;
	}
	if (memcmp(nodename, "adhoc:", 6) == 0) {  /* adhoc:SSID,mcast_ip */
		char *ssidadr;
		int ssidlen;
		char *ipadr;

		ssidadr = nodename+6;
		ipadr = strchr(ssidadr, ',');
		if (!ipadr) {
			ssidlen = strlen(ssidadr);
			ipadr = "239.255.1.2";
		} else {
			ssidlen = ipadr - ssidadr;
			ipadr += 1;  /* Skip the delimiter */
		}
		open_adhoc(ssidadr, ssidlen, parse_ip(ipadr, strlen(ipadr)));
		return 1;
	}
	if (memcmp(nodename, "mcast:", 6) == 0) {
		char *ipadr;
		ipadr = nodename+6;
		open_udp(",,0.0.0.1");
		OFCallMethodV("join-multicast-group", netih, 1, 0, parse_ip(ipadr, strlen(ipadr)));
		return 1;
	}
	if (memcmp(nodename, "udp:", 4) == 0) {
		open_udp(nodename+4);
		return 1;
	}
	open_udp(nodename);
	return 1;
}

size_t get_packet(unsigned char *packet, size_t len)
{
	long rxlen;

	if (direct_mode) {
		unsigned char ether_packet[1600];

		while (1) {
			poll_flash();  /* Advance the write queue if possible */

			rxlen = OFRead(netih, ether_packet, 1600);
			if (rxlen >= 14) {
				if (ether_packet[12] != 'X' || ether_packet[13] != 'O')
					continue;
				rxlen -= 14;
				memcpy(packet, ether_packet+14, rxlen>len ? len : rxlen);
				return (size_t)rxlen;
			}
		}
	} else {
		cell_t argarray[] = { (cell_t)"call-method", 3,5,0,0,0,0,0,0,0,0};

		argarray[CIF_HANDLER_IN+LOW(0)] = (cell_t)"receive-udp-packet";
		argarray[CIF_HANDLER_IN+LOW(1)] = (cell_t)netih;
		argarray[CIF_HANDLER_IN+LOW(2)] = dstport;

		while (1) {
			poll_flash();  /* Advance the write queue if possible */

			if (call_firmware(argarray) != 0)
				return -1;

			if (argarray[CIF_HANDLER_IN+LOW(3)])  // Catch result
				return -1;

			if (argarray[CIF_HANDLER_IN+LOW(4)] == -1) // No packet
				continue;
			
			// srcport = (LONG)argarray[CIF_HANDLER_IN+LOW(5)];  // Ignore src port
			rxlen  = (long)argarray[CIF_HANDLER_IN+LOW(6)];
			len = (len < rxlen) ? len : rxlen;
			memcpy(packet, (unsigned char *)argarray[CIF_HANDLER_IN+LOW(7)], len);
			return (size_t)rxlen;
		}
	}
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
//        printf("%s %x\n", err_msg, mem);
	return mem;
}

int init_crypto()
{
	int status;
	status = OFInterpret0("fskey$ to pubkey$");
	return OFInterpret0("load-crypto");
}

int spec_valid(char *image, int imagelen, char *sig, int siglen)
{
	int placement_spec_valid;

	OFInterpretV("sha-valid?", 4, 1, siglen, sig, imagelen, image, &placement_spec_valid);
	return placement_spec_valid;
}

int hash(char *buf, int len, char *hashname, int hashnamelen, char **hashval, int *hashlen)
{
	return OFInterpretV("crypto-hash", 5, 2, hashnamelen, hashname, len, buf, 0, hashlen, hashval);
}

int hex_decode(char *ascii, int asciilen, char **binary, int *binarylen)
{
	int result;
	int callstat;

	callstat = OFInterpretV("hex-decode", 2, 3, asciilen, ascii, &result, binarylen, binary);
	if(callstat != 0)
		return callstat;

	return result;
}
