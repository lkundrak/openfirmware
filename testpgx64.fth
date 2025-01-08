\ Test pgx64

hex
no-page

: n->l ff ff ff ff bljoin and ;
: lxjoin n->l 0x20 lshift swap n->l or ;
: xlsplit ( x -- l.low l.high )   dup n->l  swap  d# 32 rshift n->l  ;
: rx!   ( x addr -- )   >r xlsplit r@ la1+ l! r> l!  ;
: rx@   ( addr -- x )   dup l@ swap la1+ l@ lxjoin   ;
: /x 8 ;
: xa1+ 8 + ;

0 value msecs
: msecs++  msecs  dup 1+ to msecs  ;
' msecs++ to get-msecs

create rxl-custom
create rxl-debug
create rxl-debug-trace
create rxl-debug-reg
\ create rxl-debug-raw

h# 0100.0000 constant /linear
/linear alloc-mem value linear
linear /linear 00 fill

create clk
h# ac c, h# ac c, h# 24 c, h# df c, h# f6 c, h# 04 c, h# 00 c, h# fd c,
h# 8e c, h# 9e c, h# 65 c, h# 05 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c,
h# 06 c, h# cf c, h# 40 c, h# 00 c, h# 10 c, h# f6 c, h# ac c, h# 53 c,
h# 40 c, h# 80 c, h# 24 c, h# fd c, h# 00 c, h# 00 c, h# 00 c, h# 02 c,
h# 06 c, h# ac c, h# 06 c, h# ac c, h# 14 c, h# 24 c, h# fd c, h# 00 c,
h# 00 c, h# 05 c, h# 55 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c,
h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c,
h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c, h# 00 c,

create lcd
h# 0e000000 , h# 00088000 , h# 00000000 , h# 00000000 ,
h# 00000000 , h# 00000000 , h# 00000000 , h# 00006001 ,
h# 00000000 , h# 00000000 , h# 00000000 , h# 00000000 ,
h# 00000000 , h# 00000000 , h# 00000000 , h# 00000000 ,
h# 00000000 , h# 00000000 , h# 00000000 , h# 00000000 ,
h# 00000000 , h# 01000000 , h# 01540354 , h# 02ab00ab ,
h# 00000000 , h# 00000000 , h# e2a70ee4 , h# 00222222 ,
h# 00000000 , h# 00006400 , h# bb6a95ea , h# b1fdfc71 ,
h# f7f16f01 , h# 0385bc1d , h# 0a1e833c , h# 00000002 ,
h# 00000794 , h# 00000000 , h# 00000002 , h# 00000000 ,
h# 00000000 , h# 00000000 , h# 00000000 , h# 00000000 ,
h# 00000000 , h# 00000000 , h# 00000000 , h# 00000000 ,
h# 00000000 , h# 00000000 , h# 00000000 , h# 01010001 ,
h# 11110111 , h# 15151511 , h# 55555515 , h# 57575755 ,
h# 77777757 , h# 7f7f7f77 , h# ffffff7f , h# 00000000 ,
h# 00000000 , h# 00000000 , h# 00000000 , h# 00000000 ,

: bad-access?
   2dup mod abort" Unaligned"
   over linear <
   -rot
   +  linear /linear +  >=
   or
;

: linear>lcd
   7ffca8 linear + l@ \ lcd data
   7ffca4 linear + c@ 2 lshift \ lcd index
   lcd + l!
;

: linear<lcd
   7ffca4 linear + c@ 2 lshift \ lcd index
   lcd + l@
   7ffca8 linear + l! \ lcd data
;

: linear>clk
   7ffc92 linear + l@ \ clk data
   7ffc91 linear + c@ 2 rshift  \ clk index
   clk + l!
;

: linear<clk
   7ffc91 linear + c@ 2 rshift  \ clk index
   clk + l@
   7ffc92 linear + l! \ clk data
;

: rl!
   dup 4 bad-access? abort" Bad rl!"
   2dup l!
   linear -
   dup 7ffc90 = if  linear>clk  then
   dup 7ffca4 = if  linear<lcd  then
   dup 7ffca8 = if  linear>lcd  then
   2drop
;

: rw!
   dup 2 bad-access? abort" Bad rw!"
   2dup w!
   linear -
   dup 7ffc90 = if  linear>clk  then
   dup 7ffca4 = if  linear<lcd  then
   dup 7ffca8 = if  linear>lcd  then
   2drop
;

: rb!
   dup 1 bad-access? abort" Bad rb!"
   2dup c!
   linear -
   dup 7ffc91 = if  linear<clk  then
   dup 7ffc92 = if  linear>clk  then
   dup 7ffca4 = if  linear<lcd  then
   dup 7ffca8 = if  linear>lcd  then
   2drop
;

: rb@  dup 1 bad-access? abort" Bad rb@"  c@ ;
: rw@  dup 2 bad-access? abort" Bad rw@"  w@  ;
: rl@  dup 4 bad-access? abort" Bad rl@"  l@  ;

dev /
   : open true ;

   new-device
      " fake-pci" device-name
      3 " #address-cells" integer-property
      2 " #size-cells" integer-property

      : open true ;

      : map-in
         4dup /linear =  swap 0200.1810 = and  swap 0 = and  swap 0 = and if
            \ Linear: 0 0 2001810 1000000
            4drop linear exit
         then
         true abort" Bad map-in"
      ;

      : map-out
         dup /linear =  if
            \ Linear: e0000000 1000000
            2drop exit
         then
         true abort" Bad map-out"
      ;

      : config-b@
         dup h# ff00 and h# 1800 =  if
            h# ff and
            dup h#  4 =  if  drop 0 exit  then \ PCI command
            dup h# 10 =  if  drop 0 exit  then \ BAR1 flags
            drop
         then
         true abort" Bad config-b@"
      ;

      : config-b!
         dup h# ff00 and h# 1800 =  if
            h# ff and
            4 =  if  drop exit  then
         then
         true abort" Bad config-b!"
      ;

      : my-b@ drop 0 ;
      : my-b! 2drop ;

      finish-device
   device-end

select /fake-pci
   new-device
      " fake-dev" device-name
      : open true ;

      : my-address 0 0 ;
      : my-space h# 1800 ;

      finish-device
   device-end

select /fake-pci/fake-dev
   666
   fload ${BP}/dev/video/debugpgx64.fth
   fload ${BP}/dev/video/loadpgx64.fth
   666 <> abort" Unbalanced stack"

   linear encode-int " address" property
." ====================" cr

select /SUNW,m64B
   .properties

." ====================" cr
   .regs

\ words
\ quit
bye

\ clk h# 40 dump
\ lcd h# 100 dump
\ quit
