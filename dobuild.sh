#git clean -ffdx */
set -e

F=cpu/arm/olpc/1.75/build

for DIR in $F; do
        CROSS=arm-linux-gnu- make -C $DIR
        echo 'h# 10000 dup alloc-mem  swap flatten-device-tree  fdt-ptr fdt - dump  bye' |
                timeout 2 cpu/x86/Linux/armforth $DIR/fw.dic  |
                perl -ne '/^ \S+  (.*)  .{16}$/ and print map { chr hex } split /\s+/, $1' |
                dtc -I dtb -O dts >$DIR/fw.dts
	sed "$(awk '/phandle = / {print "s/"$4"/100"++n"/g;"}' $DIR/fw.dts)" -i $DIR/fw.dts
done
