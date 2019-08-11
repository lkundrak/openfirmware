#define _GNU_SOURCE
#include "1275.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "partition.h"
#include "io.h"

static ihandle nandih;

static int my_nblocks;
static int my_pagesize;
static int my_erasesize;
static int my_pages_per_block;
static int delayed_page = -1;

void close_flash()
{
	OFClose(nandih);
}

/*
 * poll_flash() is a no-op for raw NAND, which has predictable write latency.
 */
void poll_flash()
{
}
void set_zdata_blocks(int nr_blocks)
{
}
void try_fs_update()
{
}
void secure_fs_update(char *adr, int len)
{
}

static int wait_flash()
{
	int error;

	if (delayed_page != -1)
		return 0;

	OFCallMethodV("wait-write-done", nandih, 0, 1, &error);
	if (error) {
		printf("Delayed write error on page 0x%x\n", delayed_page);
	}
	delayed_page = -1;
	return error;
}

void open_flash(unsigned int *erasesize, unsigned int *pagesize, unsigned int *nblocks, int *writesize)
{
	unsigned int npages;
	/* Open the device */
	nandih = OFOpen("/nandflash");

	if (nandih == 0) {
		fatal("Can't open NAND FLASH device\n");
	}
	OFCallMethodV("erase-size", nandih, 0, 1, erasesize);
	OFCallMethodV("page-size", nandih, 0, 1, pagesize);
	OFCallMethodV("partition-size", nandih, 0, 1, &npages);
	
	my_erasesize = *erasesize;
	my_pagesize = *pagesize;
	my_pages_per_block = my_erasesize / my_pagesize;
	delayed_page = -1;
        my_nblocks = npages / my_pages_per_block;;
	*nblocks = my_nblocks;
	*writesize = 2048;
}

int block_bad(unsigned int block_nr)
{
	int retval;

	if (block_nr >= my_nblocks) {
		close_flash();
		fatal("NAND block number too large\n");
	}

	OFCallMethodV("block-bad?", nandih, 1, 1, block_nr * my_pages_per_block, &retval);
        return retval;
}

int next_bad_block(int block_nr)
{
	int retval;
	int flash_page;

	flash_page = (block_nr == -1) ? -1 : block_nr * my_pages_per_block;
	OFCallMethodV("next-bad-block", nandih, 1, 1, flash_page, &retval);
	if (retval != -1)
		retval /= my_pages_per_block;
        return retval;
}

void erase_block(unsigned int block_nr)
{
	(void) wait_flash();
	OFCallMethodV("erase-block", nandih, 1, 0, block_nr * my_pages_per_block);
	OFInterpretV("gshow-erased", 1, 0, block_nr);
}

void write_cleanmarker(uint32_t block_nr)
{
	if (block_nr > my_nblocks)
		return;
	(void) wait_flash();
	OFCallMethodV("put-cleanmarker", nandih, 1, 0, block_nr*my_pages_per_block);
	OFInterpretV("clean-color show-state", 1, 0, block_nr);
	highlight_flash_block(block_nr);
}

size_t write_flash(unsigned char *adr, size_t len, unsigned int flash_page)
{
	int nwritten;

	if (wait_flash())
		return 0;

        if (len == my_pagesize) {
		OFCallMethodV("start-write-page", nandih, 2, 0, flash_page, adr);
		delayed_page = flash_page;
		nwritten = 1;
	} else {
		OFCallMethodV("fast-write-pages", nandih, 3, 1, len/my_pagesize, flash_page, adr, &nwritten);
		OFInterpretV("written-color show-state", 1, 0, flash_page/my_pages_per_block);
	}
	return nwritten * my_pagesize;
}

size_t read_flash(unsigned char *adr, size_t len, unsigned int flash_page)
{
	int nread;

	(void)wait_flash();

        if (len < my_pagesize) {
		OFCallMethodV("read-pages", nandih, 4, 0, 0, flash_page, len, adr);
		return len;
        } else {
		OFCallMethodV("read-pages", nandih, 3, 1, len/my_pagesize, flash_page, adr, &nread);
		return nread * my_pagesize;
	}
}

void *memcpy(void *to, const void *from, size_t len);

void read_oob(unsigned char *adr, unsigned int flash_page)
{
        unsigned char *res;

	(void) wait_flash();

	OFCallMethodV("read-oob", nandih, 1, 1, flash_page, &res);
        memcpy(adr, res, 0x40);
}

void make_new_partitions(struct partition_map_spec *want)
{
	int i;
	char *p;

	OFInterpretV("to nandih set-nand-vars start-partition-map", 1, 0, nandih);
	for (i = 1; i <= want->nr_partitions; i++) {
		p = want->partitions[i].name;
		OFInterpretV("add-partition", 3, 0,
			      want->partitions[i].total_eblocks,
			      strnlen(p, 16), p);
	}
	OFInterpret0("write-partition-map 0 to nandih");
}

int flash_num_partitions()
{
	int nr_partitions;
	OFCallMethodV("#partitions", nandih, 0, 1, &nr_partitions);
	if (nr_partitions < 0)
		nr_partitions = 0;
	return nr_partitions;
}

void flash_partition_info(int part_nr, int *type, int *namelen, char **nameadr,
			  int *granularity, int *size, int *start)
{
	OFCallMethodV("partition-info", nandih, 1, 6, part_nr, type, namelen, nameadr, granularity, size, start);
}

void show_flash_map()
{
	OFInterpret0("open-nand (scan-nand) close-nand-ihs");
	OFInterpret0("0 status-line at-xy kill-line");
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
	OFInterpretV("to nandih set-nand-vars  show-init  0 to nandih ", 1, 0, nandih, my_nblocks);
}

void show_state(int state, uint32_t block_nr)
{
	OFInterpretV("show-color", 2, 0, colors[state], block_nr);
}

void highlight_flash_block(uint32_t block_nr)
{
	OFInterpretV("point-block", 1, 0, block_nr);
}

void show_block_status(uint32_t block_nr, int need)
{
	if (need > 0)
		OFInterpretV("strange-color show-state", 1, 0, block_nr);
	else
		OFInterpretV("pending-color show-state", 1, 0, block_nr);
}
