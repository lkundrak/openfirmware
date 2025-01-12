hex
headers

: copyright " Copyright (c) 2000 Sun Microsystems, Inc." ;
: sccsid " @(#) pgx64.fth 1.12 01/05/04 " ;
: prt_sccsid sccsid type copyright type ;

external
: .version_pgx prt_sccsid ;

headerless


: noop-0804 ;
: noop-0805 ;
: noop-0806 ;

variable oem-branded
oem-branded on
: oem-branded? oem-branded l@ 0<> ;


headers

: pgx_token_cfg " Endian swap: off Debug: off " type cr ;

headerless


00 constant rxl-reg-crtc-h-total-disp
02 constant rxl-reg-crtc-h-disp
04 constant rxl-reg-crtc-h-sync-strt-wid
08 constant rxl-reg-crtc-v-total-disp
0a constant rxl-reg-crtc-v-disp
0c constant rxl-reg-crtc-v-sync-strt-wid
0e constant rxl-reg-crtc-v-sync-strt-wid2
14 constant rxl-reg-crtc-off-pitch
18 constant rxl-reg-crtc-int-cntl
1c constant rxl-reg-crtc-gen-cntl
1f constant rxl-reg-crtc-gen-cntl3
1e constant unused-const-0815
20 constant rxl-reg-dsp-config
24 constant rxl-reg-dsp-on-off
2c constant rxl-reg-mem-buf-cntl
34 constant rxl-reg-mem-addr-config
40 constant rxl-reg-ovr-clr
44 constant rxl-reg-ovr-wid-left-right
48 constant rxl-reg-ovr-wid-top-bottom
54 constant unused-const-081d
58 constant unused-const-081e
5c constant unused-const-081f
78 constant rxl-reg-gp-io
78 constant unused-const-0821
7a constant unused-const-0822
79 constant unused-const-0823
7b constant unused-const-0824
7c constant rxl-reg-hw-debug
80 constant rxl-reg-scratch-reg0
84 constant rxl-reg-scratch-reg1
90 constant rxl-reg-clock-cntl
91 constant rxl-reg-clock-cntl1
92 constant rxl-reg-clock-cntl2
a0 constant rxl-reg-bus-cntl
a4 constant rxl-reg-lcd-index
a8 constant rxl-reg-lcd-data
ac constant rxl-reg-ext-mem-cntl
b0 constant rxl-reg-mem-cntl
c0 constant rxl-reg-dac-regs
c0 constant rxl-reg-dac-regs0
c1 constant rxl-reg-dac-regs1
c2 constant rxl-reg-dac-regs2
c3 constant rxl-reg-dac-regs3
c4 constant rxl-reg-dac-cntl
d0 constant rxl-reg-gen-test-cntl
d4 constant rxl-reg-custom-macro-cntl
e0 constant unused-const-0838
e4 constant rxl-reg-config-stat0

\ LCD registers
00 constant rxl-config-panel
04 constant rxl-lcd-gen-ctrl
08 constant unused-rxl-dstn-control
10 constant rxl-horz-stretching
14 constant rxl-vert-stretching
18 constant rxl-ext-vert-stretch
1c constant unused-rxl-lt-gio0
1d constant rxl-lt-gio1
1f constant rxl-lt-gio3
20 constant rxl-power-management
50 constant rxl-lcd-misc-cntl

1b4 constant rxl-reg-src-cntl

0 value rxl-enable-count
0 value rxl-idle-ms
0 value rxl-idle-iterations
d# 1000 value rxl-delay

7ffc00 constant rxl-linear-blk0
0002ec constant rxl-alt-io-blk0

0 value rxl-my-self-save
0 value rxl-base
0 value unused-rxl-alt-io-base
0 value rxl-assigned-addr
0 value rxl-reg-offset
2 value rxl-fb-memory-prop
0 value rxl-offset-fb
5 value rxl-mem-type

\ Defaults, clock overriden below for the PGX64
d#  14318 value rxl-base-clock-khz
d# 630000 value rxl-clock-freq

0 value rxl-status-prop
-1 value rxl-test-result

800 constant unused-0858
400 constant unused-0859
200 constant unused-085a
100 constant rxl-status-bad-resolution
080 constant unused-085c
040 constant unused-085d
020 constant unused-085e
010 constant unused-085f
008 constant rxl-status-bad-overlay
004 constant rxl-status-bad-crtc-offset
002 constant rxl-status-fb-test-fail
001 constant rxl-status-reg-test-fail

0 value rxl-reuse-assigned-map?
0 value rxl-colormap-token-0865
0 value rxl-current-width
0 value rxl-current-height
2 value rxl-CRT-two
rxl-CRT-two value rxl-CRT-or-LCD
2 value token-086a
0 value token-086b
9 value unused-token-086c
0 value token-086d
-1 value token-086e
0 value token-086f
0 value token-0870
0 value token-0871

\ 0x02 = ??
\ 0x03 = EDID is a0
\ 0x05 = ??
\ 0x0d = ??
\ 0x0b = EDID is valid
\ 0x10 = No monitor
0 value rxl-flags-prop

0 value rxl-edid-buffer
defer rxl-delay-hook
0 value rxl-some-addr
0 value rxl-temp-buffer
0 value token-0877
0 value token-0878
0 value token-0879
0 value rxl-edid-len

: rxl-idle-loop 0 do loop ;
: rxl-time-idle-loop
    \ Wait until the millisecond boundary
    get-msecs
    begin
        dup get-msecs <>
    until
    drop

    get-msecs
    swap rxl-idle-loop
    get-msecs swap -
;

: rxl-calculate-idle-ms
    40
    begin
        dup rxl-time-idle-loop 0=
    while
        2*
    repeat
    dup
    rxl-time-idle-loop
    dup 0= if
        drop 1
    then
    >r dup 2/ swap
    begin
        2dup 1 - <
    while
        2dup + 2/
        dup
        rxl-time-idle-loop
        dup if
            r> drop >r
        else
            drop -rot
        then
        nip
    repeat
    drop r> /
;

: rxl-calibrate-delay
    rxl-idle-ms 0= if
        rxl-calculate-idle-ms dup
            to rxl-idle-ms
            to rxl-idle-iterations
    then

    4 0 do
        rxl-idle-iterations 10 > if
            rxl-idle-iterations 2/ to rxl-idle-iterations
        else
            leave
        then
    loop
;

: rxl-sleep-ms
    [ifdef] rxl-debug-trace  ." W: rxl-sleep-ms " dup . cr  [then]
    rxl-idle-ms if
        0 ?do
            rxl-idle-ms rxl-idle-loop
        loop
    else
        ms
    then
;

: rxl-8ms 8 rxl-sleep-ms ;
: rxl-1ms 1 rxl-sleep-ms ;
: rxl-short-delay rxl-idle-iterations rxl-idle-loop ;
' rxl-1ms to rxl-delay-hook

: rxl-display-installed?
    rxl-enable-count 0<> dup if
    else
        cr " Display not installed" type cr
    then
;

: rxl-num-screen-pixels rxl-current-width rxl-current-height * ;
: rxl-unused-a/ a / ;
: rxl-8/ 2/ 2/ 2/ ;
: rxl-2* 1 swap lshift ;

: rxl-resolution-num
    dup 20 < if
        rxl-2* token-086a or to token-086a
    else
        20 - rxl-2* token-086b or to token-086b
    then
;

: unused-token-0889
    dup 20 < if
        rxl-2* token-086a and 0<>
    else
        20 - rxl-2* token-086b and 0<>
    then
;

: rxl-mode-r1152x900x66 " r1152x900x66" ;
: rxl-mode-r640x480x60  " r640x480x60"  ;

defer rxl-set-mode-hook
200 constant rxl-8bpp
600 constant rxl-18bpp
600 constant rxl-20bpp


headers

rxl-8bpp value pgx-current-depth
rxl-8bpp value pgx-default-depth
d# 66 value pgx-current-vfreq

: >bitdepth
    dup
    rxl-18bpp = if drop 20 exit then
    rxl-8bpp = if 8 exit then
;

: bitdepth>
    dup 20 = if rxl-20bpp exit then
    dup 18 = if rxl-18bpp exit then
    8 = if rxl-8bpp exit then
;

headerless


310 constant rxl-reg-fifo-stat
8000 constant const-0896
ce 2* 2* constant rxl-reg-gui-stat
0 value token-0898
0 value token-0899
0 value token-089a

1 constant rxl-sync-comp
2 constant rxl-sync-dual


headers

14 value pgx-blink-speed

000000 constant truecolor-black
ffffff constant truecolor-white
666699 constant truecolor-sunblue

 0 value psuedocolor-black
ff value psuedocolor-white
 1 value psuedocolor-sunblue

: n->l ff ff ff ff bljoin and ;
: n->w ff ff bwjoin and ;

\ Sun Guava customizations
variable pgx-plano-flag
pgx-plano-flag off

[ifdef] rxl-custom
6 to rxl-mem-type
[else]
d# 29499 to rxl-base-clock-khz
3 to rxl-mem-type
[then]

8 to rxl-fb-memory-prop

headerless

7b33a040 constant rxl-def-bus-cntl

00000000 constant rxl-def-crtc-int-cntl
05000240 constant rxl-def-crtc-gen-cntl
00000000 constant rxl-def-gen-test-cntl
80010102 constant rxl-def-dac-cntl
00000006 constant unused-const-08ac

create rxl-macro-cntls
( 0 ) 080179 l,
( 1 ) 080179 l,
( 2 ) 080179 l,
( 3 ) 080179 l,
( 4 ) 7f0179 l,
( 5 ) 050179 l,
( 6 ) [ifdef] rxl-custom  7f0179 l,  [then]

create rxl-mem-configs
( 0 ) 02110000 l,
( 1 ) 02110101 l,
( 2 ) 02110101 l,
( 3 ) 00110202 l,
( 4 ) 02200213 l,
( 5 ) 02200314 l,
( 6 ) [ifdef] rxl-custom  02200213 l,  [then]

create rxl-mem-cntls
( 0 ) 10c57a37 l, \ 4MB, 4KB page, tCAS=4, tRW=2, tRAS=6, Refresh=XCLK/1953
( 1 ) 10c57a37 l, \      --//--
( 2 ) 10c57a3b l, \ 8MB, --//--
( 3 ) 10a57a3b l, \      --//--                           Refresh=XCLK/1797
( 4 ) 00265a27 l, \ 4MB, 2KB page, tCAS=3, tRW=1, tRAS=7, Refresh=XCLK/1031
( 5 ) 00265a2b l, \ 8MB, --//--
\ XL: 08165a2b  0(2KB page) 8(upper big endian) 1(50-65 MHz)   6(7RAS) 5(1RWd) a
( 6 ) [ifdef] rxl-custom  00165a2b l,  [then]

create rxl-ext-mem-cntls
( 0 ) 64000c81 l,
( 1 ) 64000c81 l,
( 2 ) 64000c81 l,
( 3 ) e0000c81 l,
( 4 ) 64004cf1 l,
( 5 ) 64000cf1 l,
( 6 ) [ifdef] rxl-custom  e0000cf1 l,  [then]

create rxl-hw-debugs
( 0 ) 0 l,
( 1 ) 0 l,
( 2 ) 0 l,
( 3 ) 00050000 l, \ Longer HCKL skew
( 4 ) 0 l,
( 5 ) 0 l,
( 6 ) [ifdef] rxl-custom  0 l,  [then]

\ unused
create rxl-configs
( 0 ) 1d c, \ SGRAM
( 1 ) 1d c, \ SGRAM
( 2 ) 1d c, \ SGRAM
( 3 ) 1c c, \ SDRAM (1:1)
( 4 ) 1e c, \ SDRAM (2:1, 32-bit)
( 5 ) 1e c, \ SDRAM
( 6 ) [ifdef] rxl-custom  1e c, [then] \ SDRAM (2:1, 32-bit)

create rxl-oem-configs
( 0 ) 1d c, \ SGRAM
( 1 ) 1d c, \ SGRAM
( 2 ) 1d c, \ SGRAM
( 3 ) 1d c, \ SGRAM
( 4 ) 1e c, \ SDRAM
( 5 ) 1e c, \ SDRAM
( 6 ) [ifdef] rxl-custom  1e c, [then] \ SDRAM (2:1, 32-bit)

create rxl-memory-sizes
( 0 ) 4 c,
( 1 ) 4 c,
( 2 ) 8 c,
( 3 ) 8 c,
( 4 ) 4 c,
( 5 ) 8 c,
( 6 ) [ifdef] rxl-custom  8 c, [then]

[ifdef] rxl-custom
\ RXL
ad value rxl-def-mpll-cntl
d5 value rxl-def-vpll-cntl
1f value rxl-def-pll-ref-div
44 value rxl-def-pll-gen-cntl
88 value rxl-def-mclk-fb-div
03 value rxl-def-pll-vclk-cntl
ff value rxl-def-vclk-post-div
da value rxl-def-vclk0-fb-div
ca value rxl-def-pll-ext-cntl
f6 value rxl-def-sclk-fb-div
ac value rxl-def-spll-cntl1
03 value rxl-def-spll-cntl2
82 value rxl-def-dll1-cntl
10 value rxl-def-dll2-cntl
19 value rxl-def-pll-yclk-cntl
[else]
\ Guava customization?
d# 1150000 to rxl-clock-freq
ad value rxl-def-mpll-cntl
d5 value rxl-def-vpll-cntl
3b value rxl-def-pll-ref-div
44 value rxl-def-pll-gen-cntl
e6 value rxl-def-mclk-fb-div
03 value rxl-def-pll-vclk-cntl
03 value rxl-def-vclk-post-div
c9 value rxl-def-vclk0-fb-div
01 value rxl-def-pll-ext-cntl
98 value rxl-def-sclk-fb-div
ac value rxl-def-spll-cntl1
53 value rxl-def-spll-cntl2
80 value rxl-def-dll1-cntl
50 value rxl-def-dll2-cntl
25 value rxl-def-pll-yclk-cntl
[then]

80 value rxl-def-lcd-misc-bias

00830274 constant rxl-def-config-panel
0f009611 constant unused-const-08c6
007f8090 constant rxl-def-lcd-gen-ctrl
00038000 constant rxl-def-lcd-misc-cntl
00000c0b constant rxl-def-power-management

9 value unused-token-08ca

c to unused-token-086c
2 to rxl-CRT-two \ useless ...
d# 1152 to rxl-current-width
d#  900 to rxl-current-height

create unused-token-08cb
454f w, 6140 w, 7186 w, 7190 w, 81d0 w, 8180 w, 8190 w, 95d0 w, a9c6 w,

\ 48
create rxl-unused-modetable
00630083 l, 000a0267 l, 02570270 l, 00230258 l, \  800x600
007f00a7 l, 00110284 l, 02ff0325 l, 00260302 l, \ 1024x768
008f00be l, 00100296 l, 038303a8 l, 00240385 l, \ 1152x900
008f00bb l, 00100295 l, 038303ae l, 00280385 l, \ 1152x900
009f00c3 l, 000e02a3 l, 031f034d l, 00270322 l, \ 1280x800
009f00d2 l, 000e02a7 l, 03ff0429 l, 00230400 l, \ 1280x1024
009f00cf l, 000802a5 l, 03ff0429 l, 00280401 l, \ 1280x1024
00b300ea l, 001402ba l, 038303af l, 00230385 l, \ 1440x900
00c70109 l, 001b02cd l, 03e7041a l, 002303e9 l, \ 1600x1000
007f00a7 l, 00110284 l, 02ff0325 l, 00260302 l, \ 1024x768
0063008b l, 00110268 l, 0257027d l, 0026025a l, \  800x600
004f0077 l, 00110254 l, 01df0205 l, 002601e2 l, \  640x480
\    |         |             |          |
\ Looks like this, probably: |          |
\    |         |             |          |
\ H_TOTAL_DISP |             |          |
\       H_SYNC_STRT_WID      |          |
\                       V_TOTAL_DISP    |
\                                 V_SYNC_STRT_WID


create token-08cd
1356 w, \  800x600
1950 w, \ 1024x768
24ea w, \ 1152x900
2a30 w, \ 1152x900
278d w, \ 1280x800
2a30 w, \ 1280x1024
34bc w, \ 1280x1024
34bc w, \ 1440x900
4272 w, \ 1600x1000
1964 w, \ 1024x768
1964 w, \  800x600
1964 w, \  640x480

create rxl-resolutions
d#  800 w, d#  600 w,
d# 1024 w, d#  768 w,
d# 1152 w, d#  900 w,
d# 1152 w, d#  900 w,
d# 1280 w, d#  800 w,
d# 1280 w, d# 1024 w,
d# 1280 w, d# 1024 w,
d# 1440 w, d#  900 w,
d# 1600 w, d# 1000 w,
d# 1024 w, d#  768 w,
d#  800 w, d#  600 w,
d#  640 w, d#  480 w,

3 value /rxl-LCD-values
create rxl-LCD-values
d#  9 c,
d# 10 c,
d# 11 c,

( -- lcd? )
: rxl-is-LCD
    false                           ( n )
    swap                            ( false n )
    rxl-LCD-values /rxl-LCD-values bounds do
        dup
        i c@ = if  drop true swap leave  then
    loop
    drop
;

d# 1024 value rxl-horiz-1024
d#  768 value rxl-vert-768
d#    9 value rxl-LCD-nine

: >rxl-val32 ff ff ff ff bljoin and ;
: rxl-reg-addr rxl-base rxl-reg-offset + + ;

[ifdef] rxl-debug-raw
: rw@ dup rw@ swap ." C: rw@ " . ." -> " dup . cr ;
: rb@ dup rb@ swap ." C: rb@ " . ." -> " dup . cr ;
: rl@ dup rl@ swap ." C: rl@ " . ." -> " dup . cr ;

: rw! 2dup ." C: rw! " . ." <- " . cr rw! ;
: rb! 2dup ." C: rb! " . ." <- " . cr rb! ;
: rl! 2dup ." C: rl! " . ." <- " . cr rl! ;
[then]

[ifdef] rxl-debug-reg
: .reg>w  rxl-reg-offset h# 7ff800 =  if  .reg1>w  else  .reg0>w  then ;
: .reg>b  rxl-reg-offset h# 7ff800 =  if  .reg1>b  else  .reg0>b  then ;
: .reg>l  rxl-reg-offset h# 7ff800 =  if  .reg1>l  else  .reg0>l  then ;

: .reg<w  rxl-reg-offset h# 7ff800 =  if  .reg1<w  else  .reg0<w  then ;
: .reg<b  rxl-reg-offset h# 7ff800 =  if  .reg1<b  else  .reg0<b  then ;
: .reg<l  rxl-reg-offset h# 7ff800 =  if  .reg1<l  else  .reg0<l  then ;

: rxl-rw@  dup  rxl-reg-addr >rxl-val32 rw@  dup rot .reg>w  noop-0804 ;
: rxl-rb@  dup  rxl-reg-addr >rxl-val32 rb@  dup rot .reg>b ;
: rxl-rl@  dup  rxl-reg-addr >rxl-val32 rl@  dup rot .reg>l  noop-0805 ;

: rxl-rw!  2dup .reg<w  rxl-reg-addr >rxl-val32 >r noop-0804 r> rw! ;
: rxl-rb!  2dup .reg<b  rxl-reg-addr >rxl-val32                 rb! ;
: rxl-rl!  2dup .reg<l  rxl-reg-addr >rxl-val32 >r noop-0805 r> rl! ;
[else]
: rxl-rw@ rxl-reg-addr >rxl-val32 rw@ noop-0804 ;
: rxl-rb@ rxl-reg-addr >rxl-val32 rb@ ;
: rxl-rl@ rxl-reg-addr >rxl-val32 rl@ noop-0805 ;

: rxl-rw! rxl-reg-addr >rxl-val32 >r noop-0804 r> rw! ;
: rxl-rb! rxl-reg-addr >rxl-val32 rb! ;
: rxl-rl! rxl-reg-addr >rxl-val32 >r noop-0805 r> rl! ;
[then]

: rxl-set-status ( stat a a' )
    <> if
        rxl-status-prop or to rxl-status-prop
    else
        drop
    then
;

: rxl-stat-rl!  ( val reg stat )
    -rot ( a b c - c a b )
    2dup ( c a b a b )
    rxl-rl! ( c a b )
    rxl-rl@ ( c a a' )
    rxl-set-status
;

: unused-rxl-stat-rw!
    -rot 2dup
    rxl-rw!
    rxl-rw@
    rxl-set-status
;

: unused-rxl-stat-rb!
    -rot 2dup
    rxl-rb!
    rxl-rb@
    rxl-set-status
;

: rxl-clock@
    [ifdef] rxl-debug-raw  dup  [then]
    2 lshift
    rxl-reg-clock-cntl1 rxl-rb!
    rxl-reg-clock-cntl2 rxl-rb@
    [ifdef] rxl-debug-raw  swap ." C: rxl-clock@ " . ." -> " dup . cr  [then]
;

: rxl-clock!
    [ifdef] rxl-debug-raw  2dup ." C: rxl-clock! " . ." <- " . cr  [then]
    2 lshift 2 or
    rxl-reg-clock-cntl1 rxl-rb!
    rxl-reg-clock-cntl2 rxl-rb!
;

: rxl-call-parent
    my-self 0<> if
        my-self to rxl-my-self-save
    else
        rxl-my-self-save to my-self
    then
    $call-parent
;

0 value rxl-my-self-save2

: unused-token-08e5
    my-self to rxl-my-self-save2
    2dup my-parent ihandle>phandle find-method if
        drop $call-parent
    else
        2drop
    then
    rxl-my-self-save2 to my-self
;

: rxl-delay-20ms
    [ifdef] rxl-debug-trace  ." W: 20ms" cr  [then]
    20 ms
;

: rxl-init-ext-mem
    [ifdef] rxl-debug-trace  cr ." P: rxl-init-ext-mem" cr  [then]
    rxl-reg-ext-mem-cntl rxl-rb@

    2 or dup         rxl-reg-ext-mem-cntl  rxl-rb!  rxl-delay-20ms
    f3 and 8 or dup  rxl-reg-ext-mem-cntl  rxl-rb!  rxl-delay-20ms
    c or dup         rxl-reg-ext-mem-cntl  rxl-rb!  rxl-delay-20ms
    f3 and dup       rxl-reg-ext-mem-cntl  rxl-rb!  rxl-delay-20ms
    f1 and           rxl-reg-ext-mem-cntl  rxl-rb!  rxl-delay-20ms
;

: rxl-reset-dll
    [ifdef] rxl-debug-trace  cr ." P: rxl-reset-dll" cr  [then]
    rxl-def-dll1-cntl 40 and 0= if
        c rxl-clock@ \ DLL_CNTL
        bf and dup
            c rxl-clock!
            rxl-delay-20ms
            dup 40 or c rxl-clock!
            rxl-delay-20ms
        c rxl-clock!
        rxl-delay-20ms
    then
;

: rxl-reset-mem-controller
    [ifdef] rxl-debug-trace  cr ." P: rxl-reset-mem-controller" cr  [then]
    rxl-def-gen-test-cntl         rxl-reg-gen-test-cntl  rxl-rl!  rxl-delay-20ms
    rxl-def-gen-test-cntl 200 or  rxl-reg-gen-test-cntl  rxl-rl!  rxl-delay-20ms
    rxl-def-gen-test-cntl         rxl-reg-gen-test-cntl  rxl-rl!  rxl-delay-20ms
;

: rxl-init-mem-sth
    [ifdef] rxl-debug-trace  cr ." P: rxl-init-mem-sth" cr  [then]
    rxl-reg-mem-cntl rxl-rl@
    dup 80000 or n->l rxl-reg-mem-cntl rxl-rl!

    rxl-reg-mem-addr-config rxl-rl@
    dup 2000000 invert and n->l rxl-reg-mem-addr-config rxl-rl!

        rxl-reset-mem-controller
        rxl-init-ext-mem

    rxl-reg-mem-addr-config rxl-rl!
    rxl-reg-mem-cntl rxl-rl!
;

: rxl-init-mem
    [ifdef] rxl-debug-trace  cr ." P: rxl-init-mem" cr  [then]
    rxl-mem-configs rxl-mem-type la+ l@
    dup 2000000 invert n->l and rxl-reg-mem-addr-config rxl-rl!

    rxl-mem-cntls rxl-mem-type la+ l@
    dup 80000 invert n->l and rxl-reg-mem-cntl rxl-rl!

        rxl-ext-mem-cntls rxl-mem-type la+ l@
        rxl-reg-ext-mem-cntl rxl-rl!

        rxl-hw-debugs rxl-mem-type la+ l@
        rxl-reg-hw-debug rxl-rl!

        rxl-macro-cntls rxl-mem-type la+ l@
        rxl-reg-custom-macro-cntl rxl-rl!

        oem-branded? if
            rxl-oem-configs rxl-mem-type ca+ c@
            rxl-reg-config-stat0 rxl-rb!
        else
            rxl-configs rxl-mem-type ca+ c@
            rxl-reg-config-stat0 rxl-rb!
        then

        rxl-memory-sizes rxl-mem-type ca+ c@
        to rxl-fb-memory-prop

        rxl-init-mem-sth

    rxl-reg-mem-cntl rxl-rl!
    rxl-reg-mem-addr-config rxl-rl!
;

: unused-init-mem
    rxl-init-mem
;

: rxl-toggle-vsync-pol
    [ifdef] rxl-debug-trace  cr ." P: rxl-toggle-vsync-pol" cr  [then]
    0 rxl-reg-crtc-v-sync-strt-wid2 rxl-rb!
    rxl-delay-hook
    20 rxl-reg-crtc-v-sync-strt-wid2 rxl-rb!
    rxl-delay-hook
;

: rxl-lcd-l@
    [ifdef] rxl-debug-raw  dup  [then]
    4 / rxl-reg-lcd-index rxl-rb!
    rxl-reg-lcd-data rxl-rl@
    [ifdef] rxl-debug-raw  swap ." C: rxl-lcd-l@ " . ." -> " dup . cr  [then]
;

: rxl-lcd-l!
    [ifdef] rxl-debug-raw  2dup ." C: rxl-lcd-l! " . ." <- " . cr  [then]
    4 / rxl-reg-lcd-index rxl-rb!
    rxl-reg-lcd-data rxl-rl!
;

: rxl-lcd-b@
    [ifdef] rxl-debug-raw  dup  [then]
    dup         ( lcdreg -- lcdreg lcdreg )
    rxl-lcd-l@  ( lcdreg -- lcdreg lcdval )
    swap        ( lcdreg lcdval -- lcdval lcdreg )
    4 mod       ( lcdreg lcdval -- lcdval lcdreg%4 )
    8 *         ( lcdval lcdreg%4 -- lcdval lcdreg%4*8 )
    rshift      ( lcdval lcdreg%4*8 -- lcdval>>lcdreg%4*8 )
    ff and
    [ifdef] rxl-debug-raw  swap ." C: rxl-lcd-b@ " . ." -> " dup . cr  [then]
;

: rxl-lcd-b!
    [ifdef] rxl-debug-raw  2dup ." C: rxl-lcd-b! " . ." <- " . cr  [then]
    dup 4 mod 8 * rot swap lshift swap
    dup 4 mod 8 * ff swap lshift
    invert n->l over
      rxl-lcd-l@
      and rot or swap
      rxl-lcd-l!
;

\ Input, 6-bit value:
\ MSB 6   5     4     3     2     1   LSB
\   x x [D16] [D15] [D14] [V16] [V15] [V14]
\ D<pin> Direction 0=input, 1=output
\ V<pin> Value
: rxl-gpio!
    \ GPIO directions
    dup                     ( a -- a a )
    2* 70 and               ( a a -- a [a<<1 & 0x70] )
    rxl-lt-gio3 rxl-lcd-b@  ( a [a<<1 & 0x70] -- a [b<<4 & 0x70] v )
    8f and                  ( a [b<<4 & 0x70] v -- a [b<<4 & 0x70] [v & 0x8f] )
    or                      ( a [b<<4 & 0x70] [v & 0x8f] -- a [b<<4 & 0x70]|[v & 0x8f] )
    rxl-lt-gio3 rxl-lcd-b!  ( a )

    \ GPIO values
    10 * 70 and             ( a -- [a<<4 & 0x70] )
    rxl-lt-gio1 rxl-lcd-b@  ( [a<<4 & 0x70] -- [a<<4 & 0x70] v )
    8f and                  ( [a<<4 & 0x70] v -- [a<<4 & 0x70] [v & 0x8f] )
    or                      ( [a<<4 & 0x70] [v & 0x8f] -- [a<<4 & 0x70]|[v & 0x8f] )
    rxl-lt-gio1 rxl-lcd-b!  ( )
;

: rxl-gpio-val@
    rxl-lt-gio1 rxl-lcd-b@ 10 / 7 and
;

: rxl-gpio@
    rxl-gpio-val@
    rxl-lt-gio3 rxl-lcd-b@ 70 and 2/ or
;

: unused-token-08f5
    unused-rxl-lt-gio0 rxl-lcd-b@ 2/ 3 and
;

( CLK -- PLL_REF_DIV  DIV  VCLK0_FB_DIV   )
: rxl-calc-pixclk-pll
                           ( CLK      )
    rxl-def-pll-ref-div    ( CLK rxl-def-pll-ref-div    )
    swap                   ( rxl-def-pll-ref-div CLK    )


                           ( rxl-def-pll-ref-div      CLK    )
         dup d# 10000 > if 1
    else dup d#  6666 > if 2
    else dup d#  5000 > if 3
    else dup d#  3333 > if 4
    else dup d#  2500 > if 6
    else                   8
    then then then then then
                           ( rxl-def-pll-ref-div      CLK DIV   )

                           ( rxl-def-pll-ref-div      CLK DIV   )
    swap                   ( rxl-def-pll-ref-div DIV      CLK   )
    over                   ( rxl-def-pll-ref-div DIV      CLK DIV )
    *                      ( rxl-def-pll-ref-div DIV      CLK*DIV )
    rxl-def-pll-ref-div *  ( rxl-def-pll-ref-div DIV      CLK*DIV*rxl-def-pll-ref-div )
    d# 10 *                ( rxl-def-pll-ref-div DIV   10*CLK*DIV*rxl-def-pll-ref-div )
    rxl-base-clock-khz /   ( rxl-def-pll-ref-div DIV  [10*CLK*DIV*rxl-def-pll-ref-div]/rxl-base-clock-khz )
    1 +                    ( rxl-def-pll-ref-div DIV  [10*CLK*DIV*rxl-def-pll-ref-div]/rxl-base-clock-khz+1 )
    2/                     ( rxl-def-pll-ref-div DIV [[10*CLK*DIV*rxl-def-pll-ref-div]/rxl-base-clock-khz+1]/2 )
                           ( PLL_REF_DIV             DIV         VCLK0_FB_DIV   )
;

\ ( PLL_REF_DIV DIV VCLK0_FB_DIV -- [VCLK0_FB_DIV*rxl-base-clock-khz*2]/[PLL_REF_DIV*DIV]/10 )
: rxl-recalc-pixclk
    rxl-base-clock-khz *
			( PLL_REF_DIV DIV VCLK0_FB_DIV*rxl-base-clock-khz )
    2*			( PLL_REF_DIV DIV VCLK0_FB_DIV*rxl-base-clock-khz*2 )
    -rot		( VCLK0_FB_DIV*rxl-base-clock-khz*2 PLL_REF_DIV DIV )
    *			( VCLK0_FB_DIV*rxl-base-clock-khz*2 PLL_REF_DIV*DIV )
    /			( [VCLK0_FB_DIV*rxl-base-clock-khz*2]/[PLL_REF_DIV*DIV] )
    d# 10 /		( [VCLK0_FB_DIV*rxl-base-clock-khz*2]/[PLL_REF_DIV*DIV]/10 )
;

: rxl-20ms 20 rxl-sleep-ms ;

( PLL_REF_DIV DIV VCLK0_FB_DIV -- )
: rxl-configure-vclk
    [ifdef] rxl-debug-trace  cr ." P: rxl-configure-vclk" cr  [then]
    ( PLL_REF_DIV DIV VCLK0_FB_DIV )
    7 rxl-clock! \ VCLK0_FB_DIV

                ( PLL_REF_DIV DIV )
    dup     3 <> swap   ( PLL_REF_DIV DIV<>3 DIV )
    dup     6 <> swap   ( PLL_REF_DIV DIV<>3 DIV<>6 DIV )
    dup d# 12 <> rot   ( PLL_REF_DIV DIV<>3 DIV DIV<>12 DIV<>6 )
    and rot and        ( PLL_REF_DIV DIV DIV<>{12,6,3} )
    if                 ( PLL_REF_DIV DIV )
        2/ dup         ( PLL_REF_DIV DIV/2 DIV/2 )
        4 = if         ( PLL_REF_DIV DIV/2 )
            1 -        ( PLL_REF_DIV DIV/2-1 )
        then
        0              \ ALT_VCLK0_POST=0
                       ( PLL_REF_DIV DIV/2-1 00 )
    else               ( PLL_REF_DIV DIV )
        3 / dup        ( PLL_REF_DIV DIV/3 DIV/3 )
        2 <> if        ( PLL_REF_DIV DIV/3 )
            1 -        ( PLL_REF_DIV DIV/3-1 )
        then
        h# 10          \ ALT_VCLK0_POST=1
                       ( PLL_REF_DIV DIV/3-1 10 )
    then

    ( PLL_REF_DIV [DIV/2==4 ? DIV/2-1 : DIV/2] 00 )  \ if DIV<>{12,6,3}
    ( PLL_REF_DIV [DIV/3==2 ? DIV/3 : DIV/3-1] 10 )  \ if DIV=={12,6,3}
    ( PLL_REF_DIV VCLK_POST_DIV  ALT_VCLK0_POST ] )

    b rxl-clock@	\ PLL_EXT_CNTL	
      h# 0f and or	\ ???
      b rxl-clock!	( PLL_REF_DIV VCLK_POST_DIV )

    6 rxl-clock!	\ VCLK_POST_DIV  ( PLL_REF_DIV )
    2 rxl-clock!	\ PLL_REF_DIV    ( )

    rxl-20ms
;

: rxl-init-clock
    [ifdef] rxl-debug-trace  cr ." P: rxl-init-clock" cr  [then]
    0 rxl-reg-clock-cntl rxl-rb!

    54 h# 3 rxl-clock!	\ PLL_GEN_CNTL enable oscillator, MCLK=CPUCLK
    5     b rxl-clock!	\ PLL_EXT_CNTL XCLK=CLUCLK
    rxl-20ms

    rxl-def-mpll-cntl      h# 00 rxl-clock!
    rxl-def-vpll-cntl      h# 01 rxl-clock!
    rxl-def-spll-cntl1     h# 16 rxl-clock!
    rxl-def-vclk0-fb-div   h# 07 rxl-clock!
    rxl-def-vclk-post-div  h# 06 rxl-clock!
    rxl-def-pll-ref-div    h# 02 rxl-clock!
    rxl-def-pll-vclk-cntl  h# 05 rxl-clock!
    rxl-def-mclk-fb-div    h# 04 rxl-clock!
    rxl-def-sclk-fb-div    h# 15 rxl-clock!
    rxl-def-pll-yclk-cntl  h# 29 rxl-clock!
    rxl-def-pll-ext-cntl   h# 0b rxl-clock!
    rxl-def-spll-cntl2     h# 17 rxl-clock!
    rxl-def-pll-gen-cntl   h# 03 rxl-clock!
    rxl-def-dll2-cntl      h# 14 rxl-clock!
    rxl-def-dll1-cntl      h# 0c rxl-clock!
    rxl-20ms

    rxl-reset-dll
    rxl-20ms

    rxl-base-clock-khz 2*
[ifdef] rxl-bugfix
    \ MFB_TIMES_4_2b@PLL_EXT_CNTL
    rxl-def-pll-ext-cntl h# 08 and  if  2*  then
[then]
    rxl-def-mclk-fb-div *
        d# 10 * rxl-def-pll-ref-div /
    1 rxl-def-pll-ext-cntl 7 and lshift
    dup d# 16 = if
        drop 3
    then
    / to rxl-clock-freq
;

: rxl-detect-monitor
    [ifdef] rxl-debug-trace  cr ." P: rxl-detect-monitor" cr  [then]
    60606000 rxl-reg-ovr-clr rxl-rl!
    50 rxl-sleep-ms

    \ Any comparator above 0.42V
    rxl-reg-dac-cntl rxl-rb@ 80 and if
        rxl-flags-prop 10 or to rxl-flags-prop
    then

    h# 0 rxl-reg-ovr-clr rxl-rl!
;

: rxl-sck@ rxl-gpio@ 4 and 0<> ;
: rxl-sda@ rxl-gpio@ 2 and 0<> ;
: rxl-sck1
    10 0 do
        rxl-gpio@ 24 or rxl-gpio! \ SCK=1
        rxl-sck@ if \ Clock stretching
            leave
        else
            rxl-delay-hook
        then
    loop
;

[ifndef] end0 \ openbios tokenizer, not real forth
[ifndef] rxl-custom
   tokenizer[ h# 900 next-fcode ]tokenizer
[then]
[then]

: rxl-sck1-delay rxl-sck1 rxl-delay-hook ;
: rxl-sck0 rxl-gpio@ 20 or fb and rxl-gpio! ;
: rxl-sck0-delay rxl-sck0 rxl-delay-hook ;
: rxl-sck-in rxl-gpio@ df and rxl-gpio! ;
: rxl-sda1 rxl-gpio@ 12 or rxl-gpio! ;
: unused-rxl-sda1-delay rxl-sda1 rxl-delay-hook ;
: rxl-sda0 rxl-gpio@ 10 or fd and rxl-gpio! ;
: rxl-sda-in rxl-gpio@ ef and rxl-gpio! ;

: rxl-edid-magic?
    rxl-edid-buffer c@
    rxl-edid-buffer 7 + c@ +
    0= if
        -1 rxl-edid-buffer 1 + 6 bounds do
            i c@ ff <> if
                drop 0 leave
            then
        loop
    else
        0
    then
;

: rxl-edid-cksum?
    0 rxl-edid-buffer 7f bounds do
        i c@ +
    loop
    negate ff and rxl-edid-buffer 7f + c@ =
;

: rxl-i2c-wait-idle
    rxl-sda-in  3 rxl-sleep-ms
    100 0 do
        rxl-sck-in  3 rxl-sleep-ms
        rxl-sck@ rxl-sda@ and if
            leave
        then
        rxl-sck0  3 rxl-sleep-ms
        rxl-sck1  3 rxl-sleep-ms
    loop
;

: rxl-i2c-begin
    rxl-i2c-wait-idle
    rxl-sda0    3 rxl-sleep-ms
    rxl-sck0    3 rxl-sleep-ms
    rxl-sda-in  3 rxl-sleep-ms
;

: rxl-i2c-end
    100 0 do
        rxl-sck0    3 rxl-sleep-ms
        rxl-sda0    3 rxl-sleep-ms
        rxl-sck1    3 rxl-sleep-ms
        rxl-sda1    3 rxl-sleep-ms
        rxl-sda-in  3 rxl-sleep-ms
        rxl-sck-in  3 rxl-sleep-ms
        rxl-sck@ rxl-sda@ and if
            leave
        then
    loop
;

: rxl-i2c-send-bit
    80 and if \ Sends MSB
        rxl-sda1
    else
        rxl-sda0
    then
    rxl-sck1-delay
    rxl-sck0
    rxl-sda-in
    rxl-delay-hook
;

: rxl-i2c-ack?
    rxl-sda-in
    rxl-sck1-delay
    rxl-sda@
    rxl-sck0-delay
;

( <i2ca> -- )
: rxl-i2c-select
    8 0 do
        dup rxl-i2c-send-bit 2*
    loop
    drop
    0 4 0 do
        100 0 do
            rxl-i2c-ack? 0= if
                drop -1 leave
            then
        loop
        rxl-delay-hook dup if
            leave
        then
    loop
;

: rxl-i2c-b<
    rxl-sda-in
    0 8 0 do
        2*
        rxl-sck1-delay
        rxl-sda@ if 1 + then
        rxl-sck0-delay
    loop
    0 rxl-i2c-send-bit
;

: rxl-i2c-last-b<
    rxl-sda-in
    0 8 0 do
        2*
        rxl-sck1-delay
        rxl-sda@ if 1 + then
        rxl-sck0-delay
    loop
;

: rxl-can-select-a0
    false
    rxl-i2c-begin
    a0 rxl-i2c-select if
        h# 0 rxl-i2c-select if
            drop true
        then
    then
    rxl-i2c-end
;

: rxl-i2c-read-a1
    rxl-i2c-begin
    a1 rxl-i2c-select if
        rxl-edid-buffer 7f bounds do
            rxl-i2c-b< i c!
        loop
        rxl-i2c-last-b< rxl-edid-buffer 7f ca+ c!
    then
    rxl-i2c-end

    \ Is EDID valid?
    rxl-edid-magic? rxl-edid-cksum? and dup if
        \ Turn on the EDID valid flag
        b rxl-flags-prop or to rxl-flags-prop
    then
;

: rxl-i2c-try-read-a1
    false
    4 0 do
        rxl-i2c-read-a1 if
            drop true leave
        then
    loop
;

: rxl-read-edid-a1?
    rxl-idle-iterations if
        ['] rxl-short-delay to rxl-delay-hook
    then

    rxl-i2c-wait-idle
    rxl-sck0
    100 rxl-sleep-ms

    false \ Bad return

    rxl-i2c-wait-idle
    rxl-sck-in
    rxl-sda-in
    3 rxl-sleep-ms
    rxl-sck@ rxl-sda@ and if
        rxl-sck0
        rxl-delay-hook
        rxl-sda@ if
            rxl-sck-in
            rxl-sda0
            rxl-delay-hook
            rxl-sck@ if
                2 rxl-flags-prop or to rxl-flags-prop
                rxl-sda-in
                3 rxl-sleep-ms
                10 0 do
                    rxl-can-select-a0 if
                        drop true \ Good return
                        h# 3 rxl-flags-prop or to rxl-flags-prop
                        leave
                    then
                loop
            then
        then
    then
;

: unused-token-0916
    >r rxl-unused-modetable r@ 2* 2* la+ dup l@
    18 rshift 200 or fff3 and swap 4 /l* bounds do
        i l@ /l
    +loop
    r>
;

: unused-token-0917
    token-08cd swap wa+ w@
;

: rxl-get-resolution ( ?? -- wifdth height )
    2* rxl-resolutions swap wa+ dup w@
    swap wa1+ w@
;

: unused-token-0919
    rxl-unused-modetable swap 2* 2* la+ dup l@
    ffff and 1 + 8 * swap 2 la+ l@
    ffff and 1 +
;

: rxl-some-length
    80 9 * 2*
;

: rxl-alloc-temp-buffer
    rxl-some-length alloc-mem to rxl-some-addr
    80 2* alloc-mem to rxl-temp-buffer
;

: rxl-free-temp-buffer
    rxl-some-addr rxl-some-length free-mem
    rxl-temp-buffer 80 free-mem
;

: unused-token-091d
    ['] rxl-8ms to rxl-delay-hook
    rxl-toggle-vsync-pol
    rxl-sda@ ff and rxl-some-addr c!
    36 0 do
        rxl-toggle-vsync-pol
        rxl-sda@ ff and rxl-some-addr c@ <> if
            -1 to token-0877 leave
        then
    loop
    token-0877 if
        ['] rxl-1ms to rxl-delay-hook
        5 rxl-flags-prop or to rxl-flags-prop
        rxl-some-addr rxl-some-length bounds do
            rxl-toggle-vsync-pol
            rxl-sda@ if
                ff
            else
                0
            then
            i c!
        loop
    then
;

: unused-token-091e
    0 to token-0878 8 + rxl-some-addr swap bounds do
        i c@ if
            1
        else
            0
        then
        token-0878 1 lshift or to token-0878
    loop
    token-0878
;

: unused-token-091f
    0 to rxl-edid-len
    token-0879 rxl-some-length bounds do
        i unused-token-091e rxl-temp-buffer rxl-edid-len + c!
        rxl-edid-len 1 + to rxl-edid-len
        9
    +loop
    80 0 do
        rxl-temp-buffer i + dup c@
        rxl-temp-buffer i + 7 + c@
        + 0= if
            rxl-temp-buffer i + 1 + c@
            rxl-temp-buffer i + 2 + c@ +
            rxl-temp-buffer i + 3 + c@ +
            rxl-temp-buffer i + 4 + c@ +
            rxl-temp-buffer i + 5 + c@ +
            rxl-temp-buffer i + 6 + c@ +
            5fa = if
                80 0 do
                    rxl-temp-buffer i + j + c@
                    rxl-edid-buffer i + c!
                loop
            then
        then
    loop
;

: unused-token-0920
    rxl-alloc-temp-buffer unused-token-091d
    false
    token-0877 if
        9 0 do
            i to token-0879
            unused-token-091f
            rxl-edid-magic? if
                rxl-edid-cksum? if
                    d rxl-flags-prop or to rxl-flags-prop
                    drop
                    true leave
                then
            then
        loop
    then
    rxl-free-temp-buffer
;

: rxl-64/
    64 /
;

\ Return location of leftmost bit set. E.g.:
\ h# 0007 rxl-bitcnt -> 3
\ h# 00ff rxl-bitcnt -> 8
\ h# 00f1 rxl-bitcnt -> 8
: rxl-bitcnt  ( n -- n )
    ffff 0 do
        dup 0= if
            drop i leave
        then
        2/
    loop
;

: rxl-configure-8bpp
    [ifdef] rxl-debug-trace  cr ." P: rxl-configure-8bpp" cr  [then]
    rxl-clock-freq 100 * swap / dup 20 / swap rxl-64/ rxl-bitcnt over
    rxl-64/ rxl-bitcnt
    dup 3 > if
        3 -
    else
        drop 0
    then
    swap dup 5 > if
        5 -
    else
        drop 0
    then

    max 6 min 2dup b swap - 1 swap lshift * rxl-64/ over 14 lshift or a 10 lshift or rxl-reg-dsp-config rxl-rl!
    swap rxl-64/ over 5 + 1 swap lshift over / 20 min 1 - 2 - over * rot 1 6 rot - lshift tuck * swap rot a tuck 2* + 1 + swap 3 * max 5 + * wljoin rxl-reg-dsp-on-off rxl-rl!
;

: rxl-configure-24bpp
    2* 2* rxl-configure-8bpp
;

    ( 9d6  4f0063 1df020c )
    ( 2518        5177443  31392268         )
    ( 25.18MHz    5177443  31.392268Khz     )
    ( 25 18o ooo    517.7443  31392.268     )
    ( pixel-clock       xx    vertical-refresh )
    ( pixel-clock/10000  htotal   vertical-refresh*1000 )
    ( pixel-clock/10000  htotal*10000   vtotal*1000 )
: rxl-r800x600x75     d#  800 d#  600 rxl-sync-dual d#  6488195 0a0167 d# 39256688 030258 d#  4950 ;
: rxl-r1024x768x60    d# 1024 d#  768 rxl-sync-dual d#  8323239 310284 d# 50266917 260302 d#  6480 ;
: rxl-r1152x900x66    d# 1152 d#  900 rxl-sync-comp d#  9371838 100296 d# 58917800 240385 d#  9450 ;
: rxl-r1152x900x76    d# 1152 d#  900 rxl-sync-comp d#  9371835 100295 d# 58917806 280385 d# 10800 ;
: rxl-r1280x800x76    d# 1280 d#  800 rxl-sync-comp d# 10420419 0e02a3 d# 52364109 270322 d# 10125 ;
: rxl-r1280x1024x60   d# 1280 d# 1024 rxl-sync-dual d# 10420434 0e02a7 d# 67044393 230400 d# 10800 ;
: rxl-r1440x900x76x8  d# 1440 d#  900 rxl-sync-comp d# 11731178 1402ba d# 58917807 230385 d# 13500 ;
: rxl-r1600x1000x66   d# 1600 d# 1000 rxl-sync-comp d# 13041909 1101ce d# 65471502 2503e9 d# 13500 ;
: rxl-r640x480x60     d#  640 d#  480 rxl-sync-dual d#  5177443 2c0153 d# 31392268 2201e9 d#  2518 ;
: rxl-r1024x768x70    d# 1024 d#  768 rxl-sync-dual d#  8323237 310184 d# 50266917 260302 d#  7521 ;
: rxl-r1024x768x75    d# 1024 d#  768 rxl-sync-dual d#  8323235 0c0183 d# 50266911 030300 d#  7875 ;
: rxl-r1024x768       d# 1024 d#  768 rxl-sync-comp d#  8323241 080285 d# 50266916 040301 d#  8438 ;
: rxl-r1024x800x84    d# 1024 d#  800 rxl-sync-comp d#  8323236 100283 d# 52364100 040321 d#  9450 ;
: rxl-r1280x1024x67   d# 1280 d# 1024 rxl-sync-comp d# 10420427 0e01a3 d# 67044394 080401 d# 11700 ;
: rxl-r1280x1024x75   d# 1280 d# 1024 rxl-sync-dual d# 10420434 1201a3 d# 67044393 030400 d# 13500 ;
: rxl-r1280x1024x76   d# 1280 d# 1024 rxl-sync-comp d# 10420431 0801a5 d# 67044393 080401 d# 13500 ;
: rxl-r1280x1024x85   d# 1280 d# 1024 rxl-sync-dual d# 10420439 1401a7 d# 67044399 030400 d# 15750 ;
: rxl-r1600x1000x76   d# 1600 d# 1000 rxl-sync-comp d# 13041929 1b02cb d# 65471514 0303e9 d# 17010 ;
: rxl-r1600x1200x60   d# 1600 d# 1200 rxl-sync-dual d# 13041933 1801d1 d# 78578913 0304b0 d# 16200 ;
: rxl-r1600x1200x70   d# 1600 d# 1200 rxl-sync-dual d# 13041933 1801d1 d# 78578913 0304b0 d# 18900 ;

external

: r640x480x60x8     rxl-r640x480x60     rxl-8bpp          ;
: r640x480x60x24    rxl-r640x480x60     rxl-20bpp         ;
: r800x600x75x8     rxl-r800x600x75     rxl-8bpp          ;
: r800x600x75x24    rxl-r800x600x75     rxl-20bpp         ;
: r1024x768x60x8    rxl-r1024x768x60    rxl-8bpp          ;
: r1024x768x60x24   rxl-r1024x768x60    rxl-20bpp         ;
: r1024x768x70x8    rxl-r1024x768x70    rxl-8bpp          ;
: r1024x768x70x24   rxl-r1024x768x70    rxl-20bpp         ;
: r1024x768x75x8    rxl-r1024x768x75    rxl-8bpp          ;
: r1024x768x75x24   rxl-r1024x768x75    rxl-20bpp         ;
: r1024x768x77x8    rxl-r1024x768       rxl-8bpp          ;
: r1024x768x77x24   rxl-r1024x768       rxl-20bpp         ;
: r1024x800x84x8    rxl-r1024x800x84    rxl-8bpp          ;
: r1024x800x84x24   rxl-r1024x800x84    rxl-20bpp         ;
: r1152x900x66x8    rxl-r1152x900x66    rxl-8bpp          ;
: r1152x900x66x24   rxl-r1152x900x66    rxl-20bpp         ;
: r1152x900x76x8    rxl-r1152x900x76    rxl-8bpp          ;
: r1152x900x76x24   rxl-r1152x900x76    rxl-20bpp         ;
: r1280x800x76x8    rxl-r1280x800x76    rxl-8bpp          ;
: r1280x800x76x24   rxl-r1280x800x76    rxl-20bpp         ;
: r1280x1024x60x8   rxl-r1280x1024x60   rxl-8bpp          ;
: r1280x1024x60x24  rxl-r1280x1024x60   rxl-20bpp         ;
: r1280x1024x67x8   rxl-r1280x1024x67   rxl-8bpp          ;
: r1280x1024x67x24  rxl-r1280x1024x67   rxl-20bpp         ;
: r1280x1024x75x8   rxl-r1280x1024x75   rxl-8bpp          ;
: r1280x1024x75x24  rxl-r1280x1024x75   rxl-20bpp         ;
: r1280x1024x76x8   rxl-r1280x1024x76   rxl-8bpp          ;
: r1280x1024x76x24  rxl-r1280x1024x76   rxl-20bpp         ;
: r1280x1024x85x8   rxl-r1280x1024x85   rxl-8bpp          ;
: r1280x1024x85x24  rxl-r1280x1024x85   rxl-20bpp         ;
: r1440x900x76x8    rxl-r1440x900x76x8  rxl-8bpp          ;
: r1440x900x76x24   rxl-r1440x900x76x8  rxl-20bpp         ;
: r1600x1000x66x8   rxl-r1600x1000x66   rxl-8bpp          ;
: r1600x1000x76x8   rxl-r1600x1000x76   rxl-8bpp          ;
: r1600x1200x60x8   rxl-r1600x1200x60   rxl-8bpp          ;
: r1600x1200x70x8   rxl-r1600x1200x70   rxl-8bpp          ;
: r640x480x60       rxl-r640x480x60     pgx-default-depth ;
: r800x600x75       rxl-r800x600x75     pgx-default-depth ;
: r1024x768x60      rxl-r1024x768x60    pgx-default-depth ;
: r1024x768x70      rxl-r1024x768x70    pgx-default-depth ;
: r1024x768x75      rxl-r1024x768x75    pgx-default-depth ;
: r1024x768x77      rxl-r1024x768       pgx-default-depth ;
: r1024x800x84      rxl-r1024x800x84    pgx-default-depth ;
: r1152x900x66      rxl-r1152x900x66    pgx-default-depth ;
: r1152x900x76      rxl-r1152x900x76    pgx-default-depth ;
: r1280x800x76      rxl-r1280x800x76    pgx-default-depth ;
: r1280x1024x60     rxl-r1280x1024x60   pgx-default-depth ;
: r1280x1024x67     rxl-r1280x1024x67   pgx-default-depth ;
: r1280x1024x75     rxl-r1280x1024x75   pgx-default-depth ;
: r1280x1024x76     rxl-r1280x1024x76   pgx-default-depth ;
: r1280x1024x85     rxl-r1280x1024x85   pgx-default-depth ;
: r1440x900x76      rxl-r1440x900x76x8  pgx-default-depth ;
: r1600x1000x66     rxl-r1600x1000x66   pgx-default-depth ;
: r1600x1000x76     rxl-r1600x1000x76   pgx-default-depth ;
: r1600x1200x60     rxl-r1600x1200x60   pgx-default-depth ;
: r1600x1200x70     rxl-r1600x1200x70   pgx-default-depth ;

headerless


-1 value unused-token-0971


headers

: set_composite_sync
    [ifdef] rxl-debug-trace  cr ." P: set_composite_sync" cr  [then]
    rxl-reg-gp-io rxl-rl@
    1000100 or rxl-reg-gp-io rxl-rl! \ GPIO8=out(1)

    rxl-reg-crtc-gen-cntl rxl-rb@
    10 or rxl-reg-crtc-gen-cntl rxl-rb!
;

: set_dual_sync
    [ifdef] rxl-debug-trace  cr ." P: set_dual_sync" cr  [then]
    rxl-reg-gp-io rxl-rl@
    100 invert >rxl-val32 and 1000000 or rxl-reg-gp-io rxl-rl! \ GPIO9=out(!GPIO8)

    rxl-reg-crtc-gen-cntl rxl-rb@
    ef and rxl-reg-crtc-gen-cntl rxl-rb!
;

: valid_bitdepth?
    case
        rxl-8bpp  of true endof
        rxl-18bpp of true endof
        rxl-20bpp of true endof
        false swap
    endcase
;

: change_bpp
    [ifdef] rxl-debug-trace  cr ." P: change_bpp" cr  [then]
    rxl-reg-crtc-gen-cntl rxl-rw@
    f8ff and swap or rxl-reg-crtc-gen-cntl rxl-rw!
;

: 8bpp
    [ifdef] rxl-debug-trace  cr ." P: 8bpp" cr  [then]
    rxl-8bpp
      dup change_bpp
      to pgx-current-depth
;

: 24bpp
    [ifdef] rxl-debug-trace  cr ." P: 24bpp" cr  [then]
    rxl-18bpp
      dup change_bpp
      to pgx-current-depth
;

: reset-gt-crtc
    [ifdef] rxl-debug-trace  cr ." P: reset-gt-crtc" cr  [then]
    1 rxl-reg-crtc-gen-cntl3 rxl-rb!
;

: reset-crtc
    [ifdef] rxl-debug-trace  cr ." P: reset-crtc" cr  [then]
    5 rxl-reg-crtc-gen-cntl3 rxl-rb!
    0 rxl-power-management rxl-lcd-b!
    1 rxl-reg-lcd-index 1 + rxl-rb!

    h# 3 \ PLL_GEN_CNTL
       dup rxl-clock@
       70 or \ MCLK=XTALIN
       swap rxl-clock!

    rxl-20ms

    rxl-lcd-gen-ctrl
      dup rxl-lcd-b@
      fc and swap rxl-lcd-b!

    rxl-def-pll-gen-cntl h# 3 rxl-clock!
    rxl-20ms
;

: enable-crtc
    [ifdef] rxl-debug-trace  cr ." P: enable-crtc" cr  [then]
    3 rxl-reg-crtc-gen-cntl3 rxl-rb!

    h# 3 \ PLL_GEN_CNTL
       dup rxl-clock@
       70 or \ MCLK=XTALIN
       swap rxl-clock!

    rxl-20ms
    rxl-CRT-or-LCD rxl-is-LCD 0= if
	\ CRT
        rxl-reg-dac-cntl
          dup rxl-rb@
          ef and swap rxl-rb!

        rxl-lcd-gen-ctrl
          dup rxl-lcd-b@
          1 or swap rxl-lcd-b!

        9 rxl-power-management rxl-lcd-l!
        0 rxl-ext-vert-stretch rxl-lcd-l!
        0 rxl-vert-stretching rxl-lcd-l!
        0 rxl-horz-stretching rxl-lcd-l!
    else
	\ LCD
        rxl-current-height rxl-vert-768 < if
            rxl-current-height 400 * rxl-vert-768 / c0000000 or 400
        else
            0 0
        then
        rxl-ext-vert-stretch rxl-lcd-l!
        rxl-vert-stretching rxl-lcd-l!

        rxl-current-width rxl-horiz-1024 < if
            rxl-current-width 1000 * rxl-horiz-1024 / c0000000 or
        else
            0
        then
        rxl-horz-stretching rxl-lcd-l!

        0 rxl-reg-lcd-index 1 + rxl-rb!
        2000009 rxl-power-management rxl-lcd-l!

        rxl-lcd-gen-ctrl
          dup rxl-lcd-b@
          fe and 2 or swap rxl-lcd-b!

        rxl-def-lcd-misc-cntl
          rxl-def-lcd-misc-bias
          dup 8 lshift or
        or rxl-lcd-misc-cntl rxl-lcd-l!
    then
    rxl-def-pll-gen-cntl h# 3 rxl-clock!
    rxl-20ms
;

: enable-crtc-out
    [ifdef] rxl-debug-trace  cr ." P: enable-crtc-out" cr  [then]
    rxl-lcd-gen-ctrl
      dup rxl-lcd-b@
      1 or swap rxl-lcd-b!
;

: disable-crtc-out
    [ifdef] rxl-debug-trace  cr ." P: disable-crtc-out" cr  [then]
    rxl-lcd-gen-ctrl
      dup rxl-lcd-b@
      fe and swap rxl-lcd-b!
;

: enable-LCD
    [ifdef] rxl-debug-trace  cr ." P: enable-LCD" cr  [then]
    rxl-lcd-gen-ctrl rxl-lcd-b@
        rxl-CRT-or-LCD rxl-LCD-nine = if
            2 or fe and  \ rxl-lcd-gen-ctrl CRT=off LCD=on
            0200.0009    \ rxl-power-management
            0            \ rxl-reg-lcd-index
        else
            9 and 1 or   \ rxl-lcd-gen-ctrl CRT=on LCD=off
            0            \ rxl-power-management
            1            \ rxl-reg-lcd-index
        then
        rxl-reg-lcd-index 1 + rxl-rb!
        rxl-power-management rxl-lcd-l!
    rxl-lcd-gen-ctrl rxl-lcd-b!
;

: enable-monitor
    [ifdef] rxl-debug-trace  cr ." P: enable-monitor" cr  [then]
    rxl-reg-crtc-gen-cntl rxl-rb@
    bf and rxl-reg-crtc-gen-cntl rxl-rb!
;

: disable-monitor
    [ifdef] rxl-debug-trace  cr ." P: disable-monitor" cr  [then]
    rxl-reg-crtc-gen-cntl rxl-rb@
    40 or rxl-reg-crtc-gen-cntl rxl-rb!
;

0 value pgx_nvram_bitdepth
0 value edid_match
defer new-mode-test

( HDISP VDISP BPP )
( x * y * depth -- t/f )
: resolution_mem_check
    case                ( a b 18|20 )
        18 of 4 endof   ( a b 4 )
        20 of 4 endof   ( a b 4 )
        drop 1 0        ( a 1 [0|4] )
    endcase             ( a b [0|4] )
    *                   ( a b*[0|4] )
    *                   ( a*b*[0|4] )
    8000 +              ( a*b*[0|4]+8000 )
    rxl-fb-memory-prop  ( a*b*[0|4]+8000 rxl-fb-memory-prop    )
    d# 1024 * d# 1024 *         ( a*b*[0|4]+8000 rxl-fb-memory-prop*1M )
    <                   ( a*b*[0|4]+8000<rxl-fb-memory-prop*1M )
;

( pixel-clock/10000  xx              vertical-refresh*1000 )
( pixel-clock/10000  htotal*10000   vtotal*1000 )
: calc-current-vfreq
    ( bK c a  --  n )
                ( b c a )
    rot         ( c a b )
    d# 10000 *  ( c a 10000b )
    rot         ( a 10000b c )
    ffff and    ( a 10000b c&ffff )
    8 *         ( a 10000b 8[c&ffff] )
    /           ( a 10000b/8[c&ffff] )
    d# 10 *     ( a 10[10000b/8[c&ffff]] )
    swap        ( 10[10000b/8[c&ffff]] a )
    ffff and    ( 10[10000b/8[c&ffff]] a&ffff )
    /           ( 10[10000b/8[c&ffff]]/[a&ffff] )
    4 +         ( [a&ffff]/10[10000b/8[c&ffff]]+4 )
    d# 10 /	( [[a&ffff]/10[10000b/8[c&ffff]]+4]/10 )


    \   vertical-refresh*1000 &ffff         10000 * pixel-clock/10000
    \  -------------------------------  x  -------------------------- + 4
    \                  10                        8 x htotal*10000
    \ ----------------------------------------------------------------------
    \                           10
;

headerless

: rxl-detect-CPD-4410
    " edid" get-my-property 0= if
        dup 0=    if 2drop exit then
        dup 80 <> if 2drop exit then

        over 08 + c@ h# 4e <> if 2drop exit then
        over 09 + c@ h# ae <> if 2drop exit then
        over 12 + c@ h# 01 <> if 2drop exit then
        over 13 + c@ h# 02 <> if 2drop exit then
        over 4b + c@ h# fc <> if 2drop exit then

        drop 4d + " CPD 4410"n " comp 0= if
            pgx-plano-flag on
        then
    then
;

headers

\ : rxl-r640x480x60   d#  640 d#  480 rxl-sync-dual d#  5177443 2c0153 d# 31392268 2201e9 d#  2518 ; 8bpp
\                                                          |       |          |      |         |
\                                                          |       |          |      |         `--- pixel clock
\                                                          |       |          |      `--- CRTC_V_SYNC_STRT_WID
\                                                          |       |          `--- CRTC_V_TOTAL_DISP (vrefresh)
\                                                          |       `--- CRTC_H_SYNC_STRT_WID
\                                                          `--- CRTC_H_TOTAL_DISP
\ HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP
\  pix  pix   1/dual *1000        *1000        /10000
: set_res_registers
    [ifdef] rxl-debug-trace  cr ." P: set_res_registers" cr  [then]
    oem-branded? if
        rxl-detect-CPD-4410
    then

    \ Calculate VFREQ
             ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP  )
    over     ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP  PIXCLK )
    6 pick   ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP  PIXCLK HTOTAL )
    5 pick   ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP  PIXCLK HTOTAL VTOTAL )
    calc-current-vfreq to pgx-current-vfreq
             ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP )
    reset-crtc

    \ Check available memory and downgrade BPP and resolution (not really) if insufficient
    pgx_nvram_bitdepth if
        8 pick                ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP  HDISP )
        8 pick                ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP  HDISP VDISP )
        2 pick                ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP  HDISP VDISP BPP )
        resolution_mem_check 0= if
                              ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP )
            drop rxl-8bpp     ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK 8BPP )
            8 pick            ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK 8BPP  HDISP )
            8 pick            ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK 8BPP  HDISP VDISP )
            rxl-8bpp          ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK 8BPP  HDISP VDISP 8BPP )
            resolution_mem_check 0= if
                              ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP )
                2drop 2drop 2drop 2drop drop
                              ( )
                rxl-mode-r1152x900x66 $find drop execute
                              ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK BPP )
            then
        then
    then
    to pgx-current-depth      ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC PIXCLK )

    \ Configure: Clocks
    rxl-calc-pixclk-pll       ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC   PLL_REF_DIV DIV VCLK0_FB_DIV )
    2 pick 2 pick 2 pick      ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC   PLL_REF_DIV DIV VCLK0_FB_DIV   PLL_REF_DIV DIV VCLK0_FB_DIV )
    rxl-recalc-pixclk         ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC   PLL_REF_DIV DIV VCLK0_FB_DIV   calcclk )
    2 roll                    ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC   PLL_REF_DIV VCLK0_FB_DIV calcclk DIV )
    2swap                     ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC   calcclk DIV  PLL_REF_DIV VCLK0_FB_DIV )
    rot                       ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC   calcclk PLL_REF_DIV VCLK0_FB_DIV DIV )
    swap                      ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC   calcclk PLL_REF_DIV DIV VCLK0_FB_DIV )
    rxl-configure-vclk        ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC   calcclk )

    \ Configure: Depth
    pgx-current-depth case
        rxl-8bpp  of 8bpp rxl-configure-8bpp endof
        rxl-18bpp of 24bpp rxl-configure-24bpp endof
        rxl-20bpp of 24bpp rxl-configure-24bpp endof
    endcase

    \ Configure: Vertical resolution & sync
    oem-branded? if
        pgx-plano-flag l@ if
            dup 200000 and xor
        then
    then                                                                 ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL VSYNC )
    rxl-reg-crtc-v-sync-strt-wid rxl-status-bad-resolution rxl-stat-rl!  ( HDISP VDISP  SYNC  HTOTAL HSYNC VTOTAL )
    rxl-reg-crtc-v-total-disp rxl-status-bad-resolution rxl-stat-rl!     ( HDISP VDISP  SYNC  HTOTAL HSYNC )

    \ Configure: Horizontal resolution & sync
    oem-branded? if
        pgx-plano-flag l@ if
            dup 200000 and xor
        then
    then                                                                 ( HDISP VDISP  SYNC  HTOTAL HSYNC  )
    rxl-reg-crtc-h-sync-strt-wid rxl-status-bad-resolution rxl-stat-rl!  ( HDISP VDISP  SYNC  HTOTAL )
    ffffff and
    rxl-reg-crtc-h-total-disp rxl-status-bad-resolution rxl-stat-rl!     ( HDISP VDISP  SYNC  )

    \ Configure: sync signal
    oem-branded? if
        pgx-plano-flag l@ if
            drop set_dual_sync
        else
            case
                rxl-sync-comp of set_composite_sync endof
                rxl-sync-dual of set_dual_sync endof
            endcase
        then
    else
        case
            rxl-sync-comp of set_composite_sync endof
            rxl-sync-dual of set_dual_sync endof
        endcase
    then                                                              ( HDISP VDISP )

    \ Window
    0 rxl-reg-ovr-clr rxl-status-bad-overlay rxl-stat-rl!
    0 rxl-reg-ovr-wid-left-right rxl-status-bad-overlay rxl-stat-rl!
    0 rxl-reg-ovr-wid-top-bottom rxl-status-bad-overlay rxl-stat-rl!

    drop                                                              ( HDISP )

    \ Determine aligned CRTC pitch
    rxl-8/ 16 lshift                                                  ( HDISP/8<<16 )
    rxl-offset-fb rxl-8/ +                                            ( HDISP/8<<16+rxl-offset-fb/8 )
    rxl-reg-crtc-off-pitch rxl-status-bad-crtc-offset rxl-stat-rl!    ( )

    new-mode-test if
        rxl-set-mode-hook
    then
;

: valid-resolution?
    over " r" comp 0= if
        $find if
            drop true
        else
            2drop false
        then
    else
        2drop false
    then
;

\ : rxl-r640x480x60     d#  640 d#  480 rxl-sync-dual 4f0063 2c0153 1df020c 2201e9  9d6                     ;
\ : r640x480x60x8       rxl-r640x480x60                                                   rxl-8bpp          ;
\ : rxl-r640x480x60     d#  640 d#  480 rxl-sync-dual 4f0063 2c0153 1df020c 2201e9  9d6   rxl-8bpp          ;
\ 2 constant rxl-sync-dual
\ 200 constant rxl-8bpp
\ : rxl-r640x480x60     d#  640 d#  480   2   4f0063 2c0153 1df020c 2201e9  9d6   2000          ;

: set_mon_params
    [ifdef] rxl-debug-trace  cr ." P: set_mon_params: " 2dup type cr  [then]
[ifdef] rxl-bugfix
    my-self ['] $call-method catch  if
        3drop false
    else
        dup valid_bitdepth? 0= pgx_nvram_bitdepth or if
            drop pgx-default-depth
        then                         ( depth )
        set_res_registers true
    then
[else]
    $find if
        execute
        dup valid_bitdepth? 0= pgx_nvram_bitdepth or if
            drop pgx-default-depth
        then                         ( depth )
        set_res_registers true
    else
        2drop false
    then
[then]
;

headerless

: rxl-maybe-execute
    $find if
        execute true
    else
        2drop false
    then
;

: token-098a
    case
        3140 of " r640x480x60"  true to edid_match endof
        454f of " r800x600x75"  true to edid_match endof
        6140 of " r1024x768x60" true to edid_match endof
        614a of " r1024x768x70" true to edid_match endof
        614f of " r1024x768x75" true to edid_match endof
        6151 of " r1024x768x77" true to edid_match endof
        6161 of " r1024x768x77" true to edid_match endof
        6198 of " r1024x800x84" true to edid_match endof
        7186 of " r1152x900x66" true to edid_match endof
        7190 of " r1152x900x76" true to edid_match endof
        false to edid_match
    endcase
    edid_match
;

: token-098b
    case
        8180 of " r1280x1024x60" true to edid_match endof
        8187 of " r1280x1024x67" true to edid_match endof
        818f of " r1280x1024x75" true to edid_match endof
        8190 of " r1280x1024x76" true to edid_match endof
        8199 of " r1280x1024x85" true to edid_match endof
        81d0 of " r1280x800x76"  true to edid_match endof
        95d0 of " r1440x900x76"  true to edid_match endof
        a9c6 of " r1600x1000x66" true to edid_match endof
        a9d0 of " r1600x1000x76" true to edid_match endof
        false to edid_match
    endcase
    edid_match
;

: rxl-match-edid
    " edid" get-my-property 0= if
        drop dup 23 + c@
        8 lshift swap 24 + c@ or
        dup h# 0001 and if drop " r1280x1024x75" true dup to edid_match exit then
        dup h# 0002 and if drop " r1024x768x75"  true dup to edid_match exit then
        dup h# 0040 and if drop " r800x600x75"   true dup to edid_match exit then
        dup h# 0004 and if drop " r1024x768x70"  true dup to edid_match exit then
        dup h# 0008 and if drop " r1024x768x60"  true dup to edid_match exit then
            h# 2000 and if      " r640x480x60"   true dup to edid_match exit then
    then
    edid_match
;

headers

: set_sun_default_res
    0 to edid_match
    rxl-mode-r1152x900x66 set_mon_params
    drop
;

headerless

: token-098e
    pgx_nvram_bitdepth if
        drop 2dup
        rxl-maybe-execute if
            2drop 2drop 2drop drop
            pgx-default-depth
            resolution_mem_check 0= if
                2drop 0 0 to edid_match
            else
                true
            then
        else
            false
        then
    then
;

: rxl-get-edid-mode
    " edid" get-my-property 0= if
        drop 26 + 0 0 to edid_match
        begin
            2dup /w* + w@ dup 8000 and if
                token-098b dup if
                    token-098e
                then
            else
                token-098a dup if
                    token-098e
                then
            then
            0= if
                1 + dup 8 - 0=
            else
                edid_match
            then
        until
        edid_match 0= if
            rxl-match-edid drop
        then
        edid_match 0<> if
            >r >r 2drop r> r>
        else
            2drop
        then
    else
        false to edid_match
    then
    edid_match
;

: rxl-eeprom-mode
    dup " 24bpp" comp 0= if
        rxl-18bpp to pgx-default-depth
        -1 to pgx_nvram_bitdepth drop
        false
        exit
    then
    dup " 8bpp" comp 0= if
        rxl-8bpp to pgx-default-depth
        -1 to pgx_nvram_bitdepth drop
        false
        exit
    then
    " default" comp 0= if
        rxl-mode-r1152x900x66 true
        exit
    then
    false
;

: rxl-xlate-mode
    dup " svga24"  comp 0= if drop " r1024x768x60x24" true exit then
    dup " svgax24" comp 0= if drop " r1024x768x60x24" true exit then
    dup " svga"    comp 0= if drop " r1024x768x60x8"  true exit then
    dup " vga24"   comp 0= if drop " r640x480x60x24"  true exit then
    dup " vgax24"  comp 0= if drop " r640x480x60x24"  true exit then
        " vga"     comp 0= if      " r640x480x60x8"   true exit then
    false
;

headers

: read_eeprom_opt
    my-args 0= if
        drop false exit
    then

    dup rxl-eeprom-mode if
        rot drop true exit
    then

    rxl-xlate-mode if
        true exit
    then

    my-args valid-resolution?  if
        my-args true exit
    then

    pgx_nvram_bitdepth 0= if
        rxl-mode-r1152x900x66 true exit
    then
    false
;

headerless


0 value unused-edid-a1-read?

: unused-token-0994
    rxl-flags-prop 10 and if
        rxl-CRT-two to rxl-CRT-or-LCD
    else
        rxl-LCD-nine to rxl-CRT-or-LCD
    then
    rxl-CRT-or-LCD dup

    rxl-resolution-num
    rxl-get-resolution
        to rxl-current-height
        to rxl-current-width
;

: rxl-set-r640x480x60
    [ifdef] rxl-debug-trace  cr ." P: rxl-set-r640x480x60" cr  [then]
    rxl-mode-r640x480x60 $find
[ifdef] rxl-bugfix
    if
      execute
    else
      \ type ."  not found." cr exit
      2drop r640x480x60
    then
[else]
    drop execute
[then]

    7 pick to rxl-current-height
    8 pick to rxl-current-width
    set_res_registers
    enable-crtc
;

: unused-token-0996
    0 to rxl-flags-prop
    0 to token-086f
    0 to token-0870
    rxl-edid-buffer 80 ff fill
    rxl-set-r640x480x60
    rxl-delay rxl-sleep-ms
    rxl-read-edid-a1? if
        rxl-i2c-try-read-a1 to unused-edid-a1-read?
    then
    reset-crtc
    enable-crtc-out
    enable-monitor
    rxl-detect-monitor
    disable-crtc-out
;

: rxl-encode-edid-prop
    rxl-edid-buffer 80 encode-bytes " edid" property
;

: rxl-read-edid
    [ifdef] rxl-debug-trace  cr ." P: rxl-read-edid" cr  [then]
    80 alloc-mem to rxl-edid-buffer
    0 to rxl-flags-prop
    0 to token-086f
    0 to token-0870
    rxl-edid-buffer 80 ff fill

    rxl-set-r640x480x60
    reset-crtc
    enable-crtc-out
    enable-monitor
    rxl-detect-monitor
    disable-crtc-out

    rxl-flags-prop if \ Monitor detected?
        disable-monitor
        enable-crtc
        rxl-delay rxl-sleep-ms
        rxl-read-edid-a1? if
            rxl-i2c-try-read-a1 if
                rxl-encode-edid-prop
            then
        then
        reset-crtc
        enable-monitor
    then

    rxl-edid-buffer 80 free-mem
;

: rxl-pci-enable-mem
    [ifdef] rxl-debug-trace  cr ." P: rxl-pci-enable-mem" cr  [then]
    4 my-space + \ PCI Command
      dup " config-b@" rxl-call-parent
      2 or \ Enable Memory Space
      swap " config-b!" rxl-call-parent
;

: rxl-pci-disable-mem
    [ifdef] rxl-debug-trace  cr ." P: rxl-pci-disable-mem" cr  [then]
    4 my-space + \ PCI Command
       dup " config-b@" rxl-call-parent
       fd and \ Disable Memory Space
       swap " config-b!" rxl-call-parent
;

: rxl-ensure-linear-mapped
    [ifdef] rxl-debug-trace  cr ." P: rxl-ensure-linear-mapped" cr  [then]
    rxl-base 0= if
        rxl-reuse-assigned-map? if
            " assigned-addresses" get-my-property 0= if
                begin
                    dup
                while
                    \ Is this BAR0 (Linear)?
                    decode-phys ff and 10 = if
                        drop
                        to rxl-assigned-addr
                    else
                        2drop
                    then
                    decode-int drop
                    decode-int drop
                repeat
                2drop
            then
        then
	rxl-assigned-addr 0 ( -- x 0 )
		my-space 2000010 + \ BAR1 (Linear)
		1000000 \ 16M
		" map-in" rxl-call-parent to rxl-base
        rxl-linear-blk0 to rxl-reg-offset
    then
    rxl-pci-enable-mem
;

: rxl-map-linear
    [ifdef] rxl-debug-trace  cr ." P: rxl-map-linear" cr  [then]
    my-address ( -- 0 0 )
	2000010 my-space + \ BAR1 (Linear)
	1000000 \ 16M
	" map-in" rxl-call-parent to rxl-base

    rxl-linear-blk0 to rxl-reg-offset

    4 my-space + \ PCI Command
      dup " config-b@" rxl-call-parent
      2 or \ Enable Memory Space
      swap " config-b!" rxl-call-parent
;

: rxl-unmap-linear
    [ifdef] rxl-debug-trace  cr ." P: rxl-unmap-linear" cr  [then]
    rxl-base 1000000 " map-out" rxl-call-parent
    0 to rxl-reg-offset
    0 to rxl-base
    4 my-space + \ PCI Command
      dup " config-b@" rxl-call-parent
      fd and \ Disable Memory Space
      swap " config-b!" rxl-call-parent
;

\ Same as above??
: rxl-unmap-linear2
    [ifdef] rxl-debug-trace  cr ." P: rxl-unmap-linear2" cr  [then]
    rxl-base 1000000 " map-out" rxl-call-parent
    0 to rxl-reg-offset
    0 to rxl-base
    rxl-pci-disable-mem
;

: unused-rxl-pci-enable-io
    [ifdef] rxl-debug-trace  cr ." P: unused-rxl-pci-enable-io" cr  [then]
    4 my-space + \ PCI Command
      dup " config-b@" rxl-call-parent
      1 or \ Enable IO Space
      swap " config-b!" rxl-call-parent
;

: unused-rxl-pci-disable-io
    [ifdef] rxl-debug-trace  cr ." P: unused-rxl-pci-disable-io" cr  [then]
    4 my-space + \ PCI Command
      dup " config-b@" rxl-call-parent
      fe and \ Disable IO Space
      swap " config-b!" rxl-call-parent
;

: unused-rxl-map-pci-io
    [ifdef] rxl-debug-trace  cr ." P: unused-rxl-map-pci-io" cr  [then]
    my-address ( -- 0 0 )
	0100.0014 my-space +   \ BAR2 (IO)
	100 \ 256
	" map-in" rxl-call-parent to rxl-base
    0 to rxl-reg-offset
    40 my-space + \ User register
      dup " config-b@" rxl-call-parent
      fc and \ ???
      c or \ Disable port 46E8h and ??
      swap " config-b!" rxl-call-parent
    unused-rxl-pci-enable-io
;

: unused-rxl-map-alt-io
    [ifdef] rxl-debug-trace  cr ." P: unused-rxl-map-alt-io" cr  [then]
    0 0
	8100.0000 my-space or \ NO BAR ???
	10000 \ 64K
	" map-in" rxl-call-parent to unused-rxl-alt-io-base
    40 my-space +
        dup " config-b@" rxl-call-parent
        f8 and
        8 or
        swap " config-b!" rxl-call-parent
    rxl-alt-io-blk0 to rxl-reg-offset
    unused-rxl-pci-enable-io
;

: unused-rxl-unmap-pci-io
    [ifdef] rxl-debug-trace  cr ." P: unused-rxl-unmap-pci-io" cr  [then]
    rxl-base 100 " map-out" rxl-call-parent
    0 to rxl-base
    unused-rxl-pci-disable-io
;

: unused-rxl-unmap-alt-io
    [ifdef] rxl-debug-trace  cr ." P: unused-rxl-unmap-alt-io" cr  [then]
    0 to rxl-reg-offset
    unused-rxl-alt-io-base 10000 " map-out" rxl-call-parent
    0 to unused-rxl-alt-io-base
    unused-rxl-pci-disable-io
;

: unused-rxl-map-io
    \ BAR1 (IO)
    16 my-space +
      dup
        dup " config-w@" rxl-call-parent
        dup
          invert n->w rot
          " config-w!" rxl-call-parent
        swap dup " config-w@" rxl-call-parent
      rot
    dup rot <> if
      \ BAR1 exists, map IO registers from there
      swap " config-w!" rxl-call-parent
      unused-rxl-map-pci-io
    else
      2drop
      unused-rxl-map-alt-io
    then
;

: unused-rxl-unmap-io
    rxl-reg-offset if
        unused-rxl-unmap-alt-io
    else
        unused-rxl-unmap-pci-io
    then
;

: rxl-some-palette
    " "(00 00 00 00 00 aa 00 aa 00 00 aa aa aa 00 00 aa 00 aa aa 55 00 aa aa aa 55 55 55 55 55 ff 55 ff 55 55 ff ff ff 55 55 ff 55 ff ff ff 55 ff ff ff)"
    0 swap 3 /
;

: rxl-color-b!
    rxl-reg-dac-regs1 rxl-rb!
;

: rxl-color-b@
    rxl-reg-dac-regs1 rxl-rb@
;

: rxl-get-color
    rxl-reg-dac-regs3 rxl-rb!
;

: rxl-set-color
    rxl-reg-dac-regs0 rxl-rb!
;

0 value token-09ac

: rxl-fill-rectangle
    swap rot fill
;

: rxl-draw-rectangle
    swap move rot token-09ac + -rot
;

: rxl-read-rectangle
    -rot move rot token-09ac + -rot
;

defer rxl-draw-op

: rxl-run-draw-op
    >r dup to token-09ac swap >r swap dup rxl-current-width < if
        swap over + rxl-current-width min over - r> r> swap dup rxl-current-height < if
            swap over + rxl-current-height min over - >r swap r> 2swap rxl-current-width *
            + rxl-base + rxl-offset-fb + swap 0
            ?do
                2 pick 2 pick 2 pick rxl-draw-op rxl-current-width +
            loop
        else
            2drop
        then
    else
        r> r> 2drop
    then
    drop 2drop
;

external

: dimensions
    rxl-current-width rxl-current-height
;

: color@
    rxl-display-installed? if
        rxl-get-color
        rxl-color-b@
        rxl-color-b@
        rxl-color-b@
    else
        drop 0 0 0
    then
;

: color!
    rxl-display-installed? if
        rxl-set-color
        swap rot
        rxl-color-b!
        rxl-color-b!
        rxl-color-b!
    else
        2drop 2drop
    then
;

: set-colors
    rxl-display-installed? if
        swap rxl-set-color
        ff rxl-reg-dac-regs2 rxl-rb!
        rxl-colormap-token-0865 if
            0 ?do
                dup c@ 4d * swap char+
                dup c@ 97 * swap char+
                dup c@ 1c * swap char+
                >r
                    + + 8 rshift
                    dup rxl-color-b!
                    dup rxl-color-b!
                    rxl-color-b!
                r>
            loop
            drop
        else
            3 * bounds
            ?do
                i c@ rxl-color-b!
            loop
        then
    else
        drop 2drop
    then
;

: get-colors
    rxl-display-installed? if
        swap rxl-get-color
        3 * bounds
        ?do
            rxl-color-b@ i c!
        loop
    else
        drop 2drop
    then
;

: fill-rectangle
    rxl-display-installed? if
        ['] rxl-fill-rectangle to rxl-draw-op rxl-run-draw-op
    else
        drop 2drop 2drop
    then
;

: draw-rectangle
    rxl-display-installed? if
        ['] rxl-draw-rectangle to rxl-draw-op rxl-run-draw-op
    else
        drop 2drop 2drop
    then
;

: read-rectangle
    rxl-display-installed? if
        ['] rxl-read-rectangle to rxl-draw-op rxl-run-draw-op
    else
        drop 2drop 2drop
    then
;

headerless

64 constant rxl-logo-width
64 constant rxl-logo-height
rxl-logo-width rxl-logo-height * buffer: rxl-logo

: rxl-str,
    -rot
    >r >r
    tuck + swap r@
    over + swap
    r> r>
    swap rot move
;

0 rxl-logo
" "(11 11 11 e1 11 e1 11 11 e1 11 e1 e1 e1 06 e1 06)" rxl-str,
" "(e1 06 06 06 06 06 06 b9 06 b9 06 b9 06 b9 b9 b9)" rxl-str,
" "(b9 b9 b9 b9 b9 16 b9 16 16 16 16 16 16 16 16 16)" rxl-str,
" "(3f 3f 16 3f 16 3f 3f 3f 3f 3f 3f 3f 3f da da da)" rxl-str,
" "(da fd fd fd fd fd 77 77 77 dd 77 77 dd dd dd dd)" rxl-str,
" "(dd dd 51 dd dd 51 51 dd 51 51 dd 51 51 dd 51 dd)" rxl-str,
" "(51 dd 51 51 11 53 6f 09 19 09 09 09 97 6d 97 81)" rxl-str,
" "(81 98 8d 8d 6e 6e 01 01 01 01 01 01 01 01 01 6e)" rxl-str,
" "(8d 8d 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 6e 8d 98 81 81 97 6d 6d 09 09 09)" rxl-str,
" "(2d 6f 44 44 2d 96 96 53 29 a7 a7 8e 4c 4c 83 83)" rxl-str,
" "(79 45 79 21 21 21 21 21 21 79 79 79 79 79 79 21)" rxl-str,
" "(21 21 21 21 49 49 49 51 11 96 6f 19 09 09 6d 6d)" rxl-str,
" "(6d 97 81 81 98 8d 6e 6e 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 6e 6e 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 6e 8d 98 81 97 97)" rxl-str,
" "(6d 09 09 09 19 6f 44 6f 2d 44 96 53 29 a7 af af)" rxl-str,
" "(8e 4c 4c 4c 4c 4c 4c 4c 4c 83 83 83 83 45 45 79)" rxl-str,
" "(45 79 79 79 21 21 21 21 49 49 49 4d e1 96 2d 09)" rxl-str,
" "(09 09 6d 97 97 81 81 98 8d 6e 6e 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 6e 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 6e 6e)" rxl-str,
" "(98 81 81 97 6d 6d 09 09 19 2d 6f 6f 2d 6f 96 96)" rxl-str,
" "(96 53 96 53 29 29 a7 a7 af 8e 4c 4c 4c 83 83 83)" rxl-str,
" "(83 45 79 45 79 45 79 79 79 21 21 21 21 49 21 4d)" rxl-str,
" "(11 44 2d 09 6d 6d 97 97 81 e5 98 8d 6e 6e 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 6e 8d 98 81 97 6d 6d 6d 09 19 2d 6f 6f)" rxl-str,
" "(2d 2d 6f 44 96 96 29 29 a7 a7 af af 8e 8e 8e 4c)" rxl-str,
" "(4c 83 83 83 45 45 45 79 79 79 79 79 79 21 21 21)" rxl-str,
" "(21 21 49 4d 11 44 19 09 6d 6d 97 81 e5 98 8d 6e)" rxl-str,
" "(6e 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 6e 8d 98 81 97 6d 6d 09 09)" rxl-str,
" "(19 2d 2d 6f 6f 44 96 96 53 53 53 29 a7 a7 a7 af)" rxl-str,
" "(8e 8e 4c 4c 4c 83 83 83 83 45 45 45 45 79 79 79)" rxl-str,
" "(79 79 21 21 49 ce ce a8 e1 2d 2d 6d 6d 97 81 81)" rxl-str,
" "(98 8d 6e 6e 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 6e 98 81 6d 6d 6d)" rxl-str,
" "(09 19 09 19 2d 2d 2d 6f 6f 44 96 96 53 96 29 29)" rxl-str,
" "(29 a7 a7 af af 8e 8e 4c 4c 4c 4c 83 83 4c 45 79)" rxl-str,
" "(45 79 21 ce ce 6c 93 43 89 47 47 4d e1 6f 19 6d)" rxl-str,
" "(97 81 81 98 8d 6e 6e 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 6e 98 81 97 97)" rxl-str,
" "(6d 6d 6d 09 09 09 19 19 19 2d 19 6f 6f 44 44 96)" rxl-str,
" "(96 53 53 29 29 29 29 a7 a7 a7 af 8e 4c 83 83 45)" rxl-str,
" "(21 21 49 ce 6c 6c 93 93 43 92 89 89 47 47 55 a8)" rxl-str,
" "(e1 19 19 97 97 81 98 8d 6e 6e 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 6e 6e 8d)" rxl-str,
" "(98 e5 81 97 97 6d 6d 09 09 09 19 19 19 2d 2d 2d)" rxl-str,
" "(2d 2d 6f 6f 6f 6f 96 96 96 29 a7 a7 8e 83 83 45)" rxl-str,
" "(79 21 21 ce 49 ce 0b 0b 0b 6c 93 43 43 92 89 47)" rxl-str,
" "(47 47 47 7f e1 2d 09 97 81 98 8d 6e 6e 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 6e 8d 98 98 81 97 97 6d 6d 6d 6d 6d 09 09)" rxl-str,
" "(09 19 19 2d 19 19 2d 2d 6f 96 96 29 a7 af 8e 4c)" rxl-str,
" "(83 4c 45 79 79 21 21 21 ce ce ce ce 6c 6c 93 93)" rxl-str,
" "(43 92 89 89 47 47 55 a8 e1 2d 09 81 98 98 8d 6e)" rxl-str,
" "(01 01 01 01 01 01 01 01 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 01 01 01 6e cb cb e5 cb cb 8d cb 6e 01 01 01)" rxl-str,
" "(01 01 01 01 01 01 01 6e 6e 6e 8d 8d 8d 98 98 81)" rxl-str,
" "(81 97 97 6d 09 2d 19 19 19 2d 2d 6f 44 96 29 29)" rxl-str,
" "(a7 a7 8e 8e 4c 83 45 45 79 79 21 49 49 ce ce 0b)" rxl-str,
" "(0b 6c 93 93 43 43 92 89 47 47 47 a8 e1 2d 09 81)" rxl-str,
" "(98 8d 6e 6e 6e 01 01 6e 6e 6e 6e 6e 6e 6e 6e 01)" rxl-str,
" "(01 01 01 cb 9c b7 a5 9e bd bd 7a 7a 12 12 ae ae)" rxl-str,
" "(bd 9e b4 b7 b7 9c e5 6e 01 01 01 01 01 01 01 01)" rxl-str,
" "(01 6e 6e 8d 98 81 97 6d 6d 19 19 19 09 2d 2d 6f)" rxl-str,
" "(44 96 96 29 29 af 8e 4c 83 83 83 45 79 21 21 49)" rxl-str,
" "(49 ce ce 0b 0b 6c 6c 93 43 43 92 89 47 47 55 a8)" rxl-str,
" "(06 19 09 97 97 97 97 97 97 97 81 81 81 98 8d 8d)" rxl-str,
" "(6e 6e 01 8d 9c a5 bd dc 31 3d ba b6 b6 b6 2f ba)" rxl-str,
" "(08 2f 2f ba ba 08 08 ee 7a dc bd bd a5 e4 e5 01)" rxl-str,
" "(01 01 01 01 01 01 6e 8d 98 e5 81 97 09 19 19 19)" rxl-str,
" "(09 19 2d 2d 6f 96 96 53 a7 a7 af 8e 4c 83 45 45)" rxl-str,
" "(79 79 21 21 49 ce ce 0b 0b 6c 6c 93 93 43 92 89)" rxl-str,
" "(89 47 47 a8 e1 19 09 09 09 6d 6d 6d 97 97 81 81)" rxl-str,
" "(98 8d 8d 6e cb e4 a5 5e 5e 42 b6 65 f5 7c d8 7e)" rxl-str,
" "(f6 23 7e 7e f5 f5 23 23 1a 1a 3a 3a ec 2f 3d ee)" rxl-str,
" "(74 7a bd d0 b7 ca 01 01 01 01 6e 6e 8d 98 81 97)" rxl-str,
" "(6d 19 19 19 09 2d 19 2d 6f 96 96 53 29 a7 af 8e)" rxl-str,
" "(4c 83 45 45 45 79 21 21 49 49 ce 0b 0b 6c 6c 93)" rxl-str,
" "(93 43 92 89 47 47 47 a8 e1 19 09 09 6d 6d 6d 97)" rxl-str,
" "(97 81 e5 98 8d 6e e5 b7 3c 80 42 f5 d8 18 02 99)" rxl-str,
" "(f6 f2 f6 3b 3b 6a 6a fb f2 7c 3b f2 02 f6 7e 7e)" rxl-str,
" "(d8 1a 35 65 ba 08 ee 74 7a bd a5 9c 01 01 01 6e)" rxl-str,
" "(8d 98 81 81 09 09 19 19 09 19 19 2d 6f 44 96 53)" rxl-str,
" "(29 a7 a7 8e 4c 4c 83 45 79 79 21 21 49 ce ce ce)" rxl-str,
" "(0b 6c 93 6c 43 43 92 89 47 47 47 17 06 09 09 09)" rxl-str,
" "(6d 97 97 81 8d 6e 01 01 6e a5 5e 42 f4 f4 02 18)" rxl-str,
" "(f2 6a 6b 3b 5f a2 13 7d fb fb fb 5f 13 3b 6a 8a)" rxl-str,
" "(8a 6a 6a 3b 7e 1a f5 f5 f5 3a 5c b6 08 d3 74 3c)" rxl-str,
" "(d0 9c 6e 6e 6e 8d 98 81 6d 19 09 09 09 09 2d 19)" rxl-str,
" "(2d 44 96 53 53 a7 a7 8e 4c 83 83 45 45 79 79 21)" rxl-str,
" "(21 49 ce ce ce 0b 6c 93 93 43 92 89 89 47 47 a8)" rxl-str,
" "(06 09 09 81 8d 6e 01 01 01 01 6e b7 5e ab f4 18)" rxl-str,
" "(3b 8a 99 5f fb fb 68 7d 82 5b 7d 13 20 5b 20 7d)" rxl-str,
" "(68 fb fb 13 13 13 8a 3b f6 f2 f2 02 02 23 1a 5a)" rxl-str,
" "(1a ec ba 08 d3 dc d0 c8 6e 6e 8d 98 6d 09 19 19)" rxl-str,
" "(09 19 19 2d 2d 6f 96 96 29 29 af 8e 4c 4c 83 83)" rxl-str,
" "(45 79 79 21 49 49 ce ce 0b 0b 6c 6c 93 43 43 92)" rxl-str,
" "(89 47 47 e7 e1 09 97 6e 01 01 01 01 01 9c e9 ab)" rxl-str,
" "(75 3b 3b 8a 20 82 13 20 20 7d 20 5b 5b 5b 5b bf)" rxl-str,
" "(5b 5b 82 13 8f 5b 82 5b 68 13 3b fb 20 5f 5f 8a)" rxl-str,
" "(6a 3b f2 23 7c 5a 35 2f ba 08 d3 7a a5 cb e0 98)" rxl-str,
" "(6d 09 09 09 6d 19 19 19 2d 6f 96 96 29 29 a7 af)" rxl-str,
" "(8e 4c 83 83 79 79 79 21 21 49 ce ce 0b 0b 6c 6c)" rxl-str,
" "(93 93 43 92 89 47 47 17 06 09 97 01 01 01 01 6e)" rxl-str,
" "(11 80 75 3b 6b fb a2 7d 13 fc 8f 5b a4 8f fc 7d)" rxl-str,
" "(5b 20 a2 7d f0 5b 34 34 a4 34 5b 7d 5b 20 c5 7d)" rxl-str,
" "(13 7d 13 5f fb 8a 6a 6a 02 d8 23 5a 3a ec ba 08)" rxl-str,
" "(74 bd e4 e0 97 6d 09 09 09 09 09 2d 2d 6f 44 96)" rxl-str,
" "(53 29 a7 af 8e 4c 83 45 45 79 21 79 49 49 49 ce)" rxl-str,
" "(0b 0b 6c 6c 93 43 43 92 89 89 47 e7 06 09 81 01)" rxl-str,
" "(01 01 eb e9 ab 6b 6b a2 fb 13 7d 7d a4 5b 7d 5b)" rxl-str,
" "(5b c9 33 5b 8f 5b 8f 8f 94 2b 2b 34 7d 33 5b fc)" rxl-str,
" "(5b 5b c9 7d fb 13 fb fb 99 99 f2 7e 02 02 23 7e)" rxl-str,
" "(23 1a ec ec ba d3 dc a5 c8 c8 09 6d 6d 09 09 19)" rxl-str,
" "(2d 6f 44 96 29 29 a7 af 8e 4c 83 45 45 79 79 21)" rxl-str,
" "(21 49 ce ce 0b 0b 6c 6c 93 93 43 92 89 47 47 e7)" rxl-str,
" "(06 6d 81 01 01 b7 5e 75 18 99 99 7d 7d 7d 82 7d)" rxl-str,
" "(5b 5b 33 28 28 28 76 76 76 58 58 58 58 58 39 cd)" rxl-str,
" "(58 94 fc 5b 5b 7d 7d 5b 5b 5b 34 5b 68 13 20 13)" rxl-str,
" "(f2 3b f6 7c 23 23 5a 3a 35 ec 08 74 1e 9c 6d 6d)" rxl-str,
" "(6d 6d 19 19 2d 2d 44 96 96 29 29 af 8e 4c 83 83)" rxl-str,
" "(45 79 79 79 21 49 49 ce 0b 0b 0b 6c 93 93 43 92)" rxl-str,
" "(89 47 47 e7 06 6d 98 01 69 ab 18 a2 20 7d 7d 5b)" rxl-str,
" "(34 33 94 28 28 28 28 28 28 28 76 76 76 58 58 58)" rxl-str,
" "(58 58 c7 39 39 39 39 76 fc 8f 5b 7d fc fc 34 2b)" rxl-str,
" "(5b 7d 13 7d 13 8a 8a 8a 23 23 f5 f5 35 1a 3a ba)" rxl-str,
" "(d3 bd 24 6d 97 09 09 19 2d 2d 6f 96 53 29 a7 a7)" rxl-str,
" "(8e 4c 83 83 45 45 79 21 21 49 49 ce ce 0b 6c 6c)" rxl-str,
" "(93 93 43 92 89 47 47 aa 06 9c e5 b4 48 6b 6b fb)" rxl-str,
" "(20 7d 5b 5b 94 28 c9 28 33 28 28 28 28 28 85 76)" rxl-str,
" "(76 58 58 58 58 58 58 39 39 39 39 39 39 39 34 76)" rxl-str,
" "(fc 8f 2b fc 5b fc 5b 68 20 5f fb 5f 8a f6 6a 23)" rxl-str,
" "(3a 35 1a 3a ec 3d 3c b7 97 09 09 19 2d 2d 6f 96)" rxl-str,
" "(53 29 a7 a7 8e 4c 4c 83 45 79 79 21 21 49 49 ce)" rxl-str,
" "(ce 0b 0b 6c 6c 93 43 92 89 47 89 aa 06 c8 1e 75)" rxl-str,
" "(18 a2 fb 20 7d 7d 8f 33 33 c9 33 28 28 33 28 28)" rxl-str,
" "(28 85 76 76 76 76 58 58 58 58 58 39 39 39 39 39)" rxl-str,
" "(39 72 39 39 34 5b c9 33 34 2b 34 13 fc 7d 13 99)" rxl-str,
" "(5f 8a f6 6a 02 f5 3a 35 5c ec 08 dc b7 c8 09 09)" rxl-str,
" "(19 2d 6f 96 96 29 a7 a7 8e 8e 83 83 45 79 79 21)" rxl-str,
" "(21 21 49 ce ce 0b 6c 6c 93 93 43 92 89 89 47 aa)" rxl-str,
" "(06 1e 75 18 20 20 7d 7d 5b 33 33 33 33 33 c9 33)" rxl-str,
" "(33 28 28 28 28 28 85 76 76 76 58 58 58 58 58 39)" rxl-str,
" "(39 39 39 39 72 c7 72 39 39 28 8f 34 33 33 fc 5b)" rxl-str,
" "(fb 7d 7d c5 99 8a 3b f2 6a 02 1a 1a ec 35 5c d3)" rxl-str,
" "(dc b7 9c 19 2d 2d 6f 96 53 53 a7 af 8e 4c 4c 83)" rxl-str,
" "(45 45 79 21 21 49 49 ce ce 0b 0b 6c 93 93 43 92)" rxl-str,
" "(89 89 89 aa 06 75 6b 99 fb 99 8f 34 33 33 33 33)" rxl-str,
" "(33 28 28 28 28 28 28 33 28 28 28 76 76 76 58 58)" rxl-str,
" "(58 58 58 58 39 39 39 39 c7 72 39 cd 72 72 72 33)" rxl-str,
" "(bf 94 c9 fc 34 34 13 13 68 13 5f 3b 6a 6a 23 23)" rxl-str,
" "(5a ec 3a ec d3 dc b7 e4 19 2d 44 96 53 29 a7 a7)" rxl-str,
" "(8e 4c 4c 83 45 45 79 79 21 49 ce ce ce 0b 0b 6c)" rxl-str,
" "(93 93 43 92 92 89 89 38 e9 6b 13 a2 20 7d 33 33)" rxl-str,
" "(33 33 33 33 33 28 33 28 28 33 28 28 85 28 28 28)" rxl-str,
" "(76 76 58 58 58 58 58 c7 39 39 39 39 72 c7 c7 72)" rxl-str,
" "(cd 72 72 72 33 76 8f 33 34 68 68 c5 13 fb 68 5f)" rxl-str,
" "(02 f2 6a d8 f2 23 3a 2f ba d3 3c b7 24 2d 6f 96)" rxl-str,
" "(53 53 a7 af 8e 4c 83 83 45 45 79 79 21 49 49 ce)" rxl-str,
" "(ce 0b 0b 6c 6c 93 43 43 92 89 47 aa b9 20 20 34)" rxl-str,
" "(8f 33 33 33 33 33 33 33 33 28 28 28 33 c9 28 28)" rxl-str,
" "(28 28 28 85 76 76 58 58 58 58 58 58 39 39 39 39)" rxl-str,
" "(39 39 72 39 72 72 72 72 72 bf 2b f0 13 34 34 5b)" rxl-str,
" "(c5 7d 5f 68 6b 5f 3b 23 02 02 23 35 2f d3 3d bd)" rxl-str,
" "(b7 2d ac 96 53 29 a7 a7 8e 4c 4c 83 45 45 79 21)" rxl-str,
" "(21 49 ce ce ce 0b 6c 0b 6c 93 93 43 92 89 89 38)" rxl-str,
" "(16 20 a2 5b 33 33 33 33 33 33 33 33 33 33 28 28)" rxl-str,
" "(28 28 28 28 85 28 28 28 76 76 58 58 58 58 58 58)" rxl-str,
" "(39 39 39 39 39 72 39 cd 72 72 72 72 72 72 fc 5b)" rxl-str,
" "(c9 fc 5b 5b c5 13 68 8a 5f 99 5f 02 f6 f2 f2 23)" rxl-str,
" "(1a 08 08 d3 d0 24 6f 96 96 29 a7 af 8e 8e 83 4c)" rxl-str,
" "(45 45 79 79 21 21 49 ce ce 0b 0b 6c 6c 6c 43 43)" rxl-str,
" "(92 89 47 38 b9 13 5b 33 33 33 33 33 33 33 33 33)" rxl-str,
" "(33 33 28 33 c9 28 28 28 28 28 28 28 76 76 58 58)" rxl-str,
" "(58 58 58 58 39 39 39 39 39 39 39 72 cd 72 72 72)" rxl-str,
" "(72 62 39 33 5b 8f 2b 34 5b c5 68 13 8a 6a 13 5f)" rxl-str,
" "(23 6a f2 7e 5a 35 08 b6 31 b4 2d 96 53 29 a7 a7)" rxl-str,
" "(8e 4c 4c 83 45 45 79 21 21 49 49 ce ce ce 0b 0b)" rxl-str,
" "(6c 93 93 43 92 89 47 a9 16 8f 33 33 33 33 33 33)" rxl-str,
" "(33 33 33 33 33 33 28 28 33 33 c9 33 28 28 28 28)" rxl-str,
" "(76 76 58 58 58 58 58 58 39 39 39 39 39 39 72 cd)" rxl-str,
" "(72 72 72 72 72 62 62 62 8f 76 33 33 5b c5 c5 20)" rxl-str,
" "(c5 99 13 13 02 02 f2 02 f2 5a ba ba ba 74 b7 44)" rxl-str,
" "(53 29 a7 af 8e 4c 4c 83 45 45 79 79 21 21 49 ce)" rxl-str,
" "(ce 0b 0b 6c 6c 93 93 43 92 89 47 a9 16 fc 2b 33)" rxl-str,
" "(2b 33 33 33 33 33 33 33 33 33 28 33 28 c9 33 c9)" rxl-str,
" "(33 28 28 28 76 76 58 58 58 58 58 58 39 39 39 39)" rxl-str,
" "(39 72 39 72 39 72 72 72 72 62 62 62 c9 76 fc c5)" rxl-str,
" "(2b 34 7d c5 13 68 3b 13 6a 6a 02 f2 02 7e 3a 08)" rxl-str,
" "(2f 42 1e ac ac f9 29 af 8e 4c 83 83 45 79 79 79)" rxl-str,
" "(21 21 ce ce ce 0b 0b 0b 6c 93 43 43 92 89 89 e2)" rxl-str,
" "(16 33 33 33 33 33 33 33 33 33 33 33 33 33 28 28)" rxl-str,
" "(28 33 c9 33 28 28 28 28 76 76 58 58 58 58 58 58)" rxl-str,
" "(39 39 39 39 39 39 39 cd 72 72 72 72 72 72 62 62)" rxl-str,
" "(62 58 c9 33 c9 c5 34 5b 68 68 fb 8a 20 3b 8a 7e)" rxl-str,
" "(f2 7e 1a 2f ba 2f 31 b4 ac 29 a7 af 8e 4c 4c 83)" rxl-str,
" "(45 45 79 79 21 49 49 ce ce 0b 0b 6c 6c 93 93 43)" rxl-str,
" "(92 89 47 a9 16 33 33 33 33 33 33 33 33 33 33 33)" rxl-str,
" "(33 33 28 28 33 c9 33 28 28 28 28 28 76 76 58 58)" rxl-str,
" "(58 58 58 58 39 39 39 39 39 39 39 72 72 72 72 72)" rxl-str,
" "(72 4e 62 62 62 62 33 fc 34 28 c5 5b 5b 7d 5f 68)" rxl-str,
" "(8a 3b 5f 8a 23 f2 23 b6 1a ba b6 3c ac 53 a7 af)" rxl-str,
" "(8e 4c 83 83 83 79 79 21 21 49 49 ce ce 0b 0b 6c)" rxl-str,
" "(6c 93 93 43 92 89 47 e2 00 2b 33 33 2b 33 33 33)" rxl-str,
" "(33 33 33 33 33 33 33 28 c9 33 28 28 85 76 28 28)" rxl-str,
" "(76 76 58 58 58 58 58 58 39 39 39 39 39 39 39 cd)" rxl-str,
" "(72 72 72 72 72 62 62 62 62 62 72 39 fc 2b 33 68)" rxl-str,
" "(c5 c5 fb c5 13 3b 5f 5f 6a 02 23 ec 5a 5c ba 3d)" rxl-str,
" "(a5 f9 f9 af 8e 4c 83 83 45 79 79 21 21 49 49 ce)" rxl-str,
" "(ce 0b 0b 6c 6c 93 93 43 92 89 47 e2 16 33 33 33)" rxl-str,
" "(33 33 33 33 33 33 33 33 33 33 c9 28 28 28 28 28)" rxl-str,
" "(28 28 85 76 76 76 58 58 58 58 58 58 39 39 39 39)" rxl-str,
" "(39 39 c7 72 39 72 72 72 72 62 62 62 62 41 4e 33)" rxl-str,
" "(2b fc 5b c9 7d 68 13 5f c5 3b 5f 5f 8a 02 23 65)" rxl-str,
" "(23 1a ba 3d 5e ac f9 af 8e 4c 83 45 45 79 79 21)" rxl-str,
" "(21 49 ce ce ce ce 0b 6c 6c 93 93 43 92 89 47 e2)" rxl-str,
" "(16 33 33 33 33 33 33 33 33 33 33 33 33 33 28 28)" rxl-str,
" "(28 28 28 28 28 28 28 85 76 76 58 58 58 58 58 58)" rxl-str,
" "(39 39 39 39 39 c7 72 39 72 72 72 72 72 62 62 62)" rxl-str,
" "(62 62 62 72 fc fc fc fc fc 68 7d 8a 13 99 99 13)" rxl-str,
" "(8a 8a 1a f5 7e 5a 3a ba 3d b4 f9 4c 8e 4c 83 83)" rxl-str,
" "(45 79 79 21 21 21 ce ce ce 0b 0b 0b 6c 93 93 43)" rxl-str,
" "(92 89 89 63 3f ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff e8 3f ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff 0f 3f ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff e8)" rxl-str,
" "(3f ff ff ff ff ff 26 d9 01 01 06 0f ff ff ff 38)" rxl-str,
" "(4d ff ff ff ff 0c 06 ff ff ff ff 38 06 63 ff ff)" rxl-str,
" "(ff 0c 06 ff ff 11 38 38 da ff da ff ff ff ff 38)" rxl-str,
" "(06 06 06 17 2c ff ff ff ff ff 0c 16 01 e4 3f 26)" rxl-str,
" "(ff ff ff 0f 06 0f ff ff ff 06 63 ff ff ff ff 2c)" rxl-str,
" "(4d 06 da 38 ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff 0f 3f ff ff ff ff ff 16 06 26 ff 0f 70)" rxl-str,
" "(ff ff ff 17 06 ff ff ff ff 0f 01 ff ff ff ff 17)" rxl-str,
" "(01 69 ff ff ff 0f 01 ff ff ff d9 ff 38 b9 38 ff)" rxl-str,
" "(ff ff ff 17 11 0f 0f d9 01 0c ff ff ff 2c 24 17)" rxl-str,
" "(26 26 17 38 ff ff ff ff 69 b9 ff ff 38 24 26 ff)" rxl-str,
" "(ff ff 0c 9c 17 0f 0f 63 ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff e8 3f ff ff ff ff ff 01 0f)" rxl-str,
" "(ff ff ff ff ff ff ff 17 06 ff ff ff ff 0f 01 ff)" rxl-str,
" "(ff ff ff 17 11 69 17 ff ff 0f 01 ff ff ff 3f ff)" rxl-str,
" "(3f ff 11 ff ff ff ff 17 06 ff ff ff 06 da ff ff)" rxl-str,
" "(ff da 3f ff ff ff ff ff ff ff ff ff 38 01 e3 ff)" rxl-str,
" "(69 17 ff ff ff ff 16 17 ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff 26 9c 01 ff ff ff ff ff ff ff e8 3f ff ff ff)" rxl-str,
" "(ff ff 9c 17 ff ff ff ff ff ff ff 17 06 ff ff ff)" rxl-str,
" "(ff 0f 01 ff ff ff ff 17 06 38 24 26 ff 0f 01 ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff 17 06 ff ff ff)" rxl-str,
" "(17 06 ff ff ff 01 0f ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff 11 06 17 e4 26 ff ff ff ff 01 0c ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff 3f 06 01 ff ff ff ff ff ff ff 0f)" rxl-str,
" "(da ff ff ff ff ff 17 01 4d 26 ff ff ff ff ff 17)" rxl-str,
" "(06 ff ff ff ff 0f 01 ff ff ff ff 17 06 ff 69 17)" rxl-str,
" "(ff 0f 01 ff ff ff ff ff ff ff ff ff ff ff ff 17)" rxl-str,
" "(06 ff ff ff da 3f ff ff 0c 01 ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff 0f 01 e4 a9 ff ff ff ff 0c 01 ff)" rxl-str,
" "(26 0f 2c ff ff ff ff ff 0f 69 63 01 ff ff ff ff)" rxl-str,
" "(ff ff ff 0f da ff ff ff ff ff ff 17 24 24 17 ff)" rxl-str,
" "(ff ff ff 17 06 ff ff ff ff 0f 01 ff ff ff ff 17)" rxl-str,
" "(06 ff 0f 01 2c 0f 01 ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff 17 06 ff 26 17 24 0c ff ff 0f 01 ff ff)" rxl-str,
" "(0c 06 06 4d ff ff ff ff ff ff 06 24 26 ff ff ff)" rxl-str,
" "(ff 0f 01 06 11 06 01 17 ff ff ff ff 06 38 0f 01)" rxl-str,
" "(ff ff ff ff ff ff ff 88 da ff ff ff ff ff ff ff)" rxl-str,
" "(26 17 01 4d ff ff ff 17 06 ff ff ff ff 0f 01 ff)" rxl-str,
" "(ff ff ff 17 06 ff ff 06 3f 0f 01 ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff 17 01 01 24 16 0c ff ff ff)" rxl-str,
" "(0f 01 ff ff 26 0f da 06 ff ff ff ff ff 0f 01 24)" rxl-str,
" "(17 ff ff ff ff 0f 01 2c ff ff 17 01 26 ff ff 0f)" rxl-str,
" "(69 ff 0f 01 ff ff ff ff ff ff ff 88 fd ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff 17 e4 ff ff ff 17 06 ff ff ff)" rxl-str,
" "(ff 0f 01 ff ff ff ff 17 06 ff ff 0c 01 17 01 ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff 17 06 ff ff ff)" rxl-str,
" "(ff ff ff ff 26 01 0c ff ff ff 17 06 ff ff ff ff)" rxl-str,
" "(ff 69 17 38 01 0c ff ff ff 0c 01 ff ff ff ff 01)" rxl-str,
" "(0f ff ff 06 a9 ff 0f 01 ff ff ff ff ff ff ff 0f)" rxl-str,
" "(fd ff ff ff ff ff ff ff ff ff 0f 01 ff ff ff 63)" rxl-str,
" "(24 ff ff ff ff 17 06 ff ff ff ff 17 06 ff ff ff)" rxl-str,
" "(3f 24 01 ff ff ff ff ff ff ff ff ff ff ff ff 17)" rxl-str,
" "(06 ff ff ff ff ff ff ff ff 69 17 ff ff ff 17 06)" rxl-str,
" "(ff ff ff ff 17 9c 26 ff 69 06 ff ff ff ff 01 0c)" rxl-str,
" "(ff ff ff 01 e3 ff 0f 69 ff ff 0f 01 ff ff ff ff)" rxl-str,
" "(ff ff ff 88 77 ff ff ff ff ff 17 2c ff 2c 11 16)" rxl-str,
" "(ff ff ff 26 24 da 26 ff 63 24 63 ff ff ff ff 17)" rxl-str,
" "(06 ff ff ff 70 01 01 ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff 17 06 ff ff ff ff ff ff ff ff 17 24 0c)" rxl-str,
" "(ff ff 17 06 ff ff ff 26 e4 17 ff ff 38 01 0f ff)" rxl-str,
" "(ff ff 16 b9 ff ff 17 69 ff ff b9 69 06 06 11 01)" rxl-str,
" "(06 0c ff ff ff ff ff 88 77 ff ff ff ff 26 06 01)" rxl-str,
" "(01 01 06 26 ff ff ff ff 0c b9 01 01 06 63 ff ff)" rxl-str,
" "(ff ff ff 17 06 ff ff ff ff 17 01 ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff 17 06 ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff 4d 01 11 06 24 38 ff ff ff 17 24 26 ff ff)" rxl-str,
" "(ff 69 06 ff ff ff 0c 69 a5 11 24 0f ff ff 0c 0f)" rxl-str,
" "(0f 0f 17 01 0f 26 ff ff ff ff ff 0c 77 ff ff ff)" rxl-str,
" "(ff ff ff 26 0f 2c ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff 26 0f 0c ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff 0f 0f ff ff)" rxl-str,
" "(ff ff ff ff ff ff 0f 01 ff ff ff ff ff ff ff 88)" rxl-str,
" "(77 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff 0c 06 ff ff ff ff)" rxl-str,
" "(ff ff ff 0c 77 ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff)" rxl-str,
" "(ff ff ff ff ff ff ff 0c fd ad 9f 27 9f ad 9f ad)" rxl-str,
" "(ad 9f 0c ad 0d 04 5d 04 ad b1 27 9f 27 27 ad ad)" rxl-str,
" "(04 ad ad 57 ad 27 27 04 27 ad 57 27 ad bc ad 27)" rxl-str,
" "(ad ad 27 27 57 5d 27 04 57 ad ad bc 27 ad 5d ad)" rxl-str,
" "(78 41 cd 62 cd 72 33 c5 5b c5 68 20 5f 8a 5a 2f)" rxl-str,
" "(35 23 c5 7d 40 48 d7 60 60 d5 d5 05 05 05 22 22)" rxl-str,
" "(36 36 36 d1 c1 c0 c0 61 67 67 67 0c 84 27 27 9f)" rxl-str,
" "(32 0d 04 27 27 27 27 0d 27 0d 27 0d 0d 0d ad 27)" rxl-str,
" "(27 9f ad 0e 0d b1 04 0d 0e 27 5d 9f 27 27 5d 27)" rxl-str,
" "(04 0d 04 27 5d 27 27 57 ad 27 ad ad 27 ad 57 57)" rxl-str,
" "(04 5d 5d 57 bc 27 10 39 62 c9 c9 13 13 5f 8a 8a)" rxl-str,
" "(f2 f2 23 35 5c 23 41 ef 40 48 d7 90 60 d5 d5 05)" rxl-str,
" "(05 22 22 22 22 36 36 d1 c1 c0 61 61 67 67 b0 88)" rxl-str,
" "(84 0d 9f 0e 9f 9f 0d 0d 27 32 0d 32 f3 0e 0d 0d)" rxl-str,
" "(0d 1f 32 27 0d f3 04 9f 27 04 0e 0e 9f 04 9f 27)" rxl-str,
" "(32 0d 9f 27 9f 04 27 27 0e e6 27 27 0d 27 ad 27)" rxl-str,
" "(ad 27 ad 0d 04 0d b1 57 bc ad ad 10 41 c9 c5 68)" rxl-str,
" "(68 8a f2 02 7e 23 1a 5c ba 35 41 10 ef 48 d7 60)" rxl-str,
" "(60 d5 05 05 05 05 22 22 36 36 36 36 c1 c0 61 61)" rxl-str,
" "(61 b0 67 0c 84 32 0e 32 07 1c f3 9f f3 be 32 32)" rxl-str,
" "(9f 32 32 f3 32 32 40 27 9f 9f 40 9f 0d 9f 9f 0e)" rxl-str,
" "(0d 0d f3 0d b1 9f e6 0e 5d 0e 04 b1 04 0d 27 0d)" rxl-str,
" "(0d 27 04 0d 0d 9f 0d 27 1f 0e 0d 0d b1 5d 27 27)" rxl-str,
" "(40 72 76 c5 7d 6a f2 3b 5a 35 35 3a ba ec 41 33)" rxl-str,
" "(fe 48 d7 60 60 d5 05 05 22 22 22 36 22 36 d1 d1)" rxl-str,
" "(c1 c0 61 61 67 67 b0 73 84 4e be ef 40 f3 40 4e)" rxl-str,
" "(07 be 40 32 07 ef 07 0e 9f 1c f3 f3 9f 07 07 f3)" rxl-str,
" "(f3 9f 0e 07 f3 9f 0d 0e 9f 32 9f 1f ad 57 b1 9f)" rxl-str,
" "(27 0e 32 57 57 27 04 32 0e 0d e6 e6 ef e6 1f 04)" rxl-str,
" "(04 b1 04 9f 0d ef 76 c5 c5 5f f2 02 1a 35 ec ec)" rxl-str,
" "(08 5c 2b 7d 75 cc c3 64 8b 8b 9b 90 cf 90 60 60)" rxl-str,
" "(d5 05 d5 05 05 22 22 36 22 36 36 73 84 ef 72 ef)" rxl-str,
" "(94 c7 c2 85 c2 ef 40 40 94 40 40 40 40 94 f3 1c)" rxl-str,
" "(be be 1c c2 40 32 0e 32 9f 07 9f e6 27 b1 0d 07)" rxl-str,
" "(0e 32 0e bc bc bc 57 0d 32 9f 9f 27 0d 04 27 40)" rxl-str,
" "(0e 27 78 0d 9f e6 27 0d 32 0e 4e c5 5b 68 5f f2)" rxl-str,
" "(5a 35 ec ba ee 1a 5f fb 6b 9d 37 c3 1b 64 64 64)" rxl-str,
" "(9b 9b cf 90 90 60 60 60 d5 d5 05 05 22 05 22 73)" rxl-str,
" "(84 2b 5b bf 72 c7 5b 28 d2 40 40 94 d2 be 4a 1c)" rxl-str,
" "(d2 a4 1c 07 07 07 32 0e 85 78 0d 32 07 07 be f3)" rxl-str,
" "(f3 0d b1 57 57 57 ad 27 0e 0d f3 0e 27 b1 1f b1)" rxl-str,
" "(b1 04 ef 1c 07 32 07 78 9f 0e 0e 0e 0e 07 07 c7)" rxl-str,
" "(5b 68 20 13 f2 1a 2f 08 08 f2 02 02 ab cc 59 46)" rxl-str,
" "(a3 a3 1b 1b 64 64 64 8b 9b 9b 9b 90 cf 90 90 60)" rxl-str,
" "(60 05 d5 73 84 fb 7d 13 6b 99 a2 fc 8f 5b a2 76)" rxl-str,
" "(85 c7 c7 c7 5b bf 72 85 72 be be 1c be a4 1c 32)" rxl-str,
" "(0d 0d 04 ad 0d 32 0d 57 57 57 27 32 9f 27 b1 27)" rxl-str,
" "(0e 78 32 e6 04 1c f3 04 04 0d 32 07 f3 78 78 9f)" rxl-str,
" "(07 be 10 62 20 13 99 5f 8a 02 35 08 08 5f 02 23)" rxl-str,
" "(31 9d 30 59 59 46 46 46 a3 a3 1b 1b 1b 1b 64 64)" rxl-str,
" "(8b 8b 9b 9b 90 90 60 73 84 8a fb 3b 99 5f fc 28)" rxl-str,
" "(fc a2 58 39 c7 72 39 62 a2 28 ef 07 32 9f 32 32)" rxl-str,
" "(9f 40 94 9f 0e 04 04 1f 04 ad 27 be f3 be 0e 5d)" rxl-str,
" "(57 57 bc bc bc 57 27 9f c2 c2 32 07 32 0d 0d 07)" rxl-str,
" "(1c 07 07 07 07 1c d2 62 2b fb 8a 6a 8a 6a 1a ba)" rxl-str,
" "(2f 8a f6 7c dc ea 30 30 30 52 52 59 59 46 46 46)" rxl-str,
" "(46 a3 a3 1b 1b 64 1b 64 64 8b 8b e3 84 d8 7c 02)" rxl-str,
" "(3b fb 5b 7d 3b 5b 2b 2b 33 33 28 33 18 72 07 07)" rxl-str,
" "(07 07 07 32 32 32 c2 94 27 04 27 9f 1c 40 f3 0e)" rxl-str,
" "(ad 32 07 27 5d ad 57 bc bc bc 57 ef 72 0d 0d 0d)" rxl-str,
" "(32 1c 78 9f be be 40 40 d2 40 4e 76 68 f2 7c 6a)" rxl-str,
" "(8a f2 f2 5c 5a 6a d8 1a 3c ea c6 47 55 55 55 30)" rxl-str,
" "(30 52 30 59 52 59 59 59 46 46 a3 a3 a3 1b 1b 73)" rxl-str,
" "(00 65 65 35 5a 8a fb f6 20 68 68 5b c5 34 fc fb)" rxl-str,
" "(6b be 1c 1c 1c 07 07 07 07 07 be 94 fe 4e ef f3)" rxl-str,
" "(0e ad 57 57 57 57 57 0e be 9f b1 57 bc 57 40 be)" rxl-str,
" "(0d 0e 0d 0d 0e 0d 0e f3 9f 07 d2 d2 d2 62 39 33)" rxl-str,
" "(68 5f 02 f6 6a 02 7e 35 6a f2 1a 3d 1e 4f 93 92)" rxl-str,
" "(89 89 47 47 55 55 30 30 30 30 52 52 59 59 46 59)" rxl-str,
" "(46 46 a3 0c 84 3a 35 3a 7c 7c f5 7c 02 3b 99 8a)" rxl-str,
" "(fb 13 13 a2 82 4e 72 4e c7 fe 8f a4 bf 94 be 32)" rxl-str,
" "(85 fe 0e 27 27 5d 5d 5d 57 5d 57 57 57 27 07 f3)" rxl-str,
" "(32 4e f3 57 57 0e 0e 0e 0e 0e 0e 9f 32 78 4a 10)" rxl-str,
" "(41 41 62 20 13 8a 02 f5 02 d8 02 1a c9 f6 f5 5e)" rxl-str,
" "(1e fa b8 43 92 89 47 47 55 55 55 30 30 30 30 52)" rxl-str,
" "(52 59 59 46 46 46 46 e3 00 2f 2f 35 23 1a 23 02)" rxl-str,
" "(f6 f6 f6 d8 f6 d8 6b 3b a2 82 5b 33 c7 41 40 be)" rxl-str,
" "(07 0e e6 27 9f 94 94 78 04 5d 57 57 57 57 ad 57)" rxl-str,
" "(5d 57 b1 32 94 ef be 9f b1 5d 0e 78 78 78 32 be)" rxl-str,
" "(32 78 32 10 cd 62 cd 7d 6a f2 7e 1a 65 7e 7e 02)" rxl-str,
" "(d2 23 f5 bd ed b8 93 93 92 89 89 47 47 55 55 55)" rxl-str,
" "(55 30 30 30 52 52 52 59 59 59 46 e3 84 08 ba 3a)" rxl-str,
" "(f5 65 7e 7e 02 f2 6b 6a 99 fc c9 18 5b 41 ef 41)" rxl-str,
" "(d2 d2 40 4a 78 e6 0d 0d 0d 9f 8f a4 9f 5d 5d 5d)" rxl-str,
" "(5d 5d 57 ad 57 27 ef f1 32 b1 5d 27 07 be 40 10)" rxl-str,
" "(1c 32 32 40 07 07 78 07 58 c9 c9 2b 7c 7e 5a 35)" rxl-str,
" "(3d 5a 7e 8a 41 3b b6 1e 4f b8 93 93 43 92 89 47)" rxl-str,
" "(47 47 55 55 30 30 30 30 52 52 59 52 59 46 59 e3)" rxl-str,
" "(00 ee 08 65 b6 1a 5a 23 7e 7e 02 02 5b 58 bf f6)" rxl-str,
" "(8f 62 62 41 4e 10 d2 32 0d 0d 0e 0e 0d 0e 32 8f)" rxl-str,
" "(94 32 ad 5d 5d 5d 5d ad 07 94 85 27 5d 5d b1 5d)" rxl-str,
" "(b1 5d 5d 32 10 40 ef ef 1c 07 1c 07 d2 2b 2b c5)" rxl-str,
" "(1a 5a ba 0a 08 2f 68 8a 99 fc 74 1e 4f b8 6c 93)" rxl-str,
" "(93 43 89 47 47 55 47 55 55 30 30 30 30 52 52 59)" rxl-str,
" "(59 59 46 e3 00 0a ee ba b6 35 5a d8 5a 23 7e 8a)" rxl-str,
" "(2b 33 fb d8 34 72 72 72 62 4e 40 0e 0e 0e 0e 0e)" rxl-str,
" "(0e 0d 0d 0e 85 8f 1c b1 ad 5d 0e c2 8f ef ad ad)" rxl-str,
" "(57 5d 5d 1f 5d 1f 5d b1 78 07 ef ef 1c 40 41 ef)" rxl-str,
" "(85 82 f6 23 f5 2f 35 ec 08 08 c5 68 3b f0 bd ed)" rxl-str,
" "(fa ce 6c 93 93 43 92 89 47 47 55 47 55 55 30 30)" rxl-str,
" "(30 52 52 52 59 59 59 b5 00 12 ee 08 ec 35 35 1a)" rxl-str,
" "(5a d8 7e 34 fc 2b 3b 18 34 76 cd 39 39 41 32 78)" rxl-str,
" "(78 78 0e 78 0e 78 0e 04 e6 85 a4 4e 9f 4e a4 94)" rxl-str,
" "(32 5d 5d 5d 5d 5d 5d 5d ad 1f b1 1f 04 4a 4e c2)" rxl-str,
" "(07 1c 4a 07 4a d2 13 5f 1a ba 5c ba ee ee 5f 23)" rxl-str,
" "(41 f4 1e ed f8 0b 6c 6c 93 93 43 92 89 47 47 47)" rxl-str,
" "(47 55 55 55 30 30 30 52 59 52 59 e3 00 12 0a 08)" rxl-str,
" "(ec ec 35 35 35 1a 13 68 5b 5b 18 f4 c5 c9 c9 76)" rxl-str,
" "(58 1c 32 32 32 78 78 0e 78 0e 0e ad b1 04 85 f1)" rxl-str,
" "(82 a4 40 e6 5d 5d 5d 5d 5d 5d 5d 5d 5d 5d 1f b1)" rxl-str,
" "(1f 32 85 4e 4a 4a 4a 4a d2 d2 c5 5f 5a ee 2f 08)" rxl-str,
" "(ee 08 35 6b 10 dc b4 f8 ce ce 0b 6c 6c 93 43 92)" rxl-str,
" "(89 47 47 47 55 55 55 30 30 30 52 52 52 59 59 2c)" rxl-str,
" "(00 1d 0a ee 08 ec ec 65 35 7e 13 13 7d 68 7c d8)" rxl-str,
" "(5b c9 33 c9 10 07 32 32 78 32 32 9f 78 78 0d 04)" rxl-str,
" "(9f c2 bf bf a4 bf ef 04 ad 5d 5d 5d 5d 5d 5d 5d)" rxl-str,
" "(5d 5d 5d 5d b1 32 85 58 41 d2 10 d2 d2 41 cd f2)" rxl-str,
" "(23 12 ba ee 0a 08 ee d2 82 9e ed f8 f8 ce ce 6c)" rxl-str,
" "(6c 93 93 43 92 89 47 47 55 47 55 55 55 30 30 30)" rxl-str,
" "(52 52 59 2c 00 12 12 0a ee 08 2f ec 3a 6a 5f 20)" rxl-str,
" "(7d 13 f5 7c 7d fc fc 33 07 32 07 32 32 32 78 32)" rxl-str,
" "(32 be ef 94 82 bf 85 32 f3 a4 bf f1 32 5d ad 5d)" rxl-str,
" "(5d 5d 5d 5d 5d 5d 5d 5d 1f be 4e 62 41 41 62 41)" rxl-str,
" "(cd 41 62 f2 5a 1d 08 ee 12 0a 8a 10 31 1e 4f b8)" rxl-str,
" "(93 43 43 92 89 89 47 47 47 55 47 55 55 55 30 30)" rxl-str,
" "(30 30 30 52 52 59 52 2c d9 1d 12 ee 0a ee ee ba)" rxl-str,
" "(1a 8a 8a 5f 13 fb 7c f5 13 c5 34 10 07 07 32 07)" rxl-str,
" "(07 07 ef 33 20 a2 82 a4 c2 32 04 b1 1f 0e 94 82)" rxl-str,
" "(82 c2 0d b1 5d 5d 5d 5d 5d 5d 5d 5d 9f be 40 07)" rxl-str,
" "(41 62 62 58 cd c9 2b 02 5c 1d ee 0a 0a 12 10 f0)" rxl-str,
" "(3c e9 c6 30 55 30 30 30 30 52 30 59 59 52 59 46)" rxl-str,
" "(59 46 59 59 46 46 a3 a3 a3 a3 a3 2c 84 1d 12 0a)" rxl-str,
" "(ee ee ee ee 65 f5 d8 f6 6a f2 f5 f5 20 68 5b 1c)" rxl-str,
" "(40 ef 85 94 20 6b 6b 6b a2 82 40 9f 1f 1f b1 b1)" rxl-str,
" "(b1 b1 e6 4e 82 82 82 41 0d 5d 5d 5d 5d 5d 5d b1)" rxl-str,
" "(be ef 9f e6 41 41 cd 76 c9 c9 c5 7e 2f 2e 12 12)" rxl-str,
" "(2e 08 41 42 95 56 59 46 a3 a3 a3 a3 1b a3 1b 1b)" rxl-str,
" "(1b 64 1b 64 64 64 64 8b 8b 8b 8b 9b 9b 9b cf 2c)" rxl-str,
" "(d9 1d 12 0a ee ee 08 ba 65 b6 65 65 65 65 f5 65)" rxl-str,
" "(7c f5 6b 6b 3b 6b 6b 6b 6b 6b 20 33 ef 0e 04 ad)" rxl-str,
" "(b1 b1 1f b1 1f b1 b1 b1 07 8f 20 82 82 4e 0e 5d)" rxl-str,
" "(1f 5d 5d 0d 40 85 27 1f 4a 41 62 62 c9 2b c5 23)" rxl-str,
" "(08 25 1d 25 ae 3a 20 ab c3 9a cf 90 90 60 60 60)" rxl-str,
" "(d5 d5 05 05 05 05 05 05 22 22 22 22 22 22 22 22)" rxl-str,
" "(22 22 22 70 d9 1d 1d 12 0a ee 08 5c 02 f6 d8 7c)" rxl-str,
" "(3a f5 65 3a 65 f4 18 6b 6b a2 20 8f 72 40 07 07)" rxl-str,
" "(32 0d 1f 27 1f 1f b1 1f b1 1f 1f b1 b1 e6 ef 82)" rxl-str,
" "(a2 a2 bf f3 0d 1f 1f 40 85 40 5d 5d 07 62 62 cd)" rxl-str,
" "(cd c9 c5 23 0a 25 25 1d 12 a2 ab cc 7f 9b cf 90)" rxl-str,
" "(90 60 d5 05 05 05 22 22 36 36 36 d1 d1 61 61 61)" rxl-str,
" "(61 67 67 b0 b0 50 b0 70 d9 1d 7b 12 12 0a ee 35)" rxl-str,
" "(f6 02 3b f2 6a f6 65 f5 f6 fc ef 10 d2 4a 1c 07)" rxl-str,
" "(07 07 07 07 07 27 04 1f b1 27 1f 1f 1f b1 1f b1)" rxl-str,
" "(1f b1 1f 78 c7 bf f3 ef 4e ef 40 fe fe 32 1f 1f)" rxl-str,
" "(0d 62 cd cd c9 c9 02 ae 2e a6 1d 1d ee f4 80 c3)" rxl-str,
" "(9a 9b cf 90 60 60 05 d5 05 05 22 22 22 36 36 36)" rxl-str,
" "(c1 c1 61 61 67 61 b0 b0 50 b0 50 70 d9 7b 2e 1d)" rxl-str,
" "(12 0a 0a 35 23 7e 02 02 f2 02 65 65 f6 d2 4a 1c)" rxl-str,
" "(4a 1c 1c 1c 07 1c 07 07 07 1f 04 04 04 1f b1 04)" rxl-str,
" "(1f 04 1f 1f b1 1f b1 5d 1f 0d f3 4e 4e 4e fe fe)" rxl-str,
" "(f1 85 fe 72 ef 02 d8 3a 08 1d 2e 25 a6 1d 12 1d)" rxl-str,
" "(d8 80 cc c3 9a 9b cf 90 60 60 d5 d5 05 22 22 22)" rxl-str,
" "(36 22 d1 d1 c1 c0 61 61 61 b0 67 b0 b0 50 50 70)" rxl-str,
" "(3f 2e 2e 7b 12 12 0a 5c 23 23 7e 02 3b 02 65 65)" rxl-str,
" "(f6 d2 d2 4a 1c 4a 1c 1c 1c 07 1c 07 32 e6 1f 04)" rxl-str,
" "(04 04 04 1f 1f 1f 1f 04 1f 1f b1 1f b1 5d 1f 0d)" rxl-str,
" "(f3 85 f1 94 6b 6b 6b f6 b6 0a 12 1d 7b 7b 7b 12)" rxl-str,
" "(25 12 7b d3 31 cc c3 c3 8b 9b 90 90 60 d5 05 05)" rxl-str,
" "(05 05 22 22 22 36 36 d1 c1 c0 c0 61 67 67 b0 b0)" rxl-str,
" "(b0 50 50 26 3f a6 2e 2e 1d 12 12 ec 1a 5a 23 02)" rxl-str,
" "(02 02 65 b6 23 10 4a 40 4a 1c 4a 1c 1c 4a 07 07)" rxl-str,
" "(32 04 e6 1f 04 04 04 04 1f b1 1f 1f 04 1f 1f 1f)" rxl-str,
" "(1f b1 1f 1f 78 94 bf 8f c2 20 99 7c d3 0a 12 12)" rxl-str,
" "(ee 3a 5a 7b 25 7b 1d 31 80 37 c3 64 8b 9b cf 60)" rxl-str,
" "(90 d5 d5 05 22 22 22 36 22 36 d1 c1 61 61 61 61)" rxl-str,
" "(67 67 b0 b0 50 50 50 86 d9 e0 2e 25 7b 12 12 08)" rxl-str,
" "(1a 5a 23 23 7e 02 65 b6 f6 72 40 d2 4a 4a 4a 4a)" rxl-str,
" "(4a 1c 1c 1c 32 04 04 04 04 04 04 1f 04 04 1f 1f)" rxl-str,
" "(1f 1f 1f 1f 1f 1f 1f 27 fe 82 82 9f 1f 04 0d 78)" rxl-str,
" "(78 c5 68 68 13 23 ba 25 1d 2e d3 80 9d c3 1b 8b)" rxl-str,
" "(9b cf 90 90 60 d5 05 05 22 22 22 22 36 36 36 d1)" rxl-str,
" "(c1 c0 67 67 67 67 b0 b0 50 50 50 86 da a6 ca 2e)" rxl-str,
" "(2e 7b 12 0a 35 1a 1a 23 23 02 f5 2f 18 94 10 d2)" rxl-str,
" "(d2 be 4a 4a 1c 4a 4a 1c 78 04 27 04 04 04 04 04)" rxl-str,
" "(04 1f 04 1f 04 1f 1f 1f 04 1f 27 85 82 20 ef 1f)" rxl-str,
" "(04 04 04 04 e6 c9 c5 68 7e 35 1d 25 2e 12 5e 95)" rxl-str,
" "(37 a3 1b 64 8b cf 90 60 60 d5 05 05 22 22 36 22)" rxl-str,
" "(36 36 d1 c1 c0 61 61 61 67 67 b0 50 50 50 50 26)" rxl-str,
" "(d9 25 a6 bb 2e 7b 1d 12 5c 1a 1a 5a 23 7e 7c b6)" rxl-str,
" "(7c 99 10 10 d2 d2 d2 4a 4a 4a 1c 4a 78 e6 04 04)" rxl-str,
" "(04 04 04 04 e6 04 04 04 1f 04 04 1f 1f e6 ef f0)" rxl-str,
" "(a2 82 0d 04 04 04 e6 e6 e6 c5 13 02 5a 08 c8 2e)" rxl-str,
" "(1d dc 95 56 37 1b 64 8b cf cf 90 90 d5 d5 05 05)" rxl-str,
" "(22 22 22 22 36 d1 d1 c1 c0 61 61 67 b0 b0 b0 b0)" rxl-str,
" "(50 50 50 26 d9 c8 c8 ca ca 2e 7b 1d 08 5c 1a 1a)" rxl-str,
" "(5a 23 23 65 d8 18 72 10 d2 10 d2 d2 4a 4a 4a 4a)" rxl-str,
" "(78 e6 04 27 04 e6 04 04 04 04 04 04 04 1f 04 04)" rxl-str,
" "(e6 4e bf a2 82 32 04 04 04 e6 e6 e6 78 5f 6a 5a)" rxl-str,
" "(35 25 2e 2e 3c 95 56 37 a3 1b 64 8b 9b cf 90 60)" rxl-str,
" "(d5 05 05 22 22 22 36 36 36 d1 c1 c1 61 61 67 67)" rxl-str,
" "(67 b0 b0 50 50 50 50 d4 3f 09 c8 c8 bb bb 25 7b)" rxl-str,
" "(1d ba 5c 1a 5a d8 23 f6 82 a2 5b 41 10 d2 10 d2)" rxl-str,
" "(d2 d2 4a 4a 07 04 e6 04 27 04 04 e6 04 04 04 04)" rxl-str,
" "(e6 04 e6 27 41 82 6b 20 1c 04 04 04 e6 e6 e6 0d)" rxl-str,
" "(41 8a 1a 5a 2e a6 25 2e e9 c6 59 a3 1b 1b 64 8b)" rxl-str,
" "(cf 90 90 60 d5 05 05 05 22 22 22 36 36 36 c1 c0)" rxl-str,
" "(61 61 67 67 b0 b0 50 b0 50 50 73 d4 3f 98 8d cb)" rxl-str,
" "(cb ca ca 25 7b 0a ec 3a 35 5a 5a d8 a4 f1 f1 62)" rxl-str,
" "(10 10 10 d2 10 d2 d2 d2 07 27 e6 04 e6 e6 04 04)" rxl-str,
" "(04 04 04 04 04 04 0d 28 a2 3b 18 40 04 e6 e6 e6)" rxl-str,
" "(e6 e6 0d 0e 8a 1a 5a 7b a6 25 e4 69 4f c6 30 52)" rxl-str,
" "(a3 1b 64 8b cf 90 60 60 d5 05 05 05 22 22 36 36)" rxl-str,
" "(36 d1 c1 c0 61 67 67 67 67 b0 b0 50 50 50 50 d4)" rxl-str,
" "(3f 01 01 01 01 01 01 e0 a6 7b 0a 2f 35 35 1a 5a)" rxl-str,
" "(a2 fe fe fc 41 10 41 10 10 d2 d2 d2 d2 e6 e6 27)" rxl-str,
" "(e6 e6 e6 e6 e6 e6 04 27 04 32 8f 82 6b 6b 10 e6)" rxl-str,
" "(e6 e6 e6 0d e6 0d 0e 13 1a 1a 2e bb a6 25 24 6f)" rxl-str,
" "(53 a7 4c 83 45 21 ce 6c 93 55 55 52 46 a3 64 9b)" rxl-str,
" "(90 60 05 22 36 36 c1 c0 c0 61 67 67 b0 67 50 50)" rxl-str,
" "(50 50 50 d4 da 01 01 01 01 01 01 01 01 bb 2e 0a)" rxl-str,
" "(2f 5c 35 1a f2 a2 a4 82 62 41 41 41 10 41 d2 10)" rxl-str,
" "(d2 0e e6 27 e6 e6 e6 04 e6 e6 04 0d 40 bf 99 6b)" rxl-str,
" "(18 40 e6 e6 e6 e6 0d e6 0d 0e c9 5a ec 25 ca e0)" rxl-str,
" "(c8 e4 24 2d 2d 2d 6f 44 44 96 96 96 53 29 a7 a7)" rxl-str,
" "(8e 4c 83 79 21 ce 0b 93 47 55 30 59 37 1b 8b 90)" rxl-str,
" "(d5 22 36 36 c0 61 b0 d4 51 3e 3e 3e 3e 3e 3e 3e)" rxl-str,
" "(3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e)" rxl-str,
" "(3e 3e 3e 87 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a)" rxl-str,
" "(2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a d6 14 14 14 14)" rxl-str,
" "(14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14)" rxl-str,
" "(14 14 14 91 15 15 15 15 15 15 15 15 15 15 15 15)" rxl-str,
" "(15 15 15 15 15 15 15 15 15 15 15 71 51 3e 3e 3e)" rxl-str,
" "(3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e)" rxl-str,
" "(3e 3e 3e 3e 3e 3e 3e 87 2a 2a 2a 2a 2a 2a 2a 2a)" rxl-str,
" "(2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a d6)" rxl-str,
" "(8c 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14)" rxl-str,
" "(14 14 14 14 14 14 8c 91 15 15 15 15 15 15 15 15)" rxl-str,
" "(15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 71)" rxl-str,
" "(4d 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e)" rxl-str,
" "(3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 87 2a 2a 2a 2a)" rxl-str,
" "(2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a)" rxl-str,
" "(2a 2a 2a d6 14 14 14 14 14 14 14 14 14 14 14 14)" rxl-str,
" "(14 14 14 14 14 14 14 14 14 14 f7 91 15 15 15 15)" rxl-str,
" "(15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15)" rxl-str,
" "(15 15 15 71 51 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e)" rxl-str,
" "(3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 87)" rxl-str,
" "(2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a)" rxl-str,
" "(2a 2a 2a 2a 2a 2a 2a d6 14 14 14 14 14 14 14 14)" rxl-str,
" "(14 14 14 14 14 14 14 14 14 14 14 14 14 14 de 91)" rxl-str,
" "(15 15 15 15 15 15 15 15 15 15 15 15 15 15 15 15)" rxl-str,
" "(15 15 15 15 15 15 15 71 51 3e 3e 3e 3e 3e 3e 3e)" rxl-str,
" "(3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e 3e)" rxl-str,
" "(3e 3e 3e 87 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a)" rxl-str,
" "(2a 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a d6 14 14 14 14)" rxl-str,
" "(14 14 14 14 14 14 14 14 14 14 14 14 14 14 14 14)" rxl-str,
" "(14 14 8c 91 15 15 15 15 15 15 15 15 15 15 15 15)" rxl-str,
" "(15 15 15 15 15 15 15 15 15 15 15 71 51 b2 b2 b2)" rxl-str,
" "(b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 54 c4)" rxl-str,
" "(b2 b2 b2 c4 b2 c4 c4 87 a1 a1 a1 a1 a1 a1 a1 a1)" rxl-str,
" "(a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 a1 f7)" rxl-str,
" "(8c 8c 8c 8c 8c 8c 8c 8c 8c 8c 8c 8c 8c 8c 8c 8c)" rxl-str,
" "(8c 8c 8c 8c 8c 8c de db 15 03 03 03 03 03 03 03)" rxl-str,
" "(15 03 15 03 15 03 15 03 03 03 03 03 15 03 03 71)" rxl-str,
" "(4d 54 54 54 54 54 54 54 54 54 54 54 54 54 54 54)" rxl-str,
" "(54 54 54 54 54 54 54 54 54 54 54 df 4b 4b 4b 4b)" rxl-str,
" "(4b 4b 4b 4b 4b 4b 4b 4b 4b de 4b de 4b 4b 4b 4b)" rxl-str,
" "(4b 4b 4b de 66 66 66 66 66 66 66 66 66 66 66 66)" rxl-str,
" "(66 66 66 66 66 66 66 66 66 66 a0 db 03 03 03 03)" rxl-str,
" "(03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03)" rxl-str,
" "(03 03 03 86 51 54 54 54 54 54 54 54 54 54 54 54)" rxl-str,
" "(54 54 54 b2 54 b2 54 54 54 54 54 54 54 54 54 df)" rxl-str,
" "(4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b)" rxl-str,
" "(4b 4b 4b 4b 4b 4b 4b de 66 66 66 66 66 66 66 66)" rxl-str,
" "(66 66 66 66 66 66 66 66 66 66 66 66 66 66 a0 db)" rxl-str,
" "(03 03 03 03 03 03 03 03 03 03 03 03 03 03 03 03)" rxl-str,
" "(03 03 03 03 03 03 03 86 51 54 54 54 54 54 54 54)" rxl-str,
" "(54 54 54 54 54 54 54 54 b2 54 54 54 b2 54 54 54)" rxl-str,
" "(54 54 54 df 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b)" rxl-str,
" "(4b 4b 4b 4b 4b 4b 4b 4b 4b 4b 4b de 66 66 66 66)" rxl-str,
" "(66 66 66 66 66 66 66 66 66 66 66 66 66 66 66 66)" rxl-str,
" "(66 66 a0 db 15 03 03 03 03 03 03 03 03 03 03 03)" rxl-str,
" "(03 03 03 03 03 03 03 03 03 03 03 86 51 51 7f 4d)" rxl-str,
" "(4d 4d 7f 7f a8 a8 a8 a8 a8 e7 a8 e7 a8 e7 e7 e7)" rxl-str,
" "(e7 aa aa 38 aa 38 38 aa aa 38 38 38 a9 38 a9 a9)" rxl-str,
" "(a9 e2 63 e2 63 63 e2 b3 63 b3 b3 b3 b3 e8 e8 e8)" rxl-str,
" "(e8 e8 e8 e8 88 e8 88 88 88 73 88 73 88 73 73 73)" rxl-str,
" "(73 73 73 e3 e3 e3 e3 e3 b5 b5 70 b5 b5 70 b5 70)" rxl-str,
" "(70 86 70 70 86 86 86 86 86 86 86 86 71 86 86 86)" rxl-str,
drop
constant const-09be

768 buffer: rxl-logo-palette
0 rxl-logo-palette
" "(00 00 00)" rxl-str,
" "(ff ff ff 5b 5b cb f5 29 00 25 25 49 93 69 2a ba)" rxl-str,
" "(ba ba 32 32 6b 85 85 f3 f7 f1 ea 97 97 fb d8 bb)" rxl-str,
" "(91 31 31 31 2a 2a 53 2c 2c 59 44 44 44 3a 3a 83)" rxl-str,
" "(cb ca ca a6 a6 fe 4d 4d b3 c5 a6 10 e6 11 00 a7)" rxl-str,
" "(a7 a8 75 75 75 64 62 c8 f5 ed e2 6a 6a dd b3 88)" rxl-str,
" "(48 35 35 73 b5 b5 fe c5 b9 d1 24 24 46 52 52 b3)" rxl-str,
" "(de c5 a0 8b 62 25 62 62 d4 ed ec ed e7 e7 fd 11)" rxl-str,
" "(10 10 29 29 4c 44 44 9a eb dc c6 7e 8d 12 46 46)" rxl-str,
" "(a2 22 21 20 f2 e8 db d7 d7 ff 7a 7a ec c9 a3 6a)" rxl-str,
" "(92 8b d9 30 30 63 45 45 9d 48 48 a5 6e 6e e3 84)" rxl-str,
" "(5c 22 b1 8c 67 67 66 64 41 41 95 72 72 e5 5b 5b)" rxl-str,
" "(c5 b4 aa d8 88 84 e5 5f 0b 00 9a 9a 9a 3a 3a 7c)" rxl-str,
" "(3b 3b 8a 82 7c d2 d4 b4 84 ef e3 d2 e2 cc ab bc)" rxl-str,
" "(93 55 d0 ad 7a 8a 75 8e db c1 9b 36 36 79 aa 99)" rxl-str,
" "(2d e5 d1 b5 8a 88 87 40 40 89 cf b8 a9 6c 4b 1b)" rxl-str,
" "(90 8c 8b c4 9d 62 ec de ca 7e 06 00 cd a9 73 b0)" rxl-str,
" "(93 84 21 21 3c 42 42 97 c1 99 5d 65 65 db 4a 4a)" rxl-str,
" "(a9 74 74 e9 22 22 40 a3 98 d0 4f 4f b9 9c 70 30)" rxl-str,
" "(79 54 1d 3e 3e 90 57 56 54 af 83 43 74 74 e0 d4)" rxl-str,
" "(be 12 75 51 1c 4a 4a ad de dd de 55 55 c3 5a 5a)" rxl-str,
" "(be d6 b8 8c fa f5 f0 ff fe fe f0 e5 d5 21 18 15)" rxl-str,
" "(16 09 08 40 40 92 37 35 2d 9a 96 ec 74 6c be 42)" rxl-str,
" "(42 99 94 94 93 2d 2d 5f e0 c8 a6 a9 a5 eb c4 c4)" rxl-str,
" "(ff 69 69 d4 4d 4d ad 5e 5e d0 8d 82 7f 92 85 be)" rxl-str,
" "(fd fb f8 51 51 ad e4 cf b0 95 95 9a 45 45 94 1d)" rxl-str,
" "(11 0e 64 22 03 41 40 39 d2 b0 7f 52 52 bd aa 7e)" rxl-str,
" "(3d cf b3 13 fe fd fc e7 d5 bb 4a 4a a2 a0 74 33)" rxl-str,
" "(d3 68 0a d2 b1 80 d5 b5 88 49 49 9d aa 96 ae ee)" rxl-str,
" "(e1 cf fc f9 f6 fe fc fb 56 56 be a7 7f 4b a7 7b)" rxl-str,
" "(3a f4 f1 f3 b0 98 9d c6 c0 e8 30 30 5d d4 c7 12)" rxl-str,
" "(95 96 21 56 56 b9 b8 8d 4f 4d 4d a5 db d4 e7 ef)" rxl-str,
" "(ef ff e9 d9 c0 81 7c 7a 64 63 5e 70 6b 6a 80 77)" rxl-str,
" "(c6 e7 dd da 24 24 42 b0 ac ed e8 d6 bd 70 4d 1b)" rxl-str,
" "(24 24 44 71 08 00 54 53 4c d2 c7 d8 2b 21 1d 7b)" rxl-str,
" "(7a e5 e6 df e6 d5 b8 92 ae ae b0 7e 7e ef f8 f8)" rxl-str,
" "(fe 1f 1f 36 b9 b2 e6 38 38 76 4e 4e a9 7d 57 20)" rxl-str,
" "(7e 58 1f 43 43 90 a8 83 5e 70 03 00 47 47 a9 cb)" rxl-str,
" "(aa 83 42 42 94 f8 f6 f9 42 42 9e fc fc ff fd fc)" rxl-str,
" "(fd 9c 86 9a 3f 3f 97 da be 96 a4 78 37 ca c2 df)" rxl-str,
" "(81 5a 20 37 37 7f 90 8c ed 0e 0c 09 9a 6e 2e 9d)" rxl-str,
" "(97 11 9a 74 4d 66 66 d4 98 98 9b 98 98 97 e1 7f)" rxl-str,
" "(0a a5 9d df 92 90 8e bc a8 21 82 21 07 fe fe ff)" rxl-str,
" "(c1 c0 c0 5f 5d 58 2f 2d 26 f1 ed f1 fc fb fb 26)" rxl-str,
" "(26 4e 75 70 6f 4c 4c 46 b3 a4 c3 c1 a9 a4 fb f9)" rxl-str,
" "(f9 77 77 ea cc bb bd 8e 8e f6 3e 3e 83 4e 4b a7)" rxl-str,
" "(4c 4c a0 58 58 c9 36 36 6e 6f 6b cd 6f 6e dc 61)" rxl-str,
" "(61 cd ad a2 1b d6 be a5 e7 d9 cd d0 b6 9c 53 53)" rxl-str,
" "(b8 47 47 a4 97 96 95 47 47 97 97 96 9d)" rxl-str,
drop

constant unused-const-09c0

defer rxl-draw-character
defer rxl-toggle-cursor-hook
defer rxl-delete-lines-hook
defer rxl-draw-logo-hook
defer rxl-fb8-draw-logo-hook
defer rxl-fb32-pgx64-draw-logo-hook

: rxl-in-vertical-blank?
    rxl-reg-crtc-int-cntl rxl-rl@ h# 1 and 0<>
;

: rxl-wait-fifo-free
    begin
        rxl-reg-fifo-stat rxl-rw@
        const-0896 2 pick rshift <=
    until
    drop
;

: rxl-fifo-ready
    10 rxl-wait-fifo-free
    begin
        \ Draw/GUI engine busy?
        rxl-reg-gui-stat rxl-rl@ 1 and 0=
    until
;

headers

: wait_vertical_blank
    begin
        rxl-in-vertical-blank?
    until
;

headerless

: rxl-monitor-on-after-vblank
    wait_vertical_blank
    rxl-reg-crtc-gen-cntl rxl-rb@
    40 or rxl-reg-crtc-gen-cntl rxl-rb!
;

: rxl-monitor-off-after-vblank
    wait_vertical_blank
    rxl-reg-crtc-gen-cntl rxl-rb@
    bf and rxl-reg-crtc-gen-cntl rxl-rb!
;

headers

: pgx-blink-screen
    [ifdef] rxl-debug-trace  ." W: blink" cr  [then]
    rxl-monitor-on-after-vblank
    pgx-blink-speed ms
    rxl-monitor-off-after-vblank
;

headerless

: rxl-height-prop
    rxl-reg-crtc-v-disp rxl-rw@ 1 +
;

: rxl-width-prop
    rxl-reg-crtc-h-disp rxl-rw@ 1 + 2* 2* 2*
;

: rxl-depth-prop
    rxl-reg-crtc-gen-cntl rxl-rw@ 700 and
;

: rxl-perhaps-colormap
    rxl-reg-dac-regs2 rxl-rb@
        ff rxl-reg-dac-regs2 rxl-rb!
        100 0 do
            i dup dup i color!
        loop
    rxl-reg-dac-regs2 rxl-rb!
;

: token-09d2
    \ SCRATCH_REG0
    80 dup
        rxl-rb@
        1 or swap rxl-rb!
;

: rxl-rgb-set-palette
    ff rxl-reg-dac-regs2 rxl-rb!
       ff     ff     ff  h# 0   color!
       66     66     99  h# 1   color!
       ff  h# 0   h# 0   h# 2   color!
       ff     ff  h# 0   h# 3   color!
    h# 0      ff  h# 0      4   color!
    h# 0      ff     ff     5   color!
    h# 0   h# 0      ff     6   color!
       ff  h# 0      ff     7   color!
       ff     ff     ff     fe  color!
    h# 0   h# 0   h# 0      ff  color!
    token-09d2
;

: unused-set-bw-palette
    ff rxl-reg-dac-regs2 rxl-rb!
    ff ff ff h# 0 color!
    h# 0 h# 0 h# 0 ff color!
;

: rxl-8bpp-set-palette
    ff rxl-reg-dac-regs2 rxl-rb!
    ff ff ff h# 0 color!
    66 66 66 66 color!
    99 99 99 99 color!
    h# 0 h# 0 h# 0 ff color!
;

: rxl-fb8-logo-set-palette
    rxl-reg-dac-regs2 rxl-rb@ ff rxl-reg-dac-regs2 rxl-rb!
    ff dup dup 0 color!
    ff 1 do
        rxl-logo-palette i 3 * + dup n->l c@ over 1 + n->l c@ rot 2 + n->l c@ i color!
    loop
    0 0 0 ff color! rxl-reg-dac-regs2 rxl-rb!
    token-09d2
;

: unused-set-basic-palette
    0 0 0 0 color!
    ff ff ff ff color!
    token-09d2
;

: unused-ensure-good-palette
    rxl-depth-prop rxl-18bpp = if
        0 color@ + + 0<>
        ff color@ and and ff <> or if
            unused-set-basic-palette
        then
    then
;

: rxl-new-mode-test
    rxl-fifo-ready
    rxl-depth-prop dup
    rxl-18bpp = if
        0 color@ + + 0<> ff color@ and and ff <> or
        if
            0 0 0 0 color!
            ff dup 2dup color!
            token-09d2
        then
    then
    rxl-enable-count 0 <> if
        pgx-current-depth <> if
            true exit
        then
        rxl-width-prop rxl-current-width <> if
            true exit
        then
        rxl-height-prop rxl-current-height <> if
            true exit
        then
        false
    then
;

: rxl-bogus-new-mode-test
    false
;

: unused-token-09db
    rxl-depth-prop  pgx-current-depth  <> if true exit then
    rxl-width-prop  rxl-current-width  <> if true exit then
    rxl-height-prop rxl-current-height <> if true exit then
    false
;

' rxl-bogus-new-mode-test to new-mode-test

: rxl-check-depth
    rxl-depth-prop pgx-current-depth <>
;

: rxl-fb32-reset-screen
    rxl-new-mode-test if
        rxl-set-mode-hook
    then
    fb8-reset-screen
;

: rxl-fb32-toggle-cursor
    rxl-new-mode-test if
        rxl-set-mode-hook
    then
    rxl-depth-prop dup rxl-18bpp =
    if
        drop
        rxl-toggle-cursor-hook
        exit
    then
    rxl-8bpp =
    if
        fb8-toggle-cursor
    then
;

: rxl-fb32-draw-character
    rxl-check-depth if
        rxl-set-mode-hook
    then
    rxl-depth-prop dup
    rxl-18bpp =
    if
        drop rxl-draw-character exit
    then
    rxl-8bpp = if
        column# 0= if
            oem-branded? 0= if
                rxl-rgb-set-palette
            then
        then
        fb8-draw-character
    then
;

: rxl-delete-lines
    rxl-new-mode-test if
        rxl-set-mode-hook
    then
    rxl-depth-prop dup
    rxl-18bpp = if
        drop
        rxl-delete-lines-hook
        exit
    then
    rxl-8bpp = if
        fb8-delete-lines
    then
;

: rxl-draw-logo
    rxl-new-mode-test if
        rxl-set-mode-hook
    then
    rxl-depth-prop dup
    rxl-18bpp = if
        drop rxl-draw-logo-hook exit
    then
    rxl-8bpp = if
        rxl-8bpp-set-palette
        fb8-draw-logo
    then
;

: rxl-oem-draw-logo
    " /options" find-package if
        " oem-logo?" rot get-package-property 0<> if
            0
        then
    else
        0
    then if
        rxl-depth-prop case
            rxl-18bpp of rxl-draw-logo-hook exit endof
            rxl-8bpp of rxl-draw-logo exit endof
            2drop 2drop exit
        endcase
    then

    rxl-depth-prop case
        rxl-8bpp of
            rxl-fb8-logo-set-palette
            rxl-fb8-draw-logo-hook
        endof
        rxl-18bpp of
            rxl-fb32-pgx64-draw-logo-hook
        endof
        2drop 2drop
    endcase
;

: rxl-fb8-install-prep
    [ifdef] rxl-debug-trace  cr ." P: rxl-fb8-install-prep" cr  [then]
    ['] rxl-fb32-draw-character to draw-character
    ['] rxl-fb32-reset-screen to reset-screen
    ['] rxl-fb32-toggle-cursor to toggle-cursor
    ['] pgx-blink-screen to blink-screen
    ['] fb8-invert-screen to invert-screen
    ['] fb8-erase-screen to erase-screen
    ['] fb8-insert-characters to insert-characters
    ['] fb8-delete-characters to delete-characters
    ['] fb8-insert-lines to insert-lines
    ['] fb8-delete-lines to delete-lines

    oem-branded? if
        ['] rxl-oem-draw-logo to draw-logo
    else
        ['] rxl-draw-logo to draw-logo
    then
;

defer rxl-install-prep-hook

: rxl-set-mode
    [ifdef] rxl-debug-trace  cr ." P: rxl-set-mode" cr  [then]
    rxl-width-prop to rxl-current-width
    rxl-height-prop to rxl-current-height
    rxl-depth-prop to pgx-current-depth
    rxl-base rxl-offset-fb + to frame-buffer-adr
    default-font set-font

    rxl-current-width rxl-current-height
        over char-width /
        over char-height /
        fb8-install

    rxl-current-width #columns char-width * - 2/ to window-left

    rxl-depth-prop dup
    rxl-8bpp = if
        rxl-fb8-install-prep
    then
    rxl-18bpp = if
        rxl-install-prep-hook
    then

    rxl-fifo-ready
;

' noop to rxl-set-mode-hook

: rxl-fb-resolution
    rxl-width-prop dup to rxl-current-width
    rxl-height-prop dup to rxl-current-height
    rxl-current-width char-width /
    rxl-current-height char-height /
;

: rxl-fb-install
    [ifdef] rxl-debug-trace  cr ." P: rxl-fb-install" cr  [then]
    rxl-base rxl-offset-fb + to frame-buffer-adr
    default-font set-font
    rxl-fb-resolution fb8-install
    rxl-current-width #columns char-width * - 2/ to window-left

    0 dup to line# to column#

    rxl-depth-prop dup
    rxl-18bpp = if
        drop
        rxl-install-prep-hook
        exit
    then
    rxl-8bpp = if
        rxl-fb8-install-prep
    then
;

: rxl-get-current-depth
    pgx-current-depth >bitdepth dup 20 = if
        drop 18
    then
;

: rxl-install-mode-properties
    rxl-width-prop
    dup encode-int " width" property
    rxl-height-prop encode-int " height" property
    rxl-get-current-depth encode-int " depth" property
    pgx-current-vfreq encode-int " v-freq" property
    encode-int " linebytes" property
;

: rxl-is-install
    [ifdef] rxl-debug-trace  cr ." P: rxl-is-install" cr  [then]
    rxl-enable-count 0= if
        oem-branded? if
            pgx-plano-flag off
        then
        rxl-ensure-linear-mapped
        1 to rxl-enable-count

        rxl-base rxl-offset-fb + dup
            to frame-buffer-adr
            encode-int " address" property

        read_eeprom_opt
        ['] rxl-bogus-new-mode-test to new-mode-test
        rxl-read-edid
        rxl-perhaps-colormap
           168 get-token drop
           169 get-token drop
        = if
            rxl-rgb-set-palette
        else
            rxl-some-palette set-colors ff dup 2dup color!
        then
        0= if
            rxl-get-edid-mode if
                [ifdef] rxl-debug-trace  ." Setting EDID mode" cr  [then]
                set_mon_params
            else
                0
            then
        else
            [ifdef] rxl-debug-trace  ." Setting non-EDID mode" cr  [then]
            set_mon_params
        then
        0= if
            [ifdef] rxl-debug-trace  ." Setting fallback mode" cr  [then]
            rxl-mode-r1152x900x66 set_mon_params drop
        then
        pgx-current-depth rxl-18bpp = if
            rxl-perhaps-colormap
        then
        ['] rxl-new-mode-test to new-mode-test
        rxl-fb-install
        erase-screen
        enable-monitor
        enable-crtc
        rxl-install-mode-properties
    else
        rxl-enable-count 1 + to rxl-enable-count
        rxl-fb-install
        erase-screen
    then
;

: rxl-is-remove
    [ifdef] rxl-debug-trace  cr ." P: rxl-is-remove" cr  [then]
    rxl-enable-count 1 = if
        0 to rxl-enable-count
        reset-crtc
        rxl-unmap-linear2
        -1 to frame-buffer-adr
    else
        rxl-enable-count 1 - 0 max to rxl-enable-count
    then
;

h# 0 constant const-09ec
0 value rxl-ptr
truecolor-black value rxl-logo-color

: rxl-ffffff00-le
    ffffff00 noop-0805 n->l
;

: rxl-00ffffff-le
    ffffff n->l
;

headers

: crtl_byte
    const-09ec 18 lshift
;

: pgx24_scrn_params
    rxl-width-prop rxl-height-prop over char-width / over char-height /
;

: >depth-bytes
    dup 18 = if
        drop 20
    then
    2/ 2/ 2/
;

: pixels->bytes
    pgx-current-depth >bitdepth 8 <> if
        pgx-current-depth >bitdepth dup 18 = swap 20 = or if
            /l*
        then
    then
;

: bytes/line
    screen-width pgx-current-depth >bitdepth >depth-bytes *
;

headerless

: rxl-window-left
    char-width * window-left +
;

: rxl-window-top
    char-height * window-top +
;

: token-09f8
    rxl-window-top bytes/line * swap rxl-window-left pgx-current-depth >bitdepth
    >depth-bytes * + rxl-base rxl-offset-fb + +
;

: rxl-col-row-fb-offset
    column# line# token-09f8
;

: rxl-row-offset
    line# token-09f8
;

: rxl-col-offset
    0 swap token-09f8
;

: token-09fc
    bytes/line * swap pgx-current-depth >bitdepth >depth-bytes * +
    frame-buffer-adr +
;

: token-09fd
    char-width 0 ?do
        dup 8000 and if
            truecolor-black
        else
            truecolor-white
        then
        crtl_byte or noop-0805 2 pick i /l* + rl!
        1 lshift
    loop
    drop
;

: token-09fe
    char-width 0 ?do
        dup 8000 and if
            truecolor-white
        else
            truecolor-black
        then
        crtl_byte or noop-0805 2 pick i /l* + rl!
        1 lshift
    loop
    drop
;

[ifndef] end0 \ openbios tokenizer, not real forth
[ifndef] rxl-custom
   tokenizer[ h# a00 next-fcode ]tokenizer
[then]
[then]

: token-0a00
    dup c@
    8 lshift swap char+ dup c@
    rot or swap char+
;

headers

: fb32-draw-character
    rxl-col-row-fb-offset swap >font char-height 0 ?do
        token-0a00 -rot
        inverse? if
            token-09fe
        else
            token-09fd
        then
        bytes/line + swap
    loop
    2drop
;

' fb32-draw-character to rxl-draw-character

: fb32-background-color
    inverse-screen? if
        truecolor-black
    else
        truecolor-white
    then
    crtl_byte or
;

headerless

: unused-64bit-token-0a03
    2 pick dup lxjoin -rot dup /x 1 - and >r /x / 0 ?do
        2dup rx! xa1+
    loop
    r> rot drop
;

: token-0a04
    /l / 0 ?do
        2dup rl!
        la1+
    loop
    2drop
;

: unused-token-0a05
    dup 0<> if
        over /l and if
            -rot 2dup rl! la1+ rot /l -
        then
        unused-64bit-token-0a03
        dup 0<> if
            token-0a04
        else
            drop 2drop
        then
    else
        drop 2drop
    then
;

headers

: fb32-fill
    noop-0805 swap rot token-0a04
;

: move-chars
    2dup max #columns swap - char-width * /l* -rot swap rxl-row-offset swap
    rxl-row-offset char-height 0 ?do
        2 pick 2 pick 2 pick rot move swap bytes/line + swap bytes/line +
    loop
    drop 2drop
;

: erase-chars
    swap char-width * pixels->bytes swap
    rxl-row-offset char-height 0 ?do
        2dup fb32-background-color fb32-fill bytes/line +
    loop
    2drop
;

: fb32-insert-characters
    #columns column# - min dup column# + column# swap move-chars column#
    erase-chars
;

: fb32-delete-characters
    #columns column# - min dup column# + column# move-chars #columns over -
    erase-chars
;

: fb32-cursor
    0 ?do
        2dup 0 ?do
            dup rl@
            noop-0805
            rxl-00ffffff-le xor
            noop-0805
            over rl!
            la1+
        loop
        drop swap bytes/line + swap
    loop
    2drop
;

: fb32-toggle-cursor
    rxl-col-row-fb-offset char-width char-height fb32-cursor
;

' fb32-toggle-cursor to rxl-toggle-cursor-hook

headerless

: rxl-lines-down1
    line# + #lines min
;

: rxl-lines-down2
    line# + #lines min
;

: token-0a0f
    #columns char-width * #lines rot - char-height *
;

: token-0a10
    line# + #lines min
    rxl-window-top
    0
    rxl-window-left swap
;

: token-0a11
    0
    rxl-window-left
    line#
    rxl-window-top
;

: unused-token-0a12
    0
    rxl-window-left
    swap line# + #lines min
    rxl-window-top
;

: token-0a13-delete-lines
    dup rxl-lines-down1
    token-0a0f rot token-0a11 rot token-0a10
;

: token-0a14-insert-lines
    dup rxl-lines-down2
    token-0a0f rot token-0a10 token-0a11
;

: token-0a15
    0
    rxl-window-left
    #lines rot - 0 max
    rxl-window-top
;

: token-0a16-insert-lines
    0
    rxl-window-left
    line#
    rxl-window-top
;

: token-0a17
    #columns char-width * swap
    #lines swap - 0 max #lines swap -
    char-height *
;

: token-0a18-insert-lines
    #columns char-width * swap char-height *
;

: token-0a19-delete-lines
    dup token-0a17 rot token-0a15
;

: unused-token-0a1a
    token-09fc
    -rot 0 ?do
        2dup 0 ?do
            inverse?  if
                truecolor-white
            else
                truecolor-black
            then
            crtl_byte or over rl! la1+
        loop
        drop swap bytes/line + swap
    loop
    2drop
;

: token-0a1b-insert-lines
    token-0a18-insert-lines
    token-0a16-insert-lines
;

: token-0a1c-delete-lines
    5 pick 0<>
    if
        token-09fc -rot token-09fc 2swap >r pixels->bytes -rot r> 0 ?do
            2 pick 2 pick 2 pick rot move bytes/line + swap bytes/line +
            swap
        loop
    else
        drop 2drop
    then
    drop 2drop
;

: token-0a1d
    4 pick + token-09fc -rot
    3 pick + token-09fc swap
;

: token-0a1e
    over 0<> if
        >r pixels->bytes -rot swap rot r> 0 ?do
            2 pick 2 pick 2 pick move -rot bytes/line - -rot bytes/line -
            -rot
        loop
    else
        drop
    then
    drop 2drop
;

: token-0a1f-insert-lines
    token-0a1d 2swap token-0a1e
;

headers

: fb32-delete-lines
    dup
    token-0a13-delete-lines
    token-0a1c-delete-lines
    token-0a19-delete-lines
    token-09fc rot pixels->bytes swap rot
    inverse-screen?  if
        truecolor-black
    else
        truecolor-white
    then

    crtl_byte or swap 0 ?do
        2 pick 2 pick 2 pick fb32-fill swap bytes/line + swap
    loop
    drop 2drop
;

' fb32-delete-lines to rxl-delete-lines-hook

: fb32-insert-lines
    dup
    token-0a14-insert-lines
    token-0a1f-insert-lines
    token-0a1b-insert-lines
    token-09fc rot pixels->bytes swap rot
    inverse-screen? if
        truecolor-black
    else
        truecolor-white
    then

    crtl_byte or swap 0 ?do
        2 pick 2 pick 2 pick fb32-fill swap bytes/line + swap
    loop
    drop 2drop
;

headerless

: token-0a22-move-xor24
    -rot 2 pick /l / 0 ?do
        dup rl@
        noop-0805 rxl-00ffffff-le xor noop-0805 2 pick rl!
        la1+ -rot
        la1+ -rot /l - -rot
    loop
    rot
;

: token-0a23-move-xor24
    -rot 2 pick /x / 0 ?do
        dup rx@
        noop-0806 rxl-ffffff00-le dup lxjoin xor noop-0806 2 pick rx!
        xa1+ -rot xa1+ -rot /x - -rot
    loop
    rot
;

headers

: move-xor24
    dup 0<> if
        2 pick /x 1 - and 2 pick /x 1 - and or 0= if
            token-0a23-move-xor24
        else
            2 pick /x 1 - and 2 pick /x 1 - and and /l and if
                -rot over rl@ noop-0805 rxl-00ffffff-le xor noop-0805 2 pick
                rl! la1+ -rot la1+ -rot /l - token-0a23-move-xor24
            then
        then
        dup 0<> if
            token-0a22-move-xor24
        then
    then
    drop 2drop
;

: fb32-erase-screen
    [ifdef] rxl-debug-trace  cr ." P: fb32-erase-screen" cr  [then]
    rxl-base rxl-offset-fb + to rxl-ptr
    rxl-width-prop pixels->bytes rxl-height-prop 0 ?do
        dup rxl-ptr inverse-screen?  if
            truecolor-black
        else
            truecolor-white
        then
        crtl_byte or
        fb32-fill
        rxl-ptr bytes/line + to rxl-ptr
    loop
    drop
;

: fb32-black-screen
    [ifdef] rxl-debug-trace  cr ." P: fb32-black-screen" cr  [then]
    rxl-base rxl-offset-fb + to rxl-ptr
    rxl-width-prop pixels->bytes rxl-height-prop 0 ?do
        dup
        rxl-ptr
        truecolor-black crtl_byte or
        fb32-fill
        rxl-ptr bytes/line + to rxl-ptr
    loop
    drop
;

: fb32-white-screen
    [ifdef] rxl-debug-trace  cr ." P: fb32-white-screen" cr  [then]
    rxl-base rxl-offset-fb + to rxl-ptr
    rxl-width-prop pixels->bytes rxl-height-prop 0 ?do
        dup
        rxl-ptr
        truecolor-white crtl_byte or
        fb32-fill
        rxl-ptr bytes/line + to rxl-ptr
    loop
    drop
;

: fb32-invert-screen
    [ifdef] rxl-debug-trace  cr ." P: fb32-invert-screen" cr  [then]
    rxl-base rxl-offset-fb + to rxl-ptr
    rxl-width-prop pixels->bytes rxl-height-prop 0 ?do
        rxl-ptr rxl-ptr 2 pick move-xor24
        rxl-ptr bytes/line + to rxl-ptr
    loop
    drop
;

headerless

: rxl-oem-logo?
    " /options" find-package if
        " oem-logo?" rot get-package-property 0<> if
            0
        then
    else
        0
    then
;

: rxl-be16@
    dup c@
    8 lshift swap 1 + c@
    or
;

: token-0a2b-draw-logo
    truecolor-white rxl-logo-color rot 8000 and if
        swap
    then
    drop
    inverse? if
        rxl-00ffffff-le xor
    then
    crtl_byte or
;

: token-0a2c-draw-logo
    swap rxl-be16@ swap 10 0
    do
        over token-0a2b-draw-logo noop-0805 over rl!
        la1+
        swap 1 lshift swap
    loop
    nip
;

: token-0a2d-draw-logo
    2 pick 4 rshift 0 do
        1 pick swap token-0a2c-draw-logo swap 2 + swap
    loop
    bytes/line + 2 pick 4 * -
;

: token-0a2e
    3 pick 0 < if
        >r >r >r 0 r> r> r>
    then
;

headers

: fb8-draw-guava-logo
    drop 2drop rxl-col-offset rxl-logo rxl-logo-width rxl-logo-height 0 ?do
        2dup i * + over bounds ?do
            i c@ 3 pick bytes/line j * + i 4 pick - n->l 3 pick mod + n->l
            c!
        loop
    loop
    drop 2drop
;

' fb8-draw-guava-logo to rxl-fb8-draw-logo-hook

: fb32-draw-guava-logo
    drop 2drop rxl-col-offset rxl-logo rxl-logo-width rxl-logo-height 0 ?do
        2dup i * + over bounds ?do
            i n->l c@ dup 0= over ff = or 0= if
                rxl-logo-palette swap 3 * + dup n->l c@ 10 lshift swap 1 + dup
                n->l c@ 8 lshift swap 1 + n->l c@ or or
            else
                0= if
                    ffffff
                else
                    0
                then
            then
            noop-0805 3 pick bytes/line j * + i 4 pick - n->l 3 pick mod
            2* 2* + n->l rl!
        loop
    loop
    drop 2drop
;

' fb32-draw-guava-logo to rxl-fb32-pgx64-draw-logo-hook

: fb32-draw-logo
    token-0a2e
    rxl-oem-logo? 0= if
        truecolor-sunblue to rxl-logo-color
    else
        truecolor-black to rxl-logo-color
    then
    >r swap rot rxl-col-offset r> 0 ?do
        token-0a2d-draw-logo
    loop
    2drop drop
;

' fb32-draw-logo to rxl-draw-logo-hook

: fb32-install-prep
    [ifdef] rxl-debug-trace  cr ." P: fb32-install-prep" cr  [then]
    ['] rxl-fb32-reset-screen to reset-screen
    ['] rxl-fb32-toggle-cursor to toggle-cursor
    ['] fb32-erase-screen to erase-screen
    ['] pgx-blink-screen to blink-screen
    ['] fb32-invert-screen to invert-screen
    ['] rxl-fb32-draw-character to draw-character
    ['] fb32-insert-characters to insert-characters
    ['] fb32-delete-characters to delete-characters
    ['] fb32-insert-lines to insert-lines
    ['] rxl-delete-lines to delete-lines
    oem-branded? if
        ['] rxl-oem-draw-logo to draw-logo
    else
        ['] rxl-draw-logo to draw-logo
    then
;

' fb32-install-prep to rxl-install-prep-hook

headerless

create rxl-test-bits
00000000 l,
55555555 l,
aaaaaaaa l,
ffffffff l,

: rxl-some-reg-test
    2* 2* 4 mod rxl-test-bits + l@
    >rxl-val32
    swap
    >rxl-val32
    2dup dup rxl-rl@
    -rot rxl-rl!
    -rot dup rxl-rl@
    swap 2swap swap rot rxl-rl! =
;

: rxl-some-fb-test
    2* 2* rxl-test-bits + l@
    >rxl-val32
    swap
    >rxl-val32
    2dup
    dup rl@
    -rot rl!
    80 rxl-reg-mem-buf-cntl 2 + rxl-rb!
    -rot
    dup rl@
    swap 2swap swap rot
    >rxl-val32 rl! =
;

: rxl-unused-clk-test
    2* 2* rxl-test-bits + c@
    swap 2dup dup rxl-clock@
    -rot rxl-clock!
    -rot dup rxl-clock@
    swap 2swap swap rot rxl-clock! =
;

defer rxl-test-hook
' rxl-some-reg-test to rxl-test-hook

: rxl-run-hooked-test
    -1 swap 4 0 do
        dup i rxl-test-hook 0= if
            to rxl-test-result 0 swap leave
        then
    loop
    drop
;

: rxl-run-reg-test  ['] rxl-some-reg-test   to rxl-test-hook rxl-run-hooked-test ;
: rxl-run-fb-test   ['] rxl-some-fb-test    to rxl-test-hook rxl-run-hooked-test ;
: rxl-run-clk-test  ['] rxl-unused-clk-test to rxl-test-hook rxl-run-hooked-test ;

: rxl-do-run-test
    rxl-test-result -1 <> if
        "  failed at address:  " type rxl-test-result u.
    else
        "  passed Ok" type
    then
    cr
;

defer rxl-perhaps-cur-test

: rxl-perhaps-run-test
    -1 to rxl-test-result
    rxl-perhaps-cur-test rxl-do-run-test
;

: rxl-test-ramdac
;

: rxl-test-regs
    rxl-reg-scratch-reg0 rxl-run-reg-test 0=
    rxl-reg-scratch-reg1 rxl-run-reg-test 0= or
    if
        rxl-status-prop rxl-status-reg-test-fail or to rxl-status-prop
    then
;

: rxl-test-fb
    rxl-base rxl-offset-fb + rxl-num-screen-pixels bounds
    do
        0 i >rxl-val32 8 0 do
            dup
            rxl-run-fb-test if
                drop -1 swap leave
            then
        loop
        drop 0= if
            rxl-status-prop rxl-status-fb-test-fail or to rxl-status-prop
            rxl-test-result rxl-base - rxl-offset-fb - to rxl-test-result
            rxl-do-run-test
            key?  if
                key drop leave
            else
                " Test Frame buffer - " type
            then
        then
        2 2*
    +loop
;

: unused-token-0a42
    aaaaaaaa >rxl-val32
    rxl-base rxl-offset-fb + rxl-num-screen-pixels bounds
    do
        dup i >rxl-val32 rl!
        dup i >rxl-val32 rl@ <> if
            rxl-status-prop rxl-status-fb-test-fail or to rxl-status-prop leave
        then
        4
    +loop
    drop
;

external

: self-test
    rxl-display-installed? if
        0 to rxl-status-prop
        cr

        " Test hardware registers - " type
        ['] rxl-test-regs to rxl-perhaps-cur-test rxl-perhaps-run-test

        " Test RamDAC - " type
        ['] rxl-test-ramdac to rxl-perhaps-cur-test rxl-perhaps-run-test

        " Test Frame buffer - " type
        ['] rxl-test-fb to rxl-perhaps-cur-test rxl-perhaps-run-test
    else
        rxl-map-linear
          0 to rxl-status-prop
          cr

          " Test hardware registers - " type
          ['] rxl-test-regs to rxl-perhaps-cur-test rxl-perhaps-run-test

          " Test RamDAC - " type
          ['] rxl-test-ramdac to rxl-perhaps-cur-test rxl-perhaps-run-test

          " Test Frame buffer - " type
          ['] rxl-test-fb to rxl-perhaps-cur-test rxl-perhaps-run-test
        rxl-unmap-linear
    then
    rxl-status-prop
;

headerless

: rxl-init-dac
    [ifdef] rxl-debug-trace  cr ." P: rxl-init-dac" cr  [then]
    rxl-def-bus-cntl       rxl-reg-bus-cntl       rxl-rl!
    rxl-def-crtc-int-cntl  rxl-reg-crtc-int-cntl  rxl-rw!
    rxl-def-crtc-gen-cntl  rxl-reg-crtc-gen-cntl  rxl-rl!
    rxl-def-gen-test-cntl  rxl-reg-gen-test-cntl  rxl-rl!
    rxl-def-dac-cntl       rxl-reg-dac-cntl       rxl-rl!

    ff rxl-reg-dac-regs 2 + rxl-rb!
;

: rxl-init-misc
    [ifdef] rxl-debug-trace  cr ." P: rxl-init-misc" cr  [then]
    \ Diddle some undocumented registers?
    rxl-reg-offset 0<> if
        c0 1fc rxl-rl!

        rxl-reg-offset
            7ff800 to rxl-reg-offset \ to block 1
            0 304 rxl-rl!
        to rxl-reg-offset \ back to block 0

        0 1fc rxl-rl!

	\ Reset GUI engine
        10 d0 rxl-rb!
        0 d0 rxl-rb!
    then
;

: rxl-init-lcd
    [ifdef] rxl-debug-trace  cr ." P: rxl-init-lcd" cr  [then]
    rxl-def-config-panel     rxl-config-panel     rxl-lcd-l!
    rxl-def-lcd-gen-ctrl     rxl-lcd-gen-ctrl     rxl-lcd-l!
    rxl-def-lcd-misc-cntl    rxl-lcd-misc-cntl    rxl-lcd-l!
    rxl-def-power-management rxl-power-management rxl-lcd-l!
;

: rxl-probe
    [ifdef] rxl-debug-trace  cr ." P: rxl-probe" cr  [then]
    oem-branded? if
        pgx-plano-flag off
    then

    rxl-calibrate-delay

    rxl-map-linear
      rxl-init-dac
      rxl-init-lcd
      rxl-init-clock
      rxl-init-mem
      rxl-init-misc
      0 rxl-reg-src-cntl rxl-rl!

      read_eeprom_opt
      ['] rxl-bogus-new-mode-test to new-mode-test
      rxl-read-edid 0= if
          rxl-get-edid-mode if
              set_mon_params
          else
              0
          then
      else
          set_mon_params
      then
      0= if
          rxl-mode-r1152x900x66
          set_mon_params
          drop
      then

      ['] rxl-new-mode-test to new-mode-test
      reset-gt-crtc
      enable-crtc-out

      rxl-status-prop encode-int " ATY,Status" property
      rxl-flags-prop encode-int " ATY,Flags" property
      rxl-fb-memory-prop encode-int " fb-memory" property
      rxl-install-mode-properties
    rxl-unmap-linear

    " display" device-type
    " ISO8859-1" encode-string " character-set" property

    \ reg  00801000 00000000 00000000 00000000 00000000
    \      02801010 00000000 00000000 00000000 01000000
    \      02801018 00000000 00000000 00000000 00001000
    \      02801030 00000000 00000000 00000000 00020000

    \ PCI Config Space
    my-address my-space encode-phys
    0 encode-int encode+
    0 encode-int encode+

    \ Linear aperture
    my-address my-space
      2000010 +
      10 my-space +
      " config-b@" $call-parent \ Read BAR1
      8 and if 4000.0000 or then \ Prefetchable?
      \ XXX    ^^^^^^^^^ this is probably SPARC specific
    encode-phys encode+
    0 encode-int encode+
    1000000 encode-int encode+ \ 16M

    \ Auxiliary aperture
    my-address my-space
      2000018 + encode-phys encode+
    0 encode-int encode+
    1000 encode-int encode+ \ 4K

    \ Expansion ROM
    my-address my-space 2000030 + encode-phys encode+
    0 encode-int encode+ 20000 encode-int encode+

    " reg" property

    sccsid encode-string " pgx_version" property
    ['] rxl-is-install is-install
    ['] rxl-is-remove is-remove
    ['] self-test is-selftest
    ['] rxl-set-mode to rxl-set-mode-hook
;

rxl-probe

" SUNW,m64B" device-name

oem-branded? if
    " SUNW,370-4362" encode-string " model" property
    " ATY,RageXL" encode-string " ATY,model" property
else
    " ATY,RageXL" model
then

" 113-XXXXX-100" encode-string " ATY,Rom#" property
" 109-XXXXX-XX" encode-string " ATY,Card#" property
" 1.69" encode-string " ATY,Fcode" property
