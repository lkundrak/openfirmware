\ See license at end of file

[ifndef] cl2-a1
hp-plug-gpio# constant headphone-jack
mic-plug-gpio# constant external-mic
: pin-sense?  ( gpio# -- flag )  gpio-pin@  ;
: headphones-inserted?  ( -- flag )  headphone-jack pin-sense?  ;
: microphone-inserted?  ( -- flag )
   external-mic pin-sense?
\+ olpc-cl3   0=
;
[then]

dev /i2c@d4011000
new-device

[ifdef] cl2-a1
fload ${BP}/cpu/arm/olpc/alc5624.fth  \ Realtek ALC5624 CODEC
[else]
fload ${BP}/cpu/arm/olpc/alc5631.fth  \ Realtek ALC5631Q CODEC
[then]

finish-device
device-end

fload ${BP}/cpu/arm/mmp2/sound.fth

0 0 " "  " /"  begin-package
   " audio-complex" device-name
[ifdef] olpc-cl4
   " olpc,xo4-audio" +compatible
[then]
[ifdef] olpc-cl3
   " olpc,xo3-audio" +compatible
[then]
[ifdef] olpc-cl2
   " olpc,xo1.75-audio" +compatible
[then]
   : +string  encode-string encode+  ;

   " audio-graph-card" +compatible
   " OLPC XO" " label" string-property
   0 0 encode-bytes
      " Headphones" +string " HPOL"     +string
      " Headphones" +string " HPOR"     +string
      " MIC2"           +string " Mic Jack" +string
   " routing" property
   0 0 encode-bytes
      " Headphone"  +string " Headphones" +string
      " Microphone" +string " Mic Jack"       +string
   " widgets" property
   " /audio/port" encode-phandle " dais" property

   " /gpio" encode-phandle
      mic-plug-gpio# encode-int encode+
      0 encode-int encode+  \ GPIO_ACTIVE_HIGH
      " mic-det-gpio" property

   " /gpio" encode-phandle
      hp-plug-gpio# encode-int encode+
      0 encode-int encode+  \ GPIO_ACTIVE_HIGH
      " hp-det-gpio" property

   \ The name that was hardcoded in the Linux driver was OLPC XO-1.75
   " OLPC XO" " model" string-property

   0 0 reg  \ So linux will assign a static device name

   0 0 encode-bytes
      " Headphone Jack" +string " HPOL"     +string
      " Headphone Jack" +string " HPOR"     +string
      " MIC2"           +string " Mic Jack" +string
   " audio-routing" property

   " rt5631"        " dai-link-name"  string-property
   " rt5631"       " stream-name"     string-property
   " rt5631-hifi"  " codec-dai-name"  string-property

   " /audio-codec"  encode-phandle  " codec-node"    property
   " /audio"        encode-phandle  " cpu-dai-node"  property
   " /pcm"          encode-phandle  " platform-node" property

   \ SND_SOC_DAIFTM_xxx:
   \ 4000 is ..CBS_CFS - the codec is the slave for clk and FRM
   \ 0100 is ..NB_NF   - non-inverted BCLK and FRM
   \ 0001 is ..I2S     - standard I2S bit positions
   h# 4101  " dai-format" encode-int
end-package

\ LICENSE_BEGIN
\ Copyright (c) 2011 FirmWorks
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
