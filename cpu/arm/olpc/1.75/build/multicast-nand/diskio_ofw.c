#define _GNU_SOURCE
#include "1275.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "partition.h"
#include "io.h"

static ihandle fsdiskih;

static int my_nblocks;
static int my_pagesize;
static int my_erasesize;
static int my_pages_per_block;
static int delayed_page = -1;
static int display_offset = 0;


void close_flash()
{
	OFClose(fsdiskih);
}

void poll_flash()
{
	OFCallMethodV("poll", fsdiskih, 0, 0);
}

#define BLOCKSHIFT 17  /* 128K byte blocks */
#define PAGESHIFT 9  /* 512 byte disk sectors */
void open_flash(unsigned int *erasesize, unsigned int *pagesize, unsigned int *nblocks, int *writesize)
{
	unsigned int sizelow, sizehigh;
        unsigned long long llsize;

	/* Open the device */
	fsdiskih = OFOpen("fsdisk//block-fifo");

	if (fsdiskih == 0) {
		fatal("Can't open fsdisk device\n");
	}
        *erasesize = 1 << BLOCKSHIFT;
        *pagesize = 1 << PAGESHIFT;
        OFCallMethodV("size", fsdiskih, 0, 2, &sizehigh, &sizelow);

//	OFCallMethodV("erase-size", fsdiskih, 0, 1, erasesize);
//	OFCallMethodV("page-size", fsdiskih, 0, 1, pagesize);
//	OFCallMethodV("partition-size", fsdiskih, 0, 1, &npages);
	
        llsize = ((unsigned long long)sizehigh << 32) + sizelow;

	my_erasesize = *erasesize;
	my_pagesize = *pagesize;
	my_pages_per_block = my_erasesize / my_pagesize;
//        my_nblocks = llsize / *erasesize;
        my_nblocks = llsize >> BLOCKSHIFT;
	delayed_page = -1;
	*nblocks = my_nblocks;
        *writesize = (16*1024);  // Efficient size for writes
}

int block_bad(unsigned int block_nr)
{
        return 0;
}

int next_bad_block(int block_nr)
{
        return -1;
}

void erase_block(unsigned int block_nr)
{
}

void write_cleanmarker(unsigned int block_nr)
{
}

size_t write_flash(unsigned char *adr, size_t len, unsigned int flash_page)
{
        int actual;

	OFCallMethodV("write-blocks", fsdiskih, 3, 1, len/my_pagesize, flash_page, adr, &actual);
        return actual*my_pagesize;
}

size_t read_flash(unsigned char *adr, size_t len, unsigned int flash_page)
{
	int rlen;
	int nread;

	rlen = len < my_pagesize ? my_pagesize : len;

	OFCallMethodV("read-blocks", fsdiskih, 3, 1, len/my_pagesize, flash_page, adr, &nread);

	return len < my_pagesize ? len : nread * my_pagesize;
}

void *memcpy(void *to, const void *from, size_t len);

void read_oob(unsigned char *adr, unsigned int flash_page)
{
}

void make_new_partitions(struct partition_map_spec *want)
{
}

int flash_num_partitions()
{
	return 0;
}

void flash_partition_info(int part_nr, int *type, int *namelen, char **nameadr,
			  int *granularity, int *size, int *start)
{
	printf("!!!! Unexpected call to flash_partition_info !!!!\n");
}

void show_flash_map()
{
	display_offset = 0;
	OFInterpretV("show-init cr", 1, 0, my_nblocks);
}

uint32_t colors[] = {
	0x00808080,  // LEAVE_ALONE, gray
	0x00000000,  // ERASED,  black
	0x00ffff00,  // PENDING, yellow
	0x0000ff00,  // WRITTEN, green
	0x000000ff,  // CLEANED, blue
	0x0000ffff,  // READY,   cyan
	0x00ff00ff,  // PARTIAL, magenta
	0x00ff0000,  // BAD,     red
        0x00c0c0ff,  // WILL_CLEAN, light blue
};

void init_show_state()
{
	display_offset = 0;
	OFInterpretV("to nandih set-nand-vars  show-init cr  0 to nandih ", 2, 0, fsdiskih, my_nblocks);
}

int hot;

void show_state(int state, uint32_t block_nr)
{
	int temperature;
	OFInterpretV("show-color", 2, 0, colors[state], block_nr - display_offset);
        OFInterpretV("cpu-temperature", 0, 1, &temperature);
	if (!hot && (temperature >= 90)) {
		printf(" \033[31mHOT!\033[30m");
		hot = 1;
	}
	if (hot && (temperature < 90)) {
		printf("\b\b\b\b     \b\b\b\b\b");
		hot = 0;
	}
}

void highlight_flash_block(uint32_t block_nr)
{
	OFInterpretV("point-block", 1, 0, block_nr - display_offset);
}

void show_block_status(uint32_t block_nr, int need)
{
	if (need > 0)
		OFInterpretV("strange-color show-state", 1, 0, block_nr - display_offset);
	else
		OFInterpretV("pending-color show-state", 1, 0, block_nr - display_offset);
}

static int nr_sectors = 0;

void set_zdata_blocks(int nr_blocks)
{
	nr_sectors = nr_blocks*my_pages_per_block;
	display_offset = my_nblocks - nr_blocks;
	OFInterpretV("show-init cr", 1, 0, nr_blocks);
}

void try_fs_update()
{
	if (nr_sectors)
		OFInterpretV("set-nb-zd-#sectors  fs-update /nb-updater", 1, 0, nr_sectors);
}

void secure_fs_update(char *adr, int len)
{
	if (nr_sectors)
		OFInterpretV("set-nb-zd-#sectors  do-fs-update", 3, 0, nr_sectors, len, adr);
}
