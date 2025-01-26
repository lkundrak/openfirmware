//
// SPARC Simulator
//
// Copyright (C) 2020,2025 Lubomir Rintel
// See license at end of file
//
// Usage:
//
//   Load a SPARC Forth dictionary:
//   $ sparcfth kernel.dic
//
//   Enable syscall trace:
//   $ SPARCSIM_TRACE=1 sparcfth kernel.dic
//
//   Enable syscall + instruction trace:
//   $ SPARCSIM_TRACE=2 sparcfth kernel.dic
//
//   Enable syscall + instruction + register trace:
//   $ SPARCSIM_TRACE=3 sparcfth kernel.dic

#define _GNU_SOURCE
#include <dlfcn.h>

#include <stdint.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <signal.h>
#include <endian.h>
#include <sys/mman.h>

#include "sparc_iss.h"
#include "sparc.h"

extern void restoremode();

uint32_t trace;

static int
mem_access (const uint64_t ByteAddr, const int NumBytes, uint32_t *Data, int Type)
{
	uint32_t addr;

	addr = ByteAddr & 0xffffffff;
	if (ByteAddr != addr)
		abort();

	switch (Type) {
	case SPARC_MEM_CB_RD:
		if (trace >= 2)
			fprintf(stderr, ">>> RD [%s] ba=%lx num=%d", __func__, addr, NumBytes);
		fflush(stderr);
		*Data = be32toh(*(uint32_t *)(addr & ~3));
		if (trace >= 2)
			fprintf(stderr, " %08x (%08x)\n", *Data, Type);

		if (NumBytes != 1
			&& NumBytes != 2
			&& NumBytes != 4) {
			if (trace >= 1)
				fputc('\n', stderr);
			else
				fprintf(stderr, ">>> RD [%s] ba=%lx num=%d\n", __func__, addr, NumBytes);
			abort();
		}

		return 1;
	case SPARC_MEM_CB_WR:
		if (trace >= 2)
			fprintf(stderr, ">>> WR [%s] ba=%lx num=%d %08x (%08x)\n", __func__, addr, NumBytes, *Data, Type);

		if (NumBytes == 1) {
			//if (*Data & ~0xff) {
			//	fprintf(stderr, ">>> WR [%s] ba=%lx num=%d %08x (%08x)\n", __func__, addr, NumBytes, *Data, Type);
			//	abort();
			//}
			*(uint8_t *)addr = *Data;
		} else if (NumBytes == 2) {
			//if (*Data & ~0xffff) {
			//	fprintf(stderr, ">>> WR [%s] ba=%lx num=%d %08x (%08x)\n", __func__, addr, NumBytes, *Data, Type);
			//	abort();
			//}
			*(uint16_t *)addr = htobe16(*Data);
		} else if (NumBytes == 4) {
			*(uint32_t *)addr = htobe32(*Data);
		} else {
			if (trace < 1)
				fprintf(stderr, ">>> WR [%s] ba=%lx num=%d %08x (%08x)\n", __func__, addr, NumBytes, *Data, Type);
			abort();
		}

		return 1;
	default:
		fprintf(stderr, ">>> BD [%s] ba=%lx num=%d %08x (%08x)\n", __func__, addr, NumBytes, *Data, Type);
		abort();
	}
}

void
simulate(uint8_t *mem,
         uint32_t start,
         uint32_t header,
         uint32_t syscall_vec,
         uint32_t memtop,
         uint32_t argc,
         uint32_t *argv)
{
        static long xfunctions[101];
	uint32_t argvbe32[argc];
	int reason = 0;
        void *xpage;
        int i;

	for (i = 0; i < argc; i++)
		argvbe32[i] = htobe32(argv[i]);

        xpage = mmap((void *)0x40000000, 4096, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        for (i = 0; i < sizeof(xfunctions)/sizeof(xfunctions[0]); i++)
                xfunctions[i] = htobe32((long)xpage + i * 4);

	trace = atoi(getenv("SPARCSIM_TRACE") ?: "0");
	if (trace) {
		fprintf(stderr, "mem=0x%08x start=0x%08x header=0x%08x "
			"xfunctions=0x%08x syscall_vec=0x%08x memtop=0x%08x "
			"argc=0x%08x argv=0x%08x argvbe32=0x%08x\n",
			mem, start, header,
			xfunctions, syscall_vec, memtop,
			argc, argv, argvbe32);
	}

	register_mem_callback (mem_access);
	Reset();

	// \ called with   forth_startup(header-adr, functions, mem_end, &gargc, &gargv)
	// \                                %i0        %i1       %i2       %i3     %i4
	WriteReg (header, OUTREG0);
	WriteReg ((uint32_t)xfunctions, OUTREG1);
	WriteReg (memtop, OUTREG2);
	WriteReg (argc, OUTREG3);
	WriteReg ((uint32_t)argvbe32, OUTREG4);

	Jump(start);

	do {
		Dl_info dli = { 0, };
		static int i = 0;
		uint32 PC;

		PC = GetnPC();

		if (trace >= 2)
			fprintf(stderr, "\n=== %d %x ===\n", i, PC);
		i++;

		if (PC == 0x10000044) {
			uint8_t name[17] = { 0, };
			uint32 *word;
			uint32 tos;
			uint32 *sp;

			ReadReg (OUTREG7, (uint32 *)&word);
			word--;
			if ((be32toh(*word) & 0xfff00000) == 0) {
				uint8_t c;
//				fprintf(stderr, "=== INTERPRET %08x %08x\n", word, be32toh(*word));

//				word++;
//				fprintf(stderr, " == INTERPRET %08x %08x\n", word, be32toh(*word));
//				word--;

				word--;
				c = *(((uint8_t *)word)+3);
				if ((c & 0xe0) == 0x80) {
					c &= 0x1f;
					name[c] = '\0';
					do {
						if (c) name[--c] = *(((uint8_t *)word)+2);
						if (c) name[--c] = *(((uint8_t *)word)+1);
						if (c) name[--c] = *(((uint8_t *)word)+0);
						word--;
						if (c) name[--c] = *(((uint8_t *)word)+3);
					} while (c);
				}
				if (name[0] & 0x80)
					name[0] = '\0';
				if (trace && name[0]) {
					ReadReg (GLOBALREG4, &tos);
					ReadReg (GLOBALREG7, (uint32 *)&sp);
					fprintf(stderr, " == INTERPRET [%08x %08x %08x %08x %08x]  {%s} [%02x] %08x %08x\n",
						be32toh(sp[3]), be32toh(sp[2]), be32toh(sp[1]), be32toh(sp[0]), tos,
						name, c, word, be32toh(*word));
				}
			}
		}


		if ((PC & ~0xfffc) == (uint32)xpage) {
			typedef uint32 (*handler_t)();
			handler_t handler;
			uint32 args[5];

			handler = *(handler_t *)(syscall_vec+(PC & 0xffff));
			dladdr(handler, &dli);

			if (trace >= 2) {
				fprintf(stderr, "=== HYPERCALL %d %x {%s} {%p} {%s} {%p}===\n",
					 PC & 0xffff, handler,
					dli.dli_fname, dli.dli_fbase, dli.dli_sname, dli.dli_saddr);
				RegisterDump();
			}

			ReadReg (OUTREG0, &args[0]);
			ReadReg (OUTREG1, &args[1]);
			ReadReg (OUTREG2, &args[2]);
			ReadReg (OUTREG3, &args[3]);
			ReadReg (OUTREG4, &args[4]);
			ReadReg (OUTREG5, &args[5]);

			if (trace) {
				fprintf(stderr,"SYSCALL %s (%x,%x,%x,%x,%x) =>", dli.dli_sname,
					args[0], args[1], args[2], args[3], args[4], args[5]);
			}

			args[0] = handler(args[0], args[1], args[2], args[3], args[4], args[5]);

			if (trace) {
				fprintf(stderr," (%x)\n", args[0]);
			}

			WriteReg (args[0], OUTREG0);

			Jump(GetPC());
		}

		reason = 0;
		Run(NULL, 1, 0, 0, trace >= 2 ? 1 : 0, stderr, &reason);
		if (reason)
			putchar ('\n');
		if (trace >= 2)
			RegisterDump();
	} while (reason == 0);

	restoremode();
}
