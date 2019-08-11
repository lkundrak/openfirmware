
# -*- sh -*-

ifeq ($(OFW_CPU),)
  OFW_CPU := x86
endif

ifeq ($(OFW_CPU), x86)
  CPU_CFLAGS  := -m32
  CPU_LDFLAGS := -m elf_i386
endif

ifeq ($(OFW_CPU), arm)
  ifneq (arm, $(findstring arm,$(shell uname -p)))
    # Cross-compiler setup
    ifeq ($(CROSS),)
      CROSS=/usr/local/arm/arm-linux/bin/
    endif
    CC_OFW    := $(CROSS)gcc
    LD_OFW    := $(CROSS)ld
    STRIP_OFW := $(CROSS)strip
    CPU_CFLAGS  :=
    CPU_LDFLAGS :=
  endif
endif

ifeq ($(CC_OFW),)
  # Native compiler setup
  CC_OFW := gcc
  LD_OFW := ld
  STRIP_OFW := strip
endif

LIBGCC=`$(CC_OFW) -print-libgcc-file-name`

SRCDIR=..

CC := gcc
CFLAGS ?= $(CPU_CFLAGS) -O2 -g
CFLAGS += -Wall
CFLAGS += -fno-inline
CFLAGS += -D_FORTIFY_SOURCE=0
ifeq (y, $(shell $(CC) -xc -c -fno-stack-protector /dev/null -o /dev/null 2>/dev/null && echo y))
  CFLAGS += -fno-stack-protector
endif

CFLAGS_OFW ?= $(CPU_CFLAGS) -O2 -g
CFLAGS_OFW += -Wall
CFLAGS_OFW += -fno-inline
CFLAGS_OFW += -D_FORTIFY_SOURCE=0
ifeq (y, $(shell $(CC_OFW) -xc -c -fno-stack-protector /dev/null -o /dev/null 2>/dev/null && echo y))
  CFLAGS_OFW += -fno-stack-protector
endif

# Special flags for building the version that runs in Open Firmware

HLIBDIR=$(BPDIR)/clients/lib
LIBDIR=$(HLIBDIR)/$(OFW_CPU)
CPPFLAGS_OFW += -I${HLIBDIR}

# Run these from a different address than memtest (which uses 0x10000)
# so as not to trigger the memtest fixups, particularly usb-quiet
LDFLAGS_OFW = $(CPU_LDFLAGS) -Ttext 0x20000 -Tdata 0x30000
LDFLAGS_LINUX = $(CPU_LDFLAGS)
LIBS = $(LIBDIR)/libobp.a

BUILDDIR := .

# The rx_ofw target is built by explicitly specifying it on the make
# command line, since it needs to be build in the OFW tree where it
# can access the appropriate libraries.
XTARGETS = rx_ofw

RAWTARGETS = rx_linux

TARGETS = $(foreach target,$(RAWTARGETS),$(BUILDDIR)/$(target))

.SUFFIXES:

all: $(TARGETS)

IGNORE=${wildcard $(BUILDDIR)/.*.c.dep}
-include ${IGNORE}

clean:
	rm -f $(BUILDDIR)/*.o $(TARGETS) $(XTARGETS) $(BUILDDIR)/.*.c.dep
	if [ "$(BUILDDIR)x" != ".x" ]; then rm -rf $(BUILDDIR); fi

$(BUILDDIR)/%.o: %.c
	mkdir -p $(BUILDDIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/%.bin: %.elf
	$(STRIP_OFW) -o $@ $<

FORCE:

$(LIBDIR)/libobp.a: FORCE
	make -s -C $(LIBDIR) libobp.a

$(LIBDIR)/start.o: FORCE
	make -s -C $(LIBDIR) start.o

$(BUILDDIR)/fec.o: fec.c
	mkdir -p $(BUILDDIR)
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -DNEED_BCOPY -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/rx_ofw.o: rx_ofw.c
	mkdir -p $(BUILDDIR)
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/nandblaster_rx.elf: $(LIBDIR)/start.o $(BUILDDIR)/nandblaster_rx.o $(BUILDDIR)/crc32.o $(BUILDDIR)/fec.o $(BUILDDIR)/common_ofw.o $(BUILDDIR)/rx_ofw.o $(BUILDDIR)/flashio_ofw.o $(LIBS)
	$(LD_OFW) $(LDFLAGS_OFW) -o $@ $^ $(LIBGCC)

$(BUILDDIR)/nandblaster15_rx.elf: $(LIBDIR)/start.o $(BUILDDIR)/nandblaster_rx.o $(BUILDDIR)/crc32.o $(BUILDDIR)/fec.o $(BUILDDIR)/common_ofw.o $(BUILDDIR)/rx_ofw.o $(BUILDDIR)/diskio_ofw.o $(LIBS)
	$(LD_OFW) $(LDFLAGS_OFW) -o $@ $^ $(LIBGCC)

$(BUILDDIR)/crc32.o: $(BUILDDIR)/crc32.c
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/nandblaster_rx.o: $(BUILDDIR)/nandblaster_rx.c
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/nandblaster_tx.o: $(BUILDDIR)/nandblaster_tx.c
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/tx_ofw.o: $(BUILDDIR)/tx_ofw.c
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/common_ofw.o: $(BUILDDIR)/common_ofw.c
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/flashio_ofw.o: $(BUILDDIR)/flashio_ofw.c
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/diskio_ofw.o: $(BUILDDIR)/diskio_ofw.c
	$(CC_OFW) $(CPPFLAGS_OFW) $(CFLAGS_OFW) -c -o $@ $< -g -Wp,-MD,$(BUILDDIR)/.$(<F).dep

$(BUILDDIR)/rx_linux: $(BUILDDIR)/reflash.o $(BUILDDIR)/crc32.o $(BUILDDIR)/fec.o $(BUILDDIR)/rx_linux.o
	$(CC) -o $@ $^

$(BUILDDIR)/tx_linux.o: $(BUILDDIR)/tx_linux.c
	$(CC) -c -o $@ $^

$(BUILDDIR)/tx_linux_softmac.o: $(BUILDDIR)/tx_linux_softmac.c
	$(CC) -c -o $@ $^

$(BUILDDIR)/image_to_fec: $(BUILDDIR)/image_to_fec.o $(BUILDDIR)/crc32.o $(BUILDDIR)/fec.o
	$(CC) $(LDFLAGS_LINUX) -o $@ $^

$(BUILDDIR)/blast_image: $(BUILDDIR)/blast_image.o $(BUILDDIR)/tx_linux.o
	$(CC) $(LDFLAGS_LINUX) -o $@ $^

$(BUILDDIR)/blast_image_wlan: $(BUILDDIR)/blast_image.o $(BUILDDIR)/tx_linux_softmac.o
	$(CC) $(LDFLAGS_LINUX) -o $@ $^

$(BUILDDIR)/clone_image: $(BUILDDIR)/clone_image.o $(BUILDDIR)/tx_linux.o
	$(CC) $(LDFLAGS_LINUX) -o $@ $^

$(BUILDDIR)/nandblaster_tx.elf: $(LIBDIR)/start.o $(BUILDDIR)/nandblaster_tx.o $(BUILDDIR)/crc32.o $(BUILDDIR)/fec.o $(BUILDDIR)/common_ofw.o $(BUILDDIR)/tx_ofw.o $(BUILDDIR)/flashio_ofw.o $(LIBS)
	$(LD_OFW) $(LDFLAGS_OFW) -o $@ $^ $(LIBGCC)

$(BUILDDIR)/blaster.elf: $(LIBDIR)/start.o $(BUILDDIR)/blast_image.o $(BUILDDIR)/tx_ofw.o $(BUILDDIR)/common_ofw.o $(LIBS)
	$(LD) $(LDFLAGS_OFW) -o $@ $^

$(BUILDDIR)/cloner.elf: $(LIBDIR)/start.o $(BUILDDIR)/clone_image.o $(BUILDDIR)/crc32.o $(BUILDDIR)/fec.o $(BUILDDIR)/tx_ofw.o $(BUILDDIR)/flashio_ofw.o $(LIBS)
	$(LD) $(LDFLAGS_OFW) -o $@ $^
