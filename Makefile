assemble:
	nasm boot.asm -f bin -o boot.bin

boot: assemble
	qemu-system-i386 -fda boot.bin
