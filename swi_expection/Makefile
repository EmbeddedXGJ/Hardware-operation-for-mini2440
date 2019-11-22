objs = start.o uart.o relocate.o init.o main.o

sdram.bin: $(objs)
	arm-linux-ld -T sdram.lds $^ -o sdram.elf
	arm-linux-objcopy  -O binary -S sdram.elf sdram.bin
	arm-linux-objdump -D sdram.elf > sdram.dis

%.o : %.c
	arm-linux-gcc -c -o $@ $<
%.o : %.S
	arm-linux-gcc -c -o $@ $<
clean:
	rm *.o *.dis *.bin *.elf
