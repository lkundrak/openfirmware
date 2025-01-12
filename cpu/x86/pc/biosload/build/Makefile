OS := $(shell uname)

CLIENTDIR=../../../../../clients
CLIENTPROGS=${CLIENTDIR}/emacs/x86/emacs

all: ofw.c32

floppyofw.img: FORCE build ../../../build/inflate.bin
	./build $@

ofw.c32: FORCE build ../../../build/inflate.bin ${CLIENTPROGS}
	./build $@

../../../${OS}/forth:
	@make -C ../../../${OS} forth

../../../build/inflate.bin:
	@make -C ../../../build inflate.bin

${CLIENTDIR}/emacs/x86/emacs:
	@make -C ${CLIENTDIR}/emacs/x86 emacs

build: ../../../${OS}/forth
	@ln -sf ../../../${OS}/forth build

clean:
	rm -f *.dic *.log headers *~ *.elf *.di *.img builton.fth build *.c32

clean-all: clean
	@make -C ../../../build clean
	@make -C ../../../${OS} clean

.PHONY: FORCE clean all clean-all
