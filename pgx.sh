set -e
set -x

toke -Idev/video -o pgx64.fc pgx64.fs
toke -Idev/video -fAlways-External -drxl-debug -drxl-custom -o dpgx64.fc pgx64.fs
toke -Idev/video -fAlways-External -drxl-debug -drxl-custom -drxl-bugfix -o fpgx64.fc pgx64.fs
echo "f374dc7d49e8ea156566fd4ccdba39a8  pgx64.fc"
md5sum pgx64.fc dpgx64.fc fpgx64.fc
grep '^: toke' dev/video/loadpgx64.fth |wc -l
