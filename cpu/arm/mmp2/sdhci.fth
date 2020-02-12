purpose: Device tree nodes for MMC

0 0  " d4280000"  " /" begin-package
   " sdhci" name
   " mrvl,pxav3-mmc" +compatible
   my-space  h# 120  reg
   " /clocks" encode-phandle mmp2-sdh0-clk# encode-int encode+ " clocks" property
   " io" " clock-names" string-property
   d# 39 " interrupts" integer-property
end-package

0 0  " d4280800"  " /" begin-package
   " sdhci" name
   " mrvl,pxav3-mmc" +compatible
   my-space  h# 120  reg
   " /clocks" encode-phandle mmp2-sdh1-clk# encode-int encode+ " clocks" property
   " io" " clock-names" string-property
   d# 52 " interrupts" integer-property
end-package

0 0  " d4281000"  " /" begin-package
   " sdhci" name
   " mrvl,pxav3-mmc" +compatible
   my-space  h# 120  reg
   " /clocks" encode-phandle mmp2-sdh2-clk# encode-int encode+ " clocks" property
   " io" " clock-names" string-property
   d# 53 " interrupts" integer-property
end-package

0 0  " d4281800"  " /" begin-package
   " sdhci" name
   " mrvl,pxav3-mmc" +compatible
   my-space  h# 120  reg
   " /clocks" encode-phandle mmp2-sdh3-clk# encode-int encode+ " clocks" property
   " io" " clock-names" string-property
   d# 54 " interrupts" integer-property
end-package

stand-init: SDHC clocks
   h# 400 h# 54 pmua!    \ Master SDH clock divisor
;
