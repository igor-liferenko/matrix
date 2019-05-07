\let\lheader\rheader
%\datethis
\secpagedepth=2 % begin new page only on *
\font\caps=cmcsc10 at 9pt % for USB.w

@* Program.

Take to consideration that:

\item{1.} \\{ioctl} call blocks in application until it is
read in this program
\item{2.} data is read by USB host as soon as it is sent, even if \\{read}
call has not been done in application yet (i.e., it is buffered)

$$\hbox to10cm{\vbox to6.92cm{\vfil\special{psfile=matrix.1
  clip llx=-142 lly=-58 urx=-28 ury=21 rwi=2834}}\hfil}$$

@c
@<Header files@>@;
@<Type definitions@>@;
@<Global variables@>@;
@<Create ISR for connecting to USB host@>@;

@<Create interrupt handler@>@;

void main(void)
{
  @<Connect to USB host (must be called first; |sei| is called here)@>@;
  int on_line = 0;
  DDRD |= 1 << PD5; /* to show on-line/off-line state */
  DDRB |= 1 << PB0; /* to show DTR/RTS state and to determine when transition happens */
  PORTB |= 1 << PB0; /* on when DTR/RTS is off */
  DDRC |= 1 << PC7; /* indicate that key was pressed; TODO: via tel.log check
    if DTMF is transferred when key pressed or released */

  @<Pullup input pins@>@; /* must be before starting timer */
  _delay_us(1); /* FIXME: do we need it here? */

  OCR0A = 156; /* 10ms */
  TIMSK0 |= 1 << OCIE0A; /* turn on OCIE0A; if it happens while USB RESET interrupt
    is processed, it does not change anything, as the device is going to be reset;
    if USB RESET happens whiled this interrupt is processed, it also does not change
    anything, as USB RESET is repeated several times by USB host, so it is safe
    that USB RESET interrupt is enabled (we cannot disable it because USB host
    may be rebooted) */
  TCCR0A |= 1 << WGM01;
  TCCR0B |= 1 << CS02 | 1 << CS00;

  UENUM = EP1;
  while (1) {
    @<Get |dtr_rts|@>@;
    if (dtr_rts) {
      PORTB &= ~(1 << PB0); /* DTR/RTS is on */      
    }
    else {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        on_line = 0; /* if DTR/RTS is not `on', we are always off-line */
        PORTD &= ~(1 << PD5);
      }
      PORTB |= 1 << PB0; /* DTR/RTS is off */
    }

    cli();
    if (button4_down) {/* 'A' is special button, which does not use
                                    indicator led on |PC7| --- it has its own on |PD5| */
      button4_down = 0;
      sei();
    if (dtr_rts) {
      on_line = !on_line;
      if (on_line) {
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        UEDATX = '@@'; /* for on-line indication we send `\.@@' character to
          \.{tel}---to put it to initial state */
        UEINTX &= ~(1 << FIFOCON);
        PORTD |= 1 << PD5;
      }
      else {
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        UEDATX = '%'; /* for off-line indication we send `\.\%' character to \.{tel}---to disable
          timeout signal handler (it is used for \.{avrtel} to put handset off-hook; in contrast
          with \.{avrtel}, here it is only used to go off-line (in \.{avrtel} it happens
          automatically as consequence of off-hook)) */
        UEINTX &= ~(1 << FIFOCON);
        PORTD &= ~(1 << PD5);
      }
    }
    }
    else sei();

    if (on_line) { /* (buttons are not sent if not on-line); note, that |dtr_rts| is
      necessarily `true' if |on_line| is `true', so we do not check |dtr_rts| before
      sending (and turning on the LED) TODO: ensure by reading the code that it is
      really so */
      @<Check \vb{1}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{2}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{3}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{4}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{5}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{6}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{7}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{8}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{9}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{*}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{0}; turn on LED and send if pressed, turn off LED if released@>@;
      @<Check \vb{\#}; turn on LED and send if pressed, turn off LED if released@>@;
    }
  }
}

@ @<Check \vb{1}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button1_down) {
  button1_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '1';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button1_up) {
  button1_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{2}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button2_down) {
  button2_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '2';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button2_up) {
  button2_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{3}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button3_down) {
  button3_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '3';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button3_up) {
  button3_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{4}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button5_down) {
  button5_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '4';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button5_up) {
  button5_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{5}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button6_down) {
  button6_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '5';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button6_up) {
  button6_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{6}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button7_down) {
  button7_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '6';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button7_up) {
  button7_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{7}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button9_down) {
  button9_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '7';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button9_up) {
  button9_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{8}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button10_down) {
  button10_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '8';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button10_up) {
  button10_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{9}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button11_down) {
  button11_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '9';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button11_up) {
  button11_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{*}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button13_down) {
  button13_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '*';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button13_up) {
  button13_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{0}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button14_down) {
  button14_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '0';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button14_up) {
  button14_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

@ @<Check \vb{\#}; turn on LED and send if pressed, turn off LED if released@>=
cli();
if (button15_down) {
  button15_down = 0;
  sei();
  PORTC |= 1 << PC7;
  while (!(UEINTX & 1 << TXINI)) ;
  UEINTX &= ~(1 << TXINI);
  UEDATX = '#';
  UEINTX &= ~(1 << FIFOCON);
}
else sei();
cli();
if (button15_up) {
  button15_up = 0;
  sei();
  PORTC &= ~(1 << PC7);
}
else sei();

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
UENUM = EP1; /* restore */

@* Matrix.
This is how keypad is connected:

$$\hbox to15cm{\vbox to7.72583333333333cm{\vfil\special{psfile=matrix.2
  clip llx=-1 lly=-208 urx=179 ury=11 rwi=1800}}\kern9.78cm
  \vbox to7.72583333333333cm{\vfil\special{psfile=matrix.3
  clip llx=39 lly=-208 urx=187 ury=11 rwi=1480}}\hfil}$$

@ This is the working principle:
$$\hbox to7cm{\vbox to4.2cm{\vfil\special{psfile=keypad.eps
  clip llx=0 lly=0 urx=240 ury=144 rwi=1984}}\hfil}$$

A is input and  C1 ... Cn are outputs.
We "turn on" one of C1, C2, ... Cn at a time by connecting it to ground inside the chip
(i.e., setting it to logic zero).
Other pins of C1, C2, ... Cn are not connected anywhere at that time.
The current will always flow into the pin which is connected to ground.
The current has to flow into your transmitter for the receiver to be able to tell it's a zero.
Now when the switch connected to this output pin is pressed, the input A
is pulled to ground through the switch, and its state becomes zero.
Pressing other switches doesn't change anything, since their other pins
are not connected to ground. When we want to read another switch, we
change the output pin which is connected to ground, so that always
just one of them is set like that.

To set output pin, do this:
|DDRx.y = 1|.
To unset output pin, do this;
|DDRx.y = 0|.

@ Note, that input pin A is pulled-up.
The pull-up resistor is connected to the high voltage (5V).

With a pull-up resistor, the input pin will read a high state when button is not pressed.
In other words, a small amount of current is flowing between VCC and the input
pin (not to ground), thus the input pin reads close to VCC. When button is pressed,
it connects the input pin directly to ground. The current flows through the resistor
to ground, thus the input pin reads a low state.

Since pull-up resistors are so commonly needed, our MCU has internal pull-ups
that can be enabled and disabled.

@<Pullup input pins@>=
PORTB |= 1 << PB2;
PORTD |= 1 << PD3 | 1 << PD2 | 1 << PD1;

@ @<Global variables@>=

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

@ TODO: rm "static" and compare via dvidiff that it is treated correctly

@<Local variables@>=
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

@ @<Create interrupt handler@>=
ISR(TIMER0_COMPA_vect) /* TODO: when you will finish all, check via ~/tcnt/test.w that
  this code does not exceed the period */
{
  @<Local variables@>@; /* see cwebman - is there an example of such? */

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
        @<Reset all counters, except |count16|@>@;
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
	@<Reset all counter{s}@>@;
    }
}

@ @<Reset all counters, except |count16|@>=
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

@ @<Reset all counter{s}@>=
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

@i ../usb/IN-endpoint-management.w
@i ../usb/USB.w

@ Program headers are in separate section from USB headers.

@<Header files@>=
#include <avr/io.h>
#include <avr/interrupt.h> /* |ISR|, |TIMER4_OVF_vect| */
#include <util/delay.h> /* |_delay_us|, |_delay_ms| */

@* Index.
