matrix:
	@avr-gcc -mmcu=atmega32u4 -DF_CPU=16000000UL -g -Os -o fw.elf $@.c
	@avr-objcopy -O ihex fw.elf fw.hex

main:
	@avr-gcc -mmcu=atmega32u4 -DF_CPU=16000000UL -g -Os -c $@.c
	@avr-gcc -mmcu=atmega32u4 -DF_CPU=16000000UL -g -Os -c debounce.c
	@avr-gcc -mmcu=atmega32u4 -g -o fw.elf $@.o debounce.o
	@avr-objcopy -O ihex fw.elf fw.hex

ex1 ex2:
	@avr-gcc -mmcu=atmega32u4 -DF_CPU=16000000UL -g -Os -o fw.elf $@.c
	@avr-objcopy -O ihex fw.elf fw.hex

dump:
	@avr-objdump -d fw.elf

flash:
	@avrdude -qq -c usbasp -p atmega32u4 -U efuse:v:0xcb:m -U hfuse:v:0xd9:m -U lfuse:v:0xff:m -U flash:w:fw.hex

clean:
	@git clean -X -d -f

imgs:
	@mpost matrix
	@perl -ne 'if (/^(.*\.eps): (.*)/) { system "convert $$2 $$1" }' Makefile

.PHONY: $(wildcard *.eps)

keypad.eps: keypad.png
	@convert $< $@
	@imgsize $@ 7 -
