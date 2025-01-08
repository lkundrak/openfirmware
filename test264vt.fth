\ Test ATY
\ ./cpu/x86/Linux/forth ./cpu/x86/build/basefw.dic 264vt.fth

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

: rl!
   dup e0.7ffb00 > if
      \ Register 1
      2drop exit
   then
   dup e0.7ffc00 > if
      \ Register 0
      2drop exit
   then
   dup e000.0000 > if
      .s cr
      true abort" fb!"
   then
   true abort" Bad rl!"
;

: rw!
   dup c000.0000 > if
      2drop exit
   then
   true abort" Bad rw!"
;

: rb!
   dup c000.0000 > if
      2drop exit
   then
   true abort" Bad rb!"
;


: rb@
   dup c000.0000 > if
      drop 0 exit
   then
   true abort" Bad rb@"
;


: rw@
   dup c000.0000 > if
      drop 0 exit
   then
   true abort" Bad rw@"
;

: rl@
   dup c000.0000 > if
      drop 0 exit
   then
   true abort" Bad rl@"
;


dev /
   : open true ;

   new-device
      " fake-pci" device-name
      3 " #address-cells" integer-property
      2 " #size-cells" integer-property

      : open true ;

      : map-in
         4dup 0100.0000 =  swap 0200.1810 = and  swap 0 = and  swap 0 = and if
            \ RXL Linear: 0 0 2001810 1000000
            4drop e000.0000 exit
         then

         4dup 0001.0000 =  swap 8100.1800 = and  swap 0 = and  swap 0 = and if
            \ VT2 ???: 0 0 81001800 10000
            4drop e100.0000 exit
         then

         true abort" Bad map-in"
      ;

      : map-out
         2dup 0100.0000 =  swap e000.0000 = and  if
            \ RXL Linear: e0000000 1000000
            2drop exit
         then
         2dup 0001.0000 =  swap e100.0000 = and  if
            \ VT2 ???
            2drop exit
         then
         true abort" Bad map-out"
      ;

      : config-l@
         dup h# ff00 and h# 1800 =  if
            h# ff and
            dup h# 40 =  if  drop 0 exit  then \ VT2 ???
            dup h# 4 =  if  drop 0 exit  then \ VT2 ???
            drop
         then
         true abort" Bad config-l@"
      ;

      : config-l!
         dup h# ff00 and h# 1800 =  if
            h# ff and
            dup h# 40 =  if  2drop exit  then \ VT2
            dup h# 4 =  if  2drop exit  then \ VT2
            drop
         then
         true abort" Bad config-l!"
      ;

      : config-w@
         dup h# ff00 and h# 1800 =  if
            h# ff and
            dup h# 16 =  if  drop 0 exit  then \ VT2 ???
            drop
         then
         true abort" Bad config-w@"
      ;

      : config-w!
         dup h# ff00 and h# 1800 =  if
            h# ff and
            dup h# 16 =  if  2drop exit  then \ VT2
            drop
         then
         true abort" Bad config-w!"
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
            dup h# 4 =  if  2drop exit  then
            drop
         then
         true abort" Bad config-b!"
      ;

      finish-device
   device-end

select /fake-pci
   new-device
      " fake-dev" device-name
      : open true ;

      : my-address 0 0 ;
      : my-space h# 1800 ;

      create aty-debug
      create aty-custom

[ifdef] xaty-debug
      : $call-parent
         ." call-parent: " 2dup type space .s cr
         $call-parent
      ;
[then]

      finish-device
   device-end

select /fake-pci/fake-dev
   \ fload ${BP}/dev/video/loadpgx64.fth
   fload ${BP}/dev/video/load264vt.fth

." ====================" cr

\ select /SUNW,m64B
select /ATY,264VT
   .properties

quit
