MCU=atmega32u4

matrix:
	@avr-gcc -mmcu=atmega32u4 -g -Os -o fw.elf $@.c
	@avr-objcopy -O ihex fw.elf fw.hex

dump:
	@avr-objdump -d fw.elf

flash:
	@avrdude -qq -c usbasp -p $(MCU) -U flash:w:fw.hex

clean:
	@git clean -X -d -f

.PHONY: $(wildcard *.eps)

keypad.eps: keypad.png
	@convert $< $@
	@imgsize $@ 7 -

keymap.eps: keymap.gif
	@convert $< $@
	@imgsize $@ 6 -

