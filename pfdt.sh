set -e

# : nop ; patch nop ?file reflash 00900000 00800000 do key i c! loop

make -C cpu/x86/pc/olpc/build
echo 'h# 2000 dup alloc-mem  swap flatten-device-tree  fdt-ptr fdt - dump  bye' |
	timeout 2 ./cpu/x86/Linux/forth ./cpu/x86/pc/olpc/build/fw.dic |
	perl -ne '/^ \S+  (.*)  .{16}$/ and print map { chr hex } split /\s+/, $1' |
	fdtdump - >FDT 2>&1

su -c 'install -m644 ./cpu/x86/pc/olpc/build/q2f20.rom /var/www/html/x.rom'
	
#	dtc -I dtb -O dts -f |tee olpc.dts
