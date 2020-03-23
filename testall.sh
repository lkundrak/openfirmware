#set -x
set -e

CROSS=x86_64-linux-gnu- make -C cpu/x86/pc/olpc/build/
CROSS=arm-none-eabi-    make -C cpu/arm/olpc/1.75/build
CROSS=arm-none-eabi-    make -C cpu/arm/olpc/4.0/build
CROSS=arm-none-eabi-    make -C cpu/arm/mmp3/ariel/build/

dumpdts ()
{
	echo === $1 ===
	OUTPUT=$1; shift
	FORTH=$1; shift
	DIC=$1; shift
	(
		for i in $*; do echo fload $i; done
		echo 'hex 10000 dup alloc-mem swap flatten-device-tree /fdt dump bye'
	) |
	timeout 20 cpu/x86/Linux/$FORTH $DIC |
        sed -n 's/^ [^ ][^ ]* *\(.*\)  \(.*\)  ................/\1 \2/p' |
        awk '{printf "%08x: ", n++ * 16; print}' |xxd -r >$OUTPUT.dtb
	dtc $OUTPUT.dtb >$OUTPUT.dts
}

dumpdts XO1              x86forth cpu/x86/pc/olpc/build/fw.dic

dumpdts XO175            armforth cpu/arm/olpc/1.75/build/fw.dic

dumpdts XO4              armforth cpu/arm/olpc/4.0/build/fw.dic
dumpdts XO4-GIC          armforth cpu/arm/olpc/4.0/build/fw.dic   cpu/arm/mmp3/gic.fth
dumpdts XO4-COMPAT       armforth cpu/arm/olpc/4.0/build/fw.dic   cpu/arm/olpc/4.0/compat.fth
dumpdts XO4-COMPAT-GIC   armforth cpu/arm/olpc/4.0/build/fw.dic   cpu/arm/olpc/4.0/compat.fth cpu/arm/mmp3/gic.fth

dumpdts ARIEL            armforth cpu/arm/mmp3/ariel/build/fw.dic
dumpdts ARIEL-GIC        armforth cpu/arm/mmp3/ariel/build/fw.dic cpu/arm/mmp3/gic.fth
dumpdts ARIEL-COMPAT     armforth cpu/arm/mmp3/ariel/build/fw.dic cpu/arm/olpc/4.0/compat.fth
dumpdts ARIEL-COMPAT-GIC armforth cpu/arm/mmp3/ariel/build/fw.dic cpu/arm/olpc/4.0/compat.fth cpu/arm/mmp3/gic.fth
