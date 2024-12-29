hex

headerless

( pio )
h# 00 constant aty-reg-crtc-h-total
h# 02 constant aty-reg-crtc-h-disp
h# 04 constant aty-reg-crtc-h-sync-strt-wid
h# 08 constant aty-reg-crtc-v-total
h# 0a constant aty-reg-crtc-v-disp
h# 0c constant aty-reg-crtc-v-sync-strt
h# 0e constant aty-reg-crtc-v-sync-wid-pol
h# 14 constant aty-reg-crtc-off-pitch
h# 18 constant aty-reg-crtc-int-cntl
h# 1c constant aty-reg-crtc-gen-cntl0
h# 1e constant aty-reg-crtc-gen-cntl2
h# 1f constant aty-reg-crtc-gen-cntl3
h# 20 constant aty-reg-ovr-clr
h# 24 constant aty-reg-ovr-wid-left-right
h# 28 constant aty-reg-ovr-wid-top-bottom
h# 40 constant aty-reg-scratch-reg0
h# 44 constant aty-reg-scratch-reg1
h# 48 constant aty-reg-clock-sel
h# 49 constant aty-reg-pll-wr-en-addr
h# 4a constant aty-reg-pll-data
h# 4c constant aty-reg-bus-cntl
h# 50 constant aty-reg-mem-cntl
h# 5c constant aty-reg-dac-regs
h# 5c constant aty-reg-dac-w-index
h# 5d constant aty-reg-dac-data
h# 5e constant aty-reg-dac-mask
h# 5f constant aty-reg-dac-r-index
h# 60 constant aty-reg-dac-cntl
h# 63 constant aty-reg-dac-gio
h# 64 constant aty-reg-gen-test-cntl
h# 68 constant aty-reg-config-cntl
h# 70 constant aty-reg-config-stat0
h# 78 constant aty-reg-gp-io
h# 7c constant aty-reg-crtc-h-total-disp

create aty-sparse>block-tbl ( 0822 )
( pio -> mmio )
( 00 -> 00 ) h# 00 c,
( 01 -> 01 ) h# 04 c,
( 02 -> 02 ) h# 08 c,
( 03 -> 03 ) h# 0c c,
( 04 -> 04 ) h# 10 c,
( 05 -> 05 ) h# 14 c,
( 06 -> 06 ) h# 18 c,
( 07 -> 07 ) h# 1c c,
( 08 -> 10 ) h# 40 c,
( 09 -> 11 ) h# 44 c,
( 0a -> 12 ) h# 48 c,
( 0b -> 18 ) h# 60 c,
( 0c -> 19 ) h# 64 c,
( 0d -> 1a ) h# 68 c,
( 0e -> 1b ) h# 6c c,
( 0f -> 1c ) h# 70 c,
( 10 -> 20 ) h# 80 c,
( 11 -> 21 ) h# 84 c,
( 12 -> 24 ) h# 90 c,
( 13 -> 28 ) h# a0 c,
( 14 -> 2c ) h# b0 c,
( 15 -> 2d ) h# b4 c,
( 16 -> 2e ) h# b8 c,
( 17 -> 30 ) h# c0 c,
( 18 -> 31 ) h# c4 c,
( 19 -> 34 ) h# d0 c,
( 1a -> 37 ) h# dc c,
( 1b -> 38 ) h# e0 c,
( 1c -> 39 ) h# e4 c,
( 1d -> 3a ) h# e8 c,
( 1e -> 1e ) h# 78 c,
( 1f -> 1f ) h# 7c c,


h# 6000.00f9 constant aty-def-bus-cntl ( 0823 )
h#         0 constant aty-def-crtc-int-cntl ( 0824 )
h# 010a.0240 constant aty-def-crtc-gen-cntl ( 0825 )
h#         8 constant aty-def-gen-test-cntl ( 0826 )

h# 0a02.c91a constant aty-dram-mem-cntl
h# 0a02.cb22 constant aty-edo-mem-cntl

h# 0220.cd3a constant aty-sdram-mem-cntl

h# 8001.0100 constant aty-def-dac-cntl ( 082a )

h# 9 constant aty-dram-config-statw
h# a constant aty-edo-config-statw
h# 4 constant aty-sdram-config-statw

d# 3 constant aty-first-clock ( 082e )
d# 3 constant aty-second-clock ( 082f )

h# a0 constant aty-def-pll-macro-cntl
0 value aty-open-count ( 0831 )
0 value aty-delay-ms# ( 0832 )

h# 007f.fc00 constant aty-linear-blk0 ( 0833 )
h# 007f.f800 constant aty-linear-blk1 ( 0834 )
h#      02ec constant aty-pio-offset ( 0835 )

0 value aty-saved-my-self ( 0836 )
0 value aty-block-addr ( 0837 )
0 value aty-sparse-addr ( 0838 )
0 value aty-assigned-addr ( 0839 )
0 value aty-reg-offset ( 083a )
1 value aty-mem-mbytes ( 083b )
0 value aty-io-regs-offset ( 083c )

4 value aty-mem-type

0 value aty-prop-status ( 083e )
-1 value aty-fb-check-addr ( 083f )

h# 800 constant aty-stat-unused1
h# 400 constant aty-stat-config-stat-failed
h# 200 constant aty-stat-bus-cntl-failed
h# 100 constant aty-stat-crtc-failed
h#  80 constant aty-stat-gen-test-failed
h#  40 constant aty-stat-mem-cntl-failed
h#  20 constant aty-stat-unused2
h#  10 constant aty-stat-unused3
h#   8 constant aty-stat-ovr-failed
h#   4 constant aty-stat-off-pitch-failed
h#   2 constant aty-fb-test-failed
h#   1 constant aty-test-regs-failed

false value aty-use-assigned-addr? ( 084c )
0 value aty-grayscale? ( 084d )
0 value aty-prop-width ( 084e )
0 value aty-prop-height ( 084f )
5 value aty-default-mode# ( 0850 )
aty-default-mode# value aty-current-mode# ( 0851 )
0 value aty-modes-bitmask ( 0852 )
d# 20 value /aty-std-modes ( 0853 )
0 value token-0854 ( 0854 )
0 value xaty-disp-id ( 0855 )
0 value xaty-disp-id-alt ( 0856 )
0 value token-0857 ( 0857 )

0 value aty-prop-flags ( 0858 )
\ 03 0000 0011 -
\ 05 0000 0101 -
\ 0b 0000 1011 - edid cksum okay
\ 0d 0000 1101 - edid okay
\ 10 0001 0000 -

0 value aty-edid-buf ( 0859 )
0 value aty-edid-bit-buf ( 085a )
0 value aty-edid-temp-buf ( 085b )
false value xaty-token-085c? ( 085c )
0 value aty-tmp-byte ( 085d )
0 value token-085e ( 085e )
0 value token-085f ( 085f )

\ 0 = invalid (Disable)
\ 1 = DRAM
\ 2 = EDO DRAM
\ 3 = Pseudo EDO
\ 4 = SDRAM (default on apple)
\ 5-7 invalid (Reserved)
4 to aty-mem-type

create aty-mode#>regs-tbl ( 0860 )
\ Standard EDID modes
(  0 ) h# 00630083 l, h# 00100068 l, h# 02570273 l, h# 00040258 l,
(  1 ) h# 0063007f l, h# 00090066 l, h# 02570270 l, h# 00020258 l,
(  2 ) h# 004f0067 l, h# 00250052 l, h# 01df0207 l, h# 002301e8 l,
(  3 ) h# 004f0068 l, h# 00280051 l, h# 01df01f3 l, h# 002301e0 l,
(  4 ) h# 004f006b l, h# 0028005b l, h# 01df020c l, h# 002301e2 l,
(  5 ) h# 004f0063 l, h# 002c0052 l, h# 01df020c l, h# 002201ea l,
(  6 ) h# 00000000 l, h# 00000000 l, h# 00000000 l, h# 00000000 l,
(  7 ) h# 00000000 l, h# 00000000 l, h# 00000000 l, h# 00000000 l,
(  8 ) h# 009f00d2 l, h# 001200a1 l, h# 03ff0429 l, h# 00030400 l,
(  9 ) h# 007f00a3 l, h# 000c0081 l, h# 02ff031f l, h# 00030300 l,
( 10 ) h# 007f00a5 l, h# 00310082 l, h# 02ff0325 l, h# 00260302 l,
( 11 ) h# 007f00a7 l, h# 00310082 l, h# 02ff0325 l, h# 00260302 l,
( 12 ) h# 027f009d l, h# 00160081 l, h# 02ff0330 l, h# 00080300 l,
( 13 ) h# 0067008f l, h# 0028006f l, h# 026f029a l, h# 00230270 l,
( 14 ) h# 00630083 l, h# 000a0065 l, h# 02570270 l, h# 00030258 l,
( 15 ) h# 00630081 l, h# 000f006a l, h# 0257029b l, h# 0006027c l,
\ Non-standard (Apple?) modes
( 16 ) h# 008f00b5 l, h# 00300097 l, h# 03650392 l, h# 00230368 l,
( 17 ) h# 003f004f l, h# 00040042 l, h# 017f0197 l, h# 00030181 l,
( 18 ) h# 004f0067 l, h# 002a0057 l, h# 03650395 l, h# 00230368 l,
( 19 ) h# 007f00a5 l, h# 002c0087 l, h# 02ff0323 l, h# 00230302 l,
\ Parsed from DTD
( 20 ) 0 l, 0 l, 0 l, 0 l,
( 21 ) 0 l, 0 l, 0 l, 0 l,
( 22 ) 0 l, 0 l, 0 l, 0 l,
( 23 ) 0 l, 0 l, 0 l, 0 l,

create aty-mode#>pixclk-tbl ( 0861 )
\ Standard EDID modes
(  0 ) d#  4000 w,
(  1 ) d#  3600 w,
(  2 ) d#  3150 w,
(  3 ) d#  3120 w,
(  4 ) d#  3024 w,
(  5 ) d#  2518 w,
(  6 ) d#     0 w,
(  7 ) d#     0 w,
(  8 ) d# 13500 w,
(  9 ) d#  7875 w,
( 10 ) d#  7500 w,
( 11 ) d#  6500 w,
( 12 ) d#  4490 w,
( 13 ) d#  5728 w,
( 14 ) d#  4950 w,
( 15 ) d#  5000 w,
\ Non-standard (Apple?) modes
( 16 ) d# 10000 w,
( 17 ) d#  1567 w,
( 18 ) d#  5728 w,
( 19 ) d#  7875 w,
\ Parsed from DTD
( 20 )        0 w,
( 21 )        0 w,
( 22 )        0 w,
( 23 )        0 w,

create aty-mode#>res-tbl ( 0862 )
\ Standard EDID modes
(  0 ) d#  800 w, d#  600 w,
(  1 ) d#  800 w, d#  600 w,
(  2 ) d#  640 w, d#  480 w,
(  3 ) d#  640 w, d#  480 w,
(  4 ) d#  640 w, d#  480 w,
(  5 ) d#  640 w, d#  480 w,
(  6 ) d#  720 w, d#  400 w,
(  7 ) d#  720 w, d#  400 w,
(  8 ) d# 1280 w, d# 1024 w,
(  9 ) d# 1024 w, d#  768 w,
( 10 ) d# 1024 w, d#  768 w,
( 11 ) d# 1024 w, d#  768 w,
( 12 ) d# 1024 w, d#  768 w,
( 13 ) d#  832 w, d#  624 w,
( 14 ) d#  800 w, d#  600 w,
( 15 ) d#  800 w, d#  600 w,
\ Non-standard (Apple?) modes
( 16 ) d# 1152 w, d#  870 w,
( 17 ) d#  512 w, d#  384 w,
( 18 ) d#  640 w, d#  870 w,
( 19 ) d# 1024 w, d#  768 w,
\ Parsed from DTD
( 20 )       0 w,       0 w,
( 21 )       0 w,       0 w,
( 22 )       0 w,       0 w,
( 23 )       0 w,       0 w,

\ C0: 79
\ C1: ffffc079

: aty-reg>addr ( 0863 )
    dup h# 3 and swap fc and

    aty-block-addr if
        \ Block IO
        2/ 2/
        aty-sparse>block-tbl +
        c@ +
        aty-block-addr +
    else
        \ Sparse IO
        8 lshift +
        aty-sparse-addr +
    then

    aty-reg-offset +
;

: aty-reg-w@  aty-reg>addr rw@  ;
: aty-reg-b@  aty-reg>addr rb@  ;
: aty-reg-l@  aty-reg>addr rl@  ;
: aty-reg-w!  aty-reg>addr rw!  ;
: aty-reg-b!  aty-reg>addr rb!  ;
: aty-reg-l!  aty-reg>addr rl!  ;

: aty-set-status ( 086a )
    <> if
        aty-prop-status or to aty-prop-status
    else
        drop
    then
;

: aty-stat-l! ( 086b )
    -rot 2dup
    aty-reg-l!
    aty-reg-l@
    aty-set-status
;

: aty-stat-w! ( 086c )
    -rot 2dup aty-reg-w!
    aty-reg-w@
    aty-set-status
;

: unused-aty-stat-b! ( 086d )
    -rot 2dup aty-reg-b!
    aty-reg-b@
    aty-set-status
;

: aty-call-parent ( 086e )
    aty-saved-my-self 0= if
        my-self to aty-saved-my-self
    then
    my-self 0= if
        aty-saved-my-self to my-self
    then
    $call-parent
;

: aty-gpio! ( 086f )
    dup
    aty-reg-dac-gio aty-reg-b@
    c0 and
    or
    aty-reg-dac-gio aty-reg-b!

    80000004 aty-reg-crtc-h-total-disp aty-reg-l!
    dup 8 and if
        2000000
    else
        0
    then
    swap h# 1 and if
        200 or
    then

    aty-reg-gp-io aty-reg-l@
    fdfffdff and
    or
    aty-reg-gp-io aty-reg-l!
;

: aty-gpio@ ( 0870 )
    aty-reg-dac-gio aty-reg-b@
      fe and
      80000004 aty-reg-crtc-h-total-disp aty-reg-l!
      aty-reg-gp-io 1 + aty-reg-b@
      2/ h# 1 and or
;

\ Returns three bit (pre-EDID) ID
: xaty-disp-id-gpio@ ( 0871 )
    aty-gpio@ 7 and
;

: aty-pll@ ( 0872 )
    2 lshift aty-reg-pll-wr-en-addr aty-reg-b!
    aty-reg-pll-data aty-reg-b@
;

: aty-pll! ( 0873 )
    2 lshift 2 or aty-reg-pll-wr-en-addr aty-reg-b!
    aty-reg-pll-data aty-reg-b!
;

: xaty-pll-calc-token-0874 ( 0874 )
    dup
    d# 28636 \ 2 * 14318
    * 2 pick 4 pick * / a / 8 pick - abs dup 5 pick <
    if
        4 roll 5 roll 6 roll 7 roll
    then
    2drop 2drop
;

: xaty-calc-pll-token-0875 ( 0875 )
    0 1 0 3 pick 2 36
    do
        4 pick 64 * i *
        d# 28636 \ 2 * 14318
        / dup a0 <
        if
            2drop leave
        then
        i swap dup 9f6 <=
        if
            dup 4fb >
            if
                1
            else
                dup 27b >
                if
                    2
                else
                    dup 13b >
                    if
                        4
                    else
                        8
                    then
                then
            then
            tuck * 5 + a / xaty-pll-calc-token-0874
        else
            2drop
        then
        -1
    +loop
    3 roll drop swap 2/ swap
;

: aty-config-sdram ( 0876 )
    \ Is it really SDRAM
    aty-mem-type 4 = if
        aty-reg-mem-cntl 1 + aty-reg-b@
           20 or \ DLL reset+
           dup aty-reg-mem-cntl 1 + aty-reg-b!
           df and \ DLL reset-
           aty-reg-mem-cntl 1 + aty-reg-b!

        1 ms

        aty-reg-mem-cntl 2 + aty-reg-b@
        fb and \ SDRAM reset-
        2dup aty-reg-mem-cntl 2 + aty-reg-b!
        4 or \ SDRAM reset+
        aty-reg-mem-cntl 2 + aty-reg-b!
        1 ms \ SDRAM init (PALL, 8 refres, MRS)
        \ SDRAM reset-
        aty-reg-mem-cntl 2 + aty-reg-b!
    then
;

: aty-setup-pll ( 0877 )

    h# 44  h# 03 aty-pll!
    h# 08  h# 05 aty-pll!
           h# 0a aty-pll!

    dup 4 = if
        drop 3
    then
    6 lshift   h# 06 aty-pll@
    3f and or  h# 06 aty-pll!
    dup        h# 02 aty-pll!

    aty-mem-type 1 > aty-mem-type 5 < and if
        1b8
    else
        18b
    then
    * a / 5 + a /  h# 04 aty-pll!
    h# 14          h# 03 aty-pll!
    h# 0b          h# 05 aty-pll!

    6 ms
    aty-config-sdram
;

: aty-init-pll-macro-cntl ( 0878 )
    aty-def-pll-macro-cntl h# 01 aty-pll!
;

: xaty-dac-resvd-token-0879 ( 0879 )
    60606000 aty-reg-ovr-clr aty-reg-l!

    d# 80 ms

    aty-reg-dac-cntl aty-reg-b@ h# 80 and if
        \ XXX reserved bit?
        aty-prop-flags h# 10 or to aty-prop-flags
    then

    h# 00 aty-reg-ovr-clr aty-reg-l!
;

: aty-idle-loop  0 do loop  ;
: aty-time-idle-loop ( 087b )
    \ Wait until millisecond boundary
    get-msecs
    begin
        dup get-msecs <>
    until
    drop

    get-msecs swap
    aty-idle-loop
    get-msecs swap -
;

: aty-bogo-ms ( 087c )
    begin
        dup aty-time-idle-loop 0=
    while
        2*
    repeat
;

: xaty-bogo-timer ( 087d )
    dup 2/ swap 0 >r
    begin
        2dup 1 - <
    while
        2dup + 2/ dup aty-time-idle-loop dup
        if
            r> drop >r
        else
            drop -rot
        then
        nip
    repeat
    drop r>
;

: xaty-init-bogo-timer ( 087e )
    aty-delay-ms# if
        exit
    then
    40 aty-bogo-ms xaty-bogo-timer / to aty-delay-ms#
;

: aty-ms ( 087f )
    aty-delay-ms# * aty-idle-loop
;

: aty-8ms ( 0880 )
    d# 8 aty-ms
;

: aty-1ms ( 0881 )
    d# 1 aty-ms
;

defer aty-delay ( 0882 )
' aty-1ms to aty-delay

: aty-i2c-dat? ( 0883 )
    aty-gpio@ 2 and 0<>
;

: aty-i2c-clk? ( 0884 )
    aty-gpio@ 4 and 0<>
;

: aty-i2c-wait-clk ( 0885 )
    100 0 do
        aty-gpio@ 18 and aty-gpio!
        aty-i2c-clk? if
            leave
        else
            aty-delay
        then
    loop
;

: aty-i2c-clk- ( 0886 )
    aty-gpio@
    20 or
    f8 and
    aty-gpio!
;

: aty-i2c-dat- ( 0887 )
    aty-gpio@
    28 and
    aty-gpio!
;

: aty-i2c-dat+ ( 0888 )
    aty-gpio@
    10 or       \
    f8 and
    aty-gpio!
;

: aty-turn-vsync-on ( 0889 )
        0 aty-reg-crtc-v-sync-wid-pol aty-reg-b!  aty-delay
    h# 20 aty-reg-crtc-v-sync-wid-pol aty-reg-b!  aty-delay
;

: xaty-i2c-idle ( 088a )
    aty-i2c-clk-
    aty-i2c-dat-   aty-delay
    aty-i2c-wait-clk  aty-delay
;

: aty-i2c-wait-idle ( 088b )
    100 0 do
        aty-i2c-wait-clk
        aty-i2c-dat? if
            leave
            \ Deadcode
                        aty-delay
            aty-i2c-clk-  aty-delay
            aty-i2c-dat-
        then
    loop
                aty-delay
    aty-i2c-wait-clk  aty-delay
    aty-i2c-dat+  aty-delay
    aty-i2c-clk-  aty-delay
    aty-i2c-dat-  aty-delay
;

: aty-i2c-go-idle ( 088c )
    aty-i2c-dat+  aty-delay
    aty-i2c-wait-clk  aty-delay
    aty-i2c-dat-  aty-delay
    aty-i2c-clk-  aty-delay
    aty-i2c-dat-  aty-delay
;

: >aty-i2c-bit ( 088d )
    80 and if \ Direction???
        aty-i2c-dat-
    else
        aty-i2c-dat+
    then

                aty-delay
    aty-i2c-wait-clk  aty-delay
    aty-i2c-clk-
    aty-i2c-dat-  aty-delay
;

: aty-i2c-select ( 088e )
   \ Send address
    8 0 do
        dup >aty-i2c-bit 1 lshift
    loop
    drop

    aty-i2c-wait-clk
    false
    100 0 do
        aty-i2c-dat? 0= if
            \ Device responded by pulling DAT low
            drop true leave
        then
    loop
    aty-i2c-clk-
    aty-i2c-dat-  aty-delay
;

: aty-i2c-byte> ( 088f )
    0
    8 0 do
        2* aty-i2c-dat-  aty-delay
        aty-i2c-wait-clk     aty-delay
        aty-i2c-dat?
        aty-i2c-clk-
        if
            1 or
        then
    loop
    aty-i2c-dat+  aty-delay
    aty-i2c-wait-clk  aty-delay
    aty-i2c-clk-
    aty-i2c-dat-  aty-delay
;

: aty-try-i2c-read-a0-00 ( 0890 )
    false
    aty-i2c-wait-idle
    h# a0 aty-i2c-select if
        h# 00 aty-i2c-select if
            drop true
        then
    then
    aty-i2c-go-idle
;

\ Is there 00 ff ff ff ff ff ff 00 at the beginning?
: aty-edid-header-ok? ( 0891 )
    aty-edid-buf 0 + c@
    aty-edid-buf 7 + c@
    + 0= if
        true
        aty-edid-buf 1 + 6 bounds do
            i c@ ff <> if
                drop false leave
            then
        loop
    else
        false
    then
;

: aty-edid-cksum-ok? ( 0892 )
    0
    aty-edid-buf d# 127 bounds do
        i c@ +
    loop
    negate ff and
    aty-edid-buf d# 127 + c@ =
;

: aty-i2c-try-read-a1 ( 0893 )
    aty-i2c-wait-idle
    h# a1 aty-i2c-select if
        aty-edid-buf d# 128 bounds do
            aty-i2c-byte> i c!
        loop
    then
    aty-i2c-go-idle

    aty-edid-header-ok?
    aty-edid-cksum-ok? and
    dup if
        h# 0b aty-prop-flags or to aty-prop-flags
    then
;

: aty-i2c-read-a0-00 ( 0894 )
    aty-i2c-clk-

    20 ms

    false
    aty-i2c-wait-clk
    aty-i2c-clk? if
        4 0 do
            aty-try-i2c-read-a0-00 if
                drop true
                h# 03 aty-prop-flags or to aty-prop-flags
                leave
            then
        loop
    then
;

: aty-i2c-read-a1 ( 0895 )
    false
    4 0 do
        aty-i2c-try-read-a1 if
            drop true leave
        then
    loop
;

: aty-edid-dtd+ ( 0896 )
    d# 18 *
    d# 54 +
    aty-edid-buf +
;

: aty-edid-dtd+-dup ( 0897 )
    aty-edid-dtd+ dup
;

: aty-edid-dtd-c@ ( 0898 )
    swap aty-edid-dtd+ +
    dup c@
    swap
;

: aty-edid-dtd-pixclk/10khz ( 0899 )
    aty-edid-dtd+-dup c@ swap 1 + c@ bwjoin
;

: aty-edid-dtd-disp@ ( 089a )
    aty-edid-dtd-c@ 2 + c@ f0 and 4 rshift bwjoin
;

: aty-edid-dtd-hdisp ( 089b )
    2 aty-edid-dtd-disp@
;

: aty-edid-dtd-blank@ ( 089c )
    aty-edid-dtd-c@ 1 + c@ f and bwjoin
;

: aty-edid-dtd-hblank ( 089d )
    3 aty-edid-dtd-blank@
;

: aty-edid-dtd-vdisp ( 089e )
    5 aty-edid-dtd-disp@
;

: aty-edid-dtd-blank ( 089f )
    6 aty-edid-dtd-blank@
;

: aty-edid-dtd-hfporch ( 08a0 )
    aty-edid-dtd+-dup d# 11 + c@ 0 + c0 and 2 lshift swap 8 + c@ 0 + or
;

: aty-edid-dtd-hsync ( 08a1 )
    aty-edid-dtd+-dup d# 11 + c@ 0 + 30 and 4 lshift swap 9 + c@ 0 + or
;

: aty-edid-dtd-vert ( 08a2 )
    aty-edid-dtd+ d# 10 + dup c@ 0 +
;

: aty-edid-dtd-vporch ( 08a3 )
    aty-edid-dtd-vert 4 rshift swap 1 + c@ c and 2 lshift or
;

: aty-edid-vsync ( 08a4 )
    aty-edid-dtd-vert f and swap 1 + c@ h# 3 and 4 lshift or
;

: aty-edid-dtd-features ( 08a5 )
    aty-edid-dtd+ d# 17 + c@
;

: aty-edid-dtd-dig-sync? ( 08a6 )
    aty-edid-dtd-features 10 and 10 =
;

: aty-edid-dtd-comp-sync? ( 08a7 )
    aty-edid-dtd-features 18 and 10 =
;

: unused-aty-edid-dtd-sep-sync? ( 08a8 )
    aty-edid-dtd-features 18 and 18 =
;

\ Some non-standard display-type. Apple?
: unused-aty-edid-dtd-unk? ( 08a9 )
    aty-edid-buf d# 20 + c@ 88 and 88 =
;

: unused-aty-edid-dtd-mddi? ( 08aa )
    aty-edid-buf d# 20 + c@ 84 and 84 =
;

: aty-edid-dtd-positive-vsync? ( 08ab )
    aty-edid-dtd-features 4 and 0<>
;

: aty-edid-dtd-positive-hsync? ( 08ac )
    aty-edid-dtd-features h# 2 and 0<>
;

: aty-edid-dtd-interlaced? ( 08ad )
    aty-edid-dtd-features 80 and 0<>
;

: aty-mode#mask ( 08ae )
    1 swap lshift aty-modes-bitmask
;

: aty-add-mode# ( 08af )
    aty-mode#mask or to aty-modes-bitmask
;

: aty-mode#-supported? ( 08b0 )
    aty-mode#mask and 0<>
;

: aty-8/1- ( 08b1 )
    2/ 2/ 2/ 1 -
;

: aty-edid-parse-modes ( 08b2 )

    \ RGB 4:4:4 (digital) or grayscale (analog)
    aty-edid-buf d# 24 + c@ h# 18 and 0= to aty-grayscale?

    \ Standard mode bitmap (720x400 masked out)
    aty-edid-buf d# 35 + w@ wbflip ff3f and to aty-modes-bitmask

    \ 1152x870@75 (Apple Macintosh II)
    aty-edid-buf d# 37 + c@ 80 and if
        d# 16 aty-add-mode#
    then

    \ DTDs
    4 0 do
        i aty-edid-dtd-dig-sync? if
            i aty-edid-dtd-vdisp
            i aty-edid-dtd-hdisp
            aty-mode#>res-tbl
            /aty-std-modes
            i + 2* wa+ tuck w! wa1+ w!
            i aty-edid-dtd-vporch
            i aty-edid-dtd-vdisp + i aty-edid-vsync

            i aty-edid-dtd-positive-vsync? 0= if
                20 or
            then

            wljoin
            i aty-edid-dtd-vdisp
            i aty-edid-dtd-blank +
            i aty-edid-dtd-vdisp 1 -

            wljoin
            i aty-edid-dtd-hfporch
            i aty-edid-dtd-hdisp + aty-8/1-
            i aty-edid-dtd-hsync 2/ 2/ 2/
            i aty-edid-dtd-positive-hsync? 0= if  20 or  then

            wljoin
            i aty-edid-dtd-hdisp
            i aty-edid-dtd-hblank + aty-8/1-
            i aty-edid-dtd-hdisp aty-8/1-

            wljoin
            i aty-edid-dtd-interlaced? if
                h# 2000000
            else
                h# 0
            then

            i aty-edid-dtd-comp-sync? if
                10000000 or
            then

            or aty-mode#>regs-tbl /aty-std-modes
            i + 2* 2* la+ tuck l!
            la1+ tuck l!
            la1+ tuck l!
            la1+ l!

            i aty-edid-dtd-pixclk/10khz
            aty-mode#>pixclk-tbl
            /aty-std-modes
            i + wa+ w!
            /aty-std-modes i + aty-add-mode#
        then
    loop
;

: token-08b3 ( 08b3 )
    >r
    aty-mode#>regs-tbl r@
    2* 2* la+ dup l@
    d# 24 rshift
    h# 0240 or
    h# fff3 and
    swap 4 /l* bounds
    do
        i l@ /l
    +loop
    r>
;

: aty-mode#>pixclk ( 08b4 )
    aty-mode#>pixclk-tbl swap wa+ w@
;

: aty-mode#>res ( 08b5 )
    2* aty-mode#>res-tbl swap wa+ dup w@
    swap wa1+ w@
;



create xaty-disp-id-token-08b6 ( 08b6 )
h# 00 c, h# 01 c, h# 02 c, h# 03 c,
h# 04 c, h# 05 c, h# 06 c, h# 07 c,
h# 00 c, h# 10 c, h# 20 c, h# 30 c,
h# 00 c, h# 10 c, h# 20 c, h# 30 c,
h# 00 c, h# 04 c, h# 00 c, h# 04 c,
h# 08 c, h# 0c c, h# 08 c, h# 0c c,
h# 00 c, h# 00 c, h# 01 c, h# 01 c,
h# 02 c, h# 02 c, h# 03 c, h# 03 c,

create xaty-disp-id-token-08b7 ( 08b7 )
h# 07 c,
h# 23 c,
h# 15 c,
h# 0e c,

: xaty-disp-id@ ( 08b8 )

    \ Pull three display id GPIOs up
    h# 07 aty-gpio!

    dup xaty-disp-id-token-08b7 + c@
    aty-gpio!

    1 ms

    3 lshift
    xaty-disp-id-token-08b6 +
    xaty-disp-id-gpio@ + c@
;

create token-08b9 ( 08b9 )
h# 00 c,
h# 10 c,
h# 01 c,
h# 12 c,
h# 00 c,
h# 11 c,
h# 01 c,
h# 10 c,
h# 00 c,
h# 04 c,
h# 00 c,
h# 12 c,

: xaty-disp-id-read ( 08ba )
    0 xaty-disp-id@
    dup to xaty-disp-id
    aty-prop-flags lbflip or lbflip
    1 xaty-disp-id@
    2 xaty-disp-id@ +
    3 xaty-disp-id@ +
    dup to xaty-disp-id-alt
    swap lwflip or lwflip
    to aty-prop-flags
;

: xaty-disp-id-parse ( 08bb )
    xaty-disp-id 6 = if
        xaty-disp-id-alt dup h# 3 = if
            drop 2010 to aty-modes-bitmask
        else
            dup 2b = if
                drop 4 aty-add-mode#
            else
                dup b = if
                    drop 2210 to aty-modes-bitmask
                else
                    23 = if
                        92110 to aty-modes-bitmask
                    then
                then
            then
        then
    else
        xaty-disp-id 7 = if
            xaty-disp-id-alt
            dup 2d = if
                \ 832x624 (Macintosh II?)
                drop d# 13 aty-add-mode#
            else
                dup 3a = if
                    \ 1024x768
                    drop d# 19 aty-add-mode#
                else
                    17 = if
                        821 to aty-modes-bitmask
                    then
                then
            then
        else
            xaty-disp-id 6 < if
                token-08b9
                xaty-disp-id wa+ dup c@
                0<> to aty-grayscale?
                char+ c@
                aty-add-mode#
            then
        then
    then
;

: /aty-edid-bit-buf  d# 128 9 * 2*  ;

: xaty-alloc-edid-bufs ( 08bd )
    /aty-edid-bit-buf alloc-mem to aty-edid-bit-buf
    d# 128 2* alloc-mem to aty-edid-temp-buf
;

: xaty-free-edid-bufs ( 08be )
    aty-edid-bit-buf /aty-edid-bit-buf free-mem
    aty-edid-temp-buf d# 128 free-mem
;

: xaty-edid-token-08bf ( 08bf )
    ['] aty-8ms to aty-delay
    aty-turn-vsync-on
    aty-i2c-dat? ff and aty-edid-bit-buf c!

    26 9 * 0 do
        aty-turn-vsync-on
        aty-i2c-dat? ff and aty-edid-bit-buf c@ <> if
            true to xaty-token-085c?
        then
    loop
    xaty-token-085c? if
        ['] aty-1ms to aty-delay
        h# 05 aty-prop-flags or to aty-prop-flags
        /aty-edid-bit-buf 0 do
            aty-turn-vsync-on
            aty-i2c-dat?  if  ff  else  0  then
            aty-edid-bit-buf i + c!
        loop
    then
;

: aty-edid-bits>byte ( 08c0 )
    0 to aty-tmp-byte
    8 0 do
        dup i + aty-edid-bit-buf + c@
        if  1  else  0  then
        aty-tmp-byte 1 lshift or to aty-tmp-byte
    loop
    drop aty-tmp-byte
;

: aty-edid-bits>bytes ( 08c1 )
    0 to token-085f

    /aty-edid-bit-buf 0 do
        i token-085e + aty-edid-bits>byte
        aty-edid-temp-buf token-085f + c!
        token-085f 1 + to token-085f
    9 +loop

    d# 128 0 do
        aty-edid-temp-buf i + c@
        aty-edid-temp-buf i + 7 + c@ +
        0= if
            aty-edid-temp-buf i + 1 + c@
            aty-edid-temp-buf i + 2 + c@ +
            aty-edid-temp-buf i + 3 + c@ +
            aty-edid-temp-buf i + 4 + c@ +
            aty-edid-temp-buf i + 5 + c@ +
            aty-edid-temp-buf i + 6 + c@ +
            d# 1530 = if
                d# 128 0 do
                    aty-edid-temp-buf i + j + c@
                    aty-edid-buf i + c!
                loop
            then
        then
    loop
;

: xaty-edid-token-08c2 ( 08c2 )
    xaty-i2c-idle
    xaty-alloc-edid-bufs
    xaty-edid-token-08bf
    false
    9 0 do
        i to token-085e
        aty-edid-bits>bytes
        aty-edid-header-ok? if
            aty-edid-cksum-ok? if
                h# 0d aty-prop-flags or to aty-prop-flags
                drop true leave
            then
        then
    loop
    xaty-free-edid-bufs
;

\ Turn on non-VGA display
: aty-ext-display ( 08c3 )
    h# 01 aty-reg-crtc-gen-cntl3 aty-reg-b!
;

: aty-enable-crt-clk ( 08c4 )
    aty-first-clock  aty-reg-clock-sel aty-reg-b!
    aty-second-clock aty-reg-clock-sel aty-reg-b!

    \ Enable CRTC + Extended (non-VGA) display
    h# 03 aty-reg-crtc-gen-cntl3 aty-reg-b!
;

: aty-crtc-enable-blanking ( 08c5 )
    aty-reg-crtc-gen-cntl0 aty-reg-b@
    bf and
    aty-reg-crtc-gen-cntl0 aty-reg-b!
;

: aty-setup-mode ( 08c6 )
    aty-ext-display
    aty-current-mode# token-08b3 aty-mode#>pixclk

    xaty-calc-pll-token-0875
    aty-setup-pll

    aty-reg-crtc-v-sync-strt        aty-stat-crtc-failed aty-stat-l!
    aty-reg-crtc-v-total            aty-stat-crtc-failed aty-stat-l!
    aty-reg-crtc-h-sync-strt-wid    aty-stat-crtc-failed aty-stat-l!
    ffffff and aty-reg-crtc-h-total aty-stat-crtc-failed aty-stat-l!
    aty-reg-crtc-gen-cntl0          aty-stat-crtc-failed aty-stat-w!

    0 aty-reg-ovr-clr            aty-stat-ovr-failed aty-stat-l!
    0 aty-reg-ovr-wid-left-right aty-stat-ovr-failed aty-stat-l!
    0 aty-reg-ovr-wid-top-bottom aty-stat-ovr-failed aty-stat-l!

    aty-prop-width 2/ 2/ 2/ 16 lshift
    aty-io-regs-offset 2/ 2/ 2/ +
    aty-reg-crtc-off-pitch aty-stat-off-pitch-failed aty-stat-l!
;

: aty-apply-mode ( 08c7 )
    aty-setup-mode
    aty-crtc-enable-blanking
    aty-enable-crt-clk
;

: aty-apply-mode-no-blanking ( 08c8 )
    aty-setup-mode
    aty-enable-crt-clk
;

: aty-pick-best-mode ( 08c9 )
    aty-modes-bitmask 0= if
        aty-default-mode# aty-add-mode#
    then
    /aty-std-modes 2 + 2 + 0 do
        i aty-mode#-supported? if
            i aty-mode#>res 2dup *
            aty-mem-mbytes 100000 *
            aty-io-regs-offset - <= if
                2dup * aty-prop-width aty-prop-height * < if
                    2drop
                else
                    2dup * aty-prop-width aty-prop-height * = if
                        i aty-mode#>pixclk  aty-current-mode# aty-mode#>pixclk >= if
                            to aty-prop-height
                            to aty-prop-width
                            i to aty-current-mode#
                        else
                            2drop
                        then
                    else
                        to aty-prop-height
                        to aty-prop-width
                        i to aty-current-mode#
                    then
                then
            else
                2drop
            then
        then
    loop
;

: aty-init-edid ( 08ca )
    0
        dup to aty-modes-bitmask
        aty-prop-flags h# 10 and to aty-prop-flags
        aty-edid-buf d# 128 ff fill

        aty-default-mode#
            dup to aty-current-mode#
            aty-mode#>res
               to aty-prop-height
               to aty-prop-width

        aty-apply-mode-no-blanking
        d# 1000 ms

        aty-i2c-read-a0-00 if
            aty-i2c-read-a1
        else
            xaty-edid-token-08c2
        then

        if
            aty-edid-parse-modes
        else
            xaty-disp-id-read
            xaty-disp-id-parse
        then

        aty-modes-bitmask 0= if
            aty-default-mode# aty-add-mode#
        then

        aty-ext-display
        aty-crtc-enable-blanking
        xaty-dac-resvd-token-0879
;

: aty-enable-mem ( 08cb )
    4 my-space + dup " config-l@" aty-call-parent
    2 or swap " config-l!" aty-call-parent
;

: aty-disable-mem ( 08cc )
    4 my-space + dup " config-l@" aty-call-parent
    fffffffd and swap " config-l!" aty-call-parent
;

: aty-linear-map ( 08cd )
    aty-block-addr 0= if
        aty-use-assigned-addr? if
            " assigned-addresses" get-my-property 0= if
                begin
                    dup
                while
                    \ Is this BAR0 (Linear)?
                    decode-phys ff and 10 = if
                        drop
                        to aty-assigned-addr
                    else
                        2drop
                    then
                    decode-int drop decode-int drop
                repeat
                2drop
            then
        then
        aty-assigned-addr 0
            my-space 2000010 + \ BAR1 (Linear)
            1000000 \ 16M
            " map-in" aty-call-parent to aty-block-addr
        aty-linear-blk0 to aty-reg-offset
    then
    aty-enable-mem
;

: aty-mmio-unmap ( 08ce )
    aty-block-addr if
        0 to aty-reg-offset
        aty-block-addr 1000000 " map-out"
        aty-call-parent
        0 to aty-block-addr
    then
    aty-disable-mem
;

: aty-pci-enable-pio ( 08cf )
    4 my-space + dup " config-l@" aty-call-parent
    1 or swap " config-l!" aty-call-parent
;

: aty-pci-disable-pio ( 08d0 )
    4 my-space + dup " config-l@" aty-call-parent
    fffffffe and swap " config-l!" aty-call-parent
;

: aty-block-map ( 08d1 )
    0 0 1000014 my-space or 100 " map-in" aty-call-parent to aty-block-addr
    0 to aty-reg-offset

    \ block io, disable 0x46e8
    40 my-space + dup " config-l@" aty-call-parent
       fffffffc and
       c or
       swap " config-l!" aty-call-parent

    aty-pci-enable-pio
;

: aty-sparse-map ( 08d2 )
    0 0 81000000 my-space or 10000 " map-in" aty-call-parent to aty-sparse-addr

    \ Set IO base to 0x2ec, sparse i/o, disable 0x46e8
    40 my-space +
      dup " config-l@" aty-call-parent
      h# ffff.fff8 and
      h# 08 or
      swap " config-l!" aty-call-parent

    aty-pio-offset to aty-reg-offset
    aty-pci-enable-pio
;

: aty-block-unmap ( 08d3 )
    aty-block-addr 100 " map-out" aty-call-parent
    0 to aty-block-addr
    aty-pci-disable-pio
;

: aty-sparse-unmap ( 08d4 )
    0 to aty-reg-offset
    aty-sparse-addr 10000 " map-out" aty-call-parent
    0 to aty-sparse-addr
    aty-pci-disable-pio
;

: token-08d5 ( 08d5 )
    >r >r
    aty-prop-width * +
    aty-block-addr aty-io-regs-offset + +
    r> -rot r>
;

: aty-palette ( 08d6 )
     " "(00 00 00   00 00 aa   00 aa 00   00 aa aa   aa 00 00   aa 00 aa   aa 55 00   aa aa aa   55 55 55   55 55 ff   55 ff 55   55 ff ff   ff 55 55   ff 55 ff   ff ff 55   ff ff ff)"
    0 swap 3 /
;

: aty-dac!  aty-reg-dac-data aty-reg-b!  ;
: aty-dac@  aty-reg-dac-data aty-reg-b@  ;

: aty-dac-r-index!  aty-reg-dac-r-index aty-reg-b!  ;
: aty-dac-w-index!  aty-reg-dac-w-index aty-reg-b!  ;

: aty-clip-rect ( 08db )
    swap 3 pick + aty-prop-width min
    swap 2 pick + aty-prop-height min
;

external

: dimensions ( 08dc )
    aty-prop-width aty-prop-height
;

: color@ ( 08dd )
    aty-dac-r-index!
    aty-dac@ aty-dac@ aty-dac@
;

: color! ( 08de )
    aty-dac-w-index!
    swap rot
    aty-dac! aty-dac! aty-dac!
;

: set-colors ( 08df )
    swap aty-dac-w-index!
    ff aty-reg-dac-mask aty-reg-b!

    aty-grayscale? if
        0 ?do
            dup c@ h# 4d * swap char+
            dup c@ h# 97 * swap char+
            dup c@ h# 1c * swap char+
            >r
            + + 8 rshift
            dup aty-reg-dac-data aty-reg-b!
            dup aty-reg-dac-data aty-reg-b!
                aty-reg-dac-data aty-reg-b!
            r>
        loop
        drop
    else
        3 * bounds ?do
            i c@ aty-dac!
        loop
    then
;

: get-colors ( 08e0 )
    swap
    aty-dac-r-index!
    3 * bounds ?do
        aty-dac@ i c!
    loop
;

: fill-rectangle ( 08e1 )
    aty-clip-rect
    2swap aty-prop-width * + frame-buffer-adr + swap
    0 ?do
        2 pick 2 pick 2 pick
        swap rot fill
        aty-prop-width +
    loop
    drop 2drop
;

: draw-rectangle ( 08e2 )
    aty-clip-rect
    2swap aty-prop-width * + frame-buffer-adr + swap
    0 ?do
        2 pick 2 pick 2
        pick swap move >r tuck + swap r>
        aty-prop-width +
    loop
    drop 2drop
;

: read-rectangle ( 08e3 )
    aty-clip-rect
    2swap aty-prop-width * + frame-buffer-adr + swap
    0 ?do
        2 pick 2 pick 2 pick
        -rot move >r tuck + swap r>
        aty-prop-width +
    loop
    drop 2drop
;

: mode#  aty-current-mode#  ;

: show-modes ( 08e5 )
    cr
    /aty-std-modes 2 + 2 + 0 do
        i aty-mode#-supported? if
            i aty-mode#>res
            2dup *
            aty-mem-mbytes 100000 *
            aty-io-regs-offset - <= if
                i . " = " type
                swap base @ swap d# 10 base ! .
                base ! " X " type
                base @ swap d# 10 base ! .
                base ! " @ " type
                i aty-mode#>pixclk
                base @ swap d# 10 base ! .
                base ! " MHz" type
                cr
            else
                2drop
            then
        then
    loop
;

: set-mode ( 08e6 )
    dup aty-mode#-supported? if
        dup aty-mode#>res *
        aty-mem-mbytes 100000 *
        aty-io-regs-offset - <= if
            dup to aty-current-mode#
            aty-mode#>res
              to aty-prop-height
              to aty-prop-width

            " width"     delete-property
            " height"    delete-property
            " linebytes" delete-property

            aty-prop-width  encode-int " width" property
            aty-prop-height encode-int " height" property
            aty-prop-width  encode-int " linebytes" property

            aty-prop-width aty-prop-height
            over char-width /
            over char-height /

            fb8-install
            erase-screen

            aty-apply-mode
        else
            drop " Not enough memory to support" type cr
        then
    else
        drop " Mode not supported" type cr
    then
;

headerless

\ Checks whether a write to an address can be read back
: aty-address-bad? ( addr -- bad? )
    false              ( addr false )
    swap               ( false addr )
    10 0 do
        dup            ( false addr addr )
        i              ( false addr addr i )
        swap           ( false addr i addr )
        rb!            ( false addr )
        dup            ( false addr addr )
        rb@            ( false addr val )
        i <>           ( false addr val=i? )
        if             ( false addr )
            drop true  ( false true )
            swap       ( true false )
            leave
        then
    loop               ( false|true false|addr )
    drop               ( false|true )
;

: aty-mem-bad? ( mbytes -- bad? )
    dup                         ( mbytes mbytes )

    \ Turn 4 into 3
    dup 4 = if  1 -  then       ( mbytes mbytes1 )

    aty-reg-mem-cntl aty-reg-b@
    f8 and or
    aty-reg-mem-cntl aty-reg-b!       ( mbytes )

    100000 *                    ( bytes )
    aty-block-addr +               ( fbend )
    100 -                       ( fbend-100 )
    false swap                  ( false fbend-100 )
    10 0 do
        dup i +                 ( false fbend-100 fbend-100+i )
        aty-address-bad? if
            drop true swap      ( true fbend-100 )
            leave
        then
    loop                        ( false|true fbend-100 )
    drop                        ( false|true )
;

: aty-is-install ( 08e9 )
    aty-open-count 0= if
        aty-linear-map

        aty-block-addr aty-io-regs-offset +
        dup to frame-buffer-adr
        encode-int " address" property

        4 dup aty-mem-bad? if
            2/ dup aty-mem-bad? if
                2/ dup aty-mem-bad? if
                    drop aty-mmio-unmap
                    cr " No video memory" type cr
                    exit
                then
            then
        then

        to aty-mem-mbytes
        aty-palette set-colors
        ff dup 2dup color!
        default-font set-font
        aty-pick-best-mode
    then
    aty-current-mode# set-mode
    aty-open-count 1 + to aty-open-count
;

: aty-is-remove ( 08ea )
    aty-open-count 1 = if
        0 to aty-open-count
        aty-ext-display
        aty-mmio-unmap
        " address" delete-property
        -1 to frame-buffer-adr
    else
        aty-open-count 1 - 0 max to aty-open-count
    then
;

create aty-reg-test-patterns ( 08eb )
h#          0 l,
h# 55555555 l,
h# aaaaaaaa l,
h# ffffffff l,

: aty-reg-test-b ( 08ec )
    2* 2* aty-reg-test-patterns + c@
    swap 2dup dup        aty-reg-b@
    -rot                 aty-reg-b!
    -rot dup             aty-reg-b@
    swap 2swap swap rot  aty-reg-b! =
;

: aty-reg-test-w ( 08ed )
    2* 2* aty-reg-test-patterns + w@
    swap 2dup dup        aty-reg-w@
    -rot                 aty-reg-w!
    -rot dup             aty-reg-w@
    swap 2swap swap rot  aty-reg-w! =
;

: aty-reg-test-l ( 08ee )
    2* 2* aty-reg-test-patterns + l@
    swap 2dup dup        aty-reg-l@
    -rot                 aty-reg-l!
    -rot dup             aty-reg-l@
    swap 2swap swap rot  aty-reg-l! =
;

: aty-direct-reg-test ( 08ef )
    2* 2* aty-reg-test-patterns + l@
    swap 2dup dup        rl@
    -rot                 rl!
    -rot dup             rl@
    swap 2swap swap rot  rl! =
;

: aty-pll-reg-test ( 08f0 )
    2* 2* aty-reg-test-patterns + c@
    swap 2dup dup        aty-pll@
    -rot                 aty-pll!
    -rot dup             aty-pll@
    swap 2swap swap rot  aty-pll! =
;

defer aty-reg-test-hook ( 08f1 )
' aty-reg-test-l to aty-reg-test-hook

: aty-run-reg-test ( 08f2 )
    true swap
    4 0 do
        dup i
        aty-reg-test-hook 0= if
            to aty-fb-check-addr
            false swap
            leave
        then
    loop
    drop
;

: aty-test-regs-b ( 08f3 )
    ['] aty-reg-test-b to aty-reg-test-hook
    aty-run-reg-test
;

: aty-test-regs-w ( 08f4 )
    ['] aty-reg-test-w to aty-reg-test-hook
    aty-run-reg-test
;

: aty-test-regs-l ( 08f5 )
    ['] aty-reg-test-l to aty-reg-test-hook
    aty-run-reg-test
;

: aty-test-direct-regs ( 08f6 )
    ['] aty-direct-reg-test to aty-reg-test-hook
    aty-run-reg-test
;

: aty-test-pll-regs ( 08f7 )
    ['] aty-pll-reg-test to aty-reg-test-hook
    aty-run-reg-test
;

: .aty-test-result ( 08f8 )
    aty-fb-check-addr -1 <> if
        "  failed at address:  " type aty-fb-check-addr .
    else
        "  passed Ok" type
    then
    cr
;

defer aty-test-hook ( 08f9 )

: aty-run-test ( 08fa )
    -1 to aty-fb-check-addr
    aty-test-hook
    .aty-test-result
;

: aty-noop ;

: aty-test-regs ( 08fc )
    aty-reg-scratch-reg0 aty-test-regs-l 0= if
        aty-prop-status aty-test-regs-failed or to aty-prop-status
    then
    aty-reg-scratch-reg1 aty-test-regs-l 0= if
        aty-prop-status aty-test-regs-failed or to aty-prop-status
    then
;

: aty-test-fb ( 08fd )
    aty-block-addr aty-io-regs-offset +
    aty-prop-width aty-prop-height *
    bounds do
        false i
        8 0 do
            dup
            aty-test-direct-regs if
                drop true swap leave
            then
        loop
        drop
        0= if
            aty-prop-status aty-fb-test-failed or to aty-prop-status
            aty-fb-check-addr
               aty-block-addr -
               aty-io-regs-offset -
               to aty-fb-check-addr
            .aty-test-result
            key? if
                key drop leave
            else
                " Test Frame buffer - " type
            then
        then
        4
    +loop
;

: aty-unused-check-fb ( 08fe )
    d# 12 aty-reg-test-patterns + l@

    aty-block-addr aty-io-regs-offset +
    aty-prop-width aty-prop-height *
    bounds do
        dup i rl!
        dup i rl@
        <> if
            aty-prop-status aty-fb-test-failed or to aty-prop-status
            leave
        then
        4
    +loop
    drop
;

external

: self-test ( 08ff )
    0 to aty-prop-status

    cr

    " Test hardware registers - " type
    ['] aty-test-regs to aty-test-hook
    aty-run-test

    " Test RamDAC - " type
    ['] aty-noop to aty-test-hook
    aty-run-test

    aty-block-addr if
        " Test Frame buffer - " type
        ['] aty-test-fb to aty-test-hook
        aty-run-test
    else
        " Frame buffer not mapped" type cr
    then
    aty-prop-status
;

headerless

: aty-init-regs ( 0900 )
    aty-def-bus-cntl       aty-reg-bus-cntl        aty-stat-bus-cntl-failed  aty-stat-l!
    aty-def-crtc-int-cntl  aty-reg-crtc-int-cntl                             aty-reg-w!
    aty-def-crtc-gen-cntl  aty-reg-crtc-gen-cntl0  aty-stat-crtc-failed      aty-stat-l!
    aty-def-gen-test-cntl  aty-reg-gen-test-cntl   aty-stat-gen-test-failed  aty-stat-l!

    aty-reg-config-stat0 aty-reg-b@
    h# 07 and  \ RAM type from straps
    dup 0 >    \ Is it valid?
    swap tuck 5 <
    and if
        \ Then it overrides the hardwired default
        to aty-mem-type
    else
        drop
    then

    aty-mem-type dup 4 = if
        drop
        aty-sdram-config-statw
        aty-sdram-mem-cntl
    else 2 = if
        aty-edo-config-statw
        aty-edo-mem-cntl
    else
        aty-dram-config-statw
        aty-dram-mem-cntl
    then then

    aty-reg-mem-cntl      aty-stat-mem-cntl-failed     aty-stat-l!
    aty-reg-config-stat0  aty-stat-config-stat-failed  aty-stat-w!
    aty-def-dac-cntl      aty-reg-dac-cntl             aty-reg-l!
;


xaty-init-bogo-timer

\ Top bits of I/O BAR
h# 16 my-space + dup dup " config-w@" aty-call-parent
dup
  invert rot " config-w!" aty-call-parent
  swap dup " config-w@" aty-call-parent
rot dup rot <> if
    \ Unsuccessful. No sparse I/O BAR.
    \ Write back original content, probably useless
    swap " config-w!" aty-call-parent
    aty-block-map
else
    2drop
    aty-sparse-map
then

aty-init-regs
aty-init-pll-macro-cntl

h# 0f aty-reg-config-cntl 2 + aty-reg-b!

" AAPL,cpu-id" get-inherited-property 0= if
    true to aty-use-assigned-addr?
    drop
    4 to aty-default-mode#
then

d# 128 alloc-mem to aty-edid-buf
aty-init-edid
aty-pick-best-mode

aty-block-addr if
    aty-block-unmap
else
    aty-sparse-unmap
then

aty-prop-status encode-int " ATY,Status" property
aty-prop-flags encode-int " ATY,Flags" property

aty-prop-flags h# 08 and if
    aty-edid-buf d# 128 encode-bytes " EDID" property
then
aty-edid-buf d# 128 free-mem

aty-prop-width encode-int " width" property
aty-prop-height encode-int " height" property
8 encode-int " depth" property
aty-prop-width encode-int " linebytes" property
" display" device-type
" ISO8859-1" encode-string " character-set" property

168 get-token drop
169 get-token drop
<> if
    0 0 " iso6429-1983-colors" property
then

my-address my-space encode-phys
    0 encode-int encode+
    0 encode-int encode+
    my-address my-space 2000010 + encode-phys encode+
    0 encode-int encode+
    1000000 encode-int encode+
    " reg" property

' aty-is-install is-install
' aty-is-remove is-remove

" ATY,264VT" device-name
" ATY,VT" model
" 113-XXXXX-10b14" encode-string " ATY,Rom#" property
" XXX-XXXXX-XX" encode-string " ATY,Mem#" property
" 102-XXXXX-XX" encode-string " ATY,Card#" property
" APL-1.0b11" encode-string " ATY,Fcode#" property

" "(4a 6f 79 21 70 65 66 66 70 77 70 63 00 00 00 01 ad a2 99 11 00 00 00 00 00 00 00 00 00 00 00 00 00 03 00 02 00 00 00 00 ff ff ff ff 00 00 00 00 00 00 6c f8 00 00 6c f8 00 00 6c f8 00 00 04 80 00 04 04 00 ff ff ff ff 00 00 00 00 00 00 21 bc 00 00 1d b0 00 00 17 73 00 00 71 80 02 01 04 00 ff ff ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 f8 00 00 00 80 04 04 04 00 6e 74 69 6e ff ff ff ff 00 00 00 00 ff ff ff ff 00 00 00 00 ff ff ff ff 00 00 00 00 00 00 00 04 00 00 00 1d 00 00 00 01 00 00 01 18 00 00 01 30 00 00 03 d4 00 00 00 01 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00 00 00 00 00 00 00 00 00 00 00 10 00 00 00 00 00 00 00 00 00 00 00 0e 00 00 00 0a 00 00 00 00 00 00 00 22 00 00 00 00 00 00 00 00 00 00 00 02 00 00 00 18)"
encode-bytes
" "(00 00 00 00 00 00 00 29 00 00 00 00 00 00 00 00 00 00 00 03 00 00 00 1a 00 00 00 00 02 00 00 3a 02 00 00 51 02 00 00 68 02 00 00 86 02 00 00 a5 02 00 00 bd 02 00 00 d5 02 00 00 e9 02 00 00 fd 02 00 01 14 02 00 01 2b 02 00 01 45 02 00 01 5b 02 00 01 6f 02 00 01 7d 02 00 01 86 02 00 01 8e 02 00 01 97 02 00 01 ac 02 00 01 bb 02 00 01 c5 02 00 01 db 02 00 01 e2 02 00 01 fa 02 00 02 10 02 00 02 25 02 00 02 3b 02 00 02 52 02 00 02 6d 00 01 00 00 00 00 00 0b 00 00 00 00 4a 1c 42 24 80 33 46 01 80 eb 40 0a a0 00 16 68 40 20 86 73 42 03 00 00 4e 61 6d 65 52 65 67 69 73 74 72 79 4c 69 62 00 44 72 69 76 65 72 53 65 72 76 69 63 65 73 4c 69 62 00 50 43 49 4c 69 62 00 56 69 64 65 6f 53 65 72 76 69 63 65 73 4c 69 62 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72)"
encode-bytes encode+
" "(74 79 43 72 65 61 74 65 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 44 65 6c 65 74 65 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 49 74 65 72 61 74 65 43 72 65 61 74 65 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 49 74 65 72 61 74 65 44 69 73 70 6f 73 65 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 49 74 65 72 61 74 65 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 47 65 74 53 69 7a 65 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 47 65 74 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 53 65 74 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 47 65 74 4d 6f 64 00 52 65 67 69 73 74 72 79 50 72 6f 70 65 72 74 79 53 65 74 4d 6f 64 00 49 6e 73 74 61 6c 6c 49 6e 74 65 72 72 75 70 74 46 75 6e 63 74 69 6f 6e 73)"
encode-bytes encode+
" "(00 47 65 74 49 6e 74 65 72 72 75 70 74 46 75 6e 63 74 69 6f 6e 73 00 49 4f 43 6f 6d 6d 61 6e 64 49 73 43 6f 6d 70 6c 65 74 65 00 53 79 6e 63 68 72 6f 6e 69 7a 65 49 4f 00 43 53 74 72 43 6f 70 79 00 43 53 74 72 43 6d 70 00 44 65 6c 61 79 46 6f 72 00 50 6f 6f 6c 41 6c 6c 6f 63 61 74 65 52 65 73 69 64 65 6e 74 00 50 6f 6f 6c 44 65 61 6c 6c 6f 63 61 74 65 00 42 6c 6f 63 6b 43 6f 70 79 00 53 65 74 50 72 6f 63 65 73 73 6f 72 43 61 63 68 65 4d 6f 64 65 00 55 70 54 69 6d 65 00 53 75 62 41 62 73 6f 6c 75 74 65 46 72 6f 6d 41 62 73 6f 6c 75 74 65 00 41 64 64 44 75 72 61 74 69 6f 6e 54 6f 41 62 73 6f 6c 75 74 65 00 45 78 70 4d 67 72 43 6f 6e 66 69 67 52 65 61 64 4c 6f 6e 67 00 45 78 70 4d 67 72 43 6f 6e 66 69 67 57 72 69 74 65 4c 6f 6e 67 00 56 53 4c 4e 65)"
encode-bytes encode+
" "(77 49 6e 74 65 72 72 75 70 74 53 65 72 76 69 63 65 00 56 53 4c 44 69 73 70 6f 73 65 49 6e 74 65 72 72 75 70 74 53 65 72 76 69 63 65 00 56 53 4c 44 6f 49 6e 74 65 72 72 75 70 74 53 65 72 76 69 63 65 00 54 68 65 44 72 69 76 65 72 44 65 73 63 72 69 70 74 69 6f 6e 44 6f 44 72 69 76 65 72 49 4f 00 00 00 00 04 00 00 00 04 00 01 00 14 bd e0 00 0a d1 fd 01 00 02 83 00 00 01 76 00 01 02 00 02 97 00 00 01 3c 00 01 20 4d 61 63 69 6e 74 6f 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff 90 3b e2 1d b0 3b c2 01 4c 80 7f 00 00 38 83 00 8c 38 a3 00 90 38 c3 00 94 38 e3 00 98 48 00 22 fd 60 00 00 00 80 7f 00 00 80 03 00 8c 54 00 07 bd 41 82 00 14 38 00 00 01 98 03 00 ae 80 7f 00 00 98 03 00 af 80 9f 00 00 88 04 00 ab 28 00 00 00 41 82 00 98 7c 83 23 78 38 81 00 48)"
encode-bytes encode+
" "(38 a0 00 00 48 00 09 01 60 00 00 00 7c 7d 1b 78 7f a0 07 35 41 82 00 38 80 7f 00 00 3b 80 00 00 9b 83 00 ab 80 7f 00 00 48 00 09 f5 60 00 00 00 80 7f 00 00 7f 85 e3 78 38 83 00 80 48 00 07 31 60 00 00 00 7c 7d 1b 78 48 00 00 5c a0 01 00 4c 80 7f 00 00 b0 03 00 84 a0 01 00 48 80 7f 00 00 b0 03 00 80 a0 01 00 4a 80 7f 00 00 b0 03 00 82 88 01 00 4f 80 7f 00 00 98 03 00 87 88 01 00 4e 80 7f 00 00 98 03 00 86 48 00 00 1c 7c 83 23 78 38 84 00 80 38 a0 00 00 48 00 06 d5 60 00 00 00 7c 7d 1b 78 7f a0 07 35 40 82 00 74 80 7f 00 00 a0 03 00 80 28 00 00 fe 40 82 00 0c a0 03 00 82 b0 03 00 80 80 7f 00 00 a0 83 00 80 a0 a3 00 84 48 00 1e 39 60 00 00 00 7c 7c 1b 78 80 7f 00 00 a0 83 00 80 48 00 22 7d 60 00 00 00 28 1c 00 00 41 82 00 28 54 60 07 ff 41 82 00 20)"
encode-bytes encode+
" "(80 7f 00 00 a0 03 00 84 90 03 00 70 80 7f 00 00 a0 03 00 80 90 03 00 6c 48 00 00 08 3b a0 ff ff 7f a0 07 35 41 82 00 1c 80 9f 00 00 38 00 00 80 80 64 00 94 90 64 00 6c 80 7f 00 00 90 03 00 70 80 9f 00 00 38 00 00 00 80 64 00 70 b0 64 00 84 80 9f 00 00 80 64 00 6c b0 64 00 80 80 7f 00 00 98 03 00 87 80 7f 00 00 80 03 00 88 98 03 00 86 80 7f 00 00 80 83 00 70 48 00 1b 7d 60 00 00 00 80 9f 00 00 90 64 00 74 80 7f 00 00 80 03 00 74 28 00 00 08 40 81 00 0c 38 00 00 01 98 03 00 b0 80 7f 00 00 38 00 00 00 90 03 00 08 80 9f 00 00 38 60 03 0a 90 04 00 7c 38 80 00 01 48 00 62 81 80 41 00 14 80 9f 00 00 90 64 00 08 80 7f 00 00 80 03 00 08 28 00 00 00 41 82 00 20 48 00 55 8d 60 00 00 00 80 9f 00 00 38 a0 03 0a 80 84 00 08 48 00 64 a5 80 41 00 14 80 7f 00 00)"
encode-bytes encode+
" "(48 00 21 e5 60 00 00 00 81 1f 00 00 7c 7d 1b 78 88 08 00 ab 28 00 00 00 40 82 00 2c 80 68 00 cc 80 88 00 04 80 08 00 ec a0 a3 00 14 80 c8 00 74 a0 e3 00 1c 7d 03 43 78 7c 84 02 14 48 00 22 81 60 00 00 00 80 9f 00 00 88 04 00 b0 28 00 00 00 41 82 00 14 7c 83 23 78 80 84 00 08 48 00 14 b9 60 00 00 00 80 7f 00 00 88 03 00 aa 28 00 00 00 41 82 00 1c 38 80 00 01 48 00 38 0d 60 00 00 00 80 7f 00 00 38 00 00 01 98 03 00 ad 80 7f 00 00 38 00 00 00 98 03 00 ab 80 7f 00 00 38 80 00 e4 48 00 3f 41 60 00 00 00 54 7c 07 7e 80 7f 00 00 38 80 00 b0 48 00 3f 2d 60 00 00 00 54 60 07 7e 54 00 80 1e 7c 00 e3 78 90 01 00 38 80 7f 00 00 7f c4 f3 78 38 63 00 10 38 a1 00 38 38 c0 00 04 48 00 62 b1 80 41 00 14 7c 60 07 35 41 82 00 20 80 7f 00 00 7f c4 f3 78 38 63 00 10)"
encode-bytes encode+
" "(38 a1 00 38 38 c0 00 04 48 00 62 a5 80 41 00 14 7f a3 eb 78 80 01 00 78 38 21 00 70 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 3b e2 1d b0 80 7f 00 00 80 63 00 08 28 03 00 00 41 82 00 18 48 00 61 d1 80 41 00 14 80 7f 00 00 38 00 00 00 90 03 00 08 38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 a8 03 00 1a 38 82 1d b0 7c 00 07 34 2c 00 00 08 41 82 01 00 40 80 00 40 2c 00 00 03 41 82 00 90 40 80 00 1c 2c 00 00 01 41 82 01 60 40 80 00 6c 2c 00 00 00 40 80 00 50 48 00 01 50 2c 00 00 06 41 82 00 a8 40 80 00 b8 2c 00 00 05 40 80 00 88 48 00 00 70 2c 00 00 10 41 82 01 08 40 80 00 1c 2c 00 00 0b 41 82 00 e8 40 80 01 20 2c 00 00 0a 40 80 00 c8 48 00 00 b0)"
encode-bytes encode+
" "(2c 00 00 80 41 82 00 f8 48 00 01 08 80 63 00 1c 80 84 00 00 48 00 43 4d 60 00 00 00 48 00 00 f8 80 63 00 1c 80 84 00 00 48 00 44 69 60 00 00 00 48 00 00 e4 80 63 00 1c 80 84 00 00 48 00 44 f1 60 00 00 00 48 00 00 d0 80 63 00 1c 80 84 00 00 48 00 46 69 60 00 00 00 48 00 00 bc 80 63 00 1c 80 84 00 00 48 00 47 95 60 00 00 00 48 00 00 a8 80 63 00 1c 80 84 00 00 48 00 48 05 60 00 00 00 48 00 00 94 80 63 00 1c 80 84 00 00 48 00 48 41 60 00 00 00 48 00 00 80 80 63 00 1c 80 84 00 00 48 00 48 65 60 00 00 00 48 00 00 6c 80 63 00 1c 80 84 00 00 48 00 49 3d 60 00 00 00 48 00 00 58 80 63 00 1c 80 84 00 00 48 00 44 1d 60 00 00 00 48 00 00 44 80 63 00 1c 80 84 00 00 48 00 4b 3d 60 00 00 00 48 00 00 30 80 63 00 1c 80 84 00 00 48 00 4a c9 60 00 00 00 48 00 00 1c)"
encode-bytes encode+
" "(80 63 00 1c 80 84 00 00 48 00 4b 85 60 00 00 00 48 00 00 08 38 60 ff ef 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 a8 03 00 1a 38 82 1d b0 7c 00 07 34 2c 00 00 0d 41 82 01 88 40 80 00 5c 2c 00 00 07 41 82 01 04 40 80 00 2c 2c 00 00 04 41 82 00 bc 40 80 00 14 2c 00 00 02 41 82 00 88 40 80 00 98 48 00 01 fc 2c 00 00 06 40 80 00 c8 48 00 00 b0 2c 00 00 0a 41 82 01 0c 40 80 00 10 2c 00 00 09 40 80 00 ec 48 00 00 d4 2c 00 00 0c 40 80 01 1c 48 00 01 04 2c 00 00 15 41 82 01 88 40 80 00 2c 2c 00 00 12 41 82 01 40 40 80 00 14 2c 00 00 10 41 82 01 48 40 80 01 1c 48 00 01 a4 2c 00 00 14 40 80 01 4c 48 00 01 98 2c 00 00 80 41 82 01 7c 40 80 01 8c 2c 00 00 1b 41 82 01 5c 48 00 01 80 80 63 00 1c 80 84 00 00 48 00 4a bd)"
encode-bytes encode+
" "(60 00 00 00 48 00 01 70 80 63 00 1c 80 84 00 00 48 00 4a d5 60 00 00 00 48 00 01 5c 80 63 00 1c 80 84 00 00 48 00 4a 85 60 00 00 00 48 00 01 48 80 63 00 1c 80 84 00 00 48 00 4b 75 60 00 00 00 48 00 01 34 80 63 00 1c 80 84 00 00 48 00 4b 95 60 00 00 00 48 00 01 20 80 63 00 1c 80 84 00 00 48 00 4b a9 60 00 00 00 48 00 01 0c 80 63 00 1c 80 84 00 00 48 00 4b bd 60 00 00 00 48 00 00 f8 80 63 00 1c 80 84 00 00 48 00 4b c9 60 00 00 00 48 00 00 e4 80 63 00 1c 80 84 00 00 48 00 4b c9 60 00 00 00 48 00 00 d0 80 63 00 1c 80 84 00 00 48 00 52 81 60 00 00 00 48 00 00 bc 80 63 00 1c 80 84 00 00 48 00 4f 45 60 00 00 00 48 00 00 a8 80 63 00 1c 80 84 00 00 48 00 50 05 60 00 00 00 48 00 00 94 80 63 00 1c 80 84 00 00 48 00 4b d5 60 00 00 00 48 00 00 80 80 63 00 1c)"
encode-bytes encode+
" "(80 84 00 00 48 00 4d 41 60 00 00 00 48 00 00 6c 80 63 00 1c 80 84 00 00 48 00 4b 89 60 00 00 00 48 00 00 58 80 63 00 1c 80 84 00 00 48 00 50 79 60 00 00 00 48 00 00 44 80 63 00 1c 80 84 00 00 48 00 51 71 60 00 00 00 48 00 00 30 80 63 00 1c 80 84 00 00 48 00 52 19 60 00 00 00 48 00 00 1c 80 63 00 1c 80 84 00 00 48 00 53 f1 60 00 00 00 48 00 00 08 38 60 ff ee 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff 80 7c 7c 1b 78 7c 9d 23 78 38 60 00 08 54 a0 06 3f 3b e2 01 55 90 61 00 64 41 82 00 7c 80 c1 00 64 7f e4 fb 78 7f a5 eb 78 38 7c 00 10 48 00 5d e1 80 41 00 14 7c 60 07 35 41 82 00 1c 80 c1 00 64 7f e4 fb 78 7f a5 eb 78 38 7c 00 10 48 00 5d d9 80 41 00 14 7f e4 fb 78 38 7c 00 10 38 a1 00 60 48 00 5d dd)"
encode-bytes encode+
" "(80 41 00 14 7c 7e 1b 78 7f c0 07 35 40 82 01 00 80 01 00 60 7f e4 fb 78 38 7c 00 10 60 05 00 20 48 00 5d d1 80 41 00 14 7c 7e 1b 78 48 00 00 e0 38 7c 00 10 38 81 00 5a 48 00 5e 19 80 41 00 14 38 61 00 5a 38 81 00 39 38 a1 00 38 48 00 5e 1d 80 41 00 14 7c 7e 1b 78 7f c0 07 35 40 82 00 a4 7f e3 fb 78 38 81 00 39 48 00 5e 19 80 41 00 14 7c 60 07 35 40 82 00 3c 7f e4 fb 78 7f a5 eb 78 38 7c 00 10 38 c1 00 64 48 00 5b e9 80 41 00 14 7c 7e 1b 78 7f c0 07 35 40 82 00 68 80 01 00 64 28 00 00 08 41 82 00 5c 3b c0 ff ce 48 00 00 54 38 7c 00 10 38 81 00 39 38 a1 00 60 48 00 5d 1d 80 41 00 14 7c 7e 1b 78 7f c0 07 35 40 82 00 28 80 01 00 60 54 00 06 b5 41 82 00 1c 38 7c 00 10 38 81 00 39 48 00 5d 3d 80 41 00 14 3b c0 ff ce 48 00 00 10 88 01 00 38 28 00 00 00)"
encode-bytes encode+
" "(41 82 ff 44 38 61 00 5a 48 00 5d 95 80 41 00 14 7f c3 f3 78 80 01 00 88 38 21 00 80 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff a0 7c 7c 1b 78 7c 9d 23 78 38 60 00 0c 54 a0 06 3f 3b e2 01 5a 90 61 00 40 41 82 00 78 80 c1 00 40 7f e4 fb 78 7f a5 eb 78 38 7c 00 10 48 00 5c 49 80 41 00 14 7c 60 07 35 41 82 00 1c 80 c1 00 40 7f e4 fb 78 7f a5 eb 78 38 7c 00 10 48 00 5c 41 80 41 00 14 7f e4 fb 78 38 7c 00 10 38 a1 00 38 48 00 5c 45 80 41 00 14 7c 7e 1b 78 7f c0 07 35 40 82 00 80 80 a1 00 38 7f e4 fb 78 38 7c 00 10 48 00 5c 3d 80 41 00 14 7c 7e 1b 78 48 00 00 64 7f e4 fb 78 38 7c 00 10 38 a1 00 3c 48 00 5c 39 80 41 00 14 80 81 00 3c 80 01 00 40 7c 7e 1b 78 7c 04 00 40 40 81 00 08 3b c0 ff ce 7f c0 07 35 40 82 00 20)"
encode-bytes encode+
" "(7f e4 fb 78 7f a5 eb 78 38 7c 00 10 38 c1 00 40 48 00 5a 69 80 41 00 14 7c 7e 1b 78 38 7c 00 10 7f e4 fb 78 48 00 5c 05 80 41 00 14 7f c3 f3 78 80 01 00 68 38 21 00 60 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff b0 7c 7e 1b 78 3b e2 01 69 38 00 00 01 7f e4 fb 78 90 01 00 38 38 7e 00 10 38 a1 00 38 38 c0 00 04 48 00 5b 55 80 41 00 14 7c 60 07 35 40 82 00 18 7f e4 fb 78 38 7e 00 10 38 a1 00 3c 48 00 5b 51 80 41 00 14 7c 60 07 35 40 82 00 18 80 a1 00 3c 7f e4 fb 78 38 7e 00 10 48 00 5b 4d 80 41 00 14 80 01 00 58 38 21 00 50 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 38 00 00 04 38 82 01 f6 90 01 00 38 38 a1 00 3c 38 c1 00 38 48 00 59 91 80 41 00 14 7c 60 07 35 41 82 00 0c 38 60 00 00)"
encode-bytes encode+
" "(48 00 00 08 80 61 00 3c 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c bf 2b 78 7f e3 fb 78 38 80 00 18 48 00 36 d1 60 00 00 00 54 60 06 3e 7f e3 fb 78 60 05 00 14 38 80 00 18 48 00 36 55 60 00 00 00 80 7f 00 54 38 03 00 01 90 1f 00 54 80 7f 00 50 48 00 5a 09 80 41 00 14 38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff b0 7c 7f 1b 78 38 00 00 04 38 82 02 03 90 01 00 38 38 7f 00 10 38 bf 00 58 38 c1 00 38 48 00 58 cd 80 41 00 14 38 00 00 18 38 82 02 0e 90 01 00 38 38 7f 00 10 38 bf 00 28 38 c1 00 38 48 00 58 ad 80 41 00 14 80 01 00 58 38 21 00 50 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff b0)"
encode-bytes encode+
" "(7c 7f 1b 78 3c 80 00 72 38 84 70 e0 3c 60 00 72 90 9f 00 5c 38 63 70 e0 90 7f 00 60 38 00 00 10 38 82 02 19 90 01 00 3c 38 7f 00 10 38 bf 00 5c 38 c1 00 3c 48 00 58 4d 80 41 00 14 38 00 00 04 38 82 02 2b 90 01 00 3c 38 7f 00 10 38 a1 00 38 38 c1 00 3c 48 00 58 2d 80 41 00 14 80 01 00 58 38 21 00 50 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 38 c2 1d b0 80 a6 00 00 80 85 00 00 38 04 00 01 90 05 00 00 80 86 00 00 80 04 00 00 2c 00 00 01 40 82 00 10 4b ff f3 25 60 00 00 00 48 00 00 08 38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 38 c2 1d b0 80 a6 00 00 80 85 00 00 38 04 ff ff 90 05 00 00 80 86 00 00 80 04 00 00 2c 00 00 00 40 82 00 10 4b ff f6 5d 60 00 00 00 48 00 00 08)"
encode-bytes encode+
" "(38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 38 60 00 00 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 90 81 00 6c 90 a1 00 70 90 c1 00 74 7c 7d 1b 78 7d 1e 43 78 90 e1 00 78 3b e2 1d b0 38 60 00 fc 38 80 00 01 48 00 57 1d 80 41 00 14 90 7f 00 00 80 9f 00 00 28 04 00 00 40 82 00 0c 38 60 ff a3 48 00 02 48 80 61 00 6c 80 01 00 70 90 64 00 10 90 04 00 14 80 61 00 74 80 01 00 78 90 64 00 18 90 04 00 1c 80 7f 00 00 b3 a3 00 20 80 7f 00 00 9b c3 00 ab 80 7f 00 00 38 63 00 10 4b ff fd 2d 80 9f 00 00 90 64 00 0c 80 7f 00 00 80 03 00 0c 90 03 00 04 80 7f 00 00 4b ff fe 31 80 7f 00 00 38 80 00 00 48 00 37 99 60 00 00 00 80 7f 00 00 38 80 00 e3 48 00 34 2d 60 00 00 00 54 60 06 36 2c 00 00 40 40 82 00 28 80 7f 00 00 38 80 00 a3)"
encode-bytes encode+
" "(48 00 34 11 60 00 00 00 60 65 00 08 80 7f 00 00 38 80 00 a3 48 00 33 99 60 00 00 00 3c a0 80 00 80 7f 00 00 38 a5 00 04 38 80 00 7c 48 00 35 19 60 00 00 00 80 7f 00 00 38 80 00 c7 48 00 33 d5 60 00 00 00 54 60 06 7e 80 7f 00 00 60 05 00 80 38 80 00 c7 48 00 33 59 60 00 00 00 80 7f 00 00 38 80 00 e3 48 00 33 ad 60 00 00 00 2c 03 00 40 40 82 00 2c 80 7f 00 00 38 80 00 b2 48 00 33 95 60 00 00 00 38 00 ff 20 7c 65 00 38 80 7f 00 00 38 80 00 b2 48 00 33 19 60 00 00 00 3c 80 53 44 80 7f 00 00 38 84 53 44 90 83 00 a4 80 7f 00 00 48 00 13 55 60 00 00 00 80 9f 00 00 90 64 00 88 80 7f 00 00 80 03 00 88 28 00 00 ff 40 81 00 1c 48 00 56 79 80 41 00 14 38 00 00 00 90 1f 00 00 38 60 ff ff 48 00 00 d4 4b ff fc a9 80 9f 00 00 80 04 00 58 28 00 00 00 40 82 00 08)"
encode-bytes encode+
" "(38 60 ff ff 7c 60 07 35 40 82 00 28 81 1f 00 00 80 68 00 28 80 88 00 2c 38 a8 00 4c 38 c8 00 40 38 e8 00 44 39 08 00 48 48 00 56 3d 80 41 00 14 7c 60 07 35 40 82 00 24 80 bf 00 00 38 e0 00 00 80 65 00 28 80 85 00 2c 80 c2 00 8c 7c e8 3b 78 48 00 56 45 80 41 00 14 7c 60 07 35 40 82 00 5c 80 df 00 00 80 66 00 28 80 86 00 2c 80 a6 00 4c 81 86 00 44 48 00 57 b9 80 41 00 14 3c 80 76 62 80 7f 00 00 38 00 00 01 98 03 00 aa 80 bf 00 00 38 84 6c 20 38 65 00 10 38 a5 00 50 48 00 56 11 80 41 00 14 7c 60 07 35 41 82 00 10 80 7f 00 00 38 00 00 00 90 03 00 50 38 60 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff b0 7d 1e 43 78 3b e2 1d b0 80 7f 00 00 28 03 00 00 41 82 01 0c 57 c0 06 3e 28 00 00 01)"
encode-bytes encode+
" "(40 82 00 5c 80 63 00 70 38 00 00 00 b0 61 00 3c 80 7f 00 00 38 81 00 38 80 63 00 6c 38 a0 00 01 b0 61 00 38 80 7f 00 00 80 63 00 c8 80 63 00 00 b0 61 00 3a 98 01 00 3f 80 7f 00 00 80 03 00 88 98 01 00 3e 80 7f 00 00 80 03 00 d8 90 01 00 40 80 7f 00 00 4b ff f8 f1 60 00 00 00 80 7f 00 00 88 03 00 aa 28 00 00 00 41 82 00 50 38 80 00 00 48 00 2a 4d 60 00 00 00 80 df 00 00 80 66 00 28 80 86 00 2c 80 a6 00 4c 81 86 00 48 48 00 56 a5 80 41 00 14 80 df 00 00 38 e0 00 00 80 66 00 28 80 86 00 2c 80 a6 00 4c 80 c6 00 40 7c e8 3b 78 48 00 54 e9 80 41 00 14 80 7f 00 00 80 63 00 50 28 03 00 00 41 82 00 0c 48 00 55 91 80 41 00 14 57 c0 06 3f 40 82 00 18 80 7f 00 00 38 80 00 1f 38 a0 00 01 48 00 30 d1 60 00 00 00 80 7f 00 00 48 00 54 61 80 41 00 14 38 00 00 00)"
encode-bytes encode+
" "(90 1f 00 00 38 60 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 7c 67 1b 78 a8 67 00 00 80 87 00 02 80 a7 00 06 80 c7 00 0a 80 e7 00 0e 39 00 00 00 4b ff fb e9 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 7c 67 1b 78 a8 67 00 00 80 87 00 02 80 a7 00 06 80 c7 00 0a 80 e7 00 0e 39 00 00 01 4b ff fb ad 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 7c 67 1b 78 a8 67 00 00 80 87 00 02 80 a7 00 06 80 c7 00 0a 80 e7 00 0e 39 00 00 00 4b ff fe 1d 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 7c 67 1b 78 a8 67 00 00 80 87 00 02 80 a7 00 06 80 c7 00 0a 80 e7 00 0e 39 00 00 01 4b ff fd e1)"
encode-bytes encode+
" "(80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 38 60 00 00 4e 80 00 20 38 60 00 00 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 4b ff f1 89 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 4b ff f3 0d 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 9e 23 78 7c ff 3b 78 90 a1 00 60 38 82 1d b0 80 e1 00 60 80 a4 00 00 38 80 00 00 28 05 00 00 41 82 00 08 90 65 00 24 28 06 00 0a 41 81 00 a8 38 62 02 38 54 c0 10 3a 7c 63 00 2e 7c 69 03 a6 4e 80 04 20 80 61 00 60 4b ff fe 61 48 00 00 a4 80 61 00 60 4b ff fe cd 48 00 00 98 80 61 00 60 4b ff fe 85 48 00 00 8c 80 61 00 60 4b ff fe f1 48 00 00 80 7c e3 3b 78 4b ff f9 99 48 00 00 74 7c e3 3b 78)"
encode-bytes encode+
" "(4b ff f9 dd 48 00 00 68 7c e3 3b 78 4b ff fa 21 48 00 00 5c 7c e3 3b 78 4b ff fe fd 7c 64 1b 78 48 00 00 30 7c e3 3b 78 4b ff fe f5 7c 64 1b 78 48 00 00 20 7c e3 3b 78 4b ff fe ed 7c 64 1b 78 48 00 00 10 7c e3 3b 78 4b ff ff 01 7c 64 1b 78 57 e0 07 7b 41 82 00 0c 7c 83 23 78 48 00 00 10 7f c3 f3 78 48 00 53 c1 80 41 00 14 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 54 60 06 3f 3b e2 1d b0 41 82 00 34 80 7f 00 00 38 80 00 18 48 00 2e 81 60 00 00 00 54 60 06 3e 54 00 07 ff 41 82 ff e8 48 00 00 30 48 00 00 10 38 60 ff ff 48 00 53 31 80 41 00 14 80 7f 00 00 38 80 00 18 48 00 2e 51 60 00 00 00 54 60 06 3e 54 00 07 ff 41 82 ff dc 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20)"
encode-bytes encode+
" "(7c 08 02 a6 bf 21 ff e4 90 01 00 08 94 21 ff a0 7c 79 1b 78 7c 9a 23 78 7c bb 2b 78 7c dc 33 78 7f 40 07 34 2c 00 ff ff 40 82 00 5c 3b a0 00 00 7f 7f 07 34 48 00 00 44 7f a0 07 34 54 1e 18 38 7c 9c f2 ae 7f 23 cb 78 48 00 27 d1 60 00 00 00 38 9e 00 02 38 be 00 04 38 de 00 06 7f 23 cb 78 7c 9c 22 14 7c bc 2a 14 7c dc 32 14 48 00 28 e1 60 00 00 00 3b bd 00 01 7f a0 07 34 7c 00 f8 00 41 80 ff b8 7f 40 07 35 41 80 00 5c 7f 23 cb 78 7f 44 d3 78 48 00 27 85 60 00 00 00 3b a0 00 00 7f 7f 07 34 48 00 00 34 7f a0 07 34 54 03 18 38 38 83 00 02 38 a3 00 04 38 c3 00 06 7f 23 cb 78 7c 9c 22 14 7c bc 2a 14 7c dc 32 14 48 00 28 81 60 00 00 00 3b bd 00 01 7f a0 07 34 7c 00 f8 00 41 80 ff c8 38 60 00 00 80 01 00 68 38 21 00 60 7c 08 03 a6 bb 21 ff e4 4e 80 00 20)"
encode-bytes encode+
" "(7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 38 60 00 01 4b ff fe 71 7f c3 f3 78 38 80 00 00 48 00 27 4d 60 00 00 00 3b e0 00 00 48 00 00 20 38 80 7f ff 7f c3 f3 78 7c 85 23 78 7c 86 23 78 48 00 27 81 60 00 00 00 3b ff 00 01 7f e0 07 34 2c 00 01 00 41 80 ff dc 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff b0 7c 7c 1b 78 38 62 1d b0 80 63 00 00 80 03 00 74 28 00 00 10 40 82 00 0c 3b a0 00 20 48 00 00 08 3b a0 01 00 38 60 00 01 4b ff fd e1 7f 83 e3 78 38 80 00 00 48 00 26 bd 60 00 00 00 3b c0 00 00 3b fd ff ff 48 00 00 2c 3c 60 00 01 38 63 ff ff 7c 1e 19 d6 7c c0 fb 96 7f 83 e3 78 7c c4 33 78 7c c5 33 78 48 00 26 e1 60 00 00 00 3b de 00 01 7c 1e e8 40 41 80 ff d4 80 01 00 58)"
encode-bytes encode+
" "(38 21 00 50 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 be a1 ff d4 90 01 00 08 94 21 ff 90 7c 79 1b 78 7c 9a 23 78 7c bb 2b 78 7c dc 33 78 3b a0 00 01 7f a3 eb 78 4b ff fd 55 38 62 1d b0 80 63 00 00 80 03 00 74 28 00 00 10 40 82 00 08 3b a0 00 08 7f 40 07 35 41 80 00 78 7f 40 07 34 7c 9d 01 d6 7f 23 cb 78 48 00 26 0d 60 00 00 00 3b e0 00 00 7f 77 07 34 48 00 00 4c 3b c0 00 00 7f e0 07 34 54 03 18 38 3a a3 00 02 3a c3 00 04 3b 03 00 06 48 00 00 20 7c 9c aa 2e 7c bc b2 2e 7c dc c2 2e 7f 23 cb 78 48 00 26 21 60 00 00 00 3b de 00 01 7f c0 07 34 7c 00 e8 40 41 80 ff dc 3b ff 00 01 7f e0 07 34 7c 00 b8 00 41 80 ff b0 7f 40 07 34 2c 00 ff ff 40 82 00 78 3b e0 00 00 7f 7a 07 34 48 00 00 60 7f e0 07 34 54 1b 18 38 7c 1c da ae 7f 23 cb 78 7c 9d 01 d6)"
encode-bytes encode+
" "(48 00 25 79 60 00 00 00 3b c0 00 00 3a fb 00 02 3b 1b 00 04 3b 7b 00 06 48 00 00 20 7c 9c ba 2e 7c bc c2 2e 7c dc da 2e 7f 23 cb 78 48 00 25 a1 60 00 00 00 3b de 00 01 7f c0 07 34 7c 00 e8 40 41 80 ff dc 3b ff 00 01 7f e0 07 34 7c 00 d0 00 41 80 ff 9c 80 01 00 78 38 21 00 70 7c 08 03 a6 ba a1 ff d4 4e 80 00 20 7c 08 02 a6 bf 41 ff e8 90 01 00 08 94 21 ff a0 7c 7a 1b 78 28 04 00 00 41 82 00 9c a8 04 00 06 a8 64 00 04 3b c4 00 0c 2c 00 00 03 a3 e4 00 08 7f de 1a 14 40 82 00 14 57 e0 04 3e 7f be 02 14 7f 9d 02 14 48 00 00 0c 7f dd f3 78 7f dc f3 78 38 60 00 01 4b ff fb d5 7f 43 d3 78 38 80 00 00 48 00 24 b1 60 00 00 00 3b 60 00 00 57 ff 04 3e 48 00 00 38 7c 9e d8 ae 7c 7d d8 ae 7c 1c d8 ae 7c 84 07 74 7c 65 07 74 7c 00 07 74 7f 43 d3 78 54 84 40 2e)"
encode-bytes encode+
" "(54 a5 40 2e 54 06 40 2e 48 00 24 c9 60 00 00 00 3b 7b 00 01 7c 1b f8 40 41 80 ff c8 48 00 00 10 38 62 1d b0 80 63 00 00 4b ff fd 55 80 01 00 68 38 21 00 60 7c 08 03 a6 bb 41 ff e8 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff b0 7c 7e 1b 78 88 1e 00 bd 28 00 00 00 41 82 00 c4 88 1e 00 ab 28 00 00 00 40 82 00 18 7f c3 f3 78 38 82 02 74 48 00 00 c1 60 00 00 00 48 00 00 a4 3b e0 00 01 88 7e 00 c4 57 e0 06 3e 7c 03 00 40 41 82 00 90 9b fe 00 c4 88 1e 00 ab 28 00 00 01 41 82 00 80 7f c3 f3 78 38 80 00 90 48 00 29 8d 60 00 00 00 57 e0 06 3f 7c 7f 1b 78 41 82 00 2c 7f c3 f3 78 38 82 02 6c 48 00 00 6d 60 00 00 00 7f c3 f3 78 38 80 00 b1 38 a0 00 23 48 00 28 f9 60 00 00 00 48 00 00 28 7f c3 f3 78 38 82 02 64 48 00 00 45 60 00 00 00 7f c3 f3 78)"
encode-bytes encode+
" "(38 80 00 b1 38 a0 00 35 48 00 28 d1 60 00 00 00 7f c3 f3 78 63 e5 00 40 38 80 00 90 48 00 28 bd 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7d 1b 78 7c 9e 23 78 88 1d 00 bd 28 00 00 00 41 82 00 40 7f a3 eb 78 38 80 00 91 38 a0 00 02 48 00 28 71 60 00 00 00 7f a3 eb 78 38 80 00 92 38 a0 00 40 48 00 28 5d 60 00 00 00 7f a3 eb 78 38 80 00 91 38 a0 00 00 48 00 28 49 60 00 00 00 7f a3 eb 78 38 80 00 33 48 00 24 55 60 00 00 00 3b e0 00 10 48 00 00 28 57 e3 04 3e 38 03 ff f0 54 00 08 3c 7c be 02 2e 7f a3 eb 78 7f e4 fb 78 48 00 00 75 60 00 00 00 3b ff 00 01 57 e0 04 3e 28 00 00 14 41 80 ff d4 88 1d 00 bd 28 00 00 00 41 82 00 40 7f a3 eb 78 38 80 00 91 38 a0 00 02 48 00 27 e1)"
encode-bytes encode+
" "(60 00 00 00 7f a3 eb 78 38 80 00 92 38 a0 00 42 48 00 27 cd 60 00 00 00 7f a3 eb 78 38 80 00 91 38 a0 00 00 48 00 27 b9 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff b0 7c 7c 1b 78 7c 9d 23 78 7f 83 e3 78 7c a4 2b 78 48 00 01 09 60 00 00 00 7c 7e 1b 78 48 00 2b 29 60 00 00 00 7f 83 e3 78 38 80 00 3c 48 00 23 7d 60 00 00 00 7f 83 e3 78 38 80 00 90 38 a0 00 00 48 00 27 4d 60 00 00 00 7f 83 e3 78 48 00 02 09 60 00 00 00 7f 83 e3 78 38 80 00 90 38 a0 00 04 48 00 27 2d 60 00 00 00 7f 83 e3 78 48 00 01 e9 60 00 00 00 7f 83 e3 78 38 80 00 00 48 00 02 35 60 00 00 00 7f 83 e3 78 38 80 00 00 48 00 02 25 60 00 00 00 3b e0 00 00 48 00 00 1c 7f 83 e3 78 57 a4 07 fe 48 00 02 0d 60 00 00 00)"
encode-bytes encode+
" "(57 bd fe 7e 3b ff 00 01 57 e0 04 3e 28 00 00 05 41 80 ff e0 3b e0 00 00 48 00 00 1c 7f 83 e3 78 57 c4 07 fe 48 00 01 e1 60 00 00 00 57 de fc 7e 3b ff 00 01 57 e0 04 3e 28 00 00 0d 41 80 ff e0 7f 83 e3 78 38 80 00 1e 48 00 22 b5 60 00 00 00 48 00 2a 4d 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 54 80 04 3e 28 00 03 e9 40 80 00 08 38 80 03 e9 54 80 04 3e 28 00 3e 1c 40 81 00 08 38 80 3e 1c 38 a0 00 03 48 00 00 0c 54 84 08 3c 38 a5 ff ff 54 80 04 3e 28 00 1f 48 41 80 ff f0 1c 60 00 2e 38 63 02 cc 38 00 05 98 7c 63 03 96 54 60 04 3e 28 00 01 01 40 81 00 0c 38 63 fe ff 48 00 00 08 38 60 00 00 54 a0 04 3e 54 63 06 3e 54 00 48 2c 7c 63 03 78 60 63 18 00 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78)"
encode-bytes encode+
" "(7c 9f 23 78 7f c3 f3 78 38 80 00 90 48 00 26 3d 60 00 00 00 57 e0 06 3e 38 80 ff fb 7c 63 20 38 54 00 10 3a 7c 05 1b 78 7f c3 f3 78 38 80 00 90 48 00 25 b5 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c 9f 23 78 7f c3 f3 78 38 80 00 90 48 00 25 dd 60 00 00 00 57 e0 06 3e 38 80 ff f7 7c 63 20 38 54 00 18 38 7c 05 1b 78 7f c3 f3 78 38 80 00 90 48 00 25 55 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff b0 7c 7f 1b 78 7f e3 fb 78 38 80 00 90 48 00 25 81 60 00 00 00 60 65 00 40 7f e3 fb 78 38 80 00 90 48 00 25 09 60 00 00 00 7f e3 fb 78 38 80 00 01 48 00 21 15 60 00 00 00 80 01 00 58 38 21 00 50)"
encode-bytes encode+
" "(7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 4b ff fe cd 7f e3 fb 78 38 80 00 00 4b ff ff 21 7f e3 fb 78 4b ff ff 79 7f e3 fb 78 38 80 00 01 4b ff ff 0d 7f e3 fb 78 4b ff ff 65 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 38 04 ff 80 38 62 06 f8 54 00 10 3a 7c 63 00 2e 4e 80 00 20 38 64 ff 83 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7d 1b 78 7c 9e 23 78 7f a3 eb 78 38 80 00 e3 48 00 24 ad 60 00 00 00 80 bd 00 d8 54 60 06 3e 54 00 06 36 2c 00 00 40 a0 9e 00 14 a0 7e 00 1c 7c c0 00 26 88 1d 00 bd 7c 64 19 d6 38 85 f0 00 7c 84 1b 96 28 00 00 00 54 c5 1f fe 3b e0 00 00 41 82 00 40 3c 60 00 01 80 1e 00 10 38 63 d6 d8 7c 03 03 96 7c 04 00 40 40 81 00 08)"
encode-bytes encode+
" "(7c 04 03 78 80 1e 00 00 28 00 00 14 40 82 00 18 80 7d 00 d8 3c 00 00 10 7c 03 00 40 40 82 00 08 38 80 00 01 80 1e 00 00 28 00 00 14 40 82 00 18 80 7d 00 d8 3c 00 00 10 7c 03 00 40 40 82 00 08 38 80 00 01 28 04 00 01 41 80 00 08 3b e0 00 80 28 04 00 02 41 80 00 08 3b e0 00 81 28 04 00 04 41 80 00 08 3b e0 00 82 88 1d 00 ae 28 00 00 00 41 82 00 10 28 1f 00 00 41 82 00 08 3b e0 00 80 54 a0 06 3f 40 82 00 5c 28 1f 00 82 41 80 00 24 80 1e 00 00 28 00 00 23 41 82 00 0c 28 00 00 0a 40 82 00 0c 3b e0 00 82 48 00 00 08 3b e0 00 81 28 1f 00 81 41 80 00 2c 80 1e 00 00 28 00 00 55 41 82 00 1c 28 00 00 50 41 82 00 14 28 00 00 1e 41 82 00 0c 28 00 00 4b 40 82 00 08 3b e0 00 80 7f a3 eb 78 38 80 00 e4 48 00 23 69 60 00 00 00 54 60 06 3e 54 00 07 7e 2c 00 00 02)"
encode-bytes encode+
" "(40 82 00 44 28 1f 00 81 41 80 00 14 80 1e 00 00 28 00 00 1e 40 82 00 08 3b e0 00 80 28 1f 00 82 41 80 00 24 80 1e 00 00 28 00 00 14 41 82 00 14 28 00 00 28 41 80 00 10 28 00 00 37 41 81 00 08 3b e0 00 81 7f e3 fb 78 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 38 62 02 7c 4e 80 00 20 80 04 00 00 2c 00 00 55 41 82 00 08 48 00 00 0c 38 60 00 00 4e 80 00 20 38 64 00 24 4e 80 00 20 7c 08 02 a6 bf 61 ff ec 90 01 00 08 94 21 ff b0 7c 7b 1b 78 7c 9c 23 78 7c bd 2b 78 28 1d 00 80 3b e0 00 00 40 80 00 0c 7f e3 fb 78 48 00 00 68 7f 63 db 78 4b ff ff a5 7c 7e 1b 78 48 00 00 3c 80 1e 00 00 7c 00 e0 40 40 82 00 20 7f 63 db 78 7f c4 f3 78 4b ff fd b1 7c 1d 18 40 41 81 00 24 3b e0 00 01 48 00 00 1c 7f 63 db 78 7f c4 f3 78 4b ff ff 71 7c 7e 1b 78)"
encode-bytes encode+
" "(28 1e 00 00 40 82 ff c4 57 e0 06 3f 41 82 00 0c 7f c3 f3 78 48 00 00 08 38 60 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 61 ff ec 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c 9f 23 78 7f c3 f3 78 38 80 00 c7 48 00 22 09 60 00 00 00 54 63 06 32 73 e0 00 36 7c 05 1b 78 7f c3 f3 78 38 80 00 c7 48 00 21 89 60 00 00 00 7f c3 f3 78 38 80 00 78 48 00 23 39 60 00 00 00 57 e0 06 3e 3c 80 fe 00 38 84 fd ff 54 00 07 39 7c 65 20 38 41 82 00 0c 3c 60 02 00 48 00 00 08 38 60 00 00 57 e0 06 3e 54 00 07 ff 7c a5 1b 78 41 82 00 0c 38 00 02 00 48 00 00 08 38 00 00 00 7c a5 03 78 7f c3 f3 78 38 80 00 78 48 00 22 bd 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0)"
encode-bytes encode+
" "(7c 7e 1b 78 7f c3 f3 78 38 80 00 78 48 00 22 ad 60 00 00 00 7c 7f 1b 78 7f c3 f3 78 38 80 00 c7 48 00 21 3d 60 00 00 00 57 e0 05 ad 54 63 07 7c 41 82 00 0c 38 00 00 01 48 00 00 08 38 00 00 00 7c 63 03 78 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c 9f 23 78 7f c3 f3 78 38 80 00 07 4b ff fe bd 7c 62 fa 14 88 83 01 08 7f c3 f3 78 4b ff fe ad 7f c3 f3 78 38 80 00 01 48 00 1c 81 60 00 00 00 7f c3 f3 78 4b ff ff 51 54 64 06 3e 57 e0 18 38 38 62 07 04 7c 00 22 14 7f e3 00 ae 7f c3 f3 78 38 80 00 07 4b ff fe 75 57 e3 06 3e 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff a0 7c 7c 1b 78 7c 9d 23 78 7c be 2b 78 38 80 00 00)"
encode-bytes encode+
" "(7f 83 e3 78 4b ff ff 59 7f 83 e3 78 38 80 00 01 4b ff ff 4d 7c 7f 1b 78 7f 83 e3 78 38 80 00 02 4b ff ff 3d 7f 83 e3 78 38 80 00 03 4b ff ff 31 38 00 00 07 98 1d 00 00 3b e0 00 17 9b fe 00 00 80 01 00 68 38 21 00 60 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff b0 7c 7f 1b 78 7f e3 fb 78 38 81 00 3d 38 a1 00 3c 4b ff ff 6d 88 01 00 3d 98 1f 00 a8 88 01 00 3c 98 1f 00 a9 88 01 00 3d 28 00 00 07 40 82 00 18 88 01 00 3c 28 00 00 3f 40 82 00 0c 38 60 ff ff 48 00 00 50 88 61 00 3d 38 e0 00 00 88 01 00 3c 54 63 40 2e 7c e4 3b 78 7c c3 02 14 38 60 00 01 38 00 00 0f 7c 09 03 a6 38 a2 04 bc 54 c6 04 3e 7c 05 22 2e 7c 06 00 40 40 82 00 0c 7c e3 3b 78 48 00 00 10 38 e7 00 01 38 84 00 02 42 00 ff e4 80 01 00 58 38 21 00 50)"
encode-bytes encode+
" "(7c 08 03 a6 83 e1 ff fc 4e 80 00 20 38 62 04 dc 38 c0 00 00 38 a2 1d b0 48 00 00 1c 84 03 00 0c 38 c6 00 01 54 04 08 3c 38 04 00 01 54 00 10 3a 7c 63 02 14 80 85 00 00 80 04 00 88 7c 06 00 40 40 82 ff dc 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff b0 7c 9c 23 78 7c bd 2b 78 7c de 33 78 7c ff 3b 78 4b ff ff a5 28 1c 00 00 41 82 00 0c 80 03 00 00 90 1c 00 00 28 1d 00 00 41 82 00 0c 80 03 00 04 90 1d 00 00 28 1f 00 00 41 82 00 0c 80 03 00 08 90 1f 00 00 28 1e 00 00 41 82 00 38 80 83 00 0c 38 63 00 10 48 00 00 14 80 03 00 04 54 00 07 7b 40 82 00 18 38 63 00 08 7c 80 23 78 28 00 00 00 38 84 ff ff 40 82 ff e4 80 03 00 00 90 1e 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0)"
encode-bytes encode+
" "(7c 7e 1b 78 7c 9f 23 78 4b ff ff 09 80 1e 00 88 38 83 00 10 28 00 00 0e 40 82 00 0c 38 60 00 23 48 00 00 38 80 63 00 0c 48 00 00 1c 80 04 00 00 7c 00 f8 40 40 82 00 0c 80 64 00 04 48 00 00 1c 38 84 00 08 7c 60 1b 78 28 00 00 00 38 63 ff ff 40 82 ff dc 38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff b0 7c 7e 1b 78 80 9e 00 6c 80 be 00 70 7f c3 f3 78 4b ff fb 0d 7c 64 1b 78 28 04 00 00 40 82 00 0c 38 60 ff ef 48 00 00 90 80 de 00 70 7f c3 f3 78 38 a0 00 00 38 e0 00 01 48 00 1b b1 60 00 00 00 3b e0 00 00 3c a0 00 01 3c 60 00 01 3c 80 00 01 b3 e1 00 3c 38 a5 ff ff b0 a1 00 3e 38 63 ff ff b0 61 00 40 38 84 ff ff 7f c3 f3 78 b0 81 00 42 38 c1 00 3c 38 80 ff ff 38 a0 00 01 4b ff f1 51)"
encode-bytes encode+
" "(60 00 00 00 38 00 00 ff b0 01 00 3c b3 e1 00 3e b3 e1 00 40 7f c3 f3 78 b3 e1 00 42 38 c1 00 3c 38 80 ff ff 38 a0 00 01 4b ff f1 25 60 00 00 00 7f e3 fb 78 80 01 00 58 38 21 00 50 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bd c1 ff b8 90 01 00 08 94 21 ff 80 7c af 2b 78 7c ce 33 78 7c f0 3b 78 3b a2 1d b0 80 7d 00 00 48 00 1a 91 60 00 00 00 80 7d 00 00 38 80 02 c4 48 00 1e 4d 60 00 00 00 7c 7c 1b 78 80 7d 00 00 38 80 02 c4 38 a0 ff ff 48 00 1e 0d 60 00 00 00 80 7d 00 00 38 80 02 c0 48 00 1e 25 60 00 00 00 7c 7b 1b 78 80 7d 00 00 38 80 02 c0 38 a0 00 00 48 00 1d e5 60 00 00 00 80 7d 00 00 38 80 02 c8 48 00 1d fd 60 00 00 00 7c 7a 1b 78 80 7d 00 00 38 80 02 c8 38 a0 ff ff 48 00 1d bd 60 00 00 00 80 7d 00 00 38 80 02 d0 48 00 1d d5 60 00 00 00)"
encode-bytes encode+
" "(55 c0 04 3e 2c 00 00 10 7c 79 1b 78 41 82 00 44 40 80 00 1c 2c 00 00 08 41 82 00 2c 40 80 00 48 2c 00 00 04 41 82 00 14 48 00 00 3c 2c 00 00 20 41 82 00 2c 48 00 00 30 3e 20 00 02 3a 31 02 02 48 00 00 24 3e 20 00 02 3a 31 02 02 48 00 00 18 3e 20 00 03 3a 31 03 03 48 00 00 0c 3e 20 00 06 3a 31 06 06 80 7d 00 00 7e 25 8b 78 38 80 02 d0 48 00 1d 35 60 00 00 00 80 7d 00 00 38 80 02 d4 48 00 1d 4d 60 00 00 00 7c 78 1b 78 3c a0 00 07 80 7d 00 00 38 a5 00 07 38 80 02 d4 48 00 1d 09 60 00 00 00 80 7d 00 00 38 80 02 d8 48 00 1d 21 60 00 00 00 7c 77 1b 78 3c a0 00 01 80 7d 00 00 38 a5 01 00 38 80 02 d8 48 00 1c dd 60 00 00 00 80 7d 00 00 38 80 03 08 48 00 1c f5 60 00 00 00 7c 76 1b 78 80 7d 00 00 38 80 03 08 38 a0 00 00 48 00 1c b5 60 00 00 00 80 7d 00 00)"
encode-bytes encode+
" "(38 80 03 30 48 00 1c cd 60 00 00 00 7c 75 1b 78 3c a0 01 00 80 7d 00 00 38 a5 00 03 38 80 03 30 48 00 1c 89 60 00 00 00 80 7d 00 00 48 00 18 d9 60 00 00 00 80 7d 00 00 38 80 02 a0 48 00 1c 95 60 00 00 00 7c 74 1b 78 80 7d 00 00 38 80 02 a0 38 a0 00 00 48 00 1c 55 60 00 00 00 80 7d 00 00 38 80 02 a4 48 00 1c 6d 60 00 00 00 7c 73 1b 78 55 fe 04 3e 80 7d 00 00 38 be ff ff 38 80 02 a4 48 00 1c 29 60 00 00 00 80 7d 00 00 38 80 02 ac 48 00 1c 41 60 00 00 00 7c 72 1b 78 80 7d 00 00 38 80 02 ac 38 a0 00 00 48 00 1c 01 60 00 00 00 80 7d 00 00 38 80 02 b0 48 00 1c 19 60 00 00 00 7c 71 1b 78 56 1f 04 3e 80 7d 00 00 38 bf ff ff 38 80 02 b0 48 00 1b d5 60 00 00 00 80 7d 00 00 38 80 01 00 48 00 1b ed 60 00 00 00 7c 70 1b 78 80 7d 00 00 38 80 01 00 80 03 00 f0)"
encode-bytes encode+
" "(80 a3 00 ec 54 00 e8 fe 54 a5 e8 fe 54 00 b0 12 7c a5 03 78 48 00 1b 99 60 00 00 00 80 7d 00 00 38 80 01 04 48 00 1b b1 60 00 00 00 7c 6f 1b 78 80 7d 00 00 38 80 01 04 38 a0 00 00 48 00 1b 71 60 00 00 00 80 7d 00 00 48 00 17 c1 60 00 00 00 80 7d 00 00 38 80 01 08 48 00 1b 7d 60 00 00 00 7c 6e 1b 78 80 7d 00 00 38 80 01 08 38 a0 00 00 48 00 1b 3d 60 00 00 00 3c a0 aa 56 80 7d 00 00 38 a5 aa 55 38 80 02 80 48 00 1b 25 60 00 00 00 3c a0 aa 56 80 7d 00 00 38 a5 aa 55 38 80 02 84 48 00 1b 0d 60 00 00 00 80 7d 00 00 7f e5 fb 78 38 80 01 14 48 00 1a f9 60 00 00 00 80 7d 00 00 7f c5 f3 78 38 80 01 10 48 00 1a e5 60 00 00 00 80 7d 00 00 48 00 17 35 60 00 00 00 80 7d 00 00 7f 85 e3 78 38 80 02 c4 48 00 1a c5 60 00 00 00 80 7d 00 00 7f 65 db 78 38 80 02 c4)"
encode-bytes encode+
" "(48 00 1a b1 60 00 00 00 80 7d 00 00 7f 45 d3 78 38 80 02 c8 48 00 1a 9d 60 00 00 00 80 7d 00 00 7f 25 cb 78 38 80 02 d0 48 00 1a 89 60 00 00 00 80 7d 00 00 7f 05 c3 78 38 80 02 d4 48 00 1a 75 60 00 00 00 80 7d 00 00 7e e5 bb 78 38 80 02 d8 48 00 1a 61 60 00 00 00 80 7d 00 00 7e c5 b3 78 38 80 03 08 48 00 1a 4d 60 00 00 00 80 7d 00 00 7e a5 ab 78 38 80 03 30 48 00 1a 39 60 00 00 00 80 7d 00 00 48 00 16 89 60 00 00 00 80 7d 00 00 7e 85 a3 78 38 80 02 a0 48 00 1a 19 60 00 00 00 80 7d 00 00 7e 65 9b 78 38 80 02 a4 48 00 1a 05 60 00 00 00 80 7d 00 00 7e 45 93 78 38 80 02 ac 48 00 19 f1 60 00 00 00 80 7d 00 00 7e 25 8b 78 38 80 02 b0 48 00 19 dd 60 00 00 00 80 7d 00 00 7e 05 83 78 38 80 01 00 48 00 19 c9 60 00 00 00 80 7d 00 00 7d e5 7b 78 38 80 01 04)"
encode-bytes encode+
" "(48 00 19 b5 60 00 00 00 80 7d 00 00 7d c5 73 78 38 80 01 04 48 00 19 a1 60 00 00 00 80 7d 00 00 48 00 15 f1 60 00 00 00 38 60 00 00 80 01 00 88 38 21 00 80 7c 08 03 a6 b9 c1 ff b8 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff b0 7c 7e 1b 78 7f c3 f3 78 38 80 00 e4 48 00 18 25 60 00 00 00 54 60 06 3e 54 00 07 7e 2c 00 00 04 40 82 01 d8 7f c3 f3 78 38 80 00 91 38 a0 00 06 48 00 17 9d 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 a0 48 00 17 89 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 0a 48 00 17 75 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 2d 48 00 17 61 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 12 48 00 17 4d 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 c6 48 00 17 39 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 16 48 00 17 25)"
encode-bytes encode+
" "(60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 0b 48 00 17 11 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 32 48 00 16 fd 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 c0 48 00 16 e9 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 2e 48 00 16 d5 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 00 48 00 16 c1 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 0e 48 00 16 ad 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 14 48 00 16 99 60 00 00 00 7f c3 f3 78 38 80 00 b1 48 00 16 ed 60 00 00 00 60 7f 00 20 7f c3 f3 78 7f e5 fb 78 38 80 00 b1 48 00 16 71 60 00 00 00 73 ff 00 df 7f c3 f3 78 7f e5 fb 78 38 80 00 b1 48 00 16 59 60 00 00 00 7f c3 f3 78 38 80 00 01 48 00 12 65 60 00 00 00 7f c3 f3 78 38 80 00 b2 48 00 16 9d 60 00 00 00 70 7f 00 fb 7f c3 f3 78 7f e5 fb 78)"
encode-bytes encode+
" "(38 80 00 b2 48 00 16 21 60 00 00 00 63 ff 00 04 7f c3 f3 78 7f e5 fb 78 38 80 00 b2 48 00 16 09 60 00 00 00 7f c3 f3 78 38 80 00 01 48 00 12 15 60 00 00 00 73 ff 00 fb 7f c3 f3 78 7f e5 fb 78 38 80 00 b2 48 00 15 e1 60 00 00 00 48 00 01 d8 7f c3 f3 78 38 80 00 e4 48 00 16 31 60 00 00 00 54 60 06 3e 54 00 07 7e 2c 00 00 02 41 82 00 24 7f c3 f3 78 38 80 00 e4 48 00 16 11 60 00 00 00 54 60 06 3e 54 00 07 7e 2c 00 00 03 40 82 00 d0 7f c3 f3 78 38 80 00 91 38 a0 00 06 48 00 15 89 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 a0 48 00 15 75 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 0a 48 00 15 61 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 2d 48 00 15 4d 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 12 48 00 15 39 60 00 00 00 7f c3 f3 78 38 80 00 92)"
encode-bytes encode+
" "(38 a0 00 c6 48 00 15 25 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 16 48 00 15 11 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 0b 48 00 14 fd 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 0e 48 00 14 e9 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 14 48 00 14 d5 60 00 00 00 48 00 00 cc 7f c3 f3 78 38 80 00 91 38 a0 00 0a 48 00 14 bd 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 36 48 00 14 a9 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 12 48 00 14 95 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 d5 48 00 14 81 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 16 48 00 14 6d 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 0b 48 00 14 59 60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 06 48 00 14 45 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 ad 48 00 14 31)"
encode-bytes encode+
" "(60 00 00 00 7f c3 f3 78 38 80 00 91 38 a0 00 0e 48 00 14 1d 60 00 00 00 7f c3 f3 78 38 80 00 92 38 a0 00 14 48 00 14 09 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 38 60 00 01 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff b0 7c 7c 1b 78 7c bd 2b 78 7f 83 e3 78 7f a4 eb 78 3b c0 00 0b 48 00 01 21 60 00 00 00 7c 7f 1b 78 7f 83 e3 78 38 80 00 90 38 a0 00 00 48 00 13 a9 60 00 00 00 7f 83 e3 78 38 80 00 0f 48 00 0f b5 60 00 00 00 7f 83 e3 78 38 80 00 91 38 a0 00 1a 48 00 13 85 60 00 00 00 57 e0 04 3e 7f 83 e3 78 7c 05 46 70 38 80 00 92 48 00 13 6d 60 00 00 00 7f 83 e3 78 38 80 00 91 38 a0 00 1e 48 00 13 59 60 00 00 00 7f 83 e3 78 57 e5 06 3e 38 80 00 92 48 00 13 45 60 00 00 00 7f 83 e3 78 38 80 00 e4 48 00 13 99)"
encode-bytes encode+
" "(60 00 00 00 54 60 07 7e 54 00 06 3e 28 00 00 04 41 82 00 0c 28 00 00 02 40 82 00 18 57 a0 04 3e 28 00 1f 40 41 81 00 08 48 00 00 08 63 de 00 10 7f 83 e3 78 38 80 00 91 38 a0 00 16 48 00 12 f5 60 00 00 00 7f 83 e3 78 7f c5 f3 78 38 80 00 92 48 00 12 e1 60 00 00 00 7f 83 e3 78 38 80 00 0f 48 00 0e ed 60 00 00 00 7f 83 e3 78 38 80 00 91 38 a0 00 00 48 00 12 bd 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff b0 7c 7e 1b 78 7c 9f 23 78 7f c3 f3 78 38 80 00 91 38 a0 00 08 48 00 12 7d 60 00 00 00 7f c3 f3 78 38 80 00 92 48 00 12 d1 60 00 00 00 57 e0 04 3e 28 00 04 2a 54 63 06 3e 40 80 00 08 3b e0 04 2a 57 e0 04 3e 28 00 34 f8 40 81 00 08 3b e0 34 f8 57 e0 04 3e 7c 60 19 d6 38 00 0b 30)"
encode-bytes encode+
" "(7c 03 03 96 90 01 00 3c 3c 00 43 30 90 01 00 38 c8 42 01 10 c8 21 00 38 c8 02 01 30 38 00 00 08 ec 61 10 28 3b e0 00 03 fc 03 00 40 40 81 00 0c 38 00 00 04 3b e0 00 02 c8 02 01 28 fc 03 00 40 40 81 00 0c 38 00 00 02 3b e0 00 01 c8 02 01 20 fc 03 00 40 40 81 00 0c 38 00 00 01 3b e0 00 00 54 00 06 3e 90 01 00 3c 3c 00 43 30 90 01 00 38 c8 22 01 10 c8 01 00 38 c8 42 01 18 ec 00 08 28 ec 03 00 32 fc 22 00 2a 48 00 34 21 57 e0 06 3e 54 63 06 3e 54 00 40 2e 7c 63 03 78 80 01 00 58 38 21 00 50 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c bf 2b 78 38 00 ff ff 7c 04 00 40 41 82 00 14 38 02 07 24 7c 60 22 14 88 63 00 00 48 00 00 44 7f c3 f3 78 38 80 00 1c 48 00 11 ad 60 00 00 00 70 64 00 b3 28 1f 00 00)"
encode-bytes encode+
" "(41 82 00 08 60 84 00 40 7c 62 fa 14 88 03 01 0c 7f c3 f3 78 7c 85 03 78 38 80 00 1c 48 00 11 1d 60 00 00 00 38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 88 03 00 f5 28 00 00 01 40 82 00 18 54 84 06 3e 54 a5 04 3e 4b ff fc f9 60 00 00 00 48 00 00 3c 88 03 00 f4 2c 00 00 01 41 82 00 14 40 80 00 2c 2c 00 00 00 40 80 00 14 48 00 00 20 4b ff e9 19 60 00 00 00 48 00 00 14 54 84 06 3e 54 a5 04 3e 4b ff fc bd 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 2c 03 00 10 41 82 00 34 40 80 00 1c 2c 03 00 08 41 82 00 20 40 80 00 34 2c 03 00 04 41 82 00 14 48 00 00 28 2c 03 00 20 41 82 00 18 48 00 00 1c 38 60 00 02 4e 80 00 20 38 60 00 03 4e 80 00 20 38 60 00 06 4e 80 00 20 38 60 00 00)"
encode-bytes encode+
" "(4e 80 00 20 7c 08 02 a6 be e1 ff dc 90 01 00 08 94 21 ff 90 7c 7c 1b 78 7c 97 23 78 7c bd 2b 78 7c de 33 78 7c ff 3b 78 7d 19 43 78 7d 3b 4b 78 7f 83 e3 78 38 80 00 e3 48 00 10 69 60 00 00 00 54 60 06 3e 54 00 06 36 2c 00 00 40 7f 83 e3 78 38 80 00 e3 7c 00 00 26 54 00 1f fe 98 01 00 38 48 00 10 41 60 00 00 00 54 60 06 3e 28 00 00 40 38 7c 00 10 38 82 01 38 7c 00 00 26 54 18 1f fe 38 a1 00 38 38 c0 00 04 48 00 33 c9 80 41 00 14 2c 03 00 00 41 82 00 1c 38 7c 00 10 38 82 01 38 38 a1 00 38 38 c0 00 04 48 00 33 c1 80 41 00 14 a0 77 00 16 28 03 ff ff 40 81 00 0c 3b 40 00 02 48 00 00 08 3b 40 00 01 57 60 06 3f 9b 5c 00 c3 41 82 02 38 54 60 e8 fe 7c 80 d3 96 7f 83 e3 78 38 a4 ff ff 38 80 00 00 48 00 0f 55 60 00 00 00 a0 17 00 14 7f 83 e3 78 7c 00 1e 70)"
encode-bytes encode+
" "(7c 00 01 94 7c 80 d3 96 38 a4 ff ff 38 80 00 02 48 00 0f 31 60 00 00 00 a0 77 00 1a a0 17 00 0c 7c 63 1e 70 7c 63 01 94 7c a3 d3 96 54 00 07 ff 40 82 00 08 38 a5 00 20 7f 83 e3 78 38 80 00 06 48 00 0f 01 60 00 00 00 a0 97 00 1e 7f 83 e3 78 38 a4 ff ff 38 80 00 08 48 00 10 2d 60 00 00 00 a0 97 00 1c 7f 83 e3 78 38 a4 ff ff 38 80 00 0a 48 00 10 15 60 00 00 00 a0 77 00 20 a0 17 00 1c 38 a3 ff ff 7f 83 e3 78 7c a0 2a 14 38 80 00 0c 48 00 0f f5 60 00 00 00 a0 17 00 0c a0 b7 00 22 54 00 07 bd 40 82 00 08 38 a5 00 20 7f 83 e3 78 38 80 00 0e 48 00 0e 8d 60 00 00 00 80 b7 00 10 7f 83 e3 78 7f e4 07 74 38 dc 00 f8 48 00 05 b5 60 00 00 00 7c 7b 1b 78 7f 83 e3 78 7f 65 db 78 38 80 00 90 48 00 0e 5d 60 00 00 00 7f 83 e3 78 63 65 00 40 38 80 00 90 48 00 0e 49)"
encode-bytes encode+
" "(60 00 00 00 7f 83 e3 78 38 80 00 44 38 a0 00 00 48 00 0f cd 60 00 00 00 7f 83 e3 78 38 80 00 48 38 a0 00 00 48 00 0f b9 60 00 00 00 7f 83 e3 78 38 80 00 40 38 a0 00 00 48 00 0f a5 60 00 00 00 7f 83 e3 78 38 80 00 1c 48 00 0e 61 60 00 00 00 a0 17 00 0a 38 80 ff dc 54 00 07 bd 7c 7b 20 38 41 82 00 08 63 7b 00 02 a0 17 00 0a 54 00 07 7b 41 82 00 74 7f 83 e3 78 63 7b 00 01 38 80 00 08 48 00 0f 35 60 00 00 00 54 65 08 3c 7f 83 e3 78 38 80 00 08 48 00 0e f5 60 00 00 00 7f 83 e3 78 38 80 00 0a 48 00 0f 11 60 00 00 00 54 65 08 3c 7f 83 e3 78 38 80 00 0a 48 00 0e d1 60 00 00 00 7f 83 e3 78 38 80 00 0c 48 00 0e ed 60 00 00 00 54 65 08 3c 7f 83 e3 78 38 80 00 0c 48 00 0e ad 60 00 00 00 7f 83 e3 78 7f 65 db 78 38 80 00 1c 48 00 0d 55 60 00 00 00 a0 97 00 1c)"
encode-bytes encode+
" "(7f 83 e3 78 38 a4 ff f0 38 80 00 10 48 00 0e 81 60 00 00 00 7f 83 e3 78 88 9c 00 bc 48 00 06 09 60 00 00 00 a0 17 00 18 a0 77 00 14 7c 00 ca 14 7c 03 02 14 54 00 e8 fe 7c 80 d3 96 7f 83 e3 78 38 a4 ff ff 38 80 00 04 48 00 0d 01 60 00 00 00 7f 83 e3 78 57 25 07 7e 38 80 00 05 48 00 0c ed 60 00 00 00 80 97 00 10 7f 83 e3 78 7f e5 07 74 48 00 04 5d 60 00 00 00 88 01 00 38 7c 79 1b 78 28 00 00 00 41 82 00 10 80 19 00 18 54 1b 07 3e 48 00 00 0c 80 19 00 0c 70 1b 00 2f 7f 83 e3 78 7f 65 db 78 38 80 00 1e 48 00 0c a1 60 00 00 00 7f 83 e3 78 38 80 00 1d 48 00 0c f5 60 00 00 00 88 01 00 38 54 7b 06 be 28 00 00 00 41 82 00 10 80 19 00 18 54 00 06 32 48 00 00 0c 80 19 00 0c 54 00 06 32 7f 7b 03 78 7f 83 e3 78 7f 65 db 78 38 80 00 1d 48 00 0c 55 60 00 00 00)"
encode-bytes encode+
" "(57 00 06 3f 88 61 00 38 38 00 00 00 40 82 00 08 38 00 00 01 7c 60 00 39 41 82 00 f4 7f 83 e3 78 38 80 00 5c 48 00 0e 11 60 00 00 00 54 7b 04 3e 7f 83 e3 78 38 80 01 40 48 00 0d fd 60 00 00 00 54 60 07 ff 41 82 00 0c 3c 60 01 00 48 00 00 08 38 60 00 00 80 19 00 18 7f 7b 1b 78 54 00 06 f7 41 82 00 0c 3c 60 00 01 48 00 00 08 38 60 00 00 80 19 00 18 7f 7b 1b 78 54 00 05 ef 41 82 00 0c 3c 00 00 02 48 00 00 08 38 00 00 00 7f 7b 03 78 7f 83 e3 78 7f 65 db 78 38 80 00 5c 48 00 0d 49 60 00 00 00 7f 83 e3 78 38 80 00 5c 48 00 0d 89 60 00 00 00 80 19 00 18 3c 80 ef 00 38 84 ff ff 54 00 06 f7 7c 7b 20 38 41 82 00 0c 3c 60 01 00 48 00 00 08 38 60 00 00 80 19 00 18 7f 7b 1b 78 54 00 05 ef 41 82 00 0c 3c 00 10 00 48 00 00 08 38 00 00 00 7f 7b 03 78 7f 83 e3 78)"
encode-bytes encode+
" "(7f 65 db 78 38 80 00 5c 48 00 0d 5d 60 00 00 00 57 00 06 3f 41 82 00 fc 83 79 00 18 7f 83 e3 78 38 80 00 e4 48 00 0b 91 60 00 00 00 54 60 06 3e 54 00 07 7e 2c 00 00 04 40 82 00 48 3b 7b 00 02 2c 1b 00 1f 40 81 00 08 3b 60 00 1f 80 19 00 04 2c 00 00 10 40 82 00 10 80 19 00 08 2c 00 27 10 40 80 00 1c 80 19 00 04 2c 00 00 20 40 82 00 14 80 19 00 08 2c 00 0f a0 41 80 00 08 3b 7b 00 01 7f 83 e3 78 38 80 00 1e 48 00 0b 2d 60 00 00 00 54 63 06 36 57 60 07 3e 7c 05 1b 78 7f 83 e3 78 38 80 00 1e 48 00 0a ad 60 00 00 00 7f 83 e3 78 38 80 00 5c 48 00 0c 5d 60 00 00 00 3c 80 ff fd 38 84 ff ff 57 60 06 f7 7c 7b 20 38 41 82 00 0c 3c 60 00 01 48 00 00 08 38 60 00 00 80 19 00 18 7f 7b 1b 78 54 00 05 ef 41 82 00 0c 3c 00 00 02 48 00 00 08 38 00 00 00 7f 7b 03 78)"
encode-bytes encode+
" "(7f 83 e3 78 7f 65 db 78 38 80 00 5c 48 00 0b e1 60 00 00 00 7f 83 e3 78 38 80 00 df 48 00 0a 9d 60 00 00 00 88 01 00 38 54 7b 06 32 28 00 00 00 41 82 00 0c 38 00 00 3f 48 00 00 0c 80 19 00 14 54 00 06 be 7f 7b 03 78 7f 83 e3 78 7f 65 db 78 38 80 00 df 48 00 0a 01 60 00 00 00 7f 83 e3 78 38 80 00 b0 48 00 0b b1 60 00 00 00 3c 80 ff a0 38 84 ff ff 57 00 06 3f 7c 7b 20 38 40 82 00 40 80 19 00 14 7f 83 e3 78 54 00 06 32 54 00 78 20 7f 7b 03 78 38 80 00 e4 48 00 0a 21 60 00 00 00 54 60 06 3e 54 00 07 7e 2c 00 00 04 40 82 00 10 57 00 06 3f 40 82 00 08 67 7b 00 20 7f 83 e3 78 7f 65 db 78 38 80 00 b0 48 00 0b 25 60 00 00 00 28 1a 00 01 7f e3 07 74 41 82 00 18 2c 03 00 08 40 82 00 0c 38 60 00 10 48 00 00 08 38 60 00 20 4b ff f8 dd 7c 65 1b 78 7f 83 e3 78)"
encode-bytes encode+
" "(38 80 00 1d 48 00 09 55 60 00 00 00 88 1c 00 c0 28 00 00 00 41 82 00 38 7f e3 07 74 4b ff f8 b5 54 77 07 7e 7f 83 e3 78 38 80 00 b3 48 00 09 91 60 00 00 00 54 60 06 38 7c 05 bb 78 7f 83 e3 78 38 80 00 b3 48 00 09 15 60 00 00 00 57 c0 04 3e 7c 00 d3 96 54 00 e8 fe 54 00 b0 12 90 1c 00 9c 57 a0 e8 fe 90 1c 00 a0 80 9c 00 a0 80 1c 00 9c 7f 83 e3 78 7c 85 03 78 38 80 00 14 48 00 0a 75 60 00 00 00 80 01 00 78 38 21 00 70 7c 08 03 a6 ba e1 ff dc 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c dd 33 78 3b c0 00 00 7c bf 2b 78 7f c4 f3 78 4b ff f7 a5 60 00 00 00 b3 fd 00 00 7f c3 f3 78 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 bf 01 ff e0 90 01 00 08 94 21 ff a0 7c 7e 1b 78 7c 98 23 78 7c b9 2b 78 3b 82 16 28)"
encode-bytes encode+
" "(3b a2 10 e8 7f c3 f3 78 38 80 00 b0 48 00 0a 11 60 00 00 00 54 7b 07 7e 7f c3 f3 78 38 80 00 e4 48 00 08 a1 60 00 00 00 54 63 07 7e 54 60 06 3e 2c 00 00 03 41 82 00 38 40 80 00 14 2c 00 00 01 41 82 00 24 40 80 00 18 48 00 00 24 2c 00 00 05 40 80 00 1c 3b e2 0c a4 48 00 00 18 3b e2 07 2c 48 00 00 10 7f bf eb 78 48 00 00 08 7f bf eb 78 28 1b 00 03 40 82 00 08 3b 60 00 02 54 60 06 3e 54 00 80 1e 3b 40 00 00 7f 5d d3 78 7c 05 db 78 57 24 04 3e 57 03 04 3e 48 00 00 7c 7c 1f e8 2e 7c 05 00 00 40 82 00 68 38 1d 00 04 7c 1f 00 2e 7c 04 00 00 40 82 00 58 38 1d 00 08 7c 1f 00 2e 7c 00 18 00 41 80 00 48 7f 84 e3 78 38 7e 00 10 7c bf ea 14 38 c0 00 1c 48 00 2b 99 80 41 00 14 2c 03 00 00 41 82 00 1c 7f 84 e3 78 38 7e 00 10 7c bf ea 14 38 c0 00 1c 48 00 2b 91)"
encode-bytes encode+
" "(80 41 00 14 1c 1a 00 1c 7c 7f 02 14 48 00 00 1c 3b 5a 00 01 3b bd 00 1c 7c 1f e8 2e 2c 00 ff ff 40 82 ff 80 7f e3 fb 78 80 01 00 68 38 21 00 60 7c 08 03 a6 bb 01 ff e0 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 54 85 07 be 38 80 ff ff 48 00 00 c9 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 88 03 00 aa 28 00 00 00 41 82 00 24 54 80 06 3f 41 82 00 0c 38 a0 00 06 48 00 00 08 38 a0 00 00 38 80 00 18 48 00 06 c9 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 88 63 00 f5 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 4b ff ff e1 88 1f 00 f6 7c 03 1b 78 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0)"
encode-bytes encode+
" "(38 80 00 c0 48 00 06 c5 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7d 1b 78 7c 9e 23 78 7c bf 2b 78 7f a3 eb 78 4b ff ff 81 54 60 06 3e 2c 00 00 01 41 82 00 30 40 80 00 48 2c 00 00 00 40 80 00 08 48 00 00 3c 7f a3 eb 78 7f c4 f3 78 7f e5 fb 78 4b ff f4 79 60 00 00 00 7c 7f 1b 78 48 00 00 24 7f a3 eb 78 7f c4 f3 78 7f e5 fb 78 4b ff f4 5d 60 00 00 00 7c 7f 1b 78 48 00 00 08 3b e0 00 00 7f a3 eb 78 4b ff ff 59 7f e3 fb 78 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c 9f 23 78 7f c3 f3 78 38 80 00 c4 38 a0 00 00 48 00 05 89 60 00 00 00 7f c3 f3 78 7f e5 fb 78 38 80 00 c3 48 00 05 75 60 00 00 00 80 01 00 48)"
encode-bytes encode+
" "(38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c 9f 23 78 7f c3 f3 78 38 80 00 c4 38 a0 00 00 48 00 05 35 60 00 00 00 7f c3 f3 78 7f e5 fb 78 38 80 00 c0 48 00 05 21 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7d 1b 78 7c be 2b 78 7c df 33 78 54 80 04 3e 7f a3 eb 78 7c 05 46 70 38 80 00 c1 48 00 04 d9 60 00 00 00 57 c0 04 3e 7f a3 eb 78 7c 05 46 70 38 80 00 c1 48 00 04 c1 60 00 00 00 57 e0 04 3e 7f a3 eb 78 7c 05 46 70 38 80 00 c1 48 00 04 a9 60 00 00 00 7f a3 eb 78 38 80 00 c2 38 a0 00 ff 48 00 04 95 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08)"
encode-bytes encode+
" "(94 21 ff b0 7c 7c 1b 78 7c 9d 23 78 7c be 2b 78 7c df 33 78 7f 83 e3 78 38 80 00 c1 48 00 04 b5 60 00 00 00 54 63 06 3e 54 60 40 2e 7c 00 1a 14 7f 83 e3 78 b0 1d 00 00 38 80 00 c1 48 00 04 95 60 00 00 00 54 63 06 3e 54 60 40 2e 7c 00 1a 14 7f 83 e3 78 b0 1e 00 00 38 80 00 c1 48 00 04 75 60 00 00 00 54 63 06 3e 54 60 40 2e 7c 00 1a 14 b0 1f 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff a0 7c 9f 23 78 38 61 00 40 48 00 27 21 80 41 00 14 80 a1 00 40 80 c1 00 44 38 61 00 50 57 e4 04 3e 48 00 27 21 80 41 00 14 38 61 00 38 48 00 26 fd 80 41 00 14 80 81 00 38 80 a1 00 3c 80 c1 00 50 80 e1 00 54 38 61 00 48 48 00 27 11 80 41 00 14 80 01 00 48 2c 00 00 00 41 80 ff d0 80 01 00 68 38 21 00 60)"
encode-bytes encode+
" "(7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 38 80 00 d1 38 a0 00 00 48 00 03 45 60 00 00 00 7f e3 fb 78 38 80 00 d1 38 a0 00 03 48 00 03 31 60 00 00 00 7f e3 fb 78 38 80 03 38 38 a0 00 00 48 00 04 b5 60 00 00 00 7f e3 fb 78 38 80 03 10 38 a0 00 00 48 00 04 a1 60 00 00 00 7f e3 fb 78 38 80 00 a0 48 00 04 b9 60 00 00 00 3c 80 ff 60 38 84 ff ff 7c 60 20 38 64 05 00 a0 7f e3 fb 78 38 80 00 a0 48 00 04 71 60 00 00 00 7f e3 fb 78 38 80 00 d1 38 a0 00 00 48 00 02 c5 60 00 00 00 7f e3 fb 78 38 80 00 d1 38 a0 00 03 48 00 02 b1 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 4b ff ff 19 7f e3 fb 78)"
encode-bytes encode+
" "(48 00 00 69 60 00 00 00 7f e3 fb 78 48 00 00 1d 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 38 80 03 38 48 00 03 f1 60 00 00 00 54 60 07 ff 40 82 ff ec 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 38 80 03 10 48 00 03 b1 60 00 00 00 54 60 04 3f 40 82 ff ec 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 88 03 00 c0 38 60 00 00 28 00 00 00 41 82 00 08 3c 63 00 80 3c a0 00 20 7c 05 23 96 7c 00 21 d6 7c 00 28 50 7c 63 02 14 4e 80 00 20 7c 08 02 a6 bf 61 ff ec 90 01 00 08 94 21 ff a0 7c 7b 1b 78 7c 9c 23 78 7c fd 3b 78 28 05 00 00 41 82 00 0c 90 bb 00 c8)"
encode-bytes encode+
" "(48 00 00 1c 57 a0 06 3f 41 82 00 14 80 1c 00 00 28 00 00 fe 41 82 00 08 93 9b 00 c8 90 db 00 d0 7f 63 db 78 7c c4 33 78 93 9b 00 cc 4b ff dc dd 60 00 00 00 7c 7e 1b 78 38 62 16 30 57 c0 10 3a 7f e3 00 2e 28 1f 00 08 93 fb 00 d4 41 81 00 10 38 00 00 00 98 1b 00 b0 48 00 00 0c 38 00 00 01 98 1b 00 b0 a0 1c 00 14 7f 63 db 78 7c 00 f9 d6 54 04 e8 fe 38 04 00 3f 54 00 00 32 90 1b 00 78 80 1b 00 78 54 00 18 38 7c 00 fb 96 90 1b 00 f0 93 fb 00 74 83 9b 00 c8 80 9b 00 78 4b ff ff 11 90 7b 00 ec 88 1b 00 ab 28 00 00 00 40 82 00 18 7f 63 db 78 38 80 00 1f 38 a0 00 01 48 00 00 bd 60 00 00 00 80 1b 00 6c 28 00 00 23 40 82 00 20 28 1f 00 08 41 81 00 18 7f 63 db 78 38 80 00 01 4b ff d7 05 60 00 00 00 48 00 00 14 7f 63 db 78 38 80 00 00 4b ff d6 f1 60 00 00 00)"
encode-bytes encode+
" "(a0 1c 00 0a 38 a0 00 00 54 00 07 ff 40 82 00 10 80 1b 00 8c 54 00 07 ff 41 82 00 08 38 a0 00 01 7f 63 db 78 7f c4 f3 78 4b ff fa 0d 60 00 00 00 7c 68 1b 78 80 bb 00 ec 80 db 00 f0 7f 63 db 78 7f 84 e3 78 7f e7 fb 78 7f a9 eb 78 4b ff ef f9 60 00 00 00 7f 63 db 78 38 80 00 1f 38 a0 00 03 48 00 00 1d 60 00 00 00 80 01 00 68 38 21 00 60 7c 08 03 a6 bb 61 ff ec 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 54 87 04 3e 28 07 00 90 40 82 00 2c 88 03 00 bd 28 00 00 00 40 82 00 20 88 03 00 bf 28 00 00 02 40 80 00 14 54 a0 06 3e 80 c3 00 e8 54 00 c0 0e 7c 06 39 2e 80 63 00 e8 54 80 04 3e 7c a3 01 ae 48 00 22 f1 80 41 00 14 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 80 63 00 e8 54 80 04 3e 7c 63 00 ae 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0)"
encode-bytes encode+
" "(54 a0 06 3e 54 06 40 2e 54 a0 c6 3e 7c 06 02 14 7c 03 23 2e 48 00 22 a9 80 41 00 14 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 54 a7 86 3e 54 a0 c6 3e 54 a6 06 3e 54 e7 40 2e 54 00 80 1e 54 a8 46 3e 7c 00 3a 14 54 c5 c0 0e 7c 00 42 14 7c 05 02 14 7c 03 21 2e 48 00 22 59 80 41 00 14 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 83 22 2e 54 80 06 3e 54 03 40 2e 54 80 c6 3e 7c 63 02 14 4e 80 00 20 7c a3 20 2e 54 a4 86 3e 54 a0 c6 3e 54 a3 06 3e 54 84 40 2e 54 00 80 1e 54 a5 46 3e 7c 00 22 14 54 64 c0 0e 7c 60 2a 14 7c 64 1a 14 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 80 63 00 e8 54 84 04 3e 54 a5 04 3e 4b ff ff 19 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0)"
encode-bytes encode+
" "(80 63 00 e8 54 84 04 3e 4b ff ff 79 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 80 63 00 e8 54 84 04 3e 4b ff ff 01 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 80 63 00 e8 54 84 04 3e 4b ff ff 41 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 80 63 00 e8 54 84 04 3e 38 63 ff 00 4b ff ff 15 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 80 63 00 e8 54 84 04 3e 38 63 ff 00 4b ff fe 81 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff b0 7c 7f 1b 78 7c 9c 23 78 57 80 04 3e 38 62 16 48 54 00 10 3a 7f c3 00 2e 80 1f 00 0c 7f e3 fb 78 7f be 02 14 3b bd e0 00)"
encode-bytes encode+
" "(38 80 00 b0 4b ff fd e9 60 00 00 00 54 63 00 38 57 80 07 7e 7c 05 1b 78 7f e3 fb 78 38 80 00 b0 4b ff fd 69 60 00 00 00 38 a0 00 00 38 80 00 55 48 00 00 14 54 a0 06 3e 7c 60 e8 50 98 83 00 00 38 a5 00 01 54 a0 06 3e 28 00 00 10 41 80 ff e8 38 a0 00 00 48 00 00 24 54 a0 06 3e 7c 60 e8 50 88 03 00 00 28 00 00 55 41 82 00 0c 38 60 00 00 48 00 00 1c 38 a5 00 01 54 a0 06 3e 28 00 00 10 41 80 ff d8 93 df 00 d8 38 60 00 01 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 88 1f 00 bd 28 00 00 00 41 82 00 3c 7f e3 fb 78 38 80 00 03 4b ff ff 01 54 60 06 3f 40 82 00 10 7f e3 fb 78 38 80 00 02 4b ff fe ed 54 60 06 3f 40 82 00 48 7f e3 fb 78 38 80 00 01 4b ff fe d9 48 00 00 38 7f e3 fb 78)"
encode-bytes encode+
" "(38 80 00 04 4b ff fe c9 54 60 06 3f 40 82 00 10 7f e3 fb 78 38 80 00 03 4b ff fe b5 54 60 06 3f 40 82 00 10 7f e3 fb 78 38 80 00 02 4b ff fe a1 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 4e 80 00 20 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff b0 7c 7f 1b 78 4b ff ff e5 38 7f 00 10 38 a1 00 3c 38 80 00 00 48 00 1f 11 80 41 00 14 3c 60 43 54 80 01 00 3c 38 63 10 02 7c 00 18 40 41 82 00 14 3c 60 56 54 38 63 10 02 7c 00 18 40 40 82 00 0c 38 00 00 01 98 1f 00 bd 3c 60 56 54 80 01 00 3c 38 63 10 02 7c 00 18 40 40 82 00 0c 38 00 00 01 98 1f 00 be 80 9f 00 0c 38 7f 00 10 3c 84 00 80 38 04 fc 00 90 1f 00 e8 38 a1 00 3c 38 80 00 04 48 00 1e a5 80 41 00 14 80 01 00 3c 38 7f 00 10 60 00 00 02 90 01 00 3c 80 a1 00 3c 38 80 00 04)"
encode-bytes encode+
" "(48 00 1e 9d 80 41 00 14 3b c0 00 01 7f e3 fb 78 9b df 00 f4 38 80 00 e3 4b ff fb dd 60 00 00 00 98 7f 00 bf 88 1f 00 bd 28 00 00 00 41 82 00 2c 38 00 00 00 98 1f 00 f4 7f e3 fb 78 9b df 00 c0 38 80 00 c6 4b ff fb b1 60 00 00 00 54 60 07 7e 98 1f 00 f5 48 00 00 30 88 1f 00 bf 28 00 00 01 40 81 00 08 9b df 00 c0 7f e3 fb 78 38 80 00 e4 4b ff fc 91 60 00 00 00 54 60 04 3e 54 00 bf 7e 98 1f 00 f5 38 00 00 00 98 1f 00 f6 3c a0 01 00 80 7f 00 24 80 9f 00 0c 38 a5 ff ff 38 c0 00 01 48 00 1e 15 80 41 00 14 7f e3 fb 78 38 80 00 1f 38 a0 00 01 4b ff fa dd 60 00 00 00 88 1f 00 bd 28 00 00 00 41 82 00 14 7f e3 fb 78 4b ff e6 d9 60 00 00 00 98 7f 00 ac 4b ff fe 75 7f e3 fb 78 38 80 00 c2 4b ff fb 11 60 00 00 00 7f e3 fb 78 38 80 00 c2 38 a0 00 ff 4b ff fa 99)"
encode-bytes encode+
" "(60 00 00 00 88 1f 00 f4 2c 00 00 01 41 82 00 24 40 80 00 38 2c 00 00 00 40 80 00 08 48 00 00 2c 7f e3 fb 78 4b ff e2 95 60 00 00 00 48 00 00 1c 38 00 00 00 7f e3 fb 78 98 1f 00 c4 38 80 00 01 4b ff d0 c1 60 00 00 00 7f e3 fb 78 4b ff fd 61 7f e3 fb 78 4b ff f7 ad 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 38 60 00 00 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff 70 7c 7c 1b 78 7c 9d 23 78 80 9d 00 6c 7f a3 eb 78 7f 85 e3 78 4b ff d7 8d 60 00 00 00 7c 7f 1b 78 28 1f 00 00 40 82 00 0c 38 60 ff ef 48 00 00 d8 80 1d 00 cc 7c 00 f8 40 7c 00 00 26 54 00 1f fe 68 1e 00 01 57 c0 06 3f 40 82 00 18 80 1d 00 d0 7c 00 e0 40 40 82 00 0c 38 60 00 00 48 00 00 a8 93 9d 00 70 7f a3 eb 78 4b ff cc dd 60 00 00 00 80 dd 00 70)"
encode-bytes encode+
" "(7f a3 eb 78 7f e4 fb 78 57 c7 06 3e 38 a0 00 00 4b ff f7 e9 60 00 00 00 80 1d 00 b4 28 00 00 00 41 82 00 2c 38 61 00 38 7f a4 eb 78 48 00 12 71 60 00 00 00 80 9d 00 b8 81 9d 00 b4 38 61 00 38 38 a0 00 00 48 00 1e d1 80 41 00 14 80 1d 00 70 3b e0 00 00 b0 1d 00 84 80 1d 00 6c 7f a3 eb 78 b0 1d 00 80 80 bd 00 c8 38 9d 00 80 80 05 00 00 38 a0 00 01 b0 1d 00 82 9b fd 00 87 80 1d 00 88 98 1d 00 86 4b ff bf 0d 60 00 00 00 7f e3 fb 78 80 01 00 98 38 21 00 90 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c 9f 23 78 a8 1e 00 06 2c 00 00 00 41 82 00 0c 38 60 ff ef 48 00 00 18 a8 7e 00 00 7f e4 fb 78 4b ff fe a5 80 1f 00 04 90 1e 00 08 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6)"
encode-bytes encode+
" "(bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c 9f 23 78 80 1e 00 02 7f e4 fb 78 90 1f 00 6c a0 7e 00 00 4b ff fe 5d 80 1f 00 04 90 1e 00 08 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf 61 ff ec 90 01 00 08 94 21 f7 b0 7c 9d 23 78 88 1d 00 b0 28 00 00 00 41 82 00 0c 38 60 ff ef 48 00 01 54 80 a3 00 00 28 05 00 00 40 82 00 0c 38 60 ff ef 48 00 01 40 a8 83 00 06 ab e3 00 04 3b c4 00 01 7f c0 07 34 2c 00 01 00 7c a4 2b 78 40 81 00 0c 38 60 ff ef 48 00 01 1c 88 7d 00 af 28 03 00 00 41 82 00 98 3b 60 00 00 38 a1 00 38 48 00 00 5c 7f 63 07 34 54 7c 18 38 39 5c 00 04 38 fc 00 06 39 9c 00 02 7c c4 3a 2e 3d 00 00 01 7d 64 62 2e 7d 24 52 2e 39 08 97 0a 7c 64 e2 ae 7d 09 41 d6 1d 26 1c 29 1c cb 4c cc 7d 08 4a 14 7d 06 42 14)"
encode-bytes encode+
" "(7c 65 e3 2e 55 08 84 3e 7d 05 63 2e 7d 05 53 2e 7d 05 3b 2e 3b 7b 00 01 7f 63 07 34 7c 03 00 00 41 80 ff a0 80 dd 00 08 28 06 00 00 41 82 00 78 38 81 00 38 7f c3 f3 78 7c 85 23 78 48 00 04 09 60 00 00 00 48 00 00 60 80 dd 00 08 28 06 00 00 41 82 00 18 7f c3 f3 78 38 a1 00 38 48 00 03 e9 60 00 00 00 48 00 00 40 3b 60 00 00 38 e1 00 38 48 00 00 28 7f 63 07 34 54 66 18 38 7c 64 32 14 80 a3 00 00 80 63 00 04 7c c7 32 14 90 a6 00 00 90 66 00 04 3b 7b 00 01 7f 63 07 34 7c 03 00 00 41 80 ff d4 7f a3 eb 78 7f e4 fb 78 7f c5 f3 78 38 c1 00 38 4b ff cb 31 60 00 00 00 38 60 00 00 80 01 08 58 38 21 08 50 7c 08 03 a6 bb 61 ff ec 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 80 c3 00 00 28 06 00 00 40 82 00 6c 80 04 00 08 28 00 00 00 40 82 00 0c 38 60 ff ef)"
encode-bytes encode+
" "(48 00 01 08 38 60 00 00 7c 07 03 78 b0 67 00 00 b0 67 00 02 b0 67 00 04 38 00 00 01 b0 07 00 06 38 00 01 00 b0 07 00 08 38 00 00 08 7c 68 1b 78 b0 07 00 0a 48 00 00 14 55 03 04 3e 38 03 00 0c 7d 07 01 ae 39 08 00 01 55 00 04 3e 28 00 01 00 41 80 ff e8 48 00 00 94 a8 66 00 00 2c 03 00 00 41 82 00 0c 38 60 ff ef 48 00 00 a0 80 04 00 08 28 00 00 00 40 82 00 0c 38 60 ff ef 48 00 00 8c 7c 07 03 78 b0 67 00 00 a8 06 00 02 39 00 00 00 b0 07 00 02 a8 06 00 04 b0 07 00 04 a8 06 00 06 b0 07 00 06 a8 06 00 08 b0 07 00 08 a8 06 00 0a b0 07 00 0a a8 66 00 08 a8 06 00 06 7c 03 01 d6 54 00 04 3e 48 00 00 18 55 03 04 3e 38 a3 00 0c 7c 66 28 ae 39 08 00 01 7c 67 29 ae 55 03 04 3e 7c 03 00 40 41 80 ff e4 88 04 00 b0 28 00 00 00 41 82 00 14 7c 83 23 78 7c e4 3b 78)"
encode-bytes encode+
" "(4b ff cb 41 60 00 00 00 38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 f7 c0 7c 9f 23 78 a8 03 00 06 2c 00 00 00 41 82 00 0c 38 60 ff ef 48 00 00 4c 80 7f 00 cc 80 9f 00 04 80 1f 00 ec a0 a3 00 14 80 df 00 74 a0 e3 00 1c 7f e3 fb 78 7c 84 02 14 4b ff d8 85 60 00 00 00 88 1f 00 b0 28 00 00 00 41 82 00 14 7f e3 fb 78 80 9f 00 08 4b ff ca c1 60 00 00 00 38 60 00 00 80 01 08 48 38 21 08 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 88 04 00 b0 28 00 00 00 41 82 00 14 38 00 00 01 98 04 00 af 38 60 00 00 4e 80 00 20 88 04 00 ae 28 00 00 00 40 82 00 24 88 03 00 00 28 00 00 01 40 82 00 10 38 00 00 01 98 04 00 af 48 00 00 0c 38 00 00 00 98 04 00 af 38 60 00 00 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0)"
encode-bytes encode+
" "(a8 03 00 00 7c 83 23 78 98 04 00 ad 88 84 00 ad 4b ff ed a5 60 00 00 00 38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 f7 b0 7c 9f 23 78 88 1f 00 b0 28 00 00 00 40 82 00 0c 38 60 ff ef 48 00 00 b4 80 83 00 00 28 04 00 00 40 82 00 0c 38 60 ff ef 48 00 00 a0 a8 a3 00 06 ab c3 00 04 3b a5 00 01 57 a8 04 3e 28 08 01 00 40 81 00 0c 38 60 ff ef 48 00 00 80 80 df 00 08 28 06 00 00 41 82 00 18 7f a3 eb 78 38 a1 00 38 48 00 00 b5 60 00 00 00 48 00 00 44 39 20 00 00 38 e1 00 38 48 00 00 2c 55 20 04 3e 54 00 18 38 80 83 00 00 7c c7 02 14 7c a4 02 14 80 85 00 00 80 05 00 04 39 29 00 01 90 86 00 00 90 06 00 04 55 20 04 3e 7c 00 40 40 41 80 ff d0 7f e3 fb 78 7f c4 f3 78 7f a5 eb 78 38 c1 00 38 4b ff c7 f9)"
encode-bytes encode+
" "(60 00 00 00 38 60 00 00 80 01 08 58 38 21 08 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 88 03 00 00 7c 83 23 78 b0 04 00 84 38 84 00 80 38 a0 00 01 4b ff b9 6d 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 93 e1 ff fc 39 20 00 00 54 60 04 3e 48 00 00 3c 55 2a 04 3e 55 5f 18 38 7d 44 fa ae 39 7f 00 02 7d 45 fb 2e 7d 44 5a 2e 39 9f 00 04 7d 45 5b 2e 7d 44 62 2e 39 7f 00 06 7d 45 63 2e 7d 44 5a 2e 39 29 00 01 7d 45 5b 2e 55 2a 04 3e 7c 0a 00 40 41 80 ff c0 a8 06 00 06 a9 26 00 04 38 86 00 0c 2c 00 00 01 7c 84 4a 14 40 82 00 0c 7c 87 23 78 7c 88 23 78 a8 06 00 06 2c 00 00 03 40 82 00 10 a8 06 00 08 7c e4 02 14 7d 07 02 14 39 20 00 00 54 60 04 3e 48 00 00 e8 55 23 04 3e 54 63 18 38 38 c3 00 02 7c 65 32 2e)"
encode-bytes encode+
" "(7d 65 32 2e 54 63 06 31 55 6b c6 3e 41 82 00 14 55 63 04 3e 28 03 00 ff 41 82 00 08 39 6b 00 01 55 23 04 3e 54 63 18 38 38 c3 00 04 7c 65 32 2e 7d 85 32 2e 54 63 06 31 55 8c c6 3e 41 82 00 14 55 83 04 3e 28 03 00 ff 41 82 00 08 39 8c 00 01 55 23 04 3e 54 63 18 38 38 c3 00 06 7c 65 32 2e 7f e5 32 2e 54 63 06 31 57 ff c6 3e 41 82 00 14 57 e3 04 3e 28 03 00 ff 41 82 00 08 3b ff 00 01 55 23 04 3e 54 6a 18 38 55 63 04 3e 7c c4 18 ae 38 6a 00 02 7c c6 07 74 54 c6 40 2e 7c c5 1b 2e 55 83 04 3e 7c c7 18 ae 38 6a 00 04 7c c6 07 74 54 c6 40 2e 7c c5 1b 2e 57 e3 04 3e 7c c8 18 ae 38 6a 00 06 7c c6 07 74 54 c6 40 2e 7c c5 1b 2e 39 29 00 01 55 23 04 3e 7c 03 00 40 41 80 ff 14 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 7c 87 23 78 a0 83 00 00)"
encode-bytes encode+
" "(38 00 00 00 b0 87 00 84 80 83 00 02 7c e3 3b 78 b0 87 00 80 80 a7 00 c8 38 87 00 80 80 c5 00 00 38 a0 00 01 b0 c7 00 82 98 07 00 87 80 07 00 88 98 07 00 86 4b ff b7 7d 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7c 83 23 78 88 bf 00 01 54 a0 06 3f 40 82 00 08 38 a0 00 03 88 1f 00 00 88 83 00 bc 7c 00 28 38 7c 84 28 78 54 00 07 7e 7c 80 03 78 98 03 00 bc 88 83 00 bc 4b ff ea 01 60 00 00 00 38 00 00 00 7c 03 03 78 98 1f 00 01 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 80 a3 00 00 80 03 00 04 38 60 00 00 90 a4 00 b4 90 04 00 b8 4e 80 00 20 38 00 00 01 b0 03 00 06 38 60 00 00 4e 80 00 20 7c 66 1b 78 80 04 00 7c 38 60 00 00 b0 06 00 06 80 04 00 70 b0 06 00 00)"
encode-bytes encode+
" "(80 a4 00 0c 80 04 00 ec 7c 05 02 14 90 06 00 08 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff b0 7c 7e 1b 78 7c 9f 23 78 80 1e 00 00 28 00 00 00 40 82 00 0c 38 60 ff ee 48 00 00 8c 7f e3 fb 78 80 9f 00 70 4b ff cb f1 60 00 00 00 2c 03 00 04 41 82 00 28 40 80 00 10 2c 03 00 01 41 82 00 14 48 00 00 28 2c 03 00 08 41 82 00 18 48 00 00 1c 38 a0 00 01 48 00 00 1c 38 a0 00 0f 48 00 00 14 38 a0 00 ff 48 00 00 0c 38 60 ff ee 48 00 00 38 a8 9e 00 06 7c a0 07 34 7c 83 07 34 7c 03 00 00 40 81 00 0c 38 60 ff ee 48 00 00 1c 38 a4 00 01 a8 9e 00 04 80 de 00 00 7f e3 fb 78 4b ff c2 39 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 66 1b 78 38 60 00 00 90 66 00 08 a8 06 00 06 2c 00 00 00 40 82 00 18 80 a4 00 04 80 04 00 ec)"
encode-bytes encode+
" "(7c 05 02 14 90 06 00 08 4e 80 00 20 38 60 ff ee 4e 80 00 20 88 04 00 af 28 00 00 00 41 82 00 10 38 00 00 01 98 03 00 00 48 00 00 0c 38 00 00 00 98 03 00 00 38 60 00 00 4e 80 00 20 88 04 00 ad 28 00 00 00 41 82 00 10 38 00 00 00 b0 03 00 00 48 00 00 0c 38 00 00 01 b0 03 00 00 38 60 00 00 4e 80 00 20 38 00 00 00 90 03 00 00 80 04 00 08 28 00 00 00 41 82 00 08 90 03 00 00 38 60 00 00 4e 80 00 20 7c 65 1b 78 a0 04 00 84 38 60 00 00 98 05 00 00 4e 80 00 20 7c 67 1b 78 80 04 00 70 38 c0 00 00 b0 07 00 00 80 04 00 6c 7c c3 33 78 90 07 00 02 b0 c7 00 06 80 a4 00 0c 80 04 00 ec 7c 05 02 14 90 07 00 08 90 c7 00 0c 4e 80 00 20 7c 65 1b 78 a0 64 00 84 38 00 00 00 b0 65 00 00 a0 84 00 80 7c 03 03 78 90 85 00 02 90 05 00 08 4e 80 00 20 7c 08 02 a6 bf 21 ff e4)"
encode-bytes encode+
" "(90 01 00 08 94 21 ff a0 7c 7f 1b 78 7c 99 23 78 38 82 1d b4 38 a0 00 00 80 64 00 00 7c bb 2b 78 38 03 00 01 90 04 00 00 90 bf 00 04 90 bf 00 08 90 bf 00 0c 90 bf 00 10 b0 bf 00 14 83 9f 00 00 28 1c 00 00 40 82 00 48 80 99 00 6c 80 b9 00 70 7f 23 cb 78 4b ff cc 05 60 00 00 00 7c 7a 1b 78 28 1a 00 00 41 82 00 c4 7f 23 cb 78 7f 44 d3 78 4b ff c9 ed 60 00 00 00 7c 7e 1b 78 28 1e 00 00 41 82 00 a8 3b 60 00 01 48 00 00 a0 7f 23 cb 78 4b ff cb a1 60 00 00 00 7c 7a 1b 78 48 00 00 64 83 ba 00 00 7f 23 cb 78 7f 44 d3 78 4b ff c9 b1 60 00 00 00 7c 7e 1b 78 28 1e 00 00 41 82 00 30 38 00 ff fe 7c 1c 00 40 40 82 00 0c 3b 60 00 01 48 00 00 38 7c 1d e0 40 40 82 00 0c 3b 60 00 01 48 00 00 0c 57 60 06 3f 40 82 00 20 7f 23 cb 78 7f 44 d3 78 4b ff cb 45 60 00 00 00)"
encode-bytes encode+
" "(7c 7a 1b 78 28 1a 00 00 40 82 ff 9c 28 1a 00 00 40 82 00 1c 57 60 06 3f 41 82 00 14 38 00 ff fd 90 1f 00 04 38 60 00 00 48 00 00 40 57 60 06 3f 40 82 00 0c 38 60 ff ce 48 00 00 30 80 1a 00 00 38 60 00 00 90 1f 00 04 a0 1a 00 14 90 1f 00 08 a0 1a 00 1c 90 1f 00 0c a0 1a 00 08 54 00 80 1e 90 1f 00 10 b3 df 00 14 80 01 00 68 38 21 00 60 7c 08 03 a6 bb 21 ff e4 4e 80 00 20 7c 08 02 a6 bf 41 ff e8 90 01 00 08 94 21 ff b0 7c 7a 1b 78 7c 9b 23 78 80 9a 00 00 3b e0 00 00 28 04 00 00 40 82 00 08 80 9b 00 6c 7f 63 db 78 38 a0 00 80 4b ff ca ad 60 00 00 00 7c 7c 1b 78 28 1c 00 00 40 82 00 0c 38 60 ff ce 48 00 01 68 38 00 00 01 90 1a 00 0a 80 7a 00 06 38 a0 00 00 b0 a3 00 06 80 7a 00 06 38 00 00 03 b0 a3 00 08 80 9a 00 06 7f 63 db 78 b0 a4 00 0e 80 9a 00 06)"
encode-bytes encode+
" "(3b a0 00 02 b0 a4 00 10 80 9a 00 06 3b c0 00 10 90 a4 00 12 80 9a 00 06 90 a4 00 26 80 9a 00 06 b0 04 00 22 a0 9a 00 04 4b ff c8 21 60 00 00 00 28 03 00 20 41 81 00 64 38 82 16 68 54 60 10 3a 7c 84 00 2e 7c 89 03 a6 4e 80 04 20 3b a0 00 00 80 7a 00 06 39 00 00 01 b1 03 00 22 80 7a 00 06 38 00 00 08 7f be eb 78 b0 03 00 24 48 00 00 34 80 7a 00 06 38 00 00 05 7f a8 eb 78 b0 03 00 24 48 00 00 20 80 7a 00 06 38 00 00 08 b0 03 00 24 39 00 00 04 48 00 00 0c 38 60 ff ce 48 00 00 98 93 ba 00 0e 80 7a 00 06 3c a0 00 48 b3 c3 00 1e 3c 80 00 48 80 7a 00 06 55 00 18 38 b0 03 00 20 a0 fc 00 14 a0 1c 00 1c 80 da 00 06 7c 68 39 d6 b0 06 00 0a 38 03 00 3f 80 7a 00 06 38 a5 00 55 90 a3 00 16 80 7a 00 06 38 84 00 44 90 83 00 1a 80 7a 00 06 54 04 00 32 b0 e3 00 0c)"
encode-bytes encode+
" "(80 7a 00 06 38 00 00 00 b0 83 00 04 80 ba 00 06 7f 63 db 78 7f 84 e3 78 90 05 00 00 4b ff c7 4d 60 00 00 00 a0 1a 00 04 7c 00 18 40 40 81 00 08 3b e0 ff ce 7f e3 fb 78 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 41 ff e8 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7f 1b 78 7c 9d 23 78 3b c0 00 00 7f a3 eb 78 93 c1 00 38 38 81 00 3d 38 a1 00 3c 4b ff cb 3d 60 00 00 00 80 1d 00 90 b0 1f 00 00 88 01 00 3c 28 00 00 ff 40 82 00 14 9b df 00 02 88 01 00 3d 98 1f 00 03 48 00 00 14 88 01 00 3d 98 1f 00 02 88 01 00 3c 98 1f 00 03 38 00 00 84 38 82 16 ec 90 1f 00 04 38 7d 00 10 38 a1 00 38 48 00 0f 7d 80 41 00 14 7c 60 07 35 40 82 00 10 80 7f 00 04 38 03 01 00 90 1f 00 04 88 1d 00 ae 28 00 00 00 41 82 00 10 80 7f 00 04 38 03 00 10 90 1f 00 04)"
encode-bytes encode+
" "(38 00 00 00 90 1f 00 08 7c 03 03 78 90 1f 00 0c 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7d 1b 78 7c 9e 23 78 3c 60 64 65 38 63 63 6c 90 7d 00 08 80 1e 00 90 28 00 00 01 40 82 00 18 38 00 00 00 90 1d 00 0c 7c 03 03 78 90 1d 00 10 48 00 00 4c 80 9d 00 00 7f c3 f3 78 38 a0 00 80 4b ff c7 f5 60 00 00 00 7c 7f 1b 78 28 1f 00 00 40 82 00 0c 38 60 ff ce 48 00 00 24 7f c3 f3 78 80 9d 00 00 4b ff cc 29 60 00 00 00 80 1f 00 04 90 1d 00 0c 90 7d 00 10 38 60 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 a0 63 00 98 38 82 1d 70 38 03 fc 17 54 00 08 3c 7c 04 02 2e 38 62 16 f4 54 00 10 3a 7c 63 02 14 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 80 c3 00 00)"
encode-bytes encode+
" "(3b e0 00 00 2c 06 ff ff 41 82 00 48 40 80 00 10 2c 06 ff fe 40 80 00 34 48 00 00 38 2c 06 00 01 40 80 00 30 80 c3 00 04 a0 04 00 98 7c 06 00 40 41 80 00 10 a0 04 00 9a 7c 06 00 40 40 81 00 48 3b e0 ff ce 48 00 00 40 a0 c4 00 98 48 00 00 38 a0 a4 00 9a 7c 06 28 40 40 82 00 0c 38 c0 ff fd 48 00 00 24 a0 04 00 98 7c 06 00 40 41 80 00 14 7c 06 28 40 40 80 00 0c 38 c6 00 01 48 00 00 08 3b e0 ff ce 7f e0 07 35 40 82 00 48 38 00 ff fd 7c 06 00 40 90 c3 00 04 41 82 00 48 38 a6 fc 17 38 82 1d 78 54 a0 08 3c 7c 04 02 2e 38 82 1d 60 54 00 10 3a 90 03 00 08 54 a0 10 3a 80 63 00 0c 7c 84 00 2e 48 00 0e 61 80 41 00 14 48 00 00 14 38 00 00 00 90 03 00 04 90 03 00 08 90 03 00 0c 7f e3 fb 78 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6)"
encode-bytes encode+
" "(93 e1 ff fc 90 01 00 08 94 21 ff c0 80 a3 00 00 a0 04 00 98 3b e0 00 00 7c 05 00 40 41 80 00 10 a0 04 00 9a 7c 05 00 40 40 81 00 0c 3b e0 ff ce 48 00 00 38 38 05 fc 17 38 a2 1d 70 54 00 08 3c 38 82 1d 78 7c a5 02 2e 7c 04 02 2e 38 c2 16 f4 54 a5 10 3a 80 83 00 04 7c 66 2a 14 54 05 10 3a 48 00 0d 99 80 41 00 14 7f e3 fb 78 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 88 03 00 00 2c 00 00 ff 41 82 00 20 40 80 00 24 2c 00 00 00 41 82 00 08 48 00 00 18 88 04 00 bc 98 03 00 00 48 00 00 0c 38 00 00 07 98 03 00 00 38 60 00 00 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff 30 7c 7c 1b 78 7c 9d 23 78 38 00 00 80 90 01 00 b8 80 1c 00 08 3b e2 16 ec 54 00 07 ff 41 82 00 88 7f 83 e3 78 7f a4 eb 78 48 00 09 a9 60 00 00 00 80 1c 00 00)"
encode-bytes encode+
" "(7c 7e 1b 78 28 00 00 01 40 82 00 60 7f c0 07 34 2c 00 ff ed 40 82 00 14 38 7d 00 10 7f e4 fb 78 48 00 0c 4d 80 41 00 14 7f c0 07 35 40 82 00 3c 7f e4 fb 78 38 7d 00 10 38 bc 00 10 38 c0 00 80 48 00 0b b5 80 41 00 14 7c 60 07 35 41 82 00 1c 7f e4 fb 78 38 7d 00 10 38 bc 00 10 38 c0 00 80 48 00 0b ad 80 41 00 14 7f c3 f3 78 48 00 00 64 80 1c 00 00 28 00 00 01 41 82 00 0c 38 60 ff ef 48 00 00 50 7f e4 fb 78 38 7d 00 10 38 a1 00 38 38 c1 00 b8 48 00 0a 29 80 41 00 14 7c 60 07 35 40 82 00 24 80 a1 00 b8 28 05 00 80 41 81 00 18 38 61 00 38 38 9c 00 10 48 00 0c 45 80 41 00 14 48 00 00 0c 38 60 ff ef 48 00 00 08 38 60 00 00 80 01 00 d8 38 21 00 d0 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 38 00 00 01 90 03 00 04 80 04 00 0c 38 a0 00 00 90 03 00 08 80 04 00 d8)"
encode-bytes encode+
" "(90 03 00 0c 90 a3 00 10 80 04 00 0c 90 03 00 14 90 a3 00 18 88 04 00 c0 28 00 00 00 41 82 00 10 80 a4 00 0c 3c 05 00 80 90 03 00 18 80 a4 00 0c 38 00 00 00 3c a5 00 80 38 a5 fc 00 90 a3 00 1c 90 03 00 20 80 a4 00 ec 38 00 00 44 54 a5 04 3e 90 a3 00 24 80 c4 00 0c 80 a4 00 ec 7c a6 2a 14 90 a3 00 28 80 a4 00 78 90 a3 00 2c 80 a4 00 74 90 a3 00 30 80 a4 00 c8 a0 a5 00 14 90 a3 00 34 80 a4 00 c8 a0 a5 00 1c 90 a3 00 38 80 a4 00 cc a0 a5 00 14 90 a3 00 3c 80 84 00 cc a0 84 00 1c 90 83 00 40 90 03 00 00 4e 80 00 20 7c 08 02 a6 bf 61 ff ec 90 01 00 08 94 21 ff 60 7c 7b 1b 78 7c 9c 23 78 3b c2 1d 8b 3b e2 1d 80 7f 84 e3 78 38 61 00 38 3b a0 00 00 4b ff ff 11 7f e4 fb 78 38 7c 00 10 38 a1 00 38 38 c0 00 44 48 00 0a 0d 80 41 00 14 2c 03 00 00 41 82 00 1c)"
encode-bytes encode+
" "(7f e4 fb 78 38 7c 00 10 38 a1 00 38 38 c0 00 44 48 00 0a 05 80 41 00 14 80 1b 00 00 38 60 00 44 7c 00 18 40 40 80 00 08 7c 03 03 78 7f 64 db 78 7c 65 1b 78 90 61 00 38 38 61 00 38 48 00 0a c9 80 41 00 14 7f c4 f3 78 7f 65 db 78 38 7c 00 10 38 c0 00 44 48 00 09 a9 80 41 00 14 2c 03 00 00 41 82 00 1c 7f c4 f3 78 7f 65 db 78 38 7c 00 10 38 c0 00 44 48 00 09 a1 80 41 00 14 7f a3 eb 78 80 01 00 a8 38 21 00 a0 7c 08 03 a6 bb 61 ff ec 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 54 80 06 3e 70 05 00 37 38 80 00 c7 4b ff e5 3d 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0 38 80 00 c7 4b ff e5 79 60 00 00 00 70 63 00 36 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 90 01 00 08 94 21 ff c0)"
encode-bytes encode+
" "(4b ff ff c9 54 60 06 3e 54 00 07 bc 2c 00 00 02 7c 00 00 26 54 03 1f fe 80 01 00 48 38 21 00 40 7c 08 03 a6 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 4b ff ff 89 70 64 00 17 7f e3 fb 78 4b ff ff 4d 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7d 1b 78 7c 9e 23 78 7f a3 eb 78 4b ff ff 49 70 7f 00 17 7f a3 eb 78 7f e4 fb 78 4b ff ff 09 57 c0 06 3f 63 ff 00 20 41 82 00 0c 63 ff 00 04 48 00 00 08 73 ff 00 fb 7f a3 eb 78 7f e4 fb 78 4b ff fe e5 38 60 00 01 4b ff e0 4d 60 00 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 4b ff fe d9 70 64 00 27 7f e3 fb 78)"
encode-bytes encode+
" "(4b ff fe 9d 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7d 1b 78 7c 9e 23 78 7f a3 eb 78 4b ff fe 99 70 7f 00 27 7f a3 eb 78 7f e4 fb 78 4b ff fe 59 57 c0 06 3f 63 ff 00 10 41 82 00 0c 63 ff 00 02 48 00 00 08 73 ff 00 fd 7f a3 eb 78 7f e4 fb 78 4b ff fe 35 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 3b e0 00 00 7f c3 f3 78 4b ff ff 41 38 60 00 01 4b ff df 69 60 00 00 00 7f ff fb 78 48 00 00 40 7f c3 f3 78 4b ff fe 75 7f c3 f3 78 4b ff fe 0d 54 60 06 3e 54 00 07 7c 2c 00 00 06 41 82 00 2c 7f c3 f3 78 38 80 00 00 4b ff fe 8d 7f c3 f3 78 38 80 00 01 4b ff fe 81 3b ff 00 01 57 e0 06 3e 28 00 00 ff 41 80 ff bc)"
encode-bytes encode+
" "(7f c3 f3 78 38 80 00 00 4b ff fe 65 7f c3 f3 78 38 80 00 01 4b ff ff 09 7f c3 f3 78 38 80 00 01 4b ff fe 4d 7f c3 f3 78 38 80 00 00 4b ff fe f1 38 60 00 01 4b ff de dd 60 00 00 00 7f c3 f3 78 38 80 00 00 4b ff fe 29 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 38 80 00 00 4b ff fd f5 7f e3 fb 78 38 80 00 00 4b ff fe 99 7f e3 fb 78 38 80 00 01 4b ff fd dd 7f e3 fb 78 38 80 00 01 4b ff fe 81 38 60 00 01 4b ff de 6d 60 00 00 00 7f e3 fb 78 4b ff fe 31 7f e3 fb 78 4b ff fd 79 38 60 00 01 4b ff de 51 60 00 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 93 e1 ff fc 90 01 00 08 94 21 ff c0 7c 7f 1b 78 7f e3 fb 78 4b ff fe 29 7f e3 fb 78)"
encode-bytes encode+
" "(38 80 00 01 4b ff fd 6d 7f e3 fb 78 38 80 00 00 4b ff fd 61 80 01 00 48 38 21 00 40 7c 08 03 a6 83 e1 ff fc 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7f c3 f3 78 4b ff fd a5 7f c3 f3 78 38 80 00 01 4b ff fd 25 7f c3 f3 78 4b ff fc ad 7c 7f 1b 78 7f c3 f3 78 38 80 00 00 4b ff fd 0d 7f e3 fb 78 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff b0 7c 7c 1b 78 3b a0 00 00 54 9e 06 3e 3b e0 00 01 48 00 00 2c 57 a0 06 3e 20 00 00 07 7f e0 00 30 7f c0 00 39 7f 83 e3 78 7c 00 00 26 54 00 1f fe 68 04 00 01 4b ff ff 1d 3b bd 00 01 57 a0 06 3e 28 00 00 08 41 80 ff d0 7f 83 e3 78 4b ff ff 4d 54 60 06 3f 7c 00 00 26 54 03 1f fe 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 81 ff f0)"
encode-bytes encode+
" "(4e 80 00 20 7c 08 02 a6 bf 81 ff f0 90 01 00 08 94 21 ff b0 7c 7c 1b 78 3b a0 00 00 7f be eb 78 3b e0 00 01 48 00 00 28 7f 83 e3 78 4b ff ff 01 54 60 06 3f 41 82 00 14 57 c0 06 3e 20 00 00 07 7f e0 00 30 7f bd 03 78 3b de 00 01 57 c0 06 3e 28 00 00 08 41 80 ff d4 7f 83 e3 78 38 80 00 00 4b ff fe 85 7f a3 eb 78 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 81 ff f0 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7f c3 f3 78 4b ff fd d1 7f c3 f3 78 4b ff fc f1 3b e0 00 00 48 00 00 40 7f c3 f3 78 38 80 00 a0 4b ff fe d5 54 60 06 3f 41 82 00 28 7f c3 f3 78 38 80 00 00 4b ff fe c1 54 60 06 3f 41 82 00 14 7f c3 f3 78 4b ff fd 91 38 60 00 01 48 00 00 20 3b ff 00 01 57 e0 06 3e 28 00 00 08 41 80 ff bc 7f c3 f3 78 4b ff fd 71 38 60 00 00)"
encode-bytes encode+
" "(80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 7c 08 02 a6 bf a1 ff f4 90 01 00 08 94 21 ff b0 7c 7d 1b 78 7c be 2b 78 3b e0 00 00 7f a3 eb 78 4b ff fc 5d 7f a3 eb 78 38 80 00 a1 4b ff fe 49 54 60 06 3f 41 82 00 38 48 00 00 18 7f a3 eb 78 4b ff fe b5 57 e0 06 3e 7c 7e 01 ae 3b ff 00 01 57 e0 06 3e 28 00 00 80 41 80 ff e4 7f a3 eb 78 4b ff fc f5 38 60 00 01 48 00 00 10 7f a3 eb 78 4b ff fc e5 7f e3 fb 78 80 01 00 58 38 21 00 50 7c 08 03 a6 bb a1 ff f4 4e 80 00 20 7c 08 02 a6 bf 61 ff ec 90 01 00 08 94 21 ff b0 7c 7b 1b 78 7c 9c 23 78 7c bd 2b 78 3b c0 00 00 3b e0 00 ff 48 00 00 48 38 60 00 00 48 00 00 10 54 60 06 3e 7f fd 01 ae 38 63 00 01 54 60 06 3e 28 00 00 80 41 80 ff ec 7f 63 db 78 7f 84 e3 78 7f a5 eb 78 4b ff ff 21 54 60 06 3f)"
encode-bytes encode+
" "(41 82 00 0c 38 60 00 01 48 00 00 18 3b de 00 01 57 c0 06 3e 28 00 00 08 41 80 ff b4 38 60 00 00 80 01 00 58 38 21 00 50 7c 08 03 a6 bb 61 ff ec 4e 80 00 20 88 83 00 00 88 03 00 07 38 a0 00 00 7c 80 00 39 41 82 00 0c 7c a3 2b 78 4e 80 00 20 38 80 00 01 48 00 00 20 54 80 06 3e 7c 03 00 ae 28 00 00 ff 41 82 00 0c 38 60 00 00 4e 80 00 20 38 84 00 01 54 80 06 3e 28 00 00 07 41 80 ff dc 38 80 00 00 48 00 00 14 54 80 06 3e 7c 03 00 ae 38 84 00 01 7c a5 02 14 54 80 06 3e 28 00 00 80 41 80 ff e8 54 a5 06 3e 54 a0 06 3f 40 82 00 0c 38 60 00 01 4e 80 00 20 38 60 00 00 4e 80 00 20 7c 08 02 a6 bf c1 ff f8 90 01 00 08 94 21 ff c0 7c 7e 1b 78 7c 9f 23 78 80 1e 00 08 54 00 07 ff 40 82 00 0c 38 60 ff ce 48 00 00 7c 80 1e 00 04 28 00 00 00 41 82 00 0c 38 60 ff ce)"
encode-bytes encode+
" "(48 00 00 68 7f e3 fb 78 4b ff fd 81 54 60 06 3f 40 82 00 0c 38 60 ff ed 48 00 00 50 80 9e 00 00 7f e3 fb 78 38 04 ff ff 54 04 38 30 38 be 00 10 4b ff fe 79 54 60 06 3e 28 00 00 01 41 82 00 0c 38 60 ff ed 48 00 00 24 38 7e 00 10 4b ff fe ed 54 60 06 3e 28 00 00 01 41 82 00 0c 38 60 ff ed 48 00 00 08 38 60 00 00 80 01 00 48 38 21 00 40 7c 08 03 a6 bb c1 ff f8 4e 80 00 20 80 82 01 04 38 60 00 00 c8 04 00 00 c8 64 00 08 c8 84 00 10 fc 01 00 00 ff 01 18 00 4d 80 00 20 38 63 ff ff 4c 98 00 20 ff 81 20 00 fc 40 08 90 41 9c 00 08 fc 41 20 28 fc 40 10 1e d8 41 ff f8 80 61 ff fc 4d 9c 00 20 3c 63 80 00 4e 80 00 20 81 82 00 44 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 18 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20)"
encode-bytes encode+
" "(81 82 00 60 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 64 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 50 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 34 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 54 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 5c 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 58 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 48 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 2c 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 70 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 28 90 41 00 14 80 0c 00 00)"
encode-bytes encode+
" "(80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 68 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 1c 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 00 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 20 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 24 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 14 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 04 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 6c 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 08 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 10 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20)"
encode-bytes encode+
" "(81 82 00 3c 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 0c 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 4c 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 40 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 38 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 81 82 00 30 90 41 00 14 80 0c 00 00 80 4c 00 04 7c 09 03 a6 4e 80 04 20 80 0c 00 00 90 41 00 14 7c 09 03 a6 80 4c 00 04 4e 80 04 20 00 00 00 00 80 00 03 88 20 00 00 00 00 00 03 88 80 00 00 50 08 00 00 00 00 00 03 d8 80 00 01 a8 00 00 00 00 00 00 05 80 80 00 02 58 00 00 00 00 00 00 07 d8 80 00 01 98 20 00 00 00 00 00 09 70 80 00 01 18 20 00 00 00 00 00 0a 88 80 00 00 84 10 00 00 00 00 00 0b 0c)"
encode-bytes encode+
" "(80 00 00 4c 00 00 00 00 00 00 0b 58 80 00 00 6c 08 00 00 00 00 00 0b c4 80 00 00 68 08 00 00 00 00 00 0c 2c 80 00 00 80 08 00 00 00 00 00 0c ac 80 00 00 50 00 00 00 00 00 00 0c fc 80 00 00 50 00 00 00 00 00 00 0d 54 80 00 02 ac 18 00 00 00 00 00 10 00 80 00 01 44 10 00 00 00 00 00 11 44 80 00 00 3c 00 00 00 00 00 00 11 80 80 00 00 3c 00 00 00 00 00 00 11 bc 80 00 00 3c 00 00 00 00 00 00 11 f8 80 00 00 3c 00 00 00 00 00 00 12 44 80 00 00 24 00 00 00 00 00 00 12 68 80 00 00 24 00 00 00 00 00 00 12 8c 80 00 01 14 10 00 00 00 00 00 13 a0 80 00 00 7c 08 00 00 00 00 00 14 1c 80 00 00 fc 38 00 00 00 00 00 15 18 80 00 00 70 10 00 00 00 00 00 15 88 80 00 00 9c 20 00 00 00 00 00 16 24 80 00 01 54 58 00 00 00 00 00 17 78 80 00 00 d4 30 00 00 00 00 00 18 4c)"
encode-bytes encode+
" "(80 00 00 f4 10 00 00 00 00 00 19 40 80 00 01 04 18 00 00 00 00 00 1a 44 80 00 01 28 20 00 00 00 00 00 1b e8 80 00 00 60 10 00 00 00 00 00 1c 48 80 00 00 60 10 00 00 00 00 00 1c a8 80 00 00 5c 08 00 00 00 00 00 1d 04 80 00 00 58 08 00 00 00 00 00 1d 78 80 00 01 d4 18 00 00 00 00 00 1f 74 80 00 00 a8 28 00 00 00 00 00 20 1c 80 00 00 bc 10 00 00 00 00 00 20 d8 80 00 00 68 10 00 00 00 00 00 21 40 80 00 00 84 10 00 00 00 00 00 21 c4 80 00 00 74 20 00 00 00 00 00 22 38 80 00 00 b4 08 00 00 00 00 00 23 28 80 00 00 a4 20 00 00 00 00 00 23 cc 80 00 00 7c 10 00 00 00 00 00 24 48 80 00 00 d8 10 00 00 00 00 00 25 20 80 00 04 e4 90 00 00 00 00 00 2a 04 80 00 03 f0 10 00 00 00 00 00 2d fc 80 00 01 44 20 00 00 00 00 00 2f 40 80 00 01 1c 10 00 00 00 00 00 30 5c)"
encode-bytes encode+
" "(80 00 00 88 10 00 00 00 00 00 30 e4 80 00 00 74 00 00 00 00 00 00 31 a8 80 00 07 78 48 00 00 00 00 00 39 20 80 00 00 44 18 00 00 00 00 00 39 64 80 00 01 58 40 00 00 00 00 00 3a bc 80 00 00 2c 00 00 00 00 00 00 3a e8 80 00 00 48 00 00 00 00 00 00 3b 38 80 00 00 38 08 00 00 00 00 00 3b 70 80 00 00 28 00 00 00 00 00 00 3b 98 80 00 00 9c 18 00 00 00 00 00 3c 34 80 00 00 54 10 00 00 00 00 00 3c 88 80 00 00 54 10 00 00 00 00 00 3c dc 80 00 00 8c 18 00 00 00 00 00 3d 68 80 00 00 94 20 00 00 00 00 00 3d fc 80 00 00 80 08 00 00 00 00 00 3e 7c 80 00 00 d0 08 00 00 00 00 00 3f 4c 80 00 00 48 08 00 00 00 00 00 3f 94 80 00 00 40 08 00 00 00 00 00 3f d4 80 00 00 40 08 00 00 00 00 00 40 40 80 00 01 a0 28 00 00 00 00 00 41 e0 80 00 00 64 00 00 00 00 00 00 42 54)"
encode-bytes encode+
" "(80 00 00 38 00 00 00 00 00 00 42 8c 80 00 00 50 00 00 00 00 00 00 43 24 80 00 00 2c 00 00 00 00 00 00 43 50 80 00 00 28 00 00 00 00 00 00 43 78 80 00 00 28 00 00 00 00 00 00 43 a0 80 00 00 28 00 00 00 00 00 00 43 c8 80 00 00 2c 00 00 00 00 00 00 43 f4 80 00 00 2c 00 00 00 00 00 00 44 20 80 00 00 d8 20 00 00 00 00 00 44 f8 80 00 00 a0 08 00 00 00 00 00 45 a0 80 00 02 1c 10 00 00 00 00 00 47 c4 80 00 01 28 20 00 00 00 00 00 48 ec 80 00 00 54 10 00 00 00 00 00 49 40 80 00 00 48 10 00 00 00 00 00 49 88 80 00 01 8c 28 00 00 00 00 00 4b 14 80 00 01 40 00 00 00 00 00 00 4c 54 80 00 00 84 08 00 00 00 00 00 4d 28 80 00 00 38 00 00 00 00 00 00 4d 60 80 00 00 ec 18 00 00 00 00 00 4e 4c 80 00 00 38 00 00 00 00 00 00 50 14 80 00 00 60 00 00 00 00 00 00 50 74)"
encode-bytes encode+
" "(80 00 00 70 08 00 00 00 00 00 51 38 80 00 00 c8 10 00 00 00 00 00 53 14 80 00 01 80 38 00 00 00 00 00 54 94 80 00 01 c8 30 00 00 00 00 00 56 5c 80 00 00 d4 18 00 00 00 00 00 57 30 80 00 00 a0 18 00 00 00 00 00 57 f4 80 00 01 0c 08 00 00 00 00 00 59 00 80 00 00 84 08 00 00 00 00 00 59 bc 80 00 01 28 20 00 00 00 00 00 5b a8 80 00 00 e4 28 00 00 00 00 00 5c 8c 80 00 00 30 00 00 00 00 00 00 5c bc 80 00 00 2c 00 00 00 00 00 00 5c e8 80 00 00 34 00 00 00 00 00 00 5d 1c 80 00 00 3c 08 00 00 00 00 00 5d 58 80 00 00 74 18 00 00 00 00 00 5d cc 80 00 00 3c 08 00 00 00 00 00 5e 08 80 00 00 68 18 00 00 00 00 00 5e 70 80 00 00 d8 10 00 00 00 00 00 5f 48 80 00 00 80 08 00 00 00 00 00 5f c8 80 00 00 48 08 00 00 00 00 00 60 10 80 00 00 58 10 00 00 00 00 00 60 68)"
encode-bytes encode+
" "(80 00 00 80 20 00 00 00 00 00 60 e8 80 00 00 78 20 00 00 00 00 00 61 60 80 00 00 94 10 00 00 00 00 00 61 f4 80 00 00 8c 18 00 00 00 00 00 62 80 80 00 00 90 28 00 00 00 00 00 63 9c 80 00 00 b8 10 00 00 00 6e 61 6c 69 74 79 20 74 00 76 22 01 69 82 02 23 01 5a 01 55 01 4c 1d b0 02 38 01 44 02 2b 02 19 02 0e 02 03 01 f6 02 64 02 6c 02 74 04 dc 04 bc 07 04 02 7c 06 f8 07 24 16 28 10 e8 07 2c 0c a4 16 30 16 48 1d 8b 1d 80 1d 60 1d 78 1d 70 16 f4 16 ec 16 68 1d b4 26 1d 98 07 20 10 08 01 25 04 08 0c 43 30 86 02 01 3f e0 23 40 5f e0 85 03 02 40 4f c0 40 3f 80 22 41 34 04 22 12 8c 06 22 0b 58 04 28 52 41 4d 2c 54 79 70 65 01 24 53 69 6d 65 01 2e 41 54 49 52 65 70 6c 61 63 65 49 6e 66 6f 01 2c 6e 65 65 64 46 75 6c 6c 49 6e 69 74 01 24 6d 74 65 6a 04 2a 09)"
encode-bytes encode+
" "(41 54 59 2c 32 36 34 56 54 16 21 01 01 22 60 14 03 3b 06 19 2e 44 69 73 70 6c 61 79 5f 56 69 64 65 6f 5f 41 54 49 5f 6d 61 63 68 36 34 00 29 2a 01 6e 64 72 76 76 69 64 6f 01 03 2c 41 41 50 4c 2c 61 64 64 72 65 73 73 01 2a 69 6e 74 65 72 72 75 70 74 73 01 2a 64 72 69 76 65 72 2d 69 73 74 01 31 70 6f 77 65 72 2d 63 6f 6e 73 75 6d 70 74 69 6f 6e 01 29 41 54 59 2c 46 6c 61 67 73 06 22 13 10 82 02 0a 13 1c 13 34 13 44 13 54 13 64 13 28 12 e0 12 ec 12 f8 13 04 02 24 15 7c 17 70 04 2c 15 7c 13 88 13 88 19 64 12 5c 12 5c 03 21 0a 03 21 8c 01 21 43 01 21 01 06 26 0b d0 02 80 03 60 01 21 40 01 25 40 01 e0 02 0d 01 21 03 01 21 03 03 21 0f 03 21 a0 01 21 4b 08 26 16 60 02 80 03 40 01 21 20 01 25 50 03 66 03 96 01 21 03 01 21 03 03 21 14 03 21 aa 01 21 4b 08)"
encode-bytes encode+
" "(26 16 60 03 40 04 80 01 21 20 01 25 40 02 70 02 9b 01 21 01 01 21 03 03 21 19 03 21 d2 01 21 4b 08 23 1f 40 04 01 22 05 30 01 21 20 01 22 60 03 01 22 03 24 01 21 03 01 21 03 03 21 1e 03 21 dc 01 21 4b 08 26 27 10 04 80 05 b0 01 21 20 01 25 80 03 66 03 93 01 21 03 01 21 03 03 21 23 03 21 96 01 21 3c 08 26 09 d6 02 80 03 20 01 21 10 01 25 60 01 e0 02 0d 01 21 0a 01 21 02 03 21 28 03 21 b4 01 21 38 03 21 03 04 25 0e 10 03 20 04 02 21 18 01 25 48 02 58 02 71 01 21 01 01 21 02 03 21 2d 03 21 b6 01 21 3c 03 21 03 04 26 0f a0 03 20 04 20 01 21 28 01 25 80 02 58 02 74 01 21 01 01 21 04 03 21 32 03 21 b8 01 21 48 03 21 03 04 26 13 88 03 20 04 10 01 21 38 01 25 78 02 58 02 9a 01 21 25 01 21 06 03 21 37 03 21 ba 01 21 4b 03 21 03 04 26 13 56 03 20 04 20 01)"
encode-bytes encode+
" "(21 40 01 25 50 02 58 02 71 01 21 01 01 21 03 03 21 3c 03 21 be 01 21 3c 08 23 19 64 04 01 22 05 40 01 21 18 01 22 88 03 01 22 03 26 01 21 03 01 21 06 03 21 41 03 21 c8 01 21 46 08 23 1d 2e 04 01 22 05 30 01 21 18 01 22 88 03 01 22 03 26 01 21 03 01 21 06 03 21 46 05 21 4b 03 21 03 04 23 1e c3 04 01 22 05 20 01 21 10 01 22 60 03 01 22 03 20 01 21 01 01 21 03 03 21 4b 03 21 fa 01 21 4b 03 21 03 04 23 31 38 05 01 22 06 90 01 21 10 01 25 90 03 c0 03 e8 01 21 01 01 21 03 03 21 50 02 22 01 04 01 21 3c 03 21 03 04 23 2a 44 05 01 22 06 90 01 21 10 01 22 70 04 01 22 04 2f 01 21 01 01 21 03 03 21 55 02 22 01 06 01 21 4b 03 21 03 04 23 34 f8 05 01 22 06 98 01 21 10 01 22 90 04 01 22 04 2a 01 21 01 01 2d 03 02 21 06 2b 05 1e 01 14 07 2d 07 3a 02 31 03 35 06)"
encode-bytes encode+
" "(03 06 0b 06 23 07 17 03 31 03 34 07 3b ff 04 21 01 03 25 03 03 eb 03 eb 03 21 01 03 21 05 07 21 01 03 25 03 03 e9 03 e9 03 21 01 03 21 0a 03 21 07 07 25 09 03 e9 03 ea 82 02 04 00 01 00 0f 00 07 00 02 01 25 09 03 ec 03 ec 03 21 01 03 21 0f 03 21 07 07 25 03 03 e9 03 ea 03 21 01 03 21 14 03 21 07 07 25 03 03 e9 03 ea 03 21 01 03 21 19 03 21 07 07 25 03 03 e9 03 ea 82 02 04 00 01 00 1e 00 07 00 02 01 25 03 03 ec 03 ec 03 21 01 03 21 1e 03 21 07 07 25 04 03 e9 03 ea 82 02 05 00 02 00 0a 00 07 00 14 00 03 05 25 05 03 e9 03 ea 82 02 07 00 03 00 0a 00 03 00 14 00 07 00 19 00 03 05 25 06 03 e9 03 ea 82 02 0b 00 05 00 0a 00 03 00 14 00 03 00 19 00 03 00 1e 00 07 00 55 00 03 05 25 0a 03 e9 03 ea 82 02 21 00 10 00 23 00 07 00 28 00 03 00 2d 00 03 00 32 00)"
encode-bytes encode+
" "(03 00 37 00 03 00 3c 00 03 00 41 00 03 00 46 00 03 00 4b 00 01 00 50 00 01 00 55 00 01 00 0a 00 03 00 0f 00 03 00 14 00 03 00 19 00 03 00 1e 00 03 05 25 03 03 e9 03 ea 82 02 04 00 01 00 1e 00 07 00 02 01 25 03 03 ec 03 ec 03 21 01 03 21 1e 03 21 07 07 25 06 03 e9 03 ec 03 21 01 03 21 0a 03 21 07 07 21 08 03 21 10 03 21 20 01 27 01 02 03 04 05 06 07 01 23 10 20 30 01 23 10 20 30 01 21 04 01 25 04 08 0c 08 0c 02 26 01 01 02 02 03 03 01 25 20 20 10 08 08 03 21 02 01 21 02 82 02 05 00 08 02 58 00 04 00 01 00 3f 01 21 03 81 03 2f 02 00 02 00 00 08 00 15 e0 00 00 06 00 00 01 00 00 3f 00 00 04 02 00 02 00 00 08 00 1b 58 00 00 06 00 00 02 00 00 3f 00 00 45 02 00 02 00 00 08 00 24 b8 00 00 08 00 00 02 00 00 3f 00 00 46 02 00 02 00 00 08 00 27 10 00 00 0a)"
encode-bytes encode+
" "(00 00 02 00 00 3f 00 00 46 02 00 02 00 00 08 00 2c 24 00 00 0c 00 00 02 00 00 3f 00 00 47 02 00 02 00 00 08 00 32 c8 00 00 0c 00 00 02 00 00 04 00 00 88 02 00 02 00 00 08 00 36 b0 00 00 0c 00 00 02 06 21 89 81 03 4a 02 00 02 00 00 08 00 5d c0 00 00 0e 00 00 02 00 00 04 00 00 87 02 00 02 00 00 10 00 07 d0 00 00 06 00 00 01 00 00 3f 00 00 03 02 00 02 00 00 10 00 0d 48 00 00 06 00 00 02 00 00 3f 00 00 04 02 00 02 00 00 10 00 10 68 00 00 08 00 00 02 00 00 3f 00 00 45 02 00 02 00 00 10 00 15 7c 00 00 0a 00 00 02 00 00 3f 00 00 47 02 00 02 00 00 10 00 19 c8 00 00 0c 00 00 02 00 00 4c 00 00 88 02 00 02 00 00 10 00 1b 58 00 00 0c 00 00 02 00 00 84 00 00 89 02 00 02 00 00 10 00 1d b0 00 00 0e 00 00 02 00 00 80 00 00 89 02 00 02 00 00 10 00 1e dc 00 00 0e)"
encode-bytes encode+
" "(00 00 02 00 00 80 00 00 8a 02 00 02 00 00 10 00 5d c0 00 00 0e 00 00 02 00 00 80 00 00 8e 02 00 02 00 00 18 00 07 d0 00 00 08 06 21 3f 81 03 81 52 00 00 04 02 00 02 00 00 18 00 0d 48 00 00 0a 00 00 01 00 00 0a 00 00 46 02 00 02 00 00 18 00 0e d8 00 00 0a 00 00 02 00 00 08 00 00 47 02 00 02 00 00 18 00 10 68 00 00 0a 00 00 02 00 00 04 00 00 88 02 00 02 00 00 18 00 11 94 00 00 0c 00 00 01 00 00 7f 00 00 88 02 00 02 00 00 18 00 14 50 00 00 28 00 00 02 00 00 40 00 00 89 02 00 02 00 00 18 00 5d c0 00 00 2a 00 00 02 00 00 40 00 00 8a 02 00 02 00 00 20 00 0b b8 00 00 0a 00 00 02 00 00 3f 00 00 47 02 00 02 00 00 20 00 0d ac 00 00 0e 00 00 01 00 00 3f 00 00 89 02 00 02 00 00 20 00 10 68 00 00 0e 00 00 02 00 00 7f 00 00 8a 02 00 02 00 00 20 00 14 50 00 00)"
encode-bytes encode+
" "(2a 00 00 03 00 00 40 00 00 8b 02 00 02 00 00 20 00 5d c0 00 00 2a 00 00 03 00 00 40 00 00 8c 02 00 01 00 00 08 00 0b b8 00 00 04 00 00 01 00 00 3f 00 00 02 02 00 01 00 00 08 00 0e d8 00 00 04 00 00 02 00 00 3f 00 00 03 02 00 01 00 00 08 00 12 c0 00 00 06 00 00 02 00 00 3f 00 00 04 02 00 01 00 00 08 00 15 18 00 00 06 00 00 02 00 00 3f 00 00 05 02 00 01 00 00 08 00 1e 14 00 00 0a 00 00 02 00 00 3f 00 00 46 02 00 01 00 00 08 00 23 28 00 00 0a 00 00 03 00 00 3f 00 00 87 02 00 01 00 00 08 00 2e e0 00 00 0c 00 00 03 00 00 7f 00 00 88 02 00 01 00 00 08 00 5d c0 00 00 0e 00 00 03 00 00 3f 00 00 88 02 00 01 00 00 10 00 07 d0 00 00 06 00 00 01 00 00 3f 00 00 03 02 00 01 00 00 10 00 0b b8 00 00 06 00 00 02 00 00 3f 00 00 04 02 00 01 00 00 10 00 11 30 00 00)"
encode-bytes encode+
" "(0a 00 00 03 00 00 3f 00 00 46 02 00 01 00 00 10 00 12 c0 00 00 0e 00 00 01 00 00 3f 00 00 47 02 00 01 00 00 10 00 15 7c 00 00 0e 00 00 02 00 00 3f 00 00 47 02 00 01 00 00 10 00 5d c0 00 00 0e 00 00 02 00 00 7f 00 00 48 02 00 01 00 00 18 00 07 d0 00 00 0a 00 00 01 00 00 3f 00 00 44 02 00 01 00 00 18 00 0b b8 00 00 0a 00 00 02 00 00 3f 00 00 86 02 00 01 00 00 18 00 0d 48 00 00 0c 00 00 02 00 00 7f 00 00 87 02 00 01 00 00 18 00 5d c0 00 00 0e 00 00 02 00 00 80 00 00 88 02 00 01 00 00 20 00 5d c0 00 00 0c 00 00 01 00 00 0f 02 25 0f ff ff ff ff 19 21 04 01 21 02 82 02 05 00 08 0f a0 00 04 00 01 00 3f 01 21 02 81 03 51 04 00 02 00 00 08 00 17 70 00 00 06 00 00 01 00 00 3f 00 00 03 04 00 02 00 00 08 00 24 b8 00 00 08 00 00 01 00 00 3f 00 00 04 04 00 02)"
encode-bytes encode+
" "(00 00 08 00 27 10 00 00 0a 00 00 01 00 00 3f 00 00 05 04 00 02 00 00 08 00 2b c0 00 00 0c 00 00 01 00 00 3f 00 00 06 04 00 02 00 00 08 00 5d c0 00 00 0e 00 00 01 00 00 04 00 00 07 04 00 02 00 00 10 00 0b b8 00 00 06 00 00 01 00 00 3f 00 00 03 04 00 02 00 00 10 00 10 68 00 00 08 00 00 01 00 00 3f 00 00 04 04 00 02 00 00 10 00 15 18 00 00 0a 00 00 01 00 00 3f 00 00 05 04 00 02 00 00 10 00 19 00 00 00 0c 00 00 01 00 00 08 00 00 06 04 00 02 00 00 10 00 23 28 00 00 0e 00 00 01 00 00 80 00 00 0a 04 00 02 00 00 10 00 5d c0 00 00 0e 00 00 01 00 00 80 00 00 0f 04 00 02 00 00 18 00 0b b8 00 00 0a 06 21 3f 03 21 05 01 21 04 01 21 02 03 21 18 02 22 10 68 03 21 0c 07 21 3f 81 03 06 00 00 06 04 00 02 00 00 18 00 11 94 00 00 28 00 00 01 06 21 07 01 21 04 01 21)"
encode-bytes encode+
" "(02 82 02 04 00 18 5d c0 00 2c 00 01 05 21 08 81 03 13 04 00 02 00 00 20 00 0b b8 00 00 0a 00 00 01 00 00 3f 00 00 06 04 00 02 00 00 20 00 0d 48 00 00 0e 00 00 01 00 00 3f 00 00 07 04 00 02 00 00 20 00 14 50 00 00 2e 00 00 01 06 21 0f 01 21 04 01 21 02 82 02 04 00 20 23 28 00 2e 00 01 05 21 10 01 21 04 01 21 02 82 02 04 00 20 5d c0 00 2e 00 01 05 21 16 81 03 51 04 00 01 00 00 08 00 0e d8 00 00 04 00 00 01 00 00 3f 00 00 04 04 00 01 00 00 08 00 11 30 00 00 06 00 00 01 00 00 3f 00 00 05 04 00 01 00 00 08 00 1e 78 00 00 06 00 00 02 00 00 3f 00 00 06 04 00 01 00 00 08 00 23 28 00 00 08 00 00 02 00 00 3f 00 00 08 04 00 01 00 00 08 00 5d c0 00 00 0a 00 00 02 00 00 3f 00 00 08 04 00 01 00 00 10 00 0b b8 00 00 06 00 00 01 00 00 3f 00 00 03 04 00 01 00 00)"
encode-bytes encode+
" "(10 00 0d 48 00 00 06 00 00 02 00 00 3f 00 00 04 04 00 01 00 00 10 00 0e d8 00 00 08 00 00 02 00 00 3f 00 00 05 04 00 01 00 00 10 00 11 30 00 00 0a 00 00 02 00 00 3f 00 00 06 04 00 01 00 00 10 00 16 a8 00 00 0c 00 00 02 00 00 3f 00 00 07 04 00 01 00 00 10 00 5d c0 00 00 0e 00 00 02 00 00 3f 00 00 08 04 00 01 00 00 18 00 07 d0 00 00 08 06 21 3f 81 03 23 00 00 04 04 00 01 00 00 18 00 0b b8 00 00 08 00 00 01 00 00 3f 00 00 04 04 00 01 00 00 18 00 0d 48 00 00 0a 00 00 01 00 00 3f 00 00 06 04 00 01 00 00 18 00 10 68 00 00 0c 00 00 01 00 00 3f 00 00 07 04 00 01 00 00 18 00 5d c0 00 00 0e 00 00 01 00 00 3f 00 00 08 04 00 01 00 00 20 00 5d c0 00 00 06 00 00 02 00 00 3f 02 25 03 ff ff ff ff 19 21 01 01 21 02 82 02 05 00 08 11 f8 00 04 00 01 00 3f 01 21 02)"
encode-bytes encode+
" "(81 03 6d 01 00 02 00 00 08 00 15 e0 00 00 06 00 00 01 00 00 3f 00 00 03 01 00 02 00 00 08 00 1b 58 00 00 06 00 00 02 00 00 3f 00 00 03 01 00 02 00 00 08 00 24 b8 00 00 08 00 00 02 00 00 3f 00 00 04 01 00 02 00 00 08 00 27 10 00 00 0a 00 00 02 00 00 3f 00 00 05 01 00 02 00 00 08 00 2b c0 00 00 0c 00 00 02 00 00 3f 00 00 06 01 00 02 00 00 08 00 36 b0 00 00 0e 00 00 02 00 00 bf 00 00 07 01 00 02 00 00 08 00 5d c0 00 00 0e 00 00 02 00 00 04 00 00 07 01 00 02 00 00 10 00 07 d0 00 00 06 00 00 01 00 00 3f 00 00 03 01 00 02 00 00 10 00 0d 48 00 00 06 00 00 02 00 00 3f 00 00 03 01 00 02 00 00 10 00 10 68 00 00 08 00 00 02 00 00 3f 00 00 04 01 00 02 00 00 10 00 15 7c 00 00 0a 00 00 02 00 00 3f 00 00 05 01 00 02 00 00 10 00 16 a8 00 00 0c 00 00 02 00 00 3f)"
encode-bytes encode+
" "(00 00 06 01 00 02 00 00 10 00 1b 58 00 00 0e 00 00 02 00 00 3f 00 00 07 01 00 02 00 00 10 00 1e dc 00 00 0e 00 00 02 00 00 85 00 00 07 01 00 02 00 00 10 00 5d c0 00 00 0e 00 00 02 00 00 80 00 00 07 01 00 02 00 00 18 00 07 d0 00 00 0a 06 21 3f 81 03 22 00 00 05 01 00 02 00 00 18 00 0b b8 00 00 0a 00 00 01 00 00 3f 00 00 05 01 00 02 00 00 18 00 0d ac 00 00 0a 00 00 01 00 00 08 00 00 05 01 00 02 00 00 18 00 0e d8 00 00 0c 00 00 01 00 00 08 00 00 06 01 00 02 00 00 18 00 10 04 00 00 0c 00 00 02 00 00 04 00 00 06 01 00 02 00 00 18 00 11 f8 00 00 0e 00 00 01 06 21 07 81 03 21 01 00 02 00 00 18 00 13 ec 00 00 28 00 00 03 00 00 80 00 00 04 01 00 02 00 00 18 00 5d c0 00 00 2c 00 00 02 00 00 40 00 00 06 01 00 02 00 00 20 00 0b b8 00 00 0a 00 00 02 00 00 3f)"
encode-bytes encode+
" "(00 00 05 01 00 02 00 00 20 00 0d ac 00 00 0c 00 00 02 00 00 06 00 00 06 01 00 02 00 00 20 00 0e d8 00 00 0c 00 00 03 06 21 06 81 03 81 0b 01 00 02 00 00 20 00 10 68 00 00 0e 00 00 02 00 00 80 00 00 07 01 00 02 00 00 20 00 14 50 00 00 2c 00 00 02 00 00 40 00 00 09 01 00 02 00 00 20 00 5d c0 00 00 2c 00 00 02 00 00 40 00 00 2f 01 00 01 00 00 08 00 0e d8 00 00 04 00 00 01 00 00 3f 00 00 02 01 00 01 00 00 08 00 15 18 00 00 06 00 00 01 00 00 3f 00 00 03 01 00 01 00 00 08 00 16 a8 00 00 08 00 00 01 00 00 3f 00 00 04 01 00 01 00 00 08 00 1e 78 00 00 0a 00 00 01 00 00 3f 00 00 05 01 00 01 00 00 08 00 21 34 00 00 0c 00 00 02 00 00 3f 00 00 06 01 00 01 00 00 08 00 5d c0 00 00 0e 00 00 02 00 00 3f 00 00 06 01 00 01 00 00 10 00 07 d0 00 00 06 00 00 01 00 00)"
encode-bytes encode+
" "(3f 00 00 03 01 00 01 00 00 10 00 0b b8 00 00 06 00 00 02 00 00 3f 00 00 03 01 00 01 00 00 10 00 0d 48 00 00 08 00 00 02 00 00 3f 00 00 04 01 00 01 00 00 10 00 0e d8 00 00 0a 00 00 02 00 00 3f 00 00 05 01 00 01 00 00 10 00 11 30 00 00 0c 00 00 02 00 00 3f 00 00 06 01 00 01 00 00 10 00 16 a8 00 00 0e 00 00 02 00 00 3f 00 00 07 01 00 01 00 00 10 00 5d c0 00 00 2c 00 00 03 00 00 40 00 00 06 01 00 01 00 00 18 00 0b b8 00 00 0a 00 00 01 00 00 3f 00 00 05 01 00 01 00 00 18 00 0d 48 00 00 0c 00 00 02 00 00 08 00 00 06 01 00 01 00 00 18 00 5d c0 00 00 0e 00 00 02 00 00 08 00 00 07 01 00 01 00 00 20 00 5d c0 00 00 06 00 00 02 00 00 3f 02 25 03 ff ff ff ff 18 25 45 6e 74 72 79 0a 21 01 81 03 0a 00 00 04 00 00 08 00 00 10 00 00 20 08 00 00 10 00 00 20 00 00)"
encode-bytes encode+
" "(40 00 00 60 00 00 80 00 00 09 22 55 ac 82 02 1f 55 60 55 ac 55 ac 55 60 55 ac 55 ac 55 ac 55 60 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 84 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 55 ac 26 55 98 45 44 49 44 0b 22 01 01 02 21 08 01 20 81 7f 05 09 0b 0e 10 13 15 17 19 1b 1d 1e 20 22 24 25 27 28 2a 2c 2d 2f 30 31 33 34 36 37 38 3a 3b 3c 3e 3f 40 42 43 44 45 47 48 49 4a 4b 4d 4e 4f 50 51 52 54 55 56 57 58 59 5a 5b 5c 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 81 81 82 83 84 85 86 87 88 89 8a 8b 8c 8c 8d 8e 8f 90 91 92 93 94 95 95 96 97 98 99 9a 9b 9b 9c 9d 9e 9f a0 a1 a1 a2 a3 a4 a5 a6 a6 a7 a8 a9 aa ab ab ac ad ae af b0 b0 b1 b2 b3 b4 b4 b5)"
encode-bytes encode+
" "(b6 b7 b8 b8 b9 ba bb bc bc bd be bf c0 c0 c1 c2 c3 c3 c4 c5 c6 c7 c7 c8 c9 ca ca cb cc cd cd ce cf d0 d0 d1 d2 d3 d3 d4 d5 d6 d6 d7 d8 d9 d9 da db dc dc dd de df df e0 e1 e1 e2 e3 e4 e4 e5 e6 e7 e7 e8 e9 e9 ea eb ec ec ed ee ee ef f0 f1 f1 f2 f3 f3 f4 f5 f5 f6 f7 f8 f8 f9 fa fa fb fc fc fd fe ff 07 22 03 01 02 21 08 01 20 81 7f 03 06 09 0c 10 10 12 13 15 16 16 18 1b 1c 1e 1f 22 23 26 28 2b 2c 2f 32 34 37 3a 3c 3f 40 41 42 43 44 45 46 47 47 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 54 56 56 57 58 59 5a 5b 5c 5d 5e 5f 60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 72 73 74 75 76 77 78 79 7a 7a 7b 7c 7d 7e 7f 81 82 83 83 84 85 86 87 88 89 8a 8a 8b 8c 8d 8e 8f 90 91 92 93 93 94 95 96 97 98 98 99 9a 9b 9c 9d 9e 9f a0 a1 a1 a2 a3 a4 a4 a5 a6 a7 a8)"
encode-bytes encode+
" "(a8 a9 aa ab ac ad ad ae af b0 b1 b2 b2 b3 b4 b5 b5 b6 b7 b8 b8 b9 ba bb bc bc bd be bf c0 c0 c1 c2 c3 c3 c4 c5 c6 c6 c7 c8 c9 c9 ca cb cc cd cd ce cf d0 d1 d1 d2 d3 d4 d4 d5 d6 d7 d7 d8 d9 da da db dc dd de de df e0 e1 e1 e2 e3 e4 e4 e5 e6 e7 e7 e8 e9 ea ea eb ec ed ee ee ef f0 f1 f1 f2 f3 f4 f4 f5 f6 f7 f8 f8 f9 fa fb fb fc fd fe ff ff 01 20 81 7f 03 06 09 0c 10 10 18 20 20 22 23 24 25 27 28 29 2c 2d 2e 30 32 34 37 38 3a 3d 3f 40 41 42 42 43 44 44 45 46 47 48 49 4a 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5b 5c 5d 5e 5f 60 61 62 63 64 65 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 71 72 73 74 74 75 76 77 78 79 79 7a 7b 7c 7d 7e 7f 80 81 82 83 84 84 85 86 87 88 88 89 8a 8b 8c 8d 8e 8e 8f 90 91 92 93 93 94 95 96 96 97 98 99 9a 9a 9b 9c 9d 9e 9e)"
encode-bytes encode+
" "(9f a0 a1 a2 a2 a3 a4 a5 a5 a6 a7 a8 a8 a9 aa ab ab ac ad ae af af b0 b1 b2 b2 b3 b4 b5 b5 b6 b7 b7 b8 b9 ba ba bb bc bd bd be bf c0 c1 c1 c2 c3 c3 c4 c5 c6 c6 c7 c8 c9 c9 ca cb cc cc cd ce cf cf d0 d1 d2 d2 d3 d4 d4 d5 d6 d6 d7 d8 d9 d9 da db dc dc dd de de df e0 e1 e1 e2 e3 e4 e4 e5 e6 e6 e7 e8 e9 e9 ea eb ec ec ed ee ef ef f0 f1 f2 f2 f3 f4 f4 f5 f6 f7 f7 01 20 81 7f 02 05 08 0a 0d 10 10 10 20 20 22 23 23 24 25 25 27 28 29 2a 2c 2d 2e 2f 30 32 33 34 36 37 38 3a 3c 3d 3f 40 41 41 42 42 43 44 44 45 45 46 47 47 48 49 4a 4a 4b 4c 4d 4d 4e 4f 4f 51 51 52 53 54 55 56 56 57 58 59 5a 5b 5c 5d 5e 5f 60 60 61 62 62 63 64 64 65 66 66 67 68 69 69 6a 6b 6c 6c 6d 6e 6f 6f 70 71 72 72 73 74 74 75 76 77 77 78 79 79 7a 7b 7c 7c 7d 7e 7f 80 81 82 82 83 84 84 85)"
encode-bytes encode+
" "(86 86 87 88 88 89 8a 8a 8b 8c 8d 8d 8e 8f 90 90 91 91 92 93 93 94 95 95 96 97 97 98 99 99 9a 9b 9b 9c 9d 9d 9e 9f a0 a0 a1 a1 a2 a3 a3 a4 a4 a5 a6 a6 a7 a7 a8 a9 a9 aa ab ab ac ad ad ae af af b0 b0 b1 b2 b2 b3 b3 b4 b5 b5 b6 b6 b7 b8 b8 b9 ba ba bb bb bc bd bd be bf bf c0 c0 c1 c2 c2 c3 c3 c4 c5 c5 c6 c6 c7 c8 c8 c9 c9 ca cb cb cc cc cd ce ce cf d0 d0 d1 d1 d2 d3 d3 d4 d4 d5 d6 07 22 01 01 02 20 82 01 08 05 07 08 09 0b 0c 0d 0f 10 11 12 14 15 16 18 19 1a 1c 1d 1e 20 21 22 23 24 26 28 29 2a 2c 2d 2f 30 31 33 34 36 37 38 39 3a 3c 3d 3e 40 41 42 43 44 45 46 48 49 4b 4c 4d 4e 4f 50 51 52 53 54 55 57 58 59 5a 5b 5c 5d 5e 5f 60 61 63 63 65 65 67 67 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7a 7b 7c 7d 7e 7f 81 82 83 83 84 85 86 87 88 89 8a)"
encode-bytes encode+
" "(8b 8c 8d 8e 8e 90 90 91 92 93 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f a0 a0 a1 a2 a3 a4 a4 a5 a6 a7 a8 a9 aa aa ac ad ad ae ae b0 b1 b2 b3 b3 b4 b5 b6 b7 b8 b9 b9 ba bb bc bd be bf bf c0 c1 c2 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd cd ce ce cf d0 d1 d2 d3 d3 d4 d5 d6 d6 d7 d8 d8 d9 da db dc dd de de df e0 e1 e1 e2 e3 e4 e4 e5 e6 e7 e7 e8 e9 ea eb ec ed ee ee ef ef f0 f1 f2 f3 f3 f4 f5 f6 f7 f8 f8 f9 f9 fa fb fc fd fe ff 07 22 01 01 02 21 08 01 20 82 0c 0a 14 1d 23 26 2b 2e 30 32 34 37 39 3b 3c 3e 40 41 42 44 45 47 48 4a 4b 4d 4e 4f 50 51 52 54 55 56 57 58 5a 5b 5c 5d 5e 5f 60 61 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f 80 80 81 82 83 84 84 85 86 87 88 89 8a 8a 8b 8c 8d 8e 8f 90 90 91 92 92 93 94 95 96)"
encode-bytes encode+
" "(97 97 98 99 9a 9a 9b 9c 9d 9e 9e 9f a0 a1 a1 a2 a3 a3 a4 a5 a6 a7 a7 a8 a9 aa aa ab ac ad ad ae af af b0 b1 b2 b2 b3 b4 b4 b5 b6 b6 b7 b7 b8 b9 b9 ba bb bc bc bd be be bf c0 c0 c1 c2 c2 c3 c4 c5 c5 c6 c6 c7 c8 c8 c9 ca cb cc cd cd ce cf cf d0 d0 d1 d2 d2 d3 d3 d4 d5 d6 d6 d7 d7 d8 d9 d9 da da db dc dd dd de df df e0 e0 e1 e2 e3 e3 e4 e5 e5 e6 e6 e7 e7 e8 e8 e9 ea ea eb eb ec ed ed ee ef f0 f0 f1 f2 f2 f3 f4 f4 f5 f5 f6 f7 f7 f8 f9 fa fa fb fc fc fd fe fe ff 4d 61 63 20 53 74 64 20 47 61 6d 6d 61 01 30 50 61 67 65 2d 57 68 69 74 65 20 47 61 6d 6d 61 01 2d 4d 61 63 20 52 47 42 20 47 61 6d 6d 61 01 2e 4d 61 63 20 47 72 61 79 20 47 61 6d 6d 61 03 22 1d 24 02 22 1d 32 02 22 1d 43 02 22 1d 51 03 25 43 01 06 01 49 01 21 43 01 21 c3 01 21 43 01 2b 43 41)"
encode-bytes encode+
" "(54 49 2c 63 72 65 61 74 65 01 2b 41 54 49 2c 61 64 61 70 74 65 72 0a 22 41 f0 86 02 01 41 e0)"
encode-bytes encode+ " driver,AAPL,MacOS,PowerPC" property
