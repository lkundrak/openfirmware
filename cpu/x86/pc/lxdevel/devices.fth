\ See license at end of file
purpose: Load device drivers according to configuration definitions

: gx?  ( -- flag )  h# 4c000017 msr@ drop  4 rshift  2 =  ;
: lx?  ( -- flag )  h# 4c000017 msr@ drop  4 rshift  3 =  ;

fload ${BP}/cpu/x86/pc/isaio.fth

[ifdef] rom-loaded
fload ${BP}/cpu/x86/pc/lxdevel/vsapci.fth	\ PCI configuration access with some hacks
[else]
fload ${BP}/dev/pci/configm1.fth	\ Generic PCI configuration access
[then]

0 0  " "  " /"  begin-package
   fload ${BP}/cpu/x86/pc/mappci.fth	\ Map PCI to root
   fload ${BP}/dev/pcibus.fth		\ Generic PCI bus package
   fload ${BP}/cpu/x86/pc/lxdevel/pcinode.fth	\ System-specific words for PCI
end-package
stand-init: PCI host bridge
   " /pci" " init" execute-device-method drop
;

fload ${BP}/dev/pciprobe.fth		\ Generic PCI probing

\ Use the CPU chip's Time Stamp Counter for timing; it does just what we want
fload ${BP}/cpu/x86/tsc.fth
d# 366,666 to ms-factor
d# 367 to us-factor

[ifdef] use-root-isa
0 0  " "  " /" begin-package
   fload ${BP}/cpu/x86/pc/isabus.fth	\ ISA Bus Bridge under root node
end-package
[then]

[ifdef] use-pci-isa

[ifdef] addresses-assigned
[ifdef] use-pci-isa
\ This must precede isamisc.fth in the load file, to execute it first
fload ${BP}/cpu/x86/pc/moveisa.fth
[then]
[then]

0 0  " 0"  " /pci" begin-package
   fload ${BP}/dev/pci/isa.fth		\ ISA bus bridge under PCI node
   fload ${BP}/dev/pci/isamisc.fth
end-package

[then]

: pnp!  ( b reg# -- )  h# 2e pc!  h# 2f pc!  ;
: pnp@  ( reg# -- b )  h# 2e pc!  h# 2f pc@  ;

stand-init: superio
   h# 87 h# 2e pc!  h# 87 h# 2e pc!  \ Enable PNP registers
   h# 20 pnp@  h# 52 =  if  \ Check device ID
      h#  5 h#  7 pnp!  \ Select keyboard controller
      h# 60 h# 61 pnp!  \ Port 60
      h# 64 h# 63 pnp!  \ Port 64
      h#  1 h# 70 pnp!  \ Keyboard interrupt 1
      h#  c h# 72 pnp!  \ Keyboard interrupt 12
      h# 83 h# f0 pnp!  \ i8042 clock, fast reset, fast A20
      h#  1 h# 30 pnp!  \ Enable
   then
;

1 [if]
dev /interrupt-controller
h# 20 to vector-base0
h# 28 to vector-base1
device-end
[then]

0 0  dropin-base <# u#s u#>  " /" begin-package
   " flash" device-name

[ifdef] addresses-assigned  dropin-size  [else]  h# 8.0000  [then]
   dup value /device
   constant /device-phys
   my-address my-space /device-phys reg
   fload ${BP}/dev/flashpkg.fth
   fload ${BP}/dev/flashwrite.fth

   : init  ( comp$ /device -- )
      to /device  2>r
      0 0 encode-bytes
      2r> encode-string encode+
      " rom" encode-string encode+
      " compatible" property
[ifdef] enable-flash-select      
      /device /device-phys <>  if  enable-flash-select  then
[then]
   ;
end-package

\ Create a node below the top-level FLASH node to accessing the portion
\ containing the dropin modules.
\ The number in the line below is the offset from the beginning of the
\ FLASH to the block that contains the dropin modules.
0 0  " 0"  " /flash" begin-package
   " dropins" device-name

   h# 70000 constant /device      \ Size of the area for dropin modules
   fload ${BP}/dev/subrange.fth
end-package

devalias dropins /dropins

\ Create a pseudo-device that presents the dropin modules as a filesystem.
0 0 " "  " /" begin-package
   fload ${BP}/ofw/fs/dropinfs.fth
end-package

\ This devalias lets us say, for example, "dir rom:"
devalias rom     /dropin-fs

fload ${BP}/cpu/x86/forthint.fth	\ Low-level interrupt handling code
fload ${BP}/dev/isa/irq.fth		\ ISA interrupt dispatcher
fload ${BP}/cpu/x86/pc/isatick.fth	        \ Use ISA timer as the alarm tick timer

[ifdef] resident-packages
support-package: 16550
fload ${BP}/dev/16550pkg/16550.fth  \ Serial port support package
end-support-package
[then]

fload ${BP}/dev/pci/isaall.fth
devalias com1 /isa/serial@i3f8:115200
devalias mouse /isa/8042/mouse
devalias d disk
devalias n nand
devalias u /usb/disk

0 0  " i70"  " /isa" begin-package   	\ Real-time clock node
   fload ${BP}/dev/ds1385r.fth
   8 encode-int  0 encode-int encode+    " interrupts" property
   2 encode-int " device#" property
end-package
stand-init: RTC
   " /rtc" open-dev  clock-node !
;

fload ${BP}/cpu/x86/pc/cpunode.fth

0 [if]
fload ${BP}/ofw/console/bailout.fth
stand-init:  Keyboard overrides
   ?bailout
;
[then]

fload ${BP}/forth/lib/pattern.fth	\ Text string pattern matching
\ XXX remove the OS file commands from tools.dic
fload ${BP}/ofw/core/filecmds.fth	\ File commands: dir, del, ren, etc.

\ This alias will work for either the CS5536 NAND FLASH
\ or the CaFe NAND FLASH, whichever is present.
devalias nand /nandflash

[ifdef] pseudo-nvram
fload ${BP}/cpu/x86/pc/biosload/filenv.fth
dev /file-nvram
: floppy-nv-file  ( -- )  " a:\nvram.dat"  ;
' floppy-nv-file to nv-file
device-end
stand-init: Pseudo-NVRAM
   " /file-nvram" open-dev  to nvram-node
   nvram-node 0=  if
      ." The configuration EEPROM is not working" cr
   then
   ['] init-config-vars catch drop
;
[then]

[ifdef] use-null-nvram
\ For not storing configuration variable changes across reboots ...
\ This is useful for "turnkey" systems where configurability would
\ increase support costs.

fload ${BP}/cpu/x86/pc/nullnv.fth
stand-init: Null-NVRAM
   " /null-nvram" open-dev  to nvram-node
   ['] init-config-vars catch drop
;
[then]

[ifdef] use-flash-nvram
\ For configuration variables stored in a sector of the boot FLASH ...

\ Create a node below the top-level FLASH node to access the portion
\ containing the configuration variables.

\ The number in the line below is the offset from the beginning of the
\ FLASH to the block that contains the configuration variables.
0 0  " 70000"  " /flash" begin-package
   " nvram" device-name

   \ Size of configuration variable area.  Typically the size of
   \ a FLASH block (erase unit).
   h# 10000 constant /device
   fload ${BP}/dev/subrange.fth
end-package

stand-init: NVRAM
   " /nvram" open-dev  to nvram-node
   ['] init-config-vars catch drop
;
[then]

\ Create the alias unless it already exists
: $?devalias  ( alias$ value$ -- )
   2over  not-alias?  if  $devalias exit  then  ( alias$ value$ alias$ )
   2drop 4drop
;

: report-disk  ( -- )
   " /usb/disk" locate-device  0=  if
      drop
      " disk"  " /usb/disk"   $devalias
      exit
   then
   " /usb@f,4/disk" locate-device  0=  if
      ." Found USB 1.1 disk!" cr
      drop
      " disk"  " /usb@f,4/disk" $devalias
      exit
   then
;

: report-keyboard  ( -- )
   " /usb@f,4/keyboard" locate-device  0=  if
      drop
      " keyboard"  " /usb@f,4/keyboard"  $devalias
      exit
   then

   \ In case the keyboard is behind a USB 2 hub
   " /usb@f,5/keyboard" locate-device  0=  if
      drop
      " keyboard"  " /usb@f,5/keyboard"  $devalias
   then
;

fload ${BP}/cpu/x86/inoutstr.fth	\ Multiple I/O port read/write
fload ${BP}/dev/isa/diaguart.fth	\ ISA COM port driver
\ : inituarts ascii G uemit  ascii o uemit  ;  \ They are already on

h# 3f8 is uart-base
fload ${BP}/forth/lib/sysuart.fth	\ Use UART for key and emit

[ifndef] save-flash
: save-flash ;
: restore-flash ;
[then]

\needs md5init  fload ${BP}/ofw/ppp/md5.fth                \ MD5 hash

stand-init: PCI properties
   " /pci" find-device
   d# 66,666,667  " clock-frequency" integer-property
   dend
;

fload ${BP}/dev/geode/lpcflash.fth           \ Reflasher for LPC FLASH

: +i encode-int encode+  ;  : 0+i  0 +i  ;

false config-int tft-mode?

fload ${BP}/cpu/x86/fb16-ops.fth
fload ${BP}/ofw/termemu/fb16.fth
0 0  " 1,1"  " /pci" begin-package
   fload ${BP}/dev/geode/display/loadpkg.fth     \ Geode display

   0 0 encode-bytes
   h# 8200.0910 +i  0+i h# fd00.0000 +i  0+i h# 0100.0000 +i  \ Frame buffer
   h# 8200.0914 +i  0+i h# fe00.0000 +i  0+i h# 0000.4000 +i  \ GP
   h# 8200.0918 +i  0+i h# fe40.0000 +i  0+i h# 0000.4000 +i  \ DC
   h# 8200.091c +i  0+i h# fe80.0000 +i  0+i h# 0000.4000 +i  \ VP
   h# 8200.0920 +i  0+i h# fec0.0000 +i  0+i h# 0000.4000 +i  \ VIP (LX only)
   " assigned-addresses" property

end-package
devalias screen /display

fload ${BP}/dev/geode/gpio.fth		 \ Rudimentary GPIO driver
\ fload ${BP}/dev/geode/acpi.fth           \ Power management

\ LICENSE_BEGIN
\ Copyright (c) 2006 FirmWorks
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
