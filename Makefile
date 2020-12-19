compile1:
	nasm boot.asm -f bin -o boot.bin

run1: compile1
	qemu-system-i386 -fda boot.bin
