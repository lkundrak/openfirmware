#include <sys/mman.h>

#include <stdint.h>
#include <stddef.h>
#include <fcntl.h>
#include <stdio.h>

void
restoremode(void);

void
simulate(uint8_t *mem,
         uint32_t start,
         uint32_t header,
         uint32_t syscall_vec,
         uint32_t memtop,
         uint32_t argc,
         uint32_t argv);

void
restoremode(void)
{
}

static const char bios[] = "qemu/build/mipsel_bios.bin";
static const size_t memsize = 0x8000000; /* 128MB, maximum. */
int
main ()
{
	void *mem;
	int fd;

	fd = open(bios, O_RDONLY);
	if (fd == -1) {
		perror(bios);
		return 1;
	}

	mem = mmap(NULL, memsize, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
	if (mem == MAP_FAILED) {
		perror("mmap");
		return 1;
	}

	simulate(mem, 0, 0, 0, memsize, 0, 0);

	if (munmap(mem, memsize) == -1) {
		perror("munmap");
		return 1;
	}

	return 0;
}

