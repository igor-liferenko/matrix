all:
	ctangle matrix
	avr-gcc -mmcu=atmega32u4 -DF_CPU=16000000UL -g -Os -o fw.elf matrix.c

flash:
	avr-objcopy -O ihex fw.elf fw.hex
	avrdude -qq -c usbasp -p atmega32u4 -U efuse:v:0xcb:m -U hfuse:v:0xd9:m -U lfuse:v:0xff:m -U flash:w:fw.hex

eps:
	@make --no-print-directory `grep -o '^\S*\.eps' Makefile`

.PHONY: $(wildcard *.eps)

matrix-1.eps:
	@$(inkscape) matrix-1.svg

matrix-2.eps:
	@$(inkscape) matrix-2.svg

matrix-3.eps:
	@$(inkscape) matrix-3.svg

inkscape=inkscape --export-type=eps --export-ps-level=2 -T -o $@ 2>/dev/null
