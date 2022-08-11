all:
	ctangle matrix
	avr-gcc -mmcu=atmega32u4 -DF_CPU=16000000UL -g -Os -o fw.elf matrix.c
	avr-objcopy -O ihex fw.elf fw.hex

flash:
	avrdude -qq -c usbasp -p atmega32u4 -U efuse:v:0xcb:m -U hfuse:v:0xd9:m -U lfuse:v:0xff:m -U flash:w:fw.hex

eps:
	@inkscape --export-type=eps --export-ps-level=2 --export-filename=matrix-1.eps --export-text-to-path matrix-1.svg
	@inkscape --export-type=eps --export-ps-level=2 --export-filename=matrix-2.eps --export-text-to-path matrix-2.svg
	@inkscape --export-type=eps --export-ps-level=2 --export-filename=matrix-3.eps --export-text-to-path matrix-3.svg
	@make --no-print-directory `grep -o '^\S*\.eps' Makefile`
	@make --no-print-directory -C ../usb eps

.PHONY: $(wildcard *.eps)

keypad.eps:
	@convert keypad.png eps2:$@
