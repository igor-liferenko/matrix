\noinx
@ @c
@<Header files@>@;
@<Type definitions@>@;
@<Global variables@>@;
@<Create ISR for connecting to USB host@>@;

#define BUTTON_MASK (1<<PF4)
#define BUTTON_PIN  PINF
#define BUTTON_PORT PORTF

volatile uint8_t button_down;
volatile uint8_t button_up;

ISR(TIMER0_COMPA_vect)
{
    // Counter for number of equal states
    static uint8_t count = 0;
    // Keeps track of current (debounced) state
    static uint8_t button_state = 0;

    // Check if button is high or low for the moment
    uint8_t current_state = (~BUTTON_PIN & BUTTON_MASK) != 0;
    
    if (current_state != button_state) {
	// Button state is about to be changed, increase counter
	count++;
	if (count >= 4) {
 	    // The button have not bounced for four checks, change state
	    button_state = current_state;
	    // tell main if button was released of pressed
	    if (current_state == 0)
              button_up = 1;
            else
              button_down = 1;
	    count = 0;
	}
    } else {
	// Reset counter
	count = 0;
    }
}

void main(void)
{
  @<Connect...@>@;

    OCR0A = 156;
    TCCR0A |= 1 << WGM01;
    TCCR0B |= 1 << CS02 | 1 << CS00;
    TIMSK0 |= 1 << OCIE0A;

  // Enable internal pullup resistor on the input pin
  BUTTON_PORT |= BUTTON_MASK;

  while(1) {
    @<Get |dtr_rts|@>@;
    cli();
    // Check if the button is pressed.
    if (button_down) {
      // Clear flag
      button_down = 0;
      sei();
      if (dtr_rts) {
        UENUM = EP1;
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        UEDATX = 'L'; UEDATX = '1'; UEDATX = ' '; UEDATX = 'o'; UEDATX = 'n';
        UEDATX = '\r'; UEDATX = '\n';
        UEINTX &= ~(1 << FIFOCON);
      }
    }
    else
      sei();
    cli();
    if (button_up) {
      button_up = 0;
      sei();
      if (dtr_rts) {            
        UENUM = EP1;            
        while (!(UEINTX & 1 << TXINI)) ;            
        UEINTX &= ~(1 << TXINI);            
        UEDATX = 'L'; UEDATX = '1'; UEDATX = ' '; UEDATX = 'o'; UEDATX = 'f'; UEDATX = 'f';
        UEDATX = '\r'; UEDATX = '\n';
        UEINTX &= ~(1 << FIFOCON);            
      }
    }
    else
      sei();
    // Delay for a while so we don't check to button too often
    _delay_ms(10);
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
#include <util/delay.h>
