\ purpose: Realtek 8139 Open Firmware driver
\ See license at end of file

hex
headers

: align32  3 + 3 not and  ;

\ Configuration space access
: my-w@  ( offset -- w )  my-space +  " config-w@" $call-parent  ;
: my-w!  ( w offset -- )  my-space +  " config-w!" $call-parent  ;

: io+   0100.0000 +  ;
: mem+  0200.0000 +  ;

0 instance value bar0
: /bar0  h# 100  ;
: /bar1  h# 100  ;

: bar0-phys  0 0 my-space io+  10 +  ;
: bar1-phys  0 0 my-space mem+ 14 +  ;

: map-bar0  ( -- )
   bar0-phys /bar0 " map-in" $call-parent to bar0
   4 my-w@  5 or  4 my-w! \ Enable I/O space
;

: unmap-bar0  ( -- )
   4 my-w@  6 invert and  4 my-w! \ Disable I/O space
   bar0 /bar0 " map-out" $call-parent
   0 to bar0
;

\ I/O register access
: reg-b!  ( b offset -- )  bar0 +  rb!  ;
: reg-b@  ( offset -- b )  bar0 +  rb@  ;
: reg-w!  ( w offset -- )  bar0 +  rw!  ;
: reg-w@  ( offset -- w )  bar0 +  rw@  ;
: reg-l!  ( l offset -- )  bar0 +  rl!  ;
: reg-l@  ( offset -- l )  bar0 +  rl@  ;

\ Command and Status register
: cr@  ( -- b ) h# 37 reg-b@  ;
: cr!  ( b -- ) h# 37 reg-b!  ;

\ Network ID
create mac-adr 0 c, 0 c, 0 c, 0 c, 0 c, 0 c,
6 constant /mac-adr
: mac-adr$  ( -- adr len )
   /mac-adr 0 do i reg-b@ mac-adr i + c! loop
   mac-adr /mac-adr
;

\ Transmitter limitations
d#   60 constant /txmin
d# 1518 constant /txmax

\ Current buffer counter
0 instance value tx#
: tx++  ( -- )
   tx# 1+
   dup 3 >  if drop 0  then
   to tx#
;

\ TX bounce buffer
/txmax align32 4 * constant /txbuf
0 instance value txbuf-raw
: txbuf       ( -- a )  txbuf-raw align32 /txmax align32 tx# * +  ;
: /txbuf-raw  ( -- n )  /txbuf d# 8 +                             ;

\ TX descriptor register access
: txdes   ( -- reg )  tx# 4 * h# 10 +         ;
: txadr!  ( val -- )  tx# 4 * h# 20 + reg-l!  ;

\ RX registers
: rbstart!  ( n -- )  h# 30 reg-l!  ;  \ Receive (Rx) Buffer Start Address
: capr!     ( n -- )  h# 38 reg-w!  ;  \ Current Address of Packet Read
: rcr!      ( n -- )  h# 44 reg-l!  ;  \ Receive (Rx) Configuration Register

\ RX ring buffer & bookkeeping
0 constant rxorder \ 0=8K, 1=16K, 2=32K, 3=64K. Tunable.
h# 2000 rxorder lshift constant /rxbuf
0 instance value rxbuf-raw
: rxbuf       ( -- a )  rxbuf-raw align32      ;
: /rxbuf-raw  ( -- n )  /rxbuf d# 8 + d# 16 +  ;

\ Accessing the current packet data
0 instance value rxptr
: rxptr+   ( n -- n )  rxptr + /rxbuf mod   ;
: rxflags  ( -- n )    0 rxptr+ rxbuf + w@  ;
: rxlen    ( -- n )    2 rxptr+ rxbuf + w@  ;

: rxempty?  ( -- empty? )  cr@ 1 and  ;

false instance value use-debug?
false instance value use-promiscuous?
false instance value use-multicast?

: reset
   h# 10 cr! \ Reset+
   h# 0c cr! \ Reset-, Enable TX and RX

   \ Initialize 4 transmit buffers
   0 to tx#
   txbuf txadr! tx++
   txbuf txadr! tx++
   txbuf txadr! tx++
   txbuf txadr! tx++

   \ Initialize RX ring buffer
   rxbuf rbstart!

   \ Configure receiver
   h# 0a
   use-promiscuous?  if  h# 31 or  then
   use-multicast?    if  h# 04 or  then
   rxorder d# 11 lshift  or  \ RX buf size
   rcr!
;

: txready?  ( -- ready? )
   0 d# 1000 0 do
      drop txdes reg-l@ h# 0000.2000 and
      dup ?leave
      1 ms
   loop
;

: .txstat
   txdes reg-l@

   dup h# 8000.0000 and  if  ." TX: Carrier Sense Lost" cr  then
   dup h# 4000.0000 and  if  ." TX: Transmit Abort"     cr  then
   dup h# 2000.0000 and  if  ." TX: Out of Window"      cr  then
   dup h# 1000.0000 and  if  ." TX: No CD Heartbeat"    cr  then

   h# 0f00.0000 and  d# 24 rshift  dup  if
      ." TX: Collisions: " .d cr
   else
      drop
   then
;

: write  ( adr len -- actual )
   txready?  0=  if  ." TX timeout" cr 2drop 0  exit  then
   use-debug?  if  .txstat  then

   dup /txmax > if
      ." Truncating packet of size " . cr
      /txmax
   then

   \ Copy to a bounce buffer     ( adr len )
   txbuf /txmax 00 fill
   >r txbuf r@                   ( adr txbuf len )
   move

   \ Bump size up to minimum tx size
   r@ /txmin <  if  /txmin  else  r@  then   ( len2 )

   \ This write kicks off the transmit
   h# 3f.0000 or  txdes reg-l!   ( )
   tx++
   r>                            ( len ) ( r: )
;

: .rxstat
   h# 4c reg-l@ dup  if  ." RX: Missed packets: "       .d cr  else  drop  then
   h# 6c reg-w@ dup  if  ." RX: Disconnections: "       .d cr  else  drop  then
   h# 6e reg-w@ dup  if  ." RX: False Carrier Sense: "  .d cr  else  drop  then
;

: read  ( adr len -- -2 | actual )
   use-debug?  if  .rxstat  then
   rxempty?  if 2drop -2 exit  then

   \ Undocumented HW quirk: according to FreeBSD rl(4) manual,
   \ fff0 apparently means the packet was not read in full yet.
   rxlen h# fff0 =  if            ( dst len )
      2drop -2
      exit
   then

   rxlen <  if                    ( dst )
      ." RX buffer too small for rxlen=" rxlen . cr
      reset
      drop -2
   else rxflags 1 and 0= if
      ." RX error flags=" rxflags . cr
      reset
      drop -2
   else
      >r                         (                   r: dst )
      4 rxptr+                   ( beg )
      dup rxlen +                ( beg end )
      dup /rxbuf > if
         \ Falling off the edge of the ring buffer
         /rxbuf rxptr -          ( beg end len1 )
         rot rxbuf +             ( end len1 src )
         r> rot 2dup + >r        ( end src dst len1  r: dst2 )
         move                    ( end )
         /rxbuf -                ( len2 )
         rxbuf r> rot            ( src2 dst2 len2    r: )
         move                    ( )
      else
         \ Just a straight copy
         over -                  ( beg len )
         swap rxbuf +            ( len src )
         r> rot                  ( src dst len       r: )
         move                    ( )
      then
      rxlen                      ( rxlen )
   then then

   rxlen 4 + align32 rxptr+ to rxptr
   rxptr d# 16 - capr!
;

\ Package inet/netload calls this
: enable-promiscuous  ( -- )
   true to use-promiscuous?
   reset
;

0 value tftp-args
0 value tftp-len

: $=  ( str$ str$ -- equal? )
   rot tuck <> if
      \ Length different?
      3drop false exit
   then
   \ Compare strings of the same length
   comp 0=
;

: parse-args  ( $args -- )
   false to use-debug?
   false to use-promiscuous?
   false to use-multicast?
   begin
      \ Unconsumed arguments will be passed to obp-tftp package,
      \ so that one can do e.g.: boot net:debug,\tftpboot\vmlinux
      2dup to tftp-len to tftp-args
   dup  while
      ascii , left-parse-string
      2dup " debug"       $=  if  true to use-debug?        else
      2dup " promiscuous" $=  if  true to use-promiscuous?  else
      2dup " multicast"   $=  if  true to use-multicast?    else
                                  2drop 2drop exit
      then then then
      2drop
   repeat
   2drop
;

\ TFTP magic incantation jacked from every other driver
: load  ( adr -- len )
   " obp-tftp" find-package  if  ( adr phandle )
      tftp-args tftp-len 2dup . . rot  open-package  ( adr ihandle|0 )
   else                          ( adr )
      0                          ( adr 0 )
   then                          ( adr ihandle|0 )

   dup 0=  if ." Can't open obp-tftp support package" abort  then
                                 ( adr ihandle )
   >r
   " load" r@ $call-method       ( len )
   r> close-package
;

0 value open-count

: open  ( -- ok? )
   my-args parse-args
   use-debug?  if
      ." Debugging enabled" cr
      use-promiscuous?  if  ." Promiscuous reception enabled" cr  then
      use-multicast?    if  ." Multicast reception enabled"   cr  then
   then
   open-count 0=  if
     map-bar0

     mac-adr$ encode-bytes " local-mac-address" property

     \ Allocate buffers
     /txbuf-raw " dma-alloc" $call-parent to txbuf-raw
     /rxbuf-raw " dma-alloc" $call-parent to rxbuf-raw
     reset
   then
   open-count 1+ to open-count
   true
;

: close  ( -- )
   open-count 1 =  if
      h# 10 cr! \ Reset+
      unmap-bar0
      txbuf-raw /txbuf-raw " dma-free" $call-parent
      rxbuf-raw /rxbuf-raw " dma-free" $call-parent
   then
   open-count 1- 0 max to open-count
;

: sniff  ( adr len )
   begin
      2dup h# 20 fill
      begin
         2dup
      read -2 =  while
         key?  if exit  then
      repeat
      " page" eval
      rxptr . cr
      2dup " dump" eval
   again
;

: selftest  ( -- fail? )
   open 0=  if ." Can not open" abort  then
   ." Send packets (up to ping -s210)..."
   h# 100 dup alloc-mem swap  ( adr len )
   sniff
   free-mem                   ( )
   close
   false
;

: probe
   " network" device-type
   " ethernet" device-name
   " Realtek RTL8139" encode-string  " model" property

   " realtek,rtl8139" encode-string
     " pci10ec,8139" encode-string encode+
     " compatible" property

   my-address my-space encode-phys   0 encode-int encode+      0 encode-int encode+
      bar0-phys encode-phys encode+  0 encode-int encode+  /bar0 encode-int encode+
      bar1-phys encode-phys encode+  0 encode-int encode+  /bar1 encode-int encode+
      " reg" property
;

\ LICENSE_BEGIN
\ Copyright (c) 2024 Lubomir Rintel <lkundrak@v3.sk>
\
\ Permission is hereby granted, free of charge, to any person obtaining
\ a copy of this software and associated documentation files (the
\ "Software"), to deal in the Software without restriction, including
\ without limitation the rights to use, copy, modify, merge, publish,
\ distribute, sublicense, and/or sell copies of the Software, and to
\ permit persons to whom the Software is furnished to do so, subject to
\ the following conditions:
\
\ The above copyright notice and this permission notice shall be
\ included in all copies or substantial portions of the Software.
\
\ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
\ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
\ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
\ NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
\ LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
\ OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
\ WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
\
\ LICENSE_END
