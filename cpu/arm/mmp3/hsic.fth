purpose: MMP3 HSIC USB nodes

0 0  " f0001800"  " /" begin-package
   " hsic-phy" name
   h# 40 constant /regs
   my-address my-space /regs reg
   0 " #phy-cells" integer-property
   " usb-nop-xceiv" +compatible
   " marvell,mmp3-hsic-phy" +compatible

   " /gpio" encode-phandle
      hsic-reset-gpio# encode-int encode+
      d# 0 encode-int encode+
      " reset-gpios" property

   : open true ;
   : close ;

   : +phy          ( reg -- va )   my-space io2-pa - io2-va + +  ;
   : hsic-ctrl!    ( val -- )      h# 08 +phy l! ;
   : hsic-ctrl@    ( -- val )      h# 08 +phy l@ ;
   : hsic-enable+  ( val -- val )  h# 80 or ;
   : pll-bypass+   ( val -- val )  h# 10 or ;

   h# 10 constant hsic-pll-bypass
   h# 80 constant hsic-enable

   : init
      hsic-ctrl@
      hsic-enable+
      pll-bypass+
      hsic-ctrl!
   ;
end-package

0 0  " f0001000"  " /" begin-package
   h# 200 constant /regs
   my-address my-space /regs reg

   : my-map-in  ( len -- adr )
      my-space swap  " map-in" $call-parent  h# 100 +  ( adr )
   ;
   : my-map-out  ( adr len -- )  swap h# 100 - swap " map-out" $call-parent  ;

   false constant has-dbgp-regs?
   false constant needs-dummy-qh?
   : grab-controller  ( config-adr -- error? )  drop false  ;

   fload ${BP}/dev/usb2/hcd/ehci/loadpkg.fth

   " marvell,pxau2o-ehci" +compatible

   " USBCLK" " clock-names" string-property
   " /clocks" encode-phandle mmp2-usbhsic0-clk# encode-int encode+ " clocks" property
   d# 22 " interrupts" integer-property

   " hsic" " phy_type" string-property
   " usb" " phy-names" string-property
   " /hsic-phy@f0001800" encode-phandle " phys" property

   \ Test on/off dance required for unknown reasons
   : hsic-set-host-mode
      0 portsc@
      dup
      h# 0005.0000 or  ( test-on test-off )
      0 portsc!        \ Enable test mode
      0 portsc!        \ Back to test disabled
   ;
   ' hsic-set-host-mode to set-host-mode

   \ Set up "reserved" bits that actually enable HSIC
   : hsic-init-extra
      0 portsc@
      h# 0200.0000 or
      h# 3fff.ffff and
      0 portsc!
   ;
   ' hsic-init-extra to init-extra
end-package