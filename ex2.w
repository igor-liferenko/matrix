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
volatile uint8_t button3_down;
volatile uint8_t button3_up;
volatile uint8_t button4_down;
volatile uint8_t button4_up;
volatile uint8_t button5_down;
volatile uint8_t button5_up;
volatile uint8_t button6_down;
volatile uint8_t button6_up;
volatile uint8_t button7_down;
volatile uint8_t button7_up;
volatile uint8_t button8_down;
volatile uint8_t button8_up;
volatile uint8_t button9_down;
volatile uint8_t button9_up;
volatile uint8_t button10_down;
volatile uint8_t button10_up;
volatile uint8_t button11_down;
volatile uint8_t button11_up;
volatile uint8_t button12_down;
volatile uint8_t button12_up;
volatile uint8_t button13_down;
volatile uint8_t button13_up;
volatile uint8_t button14_down;
volatile uint8_t button14_up;
volatile uint8_t button15_down;
volatile uint8_t button15_up;
volatile uint8_t button16_down;
volatile uint8_t button16_up;

ISR(TIMER0_COMPA_vect)
{
    static uint8_t count1 = 0;
    static uint8_t count2 = 0;
    static uint8_t count3 = 0;    
    static uint8_t count4 = 0;    
    static uint8_t count5 = 0;    
    static uint8_t count6 = 0;    
    static uint8_t count7 = 0;    
    static uint8_t count8 = 0;    
    static uint8_t count9 = 0;    
    static uint8_t count10 = 0;    
    static uint8_t count11 = 0;    
    static uint8_t count12 = 0;    
    static uint8_t count13 = 0;    
    static uint8_t count14 = 0;    
    static uint8_t count15 = 0;    
    static uint8_t count16 = 0;    
    // Keeps track of current (debounced) state
    static uint8_t button1_state = 0;
    static uint8_t button2_state = 0;
    static uint8_t button3_state = 0;    
    static uint8_t button4_state = 0;    
    static uint8_t button5_state = 0;    
    static uint8_t button6_state = 0;    
    static uint8_t button7_state = 0;    
    static uint8_t button8_state = 0;    
    static uint8_t button9_state = 0;    
    static uint8_t button10_state = 0;    
    static uint8_t button11_state = 0;    
    static uint8_t button12_state = 0;    
    static uint8_t button13_state = 0;    
    static uint8_t button14_state = 0;    
    static uint8_t button15_state = 0;    
    static uint8_t button16_state = 0;    

    uint8_t current_state1 = 0;
    uint8_t current_state2 = 0;
    uint8_t current_state3 = 0;
    uint8_t current_state4 = 0;
    uint8_t current_state5 = 0;
    uint8_t current_state6 = 0;
    uint8_t current_state7 = 0;
    uint8_t current_state8 = 0;
    uint8_t current_state9 = 0;
    uint8_t current_state10 = 0;
    uint8_t current_state11 = 0;
    uint8_t current_state12 = 0;
    uint8_t current_state13 = 0;
    uint8_t current_state14 = 0;
    uint8_t current_state15 = 0;
    uint8_t current_state16 = 0;

    for (int i = PB4, done = 0; i <= PB7 && !done; i++) {
      DDRB |= 1 << i;
      _delay_us(1); /* before reading input pin for row which showed a LOW reading on
        previous column, wait
        for pullup of it to charge the stray capacitance\footnote\dag{mind that
        open-ended wire may be longer wire (where button is pressed)} and before reading input
        pin for whose row
        a button may be pressed, wait ground of \\{PFi} to
        discharge the stray capacitance\footnote\ddag{TODO: confirm this by doing test like on
        https://arduino.stackexchange.com/questions/54919/, but check transition
        not from not-pulled-up to pulled-up, but from
        not-grounded to grounded (with pullup enabled)} */
      switch (~PINB & 1 << PB2 ? 0xB2 : @|
              ~PIND & 1 << PD3 ? 0xD3 : @|
              ~PIND & 1 << PD2 ? 0xD2 : @|
              ~PIND & 1 << PD1 ? 0xD1 : 0) {
      case 0xD1:
        switch (i) {
        case PB7: current_state1 = 1; @+ break;
        case PB6: current_state2 = 1; @+ break;
        case PB5: current_state3 = 1; @+ break;
        case PB4: current_state4 = 1; @+ break;
        }
        done = 1;
        break;
      case 0xD2:
        switch (i) {
        case PB7: current_state5 = 1; @+ break;
        case PB6: current_state6 = 1; @+ break;
        case PB5: current_state7 = 1; @+ break;
        case PB4: current_state8 = 1; @+ break;
        }
        done = 1;
        break;
      case 0xD3:
        switch (i) {
        case PB7: current_state9 = 1; @+ break;
        case PB6: current_state10 = 1; @+ break;
        case PB5: current_state11 = 1; @+ break;
        case PB4: current_state12 = 1; @+ break;
        }
        done = 1;
        break;
      case 0xB2:
        switch (i) {
        case PB7: current_state13 = 1; @+ break;
        case PB6: current_state14 = 1; @+ break;
        case PB5: current_state15 = 1; @+ break;
        case PB4: current_state16 = 1; @+ break;
        }
        done = 1;
        break;
      }
      DDRB &= ~(1 << i);
    }

    if (current_state1 != button1_state) {
        count2 = 0; // reset other counters
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;
        count13 = 0;
        count14 = 0;
        count15 = 0;
        count16 = 0;
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
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;
        count13 = 0;
        count14 = 0;
        count15 = 0;
        count16 = 0;
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
    else if (current_state3 != button3_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count3++; // Button state is about to be changed, increase counter
        if (count3 >= 4) {
            // The button have not bounced for four checks, change state
            button3_state = current_state3;
            // tell main if button was released of pressed
            if (current_state3 == 0)
              button3_up = 1;
            else
              button3_down = 1;
            count3 = 0;
        }
    }
    else if (current_state4 != button4_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count4++; // Button state is about to be changed, increase counter
        if (count4 >= 4) {
            // The button have not bounced for four checks, change state
            button4_state = current_state4;
            // tell main if button was released of pressed
            if (current_state4 == 0)
              button4_up = 1;
            else
              button4_down = 1;
            count4 = 0;
        }
    }
    else if (current_state5 != button5_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count5++; // Button state is about to be changed, increase counter
        if (count5 >= 4) {
            // The button have not bounced for four checks, change state
            button5_state = current_state5;
            // tell main if button was released of pressed
            if (current_state5 == 0)
              button5_up = 1;
            else
              button5_down = 1;
            count5 = 0;
        }
    }
    else if (current_state6 != button6_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count6++; // Button state is about to be changed, increase counter
        if (count6 >= 4) {
            // The button have not bounced for four checks, change state
            button6_state = current_state6;
            // tell main if button was released of pressed
            if (current_state6 == 0)
              button6_up = 1;
            else
              button6_down = 1;
            count6 = 0;
        }
    }
    else if (current_state7 != button7_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count7++; // Button state is about to be changed, increase counter
        if (count7 >= 4) {
            // The button have not bounced for four checks, change state
            button7_state = current_state7;
            // tell main if button was released of pressed
            if (current_state7 == 0)
              button7_up = 1;
            else
              button7_down = 1;
            count7 = 0;
        }
    }
    else if (current_state8 != button8_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count8++; // Button state is about to be changed, increase counter
        if (count8 >= 4) {
            // The button have not bounced for four checks, change state
            button8_state = current_state8;
            // tell main if button was released of pressed
            if (current_state8 == 0)
              button8_up = 1;
            else
              button8_down = 1;
            count8 = 0;
        }
    }
    else if (current_state9 != button9_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count9++; // Button state is about to be changed, increase counter
        if (count9 >= 4) {
            // The button have not bounced for four checks, change state
            button9_state = current_state9;
            // tell main if button was released of pressed
            if (current_state9 == 0)
              button9_up = 1;
            else
              button9_down = 1;
            count9 = 0;
        }
    }
    else if (current_state10 != button10_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count10++; // Button state is about to be changed, increase counter
        if (count10 >= 4) {
            // The button have not bounced for four checks, change state
            button10_state = current_state10;
            // tell main if button was released of pressed
            if (current_state10 == 0)
              button10_up = 1;
            else
              button10_down = 1;
            count10 = 0;
        }
    }
    else if (current_state11 != button11_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count11++; // Button state is about to be changed, increase counter
        if (count11 >= 4) {
            // The button have not bounced for four checks, change state
            button11_state = current_state11;
            // tell main if button was released of pressed
            if (current_state11 == 0)
              button11_up = 1;
            else
              button11_down = 1;
            count11 = 0;
        }
    }
    else if (current_state12 != button12_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count12++; // Button state is about to be changed, increase counter
        if (count12 >= 4) {
            // The button have not bounced for four checks, change state
            button12_state = current_state12;
            // tell main if button was released of pressed
            if (current_state12 == 0)
              button12_up = 1;
            else
              button12_down = 1;
            count12 = 0;
        }
    }
    else if (current_state13 != button13_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16 = 0;        
        count13++; // Button state is about to be changed, increase counter
        if (count13 >= 4) {
            // The button have not bounced for four checks, change state
            button13_state = current_state13;
            // tell main if button was released of pressed
            if (current_state13 == 0)
              button13_up = 1;
            else
              button13_down = 1;
            count13 = 0;
        }
    }
    else if (current_state14 != button14_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count15 = 0;        
        count16 = 0;        
        count14++; // Button state is about to be changed, increase counter
        if (count14 >= 4) {
            // The button have not bounced for four checks, change state
            button14_state = current_state14;
            // tell main if button was released of pressed
            if (current_state14 == 0)
              button14_up = 1;
            else
              button14_down = 1;
            count14 = 0;
        }
    }
    else if (current_state15 != button15_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count16 = 0;        
        count15++; // Button state is about to be changed, increase counter
        if (count15 >= 4) {
            // The button have not bounced for four checks, change state
            button15_state = current_state15;
            // tell main if button was released of pressed
            if (current_state15 == 0)
              button15_up = 1;
            else
              button15_down = 1;
            count15 = 0;
        }
    }
    else if (current_state16 != button16_state) {
        count1 = 0; // reset other counters
        count2 = 0;
        count3 = 0;
        count4 = 0;
        count5 = 0;
        count6 = 0;
        count7 = 0;
        count8 = 0;
        count9 = 0;
        count10 = 0;
        count11 = 0;
        count12 = 0;        
        count13 = 0;        
        count14 = 0;        
        count15 = 0;        
        count16++; // Button state is about to be changed, increase counter
        if (count16 >= 4) {
            // The button have not bounced for four checks, change state
            button16_state = current_state16;
            // tell main if button was released of pressed
            if (current_state16 == 0)
              button16_up = 1;
            else
              button16_down = 1;
            count16 = 0;
        }
    }
    else {
	// Reset all counters
	count1 = 0;
        count2 = 0;
        count3 = 0; 
        count4 = 0;
        count5 = 0; 
        count6 = 0;
        count7 = 0; 
        count8 = 0;
        count9 = 0; 
        count10 = 0;
        count11 = 0; 
        count12 = 0;
        count13 = 0; 
        count14 = 0;
        count15 = 0; 
        count16 = 0;
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
