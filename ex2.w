\noinx
@ @c
@<Header files@>@;
@<Type definitions@>@;
@<Global variables@>@;
@<Create ISR for connecting to USB host@>@;

#define BUTTON1_MASK (1<<PF4)
#define BUTTON2_MASK (1<<PF5)
#define BUTTON_PIN  PINF
#define BUTTON_PORT PORTF

volatile uint8_t button1_down;
volatile uint8_t button1_up;
volatile uint8_t button2_down;
volatile uint8_t button2_up;

ISR(TIMER0_COMPA_vect)
{
    // Counter for number of equal states
    static uint8_t count1 = 0;
    static uint8_t count2 = 0;
    // Keeps track of current (debounced) state
    static uint8_t button1_state = 0;
    static uint8_t button2_state = 0;

    // Check if button is high or low for the moment
    uint8_t current_state1 = (~BUTTON_PIN & BUTTON1_MASK) != 0;
    uint8_t current_state2 = (~BUTTON_PIN & BUTTON2_MASK) != 0;

    if (current_state1 != button1_state) {
        count2 = 0; // reset other counters
	count1++; // Button state is about to be changed, increase counter
	if (count1 >= 4) {
 	    // The button have not bounced for four checks, change state
	    button1_state = current_state1;
	    // tell main if button was released of pressed
	    if (current_state1 == 0)
              button1_up = 1;
            else
              button1_down = 1;
	    count1 = 0;
	}
    }
    else if (current_state2 != button2_state) {
        count1 = 0; // reset other counters
        count2++; // Button state is about to be changed, increase counter
        if (count2 >= 4) {
            // The button have not bounced for four checks, change state
            button2_state = current_state2;
            // tell main if button was released of pressed
            if (current_state2 == 0)
              button2_up = 1;
            else
              button2_down = 1;
            count2 = 0;
        }
    }
    else {
	// Reset all counters
	count1 = 0; count2 = 0;
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
  BUTTON_PORT |= BUTTON1_MASK;
  BUTTON_PORT |= BUTTON2_MASK;

  while(1) {
    @<Get |dtr_rts|@>@;
    cli();
    // Check if the button is pressed.
    if (button1_down) {
      // Clear flag
      button1_down = 0;
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
    if (button1_up) {
      button1_up = 0;
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
    cli();
    // Check if the button is pressed.
    if (button2_down) {
      // Clear flag
      button2_down = 0;
      sei();
      if (dtr_rts) {
        UENUM = EP1;
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        UEDATX = 'L'; UEDATX = '2'; UEDATX = ' '; UEDATX = 'o'; UEDATX = 'n';
        UEDATX = '\r'; UEDATX = '\n';
        UEINTX &= ~(1 << FIFOCON);
      }
    }
    else
      sei();
    cli();
    if (button2_up) {
      button2_up = 0;
      sei();
      if (dtr_rts) {
        UENUM = EP1;
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        UEDATX = 'L'; UEDATX = '2'; UEDATX = ' '; UEDATX = 'o'; UEDATX = 'f'; UEDATX = 'f';
        UEDATX = '\r'; UEDATX = '\n';
        UEINTX &= ~(1 << FIFOCON);
      }
    }
    else
      sei();
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
