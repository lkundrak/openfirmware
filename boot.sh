set -e
set -x

make -C cpu/x86/Linux/ sparcfth forth

cpu/x86/Linux/forth cpu/x86/build/builder.dic cpu/sparc/kernel.bth

setarch -BR cpu/x86/Linux/sparcfth tokenize.exe -s 'tokenize test-pci.fth'
setarch -BR cpu/x86/Linux/sparcfth kernel.dic cpu/sparc/tools.bth
setarch -BR cpu/x86/Linux/sparcfth tools.dic "$@"
