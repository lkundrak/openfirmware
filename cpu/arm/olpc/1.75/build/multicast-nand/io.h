/*
 * Multicast-wireless NAND reflash program.  This file contains
 * prototypes for the functions that form the interfaces between
 * the functional code and the low-level I/O interfaces.
 *
 * Copyright © 2011 Mitch Bradley
 */

/* Top-level functions */
int reflash(int erasesize, int pagesize, uint32_t nblocks, int secure, int writesize, char **specadr, int *speclen);

void try_fs_update();
void secure_fs_update(char *adr, int len);

/* FLASH/mass-storage access */
void close_flash(void);
void open_flash(unsigned int *erasesize, unsigned int *pagesize, unsigned int *nblocks, int *writesize);
void poll_flash(void);
size_t write_flash(unsigned char *adr, size_t len, uint32_t flash_page);
size_t read_flash(unsigned char *adr, size_t len, uint32_t flash_page);

int next_bad_block(int block_nr);
int block_bad(uint32_t block_nr);
void erase_block(uint32_t block_nr);
void write_cleanmarker(uint32_t block_nr);
void read_oob(unsigned char *adr, unsigned int flash_page);

/* Partitions */

void flash_partition_info(int part_nr, int *type, int *namelen, char **nameadr,
			  int *granularity, int *size, int *start);
int flash_num_partitions(void);
void make_new_partitions(struct partition_map_spec *want);


/* Progress display */
// void show_block_status(uint32_t block_nr, int need);
void init_show_state();
void show_state(int state, uint32_t block_nr);
void highlight_flash_block(uint32_t block_nr);
void show_flash_map(void);
void highlight_flash_block(uint32_t block_nr);
void set_zdata_blocks(int nr_blocks);

/* Network access */
size_t get_packet(unsigned char *packet, size_t len);
int open_net(char *nodename);  /* Return value is 0 for files, 1 for networks */
void close_net(void);
size_t put_packet(void *packet, size_t len);
unsigned char *parse_ip(const char *dotted, int dottedlen);

/* Elapsed time */
void mark_time(void);
int elapsed_msecs(void);

/* Memory allocator that bails out on failure */
void *checked_malloc(size_t nbytes, char *err_msg);

/* Input file access */
void open_file(char *filename, size_t *filesize);
int  read_file(void *adr, size_t len);
void rewind_file();
void close_file();

/* Miscellaneous */
int kbhit(void);
int match(char *ptr, char *ptrend, char *name, size_t namelen);
int spec_valid(char *sig, int siglen, char *image, int imagelen);
int hex_decode(char *ascii, int asciilen, char **binary, int *binarylen);
int init_crypto();
int hash(char *buf, int len, char *hashname, int hashnamelen, char **hashval, int *hashlen);

