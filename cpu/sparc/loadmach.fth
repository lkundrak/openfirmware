id: @(#)loadmach.fth 1.13 03/07/17
copyright: Copyright 1991-1994 Firmworks  All Rights Reserved
copyright: Copyright 1994-2003 Sun Microsystems, Inc.  All Rights Reserved
copyright: Use is subject to license terms.

[ifndef] assembler?  transient  [then]
fload ${BP}/cpu/sparc/assem.fth
fload ${BP}/cpu/sparc/asmmacro.fth
fload ${BP}/cpu/sparc/code.fth
fload ${BP}/forth/lib/loclabel.fth
[ifndef] assembler?  resident  [then]

warning on

fload ${BP}/cpu/sparc/disforw.fth	\ Exports (dis , pc , dis1 , +dis

fload ${BP}/forth/lib/instdis.fth

fload ${BP}/cpu/sparc/decompm.fth

fload ${BP}/cpu/sparc/bitops.fth	\ Used by allocpmeg.fth

\  : be-l!  ( l adr -- )  >r lbsplit r@ c! r@ 1+ c!  r@ 2+ c! r> 3 + c!  ;
\  : be-l,  ( l -- )  here set-swap-bit  here  4 allot  be-l!  ;
\  : be-l@  ( adr -- n )  >r r@ 3 + c@ r@ 2+ c@ r@ 1+ c@ r> c@ bljoin  ;
\  : be-w@  ( adr -- w )  dup 1+ c@  swap c@  bwjoin  ;

fload ${BP}/cpu/sparc/objsup.fth
fload ${BP}/forth/lib/objects.fth

fload ${BP}/cpu/sparc/cpustate.fth

32\ fload ${BP}/cpu/sparc/register.fth

fload ${BP}/forth/lib/savedstk.fth
fload ${BP}/forth/lib/rstrace.fth
fload ${BP}/cpu/sparc/ftrace.fth
32\ fload ${BP}/cpu/sparc/ctrace.fth
64\ fload ${BP}/cpu/sparc/ctrace9.fth

transient fload ${BP}/forth/lib/binhdr.fth        resident
\needs $save-forth  transient fload ${BP}/cpu/sparc/savefort.fth	resident

\t16 fload ${BP}/cpu/sparc/debugm16.fth	\ Forth debugger support
\t32 fload ${BP}/cpu/sparc/debugm.fth	\ Forth debugger support
fload ${BP}/forth/lib/debug.fth			\ Forth debugger

start-module			\ Breakpointing
fload ${BP}/cpu/sparc/cpubpsup.fth	\ Breakpoint support
fload ${BP}/forth/lib/breakpt.fth
end-module

fload ${BP}/cpu/sparc/memtest.fth

fload ${BP}/cpu/sparc/doccall.fth
fload ${BP}/cpu/sparc/call.fth
64\ fload ${BP}/cpu/sparc/call32.fth

transient fload ${BP}/cpu/sparc/ccalls.fth  resident
