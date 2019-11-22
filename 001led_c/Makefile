all:
	arm-linux-gcc -c -o led.o led.c
	arm-linux-gcc -c -o start.o start.S
	arm-linux-ld -Ttext 0 led.o start.o -o led_c.elf
	arm-linux-objcopy -O binary -S led_c.elf led_c.bin
	arm-linux-objdump -D led_c.elf > led_c.dis
	
clean:
	rm *.o *.dis *.elf *.bin
