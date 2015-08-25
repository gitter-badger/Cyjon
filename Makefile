# test script

ASM=nasm -f bin
SOFTWARE=software
BOOTLOADER=bootloader

all:
	$(ASM) $(SOFTWARE)/init.asm -o init.bin
	$(ASM) $(SOFTWARE)/login.asm -o login.bin
	$(ASM) $(SOFTWARE)/shell.asm -o shell.bin
	$(ASM) $(SOFTWARE)/help.asm -o help.bin
	$(ASM) $(SOFTWARE)/uptime.asm -o uptime.bin
	$(ASM) $(SOFTWARE)/moko.asm -o moko.bin

	$(ASM) kernel.asm -o kernel.bin

	$(ASM) $(BOOTLOADER)/stage2.asm -o stage2.bin
	$(ASM) $(BOOTLOADER)/stage1.asm -o build/disk.raw

clean:
	rm -f init.bin login.bin shell.bin help.bin uptime.bin moko.bin