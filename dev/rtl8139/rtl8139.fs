tokenizer[
   h# 10ec    \ Vendor
   h# 8139    \ Product
   h# 020000  \ Class
]tokenizer pci-header

FCode-version3
   : .version    ." Realtek 8139 support package. Version 1.0, Fri Dec 2024." cr  ;
   : .copyright  ." Copyright (C) 2024 Lubomir Rintel <lkundrak@v3.sk>"       cr  ;

   fload rtl8139.fth

   .version
   probe
end0

pci-header-end
