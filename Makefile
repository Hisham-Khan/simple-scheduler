PROJECT=demo
CPU ?= cortex-m3
BOARD ?= stm32vldiscovery

qemu:
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c demo.S -o demo.o
	arm-none-eabi-ld -Tmap.ld demo.o -o demo.elf
	arm-none-eabi-objdump -D -S demo.elf > demo.elf.lst
	arm-none-eabi-objcopy -O binary demo.elf demo.bin
	arm-none-eabi-readelf -a demo.elf > demo.elf.debug
	qemu-system-arm -S -M $(BOARD) -cpu $(CPU) -nographic -kernel $(PROJECT).elf -gdb tcp::1234

gdb:
	gdb-multiarch -q $(PROJECT).elf -ex "target remote localhost:1234"

view-bin:
	xxd -e -c 4 -g 4 demo.bin

clean:
	rm -rf *.out *.elf .gdb_history *.lst *.debug *.o *.bin
