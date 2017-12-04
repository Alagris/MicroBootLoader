#!/bin/bash

mkdir -p build/asm &&
mkdir -p build/iso &&
mkdir -p build/obj

# NAME=NASM_only
# nasm test/start.s  -f bin -o build/start.bin &&

# NAME=NASM_objcopy
# nasm test/start.s  -f elf64 -o obj/start.o &&
# objcopy -O binary obj/start.o build/start.bin &&

# NAME=NASM_gcc_Ttext
# nasm test/start.s  -f elf64 -o obj/start.o &&
# gcc test/main.c -c -static -nostdlib -nostartfiles -ffreestanding -march=x86-64 -o obj/main.o &&
# ld  -Ttext 0x7C00 -r obj/main.o obj/start.o -o obj/image.o &&
# objcopy  -O binary obj/image.o build/start.bin &&

# NAME=NASM_gcc_Ttext_twice
# nasm test/start.s  -f elf64 -o obj/start.o &&
# gcc test/main.c -Ttext 0x7C00  -c -static -nostdlib -nostartfiles -ffreestanding -march=x86-64 -o obj/main.o &&
# ld  -Ttext 0x7C00 -r obj/main.o obj/start.o -o obj/image.o &&
# objcopy  -O binary obj/image.o build/start.bin &&

# NAME=gcc_only2
# gcc test/main.c -Ttext 0x7C00  -c -static -nostdlib -nostartfiles -ffreestanding  -fno-asynchronous-unwind-tables -o obj/main.o &&
# objcopy  -O binary obj/main.o build/start.bin &&

# NAME=NASM_calling_c
# nasm test/start.s -f elf64 -o obj/start.o &&
# gcc test/main.c -Ttext 0x7C00 -c -static -nostdlib -nostartfiles -ffreestanding -fno-asynchronous-unwind-tables -o obj/main.o &&
# ld -Ttext 0x7C00 --nmagic -r obj/main.o obj/start.o -o obj/image.o &&
# objcopy -O binary obj/image.o build/start.bin &&

# NAME=GAS_only
# as test/start1.asm -o obj/start.o &&
# ld -Ttest1.ld  --nmagic obj/start.o -o build/image.bin &&

# NAME=GAS_only2
# as test/start2.asm -o obj/start.o &&
# ld -Ttest2.ld  --nmagic obj/start.o -o build/image.bin &&

# NAME=GCC_onlyS
# gcc test/main.c -c -S -static -nostdlib -nostartfiles -ffreestanding -fno-asynchronous-unwind-tables -o test/main.s
# as test/main.s -o obj/main.o &&
# ld -Ttest2.ld -r --nmagic obj/main.o -o obj/image.o &&
# objcopy -O binary obj/image.o build/image.bin &&

# NAME=GCC_only
# gcc test/main1.c -c -static -nostdlib -nostartfiles -ffreestanding -fno-asynchronous-unwind-tables -o obj/main.o &&
# strip -R .comment obj/main.o &&
# ld -Ttest2.ld -r --nmagic obj/main.o -o obj/image.o &&
# objcopy -O binary obj/image.o build/image.bin &&


# NAME=GCC_GAS
# gcc test/main.c -m64 -S -static -nostdlib -nostartfiles -ffreestanding -fno-asynchronous-unwind-tables -o build/asm/main.asm &&
# as --64 build/asm/main.asm -o build/obj/main.o &&
# # gcc test/main.c -m64 -c -static -nostdlib -nostartfiles -ffreestanding -fno-asynchronous-unwind-tables -o build/obj/main.o  &&
# ld -Ttest3.ld -r --nmagic build/obj/main.o -o build/obj/image.o &&
# objcopy -O binary build/obj/image.o build/image.bin &&


# NAME=GAS_only3
# as test/start2.asm -o build/obj/start.o &&
# ld -Ttest3.ld  --nmagic build/obj/start.o -o build/obj/image.o &&
# objcopy -O binary build/obj/image.o build/image.bin

# dd if=/dev/zero of=build/iso/image.img bs=1024 count=1440 &&
# dd if=build/image.bin of=build/iso/image.img seek=0 count=1 conv=notrunc &&


genisoimage -V 'image' -input-charset iso8859-1 -o build/image.iso -b image.img -hide image.img build/iso/ &&

read -p "press enter to dump to $NAME" &&
# objdump -D -b binary -mi386 build/image.bin > log/dump$NAME
objdump -D build/image.bin > log/dump$NAME

