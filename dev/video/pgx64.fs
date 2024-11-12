tokenizer[
  h# 1002  h# 4752  h# 030000  pci-header
  0 set-rev-level
]tokenizer

\ f1 08 57fe 00007fa0
FCode-version3 ( start1 )

fload loadpgx64.fth

\ Another end0
[ifndef] rxl-custom
   tokenizer[ 0 emit-byte ]tokenizer
[then]

end0

pci-header-end
