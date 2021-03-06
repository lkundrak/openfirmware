\ See license at end of file
purpose: Host to EC SPI protocol

\ See http://wiki.laptop.org/go/XO_1.75_HOST_to_EC_Protocol

\ Interface from pckbd.fth to i8042.fth:
\   set-port  ( port# -- )  \ Selects keyboard (port#=0) or mouse (port#=1)
\   get-data  ( -- data | -1 )  \ Returns a keyboard or mouse byte, or -1 if none after one second
\   get-data?  ( -- false | data true )  \ Non-blocking version of get-data
\   clear-out-buf  ( -- )  \ Drains pending data, waiting until 120 ms elapses with no data.  Built from get-data?
\   put-get-data  ( cmd -- data | -1 )   \ Sends cmd and waits for one response byte
\         Used only by "echo?", which is not called on OLPC.
\   put-data  ( data -- )  \ Sends a byte to the keyboard or mouse
\         Used only by "cmd".  "cmd" is used by set-scan-set, default-disable-kbd, enable-scan, set-leds, toggle-leds,
\         kbd-reset, (obsolete) olpc-set-ec-keymap.  set-scan-set is used only by commented-out code guarded by
\         the non-defined ifdef "fix-keyboard".  default-disable-kbd is called only by get-initial-state (NC on OLPC).
\         enable-scan is NC on OLPC.  set-leds is called by toggle-leds with is called when you press numlock or
\         scrolllock or capslock, none of which the OLPC keyboard has.
\   enable-intf  ( -- )  \ Sends "ae" to the keyboard controller (not the keyboard).  Not called on OLPC with current FW.
\   test-lines  ( -- error? )  \ Tests the keyboard clock and data lines.  Not called on OLPC.

0 0  " d4037000"  " /" begin-package   	\ EC-SPI interface using SSP3

headerless

" ec-spi"     device-name

0 0 encode-bytes

" olpc,ec-spi" +compatible
" marvell,mmp2-ssp" +compatible

my-address      my-space  h# 1000  encode-reg
" reg" property

1 " #address-cells"  integer-property
0 " #size-cells"     integer-property

0 0 encode-bytes " spi-slave" property
ec-spi-ack-gpio# 0  " ready-gpios"  gpio-property

   d# 20 " interrupts" integer-property
   " /clocks" encode-phandle mmp2-ssp2-clk# encode-int encode+ " clocks" property

   ec-spi-ack-gpio# 1  " ack-gpios"  gpio-property
   ec-spi-cmd-gpio# 1  " cmd-gpios"  gpio-property
   ec-spi-int-gpio# 1  " int-gpios"  gpio-property

new-device
   " slave" device-name
   " olpc,xo1.75-ec" +compatible
   0 0 encode-bytes " spi-cpha" property
   ec-spi-cmd-gpio# 0  " cmd-gpios"  gpio-property
finish-device

: encode-unit  ( phys -- adr len )  push-hex  (u.)  pop-base  ;
: decode-unit  ( adr len -- phys )  push-hex  $number  if  0  then  pop-base  ;

\ Channel#(port#) Meaning
\ 0              Invalid
\ 1              Switch to Command Mode
\ 2              Command response
\ 3              Keyboard
\ 4              Touchpad
\ 5              Event
\ 6              EC Debug

6 constant #ports
#ports 2- constant #queues

d# 16 constant /q

0 value queue#
#queues /n* buffer: heads  : head  ( -- adr )  heads queue# na+  ;
#queues /n* buffer: tails  : tail  ( -- adr )  tails queue# na+  ;

#queues /q * buffer: qs    : q  ( adr -- )  qs queue# /q * +  ;

/q 1- value   q-end

: init-queues  ( -- )
   #queues  0  do
      i to queue#
      0 head !  0 tail !   /q 1- to q-end
   loop
;
: inc-q-ptr  ( pointer-addr -- )
   dup @ q-end >=  if  0 swap !  else  /c swap +!  then
;

: select-queue  ( channel# -- error? )
   2- to queue#
   queue# #queues >=
;

: enque  ( new-entry channel# -- )
   select-queue  if  drop exit  then   ( new-entry )
   tail @  head @  2dup >  if  - q-end  else  1-  then  ( new-entry tail head )
   <>  if  q tail @ ca+ c!  tail inc-q-ptr  else  drop  then
;

: deque?  ( channel# -- false | entry true )
   select-queue  if  false exit  then
   lock[
   head @  tail @  <>  if
      q head @ ca+ c@   head inc-q-ptr  true
   else
      false
   then
   ]unlock
;

h# d4037000 value ssp-base  \ Default to SSP3
: ssp-sscr0  ( -- adr )  ssp-base  ;
: ssp-sscr1  ( -- adr )  ssp-base  la1+  ;
: ssp-sssr   ( -- adr )  ssp-base  2 la+  ;
: ssp-ssdr   ( -- adr )  ssp-base  4 la+  ;

: enable  ( -- )
   h# 87 ssp-sscr0 rl!   \ Enable, 8-bit data, SPI normal mode
;
: disable  ( -- )
   h# 07 ssp-sscr0 rl!   \ 8-bit data, SPI normal mode
;
\ Switch to master mode, for testing
: master  ( -- )
   disable
   h# 0000.0000 ssp-sscr1 rl!  \ master mode
   enable
;

\ : ssp1-clk-on  7 h# 50 apbc!   3 h# 50 apbc!  ;
\ : ssp2-clk-on  7 h# 54 apbc!   3 h# 52 apbc!  ;
: ssp3-clk-on  7 h# 58 apbc!   3 h# 58 apbc!  ;
\ : ssp4-clk-on  7 h# 5c apbc!   3 h# 5c apbc!  ;

: wb  ( byte -- )  ssp-ssdr rl!  ;  \ Debugging tool
: rb  ( -- byte )  ssp-ssdr rl@ .  ;  \ Debugging tool

\ Wait until the CSS (Clock Synchronization Status) bit is 0
: wait-clk-sync  ( -- )
   begin  ssp-sssr rl@ h# 400.0000 and  0=  until
;

: init-ssp-in-slave-mode  ( -- )
   ssp3-clk-on
   h# 07 ssp-sscr0 rl!   \ 8-bit data, SPI normal mode
   h# 1300.0010 ssp-sscr1 rl!  \ SCFR=1, slave mode, early phase
   \ The enable bit must be set last, after all configuration is done
   h# 87 ssp-sscr0 rl!   \ Enable, 8-bit data, SPI normal mode
   wait-clk-sync
;
2 value ssp-rx-threshold
: set-ssp-fifo-threshold  ( n -- )  to ssp-rx-threshold  ;

: .ssr  ssp-sssr rl@  .  ;
: rxavail  ( -- n )
   ssp-sssr rl@  dup 8 and  if   ( val )
      d# 12 rshift h# f and  1+
   else
      drop 0
   then
;
: prime-fifo  ( -- )
   ssp-rx-threshold  0  ?do  0 ssp-ssdr rl!  loop
;
: rxflush  ( -- )
   begin  ssp-sssr rl@  8 and  while  ssp-ssdr rl@ drop  repeat
;
: ssp-ready?  ( -- flag )  rxavail  ssp-rx-threshold  >=  ;

false value debug?
\ Set the direction on the ACK and CMD GPIOs
: init-gpios  ( -- )
   ec-spi-cmd-gpio# gpio-dir-out
   ec-spi-ack-gpio# gpio-dir-out
;
: clr-cmd  ( -- )  ec-spi-cmd-gpio# gpio-clr  ;
: set-cmd  ( -- )  ec-spi-cmd-gpio# gpio-set  ;
: clr-ack  ( -- )  ec-spi-ack-gpio# gpio-clr  ;
: set-ack  ( -- )  ec-spi-ack-gpio# gpio-set  ;
: fast-ack  ( -- )  set-ack clr-ack  debug?  if  ." ACK " cr  then  ;
: slow-ack  ( -- )  d# 10 ms  set-ack d# 10 ms  clr-ack  ;
defer pulse-ack  ' fast-ack to pulse-ack

0 value cmdbuf
0 value cmdlen
0 value sticky?

0 value databuf
0 value datalen
0 value datain?
0 value command-finished?

0 value cmd-time-limit
: cmd-timeout?   ( -- flag )
   get-msecs  cmd-time-limit  -  0>=
;
: set-cmd-timeout  ( -- )
   get-msecs d# 1000 +  to cmd-time-limit
;

defer do-state  ' noop to do-state
defer upstream

: enter-upstream-state  ( -- )
   2 set-ssp-fifo-threshold
   ['] upstream to do-state
;
: command-done  ( -- )
   true to command-finished?
   sticky?  0=  if
      enter-upstream-state
      prime-fifo
      pulse-ack
   then
   \ In sticky mode, we hold off on pulsing ACK until we have the
   \ next command to send.
;

\ Discard 'len' bytes from the Rx FIFO.  Used after a send
\ operation to get rid of the bytes that were received as
\ a side effect.
: clean-fifo  ( len -- )  0  ?do  ssp-ssdr rl@ drop  loop  ;

: response  ( -- )
   datalen  if
      \ XXX switch to 64-byte mode if necessary
      datain?  if
         debug?  if  ." Data from EC: "  then
         datalen  0  ?do
            ssp-ssdr rl@
            debug?  if  dup .  then
            databuf i + c!
         loop
      else
         \ Unload the spurious (result of sending data) rx bytes from the FIFO
         datalen clean-fifo
      then
      debug?  if  cr  then
   then
   command-done
;
: switched  ( -- )
   \ Unload the spurious (result of sending command) rx bytes from the FIFO
   cmdlen clean-fifo
   datalen  if
      datalen set-ssp-fifo-threshold
      ['] response to do-state
      \ XXX switch to 64-byte mode if necessary
      datain?  if
         prime-fifo
      else
         debug?  if  ." Data to EC: "  then
         datalen  0  ?do
            databuf i + c@
            debug?  if  dup .  then
            ssp-ssdr rl!
         loop
      then
      pulse-ack
   else
      command-done
   then
;
: handoff-command  ( -- )
   debug?  if  ." CMD: "  then
   cmdlen 0  do
      cmdbuf i + c@
      debug?  if  dup .  then
      ssp-ssdr rl!
   loop
   debug?  if  cr  then
   cmdlen set-ssp-fifo-threshold
   sticky?  0=  if  clr-cmd  then
   ['] switched to do-state            ( )
   pulse-ack
;
: ?do-ack  ( -- )
   \ If there is more data in the FIFO, it means that the EC
   \ timed out and "inferred" an ACK, so we don't ACK until
   \ the FIFO is empty.
   ssp-ready? 0=  if  prime-fifo pulse-ack  then
;
: (upstream)  ( -- )
   ssp-ssdr rl@  ssp-ssdr rl@              ( channel# data )
   debug? if
      ." UP: " over . dup . cr
   then
   over case                               ( channel# data )
      0 of  2drop ?do-ack  endof           ( channel# data )  \ Invalid
      1 of  2drop handoff-command   endof  ( channel# data )  \ Switched
      ( default )                          ( channel# data channel# )
         enque  ?do-ack                    ( channel# )
   endcase
;
' (upstream) to upstream
: init  ( -- )
   init-gpios
   init-ssp-in-slave-mode
   rxflush
   init-queues
   clr-cmd
   prime-fifo
   clr-ack  \ Tell EC that it is okay to send
   enter-upstream-state
;

: poll  ( -- )
   lock[
   ssp-ready?  if  do-state  then
   ]unlock
\  debug?  if  key?  if  key drop debug-me  then  then
;
: cancel-command  ( -- )  \ Called when the command child times out
   clr-cmd
   ['] upstream to do-state      
   prime-fifo
   pulse-ack
;

0 instance value port#
: set-port  ( port# -- )  to port#  ;
: get-data?  ( -- false | data true )
   port# deque?     ( false | data true )
   poll
;
: get-data  ( -- data | -1 )  \ Wait for data from our device
   d# 1000 0  do
      get-data?  if  unloop exit  then		( data )
      1 ms
   loop
   true \ abort" Timeout waiting for data from device" 
;
\ Wait until the device stops sending data
: clear-out-buf  ( -- )  begin  d# 120 ms  get-data?  while  drop  repeat  ;

0 value open-count
: open  ( -- flag )
   open-count  0=  if
      my-address my-space  h# 1000  " map-in" $call-parent  is ssp-base
\     setup-pin-mux
      init
   then
   open-count 1+ to open-count
   true
;
: close  ( -- )
   set-ack
   open-count 1 =  if
      ssp-base h# 1000  " map-out" $call-parent  0 is ssp-base

      \ Reset the SSP3. There doesn't seem to be any other
      \ way to drain the TXFIFO and we need to ensure we didn't
      \ leave garbage there.
      ssp3-clk-on
   then
   open-count 1- 0 max to open-count
;

: drain  ( -- )
   begin  ssp-ready?  while  poll  repeat
;
: data-command  ( databuf datalen datain? cmdadr cmdlen more? -- )
   to sticky?  to cmdlen   to cmdbuf
   to datain?  to datalen  to databuf
   false to command-finished?

   set-cmd-timeout
   ['] do-state behavior ['] upstream =  if
      drain
      set-cmd
   else
      handoff-command
   then
   begin                   ( )
      poll                 ( )
      cmd-timeout? throw   ( )
      command-finished?    ( done? )
   until
;

: no-data-command  ( adr len sticky? -- )
   >r >r >r  0 0 0  r> r> r>  data-command
;

8 buffer: ec-cmdbuf
d# 16 buffer: ec-respbuf
: expected-response-length  ( -- n )  ec-cmdbuf 1+ c@ h# f and  ;

0 value #results
: set-cmdbuf  ( [ args ] #args #results cmd-code slen -- )
   >r                      ( [ args ] #args #results cmd-code r: slen )
   ec-cmdbuf 8 erase       ( [ args ] #args #results cmd-code )
   ec-cmdbuf c!            ( [ args ] #args #results )
   to #results             ( [ args ] #args )
   dup ec-cmdbuf 1+ c!     ( [ args ] #args  r: slen )
   r> ec-cmdbuf 2+ c!      ( [ args ] #args  r: )
   h# f and                ( [ args ] #args' )
   dup 5 >  abort" Too many EC command arguments"
   ec-cmdbuf 3 +   swap  bounds  ?do  i c!  loop  ( )
;
: timed-get-results  ( -- b )
   get-msecs  d# 50 +   begin         ( limit )
      2 deque?  if                    ( limit b )
         nip exit                     ( -- b )
      then                            ( limit )
      poll                            ( limit )
      dup get-msecs - 0<              ( limit )
   until                              ( limit )
   drop
   clr-cmd   
   true abort" EC command result timeout"
;

: ec-command-buf  ( [ args ] #args #results cmd-code -- result-buf-adr )
   0 set-cmdbuf                            ( )

   ec-cmdbuf 8 false no-data-command       ( )

   ec-respbuf    #results  bounds  ?do     ( )
      timed-get-results i c!               ( )
   loop                                    ( )

   ec-respbuf                              ( result-buf-adr )
;
: ec-command  ( [ args ] #args #results cmd-code -- [ results ] )
   ec-command-buf                    ( result-buf-adr )
   #results bounds  ?do  i c@  loop  ( [ results ] )
;

: put-data  ( byte -- )
   1 0
   port# case
      3 of  h# 46 endof
      4 of  h# 47 endof
      ( default )  3drop exit
   endcase   ( byte #args #results cmd )
   ec-command
;
: put-get-data  ( cmd -- data | -1 )  put-data get-data  ;

: enter-updater  ( -- )
   0 0 h# 50 1 set-cmdbuf
   
   ec-respbuf 1 true  ec-cmdbuf 8 true data-command
;

create pgm-cmd     h# 51 c, h# 84 c, d# 16 c, h# 02 c, h# 00 c, 0 c, 0 c, 0 c,
create read-cmd    h# 51 c, h# 04 c, d# 16 c, h# 03 c, h# 00 c, 0 c, 0 c, 0 c,
create rdstat-cmd  h# 51 c, h# 01 c, d# 01 c, h# 05 c, h# 80 c, 0 c, 0 c, 0 c,
create wena-cmd    h# 51 c, h# 01 c, d# 00 c, h# 06 c, h# 80 c, 0 c, 0 c, 0 c,
create erase-cmd   h# 51 c, h# 01 c, d# 00 c, h# 60 c, h# 80 c, 0 c, 0 c, 0 c,

: set-offset&len  ( offset len template -- )
   >r            ( offset len r: template )
   r@ 2+ c!      ( offset r: template )
   lbsplit drop  ( low mid hi r: template )
   r@ 4 + c!  r@ 5 + c!  r> 6 + c!
;
: flash-command  ( datadr datlen in? template -- )  8 true  data-command  ;

: write-flash-chunk  ( adr len offset -- )  \ len limited to 16 bytes for now
   over pgm-cmd set-offset&len   ( adr len )
   false pgm-cmd flash-command   ( )
;
: read-flash-chunk  ( adr len offset -- )
   over read-cmd set-offset&len
   true read-cmd flash-command   ( )
;
: read-flash-status  ( -- stat )
   ec-respbuf 1 true rdstat-cmd flash-command
   ec-respbuf c@
;
: write-enable-flash  ( -- )
   0 0 false wena-cmd flash-command
;
: erase-flash-all  ( -- )
   0 0 false erase-cmd flash-command
;
: read-flash  ( adr len offset -- )
   swap bounds  ?do        ( adr )
      i . (cr              ( adr )
      dup  h# 10  i  read-flash-chunk  ( adr )
      h# 10 +              ( adr' )
   h# 10 +loop             ( adr )
   drop                    ( )
;
: wait-write-enabled  ( -- )
   write-enable-flash   ( adr )
   begin  read-flash-status 2 and  until
;
: wait-write-done  ( -- )
   begin  read-flash-status 1 and 0=  until
;

: erase-flash  ( -- )
   wait-write-enabled
   erase-flash-all
   wait-write-done
;

: write-flash  ( adr len offset -- )
   swap bounds  ?do        ( adr )
      i . (cr              ( adr )
      wait-write-enabled
      dup  h# 10  i  write-flash-chunk  ( adr )
      wait-write-done      ( adr )
      h# 10 +              ( adr' )
   h# 10 +loop             ( adr )
   drop                    ( )
;

end-package

\ LICENSE_BEGIN
\ Copyright (c) 2010 FirmWorks
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
