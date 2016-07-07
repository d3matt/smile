QEMU := qemu-system-x86_64
NASM := nasm

smile.bin: smile.nasm
	$(NASM) -f bin -o smile.bin smile.nasm

test: smile.bin
	$(QEMU) -fda smile.bin
