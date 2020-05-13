\ See license at end of file
purpose: MMP2 audio clock management

\ From include/dt-bindings/clock/marvell,mmp2-audio.h
d# 0 constant mmp2-audio-sys-clk#
d# 1 constant mmp2-audio-sspa0-clk#
d# 2 constant mmp2-audio-sspa1-clk#

0 0  " "  " /" begin-package
" audio-clocks" name

h# c30 +audio  h# 10 reg
[ifdef] mmp2 " marvell,mmp2-audio-clock" +compatible  [then]
[ifdef] mmp3 " marvell,mmp3-audio-clock" +compatible  [then]

0 0 encode-bytes
   " /clocks" encode-phandle encode+ mmp2-audio-clk# encode-int encode+
   " /clocks" encode-phandle encode+ mmp2-vctcxo-clk# encode-int encode+
   " /clocks" encode-phandle encode+ mmp2-i2s0-clk# encode-int encode+
   " /clocks" encode-phandle encode+ mmp2-i2s1-clk# encode-int encode+
   " clocks" property
0 0 encode-bytes
   " audio" encode-string encode+
   " vctcxo" encode-string encode+
   " i2s0" encode-string encode+
   " i2s1" encode-string encode+
   " clock-names" property
" /clocks" encode-phandle mmp2-audio-pd# encode-int encode+
   " power-domains" property
1 " #clock-cells" integer-property
end-package

\ LICENSE_BEGIN
\ Copyright (c) 2020 Lubomir Rintel <lkundrak@v3.sk>
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
