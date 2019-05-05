\noinx
@ @c
@<Header files@>@;
@<Type definitions@>@;
@<Global variables@>@;
@<Create ISR for connecting to USB host@>@;

/*
  A bad example
  $Rev: 1003 $
*/

#include <avr/io.h>

// Connect a button from ground to pin 0 on PORTA
#define BUTTON_MASK (1<<PF4)
#define BUTTON_PIN  PINF
#define BUTTON_PORT PORTF

// Connect a LED from ground via a resistor to pin 0 on PORTB
#define LED_MASK (1<<PD5)
#define LED_PORT PORTD
#define LED_DDR  DDRD

void main(void)
{
  @<Connect...@>@;

  // Enable internal pullup resistor on the input pin
  BUTTON_PORT |= BUTTON_MASK;

  while(1) {
    @<Get |dtr_rts|@>@;
    // Check if the button is pressed. Button is active low
    // so we invert PINB with ~ for positive logic
    if (~BUTTON_PIN & BUTTON_MASK) {
      if (dtr_rts) {            
        UENUM = EP1;            
        while (!(UEINTX & 1 << TXINI)) ;            
        UEINTX &= ~(1 << TXINI);            
        UEDATX = 'L'; UEDATX = '1'; UEDATX = ' '; UEDATX = 'o'; UEDATX = 'n';
        UEDATX = '\r'; UEDATX = '\n';
        UEINTX &= ~(1 << FIFOCON);            
      }
    }
    else {
      if (dtr_rts) {            
        UENUM = EP1;            
        while (!(UEINTX & 1 << TXINI)) ;            
        UEINTX &= ~(1 << TXINI);            
        UEDATX = 'L'; UEDATX = '1'; UEDATX = ' '; UEDATX = 'o'; UEDATX = 'f'; UEDATX = 'f';
        UEDATX = '\r'; UEDATX = '\n';
        UEINTX &= ~(1 << FIFOCON);            
      }
    }
  }
}

@ No other requests except {\caps set control line state} come
after connection is established.
It is used by host to say the device not to send when DTR/RTS is not on.

@<Global variables@>=
U16 dtr_rts = 0;

@ @<Get |dtr_rts|@>=
UENUM = EP0;
if (UEINTX & 1 << RXSTPI) {
  (void) UEDATX; @+ (void) UEDATX;
  wValue = UEDATX | UEDATX << 8;
  UEINTX &= ~(1 << RXSTPI);
  UEINTX &= ~(1 << TXINI); /* STATUS stage */
  dtr_rts = wValue;
}

@i ../usb/IN-endpoint-management.w
@i ../usb/USB.w

@ Program headers are in separate section from USB headers.

@<Header files@>=
#include <avr/io.h>
