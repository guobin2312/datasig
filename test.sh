#! /bin/bash

#declare -a ARCHs=(x86 x86_64 mips arm)
declare -a ARCHs=(x86 x86_64)

rm -rf "${ARCHs[@]}"
make clean
mkdir -p "${ARCHs[@]}"

for arch in "${ARCHs[@]}"; do
    make ARCH=$arch
    cp datasig datasig.o datasig-gdb.txt datasig-gdb.md5 datasig-gdb.crc datasig-one.txt datasig-one.md5 datasig-one.crc $arch/
    make clean
done

md5sum "${ARCHs[@]/%//datasig-gdb.txt}"
md5sum "${ARCHs[@]/%//datasig-one.txt}"
for f in "${ARCHs[@]/%//datasig-gdb.crc}"; do
    echo -n "$f	"; cat $f
done
for f in "${ARCHs[@]/%//datasig-one.crc}"; do
    echo -n "$f	"; cat $f
done
