set -x
set -e
git clean -fdx cpu dev
make -C cpu/x86/build builder.dic
make -C cpu/x86/pc/biosload/build
exec \
git checkout -f cpu/x86/build/builder.dic

cat >syslinux.cfg <<EOF
default mboot ofwgrub.elf
EOF

dd if=/dev/zero bs=1k count=1440 of=fd.img
mkfs.vfat fd.img
#mcopy -i fd.img cpu/x86/pc/biosload/build/ofw.c32 ::
mcopy -i fd.img \
	syslinux.cfg \
	cpu/x86/pc/biosload/build/ofwgrub.elf \
	/usr/share/syslinux/{libcom32,mboot}.c32 ::
syslinux -i fd.img
qemu-system-i386 \
	-netdev user,id=eth0 -device rtl8139,netdev=eth0 \
	-m 64 -serial stdio -fda fd.img
# ,romfile=dev/i8255x/build/82559.fc

# scp cpu/x86/pc/biosload/build/ofwgrub.elf root@apelord.local:/boot/ && ssh root@apelord.local 'grub-reboot ofw; reboot'
# minipro -u -s -p SST39SF512@PLCC32 -w ./dev/i8255x/build/82559.fc
# dnsmasq --no-daemon --bind-interface --interface=enp0s20f0u3 --log-debug --dhcp-range=172.31.68.100,172.31.68.200 --enable-tftp --dhcp-boot=prdel.fth --tftp-root=$PWD
