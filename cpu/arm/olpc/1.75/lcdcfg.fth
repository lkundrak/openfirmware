h# d102.0000 constant video-sram-pa  \ Base of Video SRAM
h#    1.0000 constant /video-sram

dev /
new-device
   " vsram" device-name
   video-sram-pa /video-sram reg

   " marvell,mmp-vsram" +compatible
   d# 64 " granularity" integer-property
finish-device
device-end

fload ${BP}/dev/olpc/panel.fth

[ifdef] mmp3
dev /
new-device
   " hdmi-connector" name
   " hdmi-connector" +compatible
   " /hdmi-i2c" encode-phandle " ddc-i2c-bus" property
   " a" " type" string-property
   " hdmi" " label" string-property

    0 0 encode-bytes
       hdmi-hp-det-gpio# 0 encode-gpio
      " hpd-gpios" property

   new-device
      " port" device-name
      new-device
         " endpoint" device-name
      finish-device
   finish-device
finish-device
device-end

" /hdmi-connector/port/endpoint"  " /display/ports/port@1/endpoint" link-endpoints
[then]

[ifdef] has-dcon
fload ${BP}/dev/olpc/dcon/mmp2dcon.fth        \ DCON control

dev /panel
   " /dcon" encode-phandle  " control-node" property
device-end
[then]
