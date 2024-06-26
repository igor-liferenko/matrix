% TODO: get rid of 'connected = 1' and WDT (while testing, temporarily delete perl commands
% in the end of mytex/ctangle)

% a good summary of how debounce works: https://electronics.stackexchange.com/questions/355641/
% TODO: search SOF in demo and demo-comments repos and use sof for debounce - not timer
% (and search sof in matrix repo too via git log -p)
% (when SOF arrives, USB_RESET is not done, and vice versa, so these two interrupts won't clash)

% TODO: move set_control_line_state and set_line_coding to control.ch with 1 << 1 (like in
% time/mode.ch) and move EP2 to rxout.ch and move EP3 to notification.ch
% (try if usb will work without rxout.ch, first changing EP3 to EP2 in notification.ch)

% NOTE: echo need not be disabled because we do not use OUT packets

% NOTE: instead of using PB0 use dtr_rts global variable and use PB0 for what PC7 is
% now - then we may use pro-micro

\datethis
\input epsf

\font\caps=cmcsc10 at 9pt

@s uint8_t int

@* Program.

$$\epsfxsize 10cm \epsfbox{matrix-1.eps}$$

@c
@<Header files@>@;
@<Type definitions@>@;
@<Global variables@>@;
@<Create ISR for debounce timer@>@;
@<Create ISR for connecting to USB host@>@;

void main(void)
{
  @<Connect to USB host (must be called first; |sei| is called here)@>@;

  DDRB |= 1 << PB0; @+ PORTB |= 1 << PB0;
  DDRC |= 1 << PC7; /* indicate that key was pressed */
  DDRD |= 1 << PD5; /* on-line/off-line state */

  @<Pullup input pins@>@; /* must be before starting timer */
  _delay_us(1); /* FIXME: do we need it? */

  @<Start debounce timer@>@;

  while (1) {
    UENUM = 0;
    @<Handle {\caps set control line state}@>@;

    UENUM = 1;
    @<Check \vb{A} ...@>@;

    if (PORTD & 1 << PD5) {
      @<Check \vb{1}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{2}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{3}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{4}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{5}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{6}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{7}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{8}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{9}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{*}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{0}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{\#}; turn on \.{C7} and send if pressed@>@;
      @<Check \vb{B}; send if pressed and turn off \.{D5}@>@;
    }
  }
}

@ Set the match value using the |OCR0A| register.
Use CTC mode. This is like normal mode, but counter is automatically set to zero
when match occurs. This way we create the period.

With no prescaler, in 1 second there will be 16 million ticks.
We need about 100Hz, i.e., 10ms period,
which corresponds to 160000 ticks per second ($16MHz\over100$ or $16000000Hz\over100$).
160000 $\notin [1,255]$.
Let's try next prescaler, which is clk/8.
In 1 second there will be 2 million ticks.
$2000000\over100$ is 20000. 20000 $\notin [1,255]$.
Let's try next prescaler, which is clk/64.
In 1 second there will be 250 thousand ticks.
$250000\over100$ is 2500. 2500 $\notin [1,255]$.
Let's try next prescaler, which is clk/256.
In 1 second there will be 62500 ticks.
$62500\over100$ is 625. 625 $\notin [1,255]$.
Let's try next prescaler, which is clk/1024.
In 1 second there will be 15625 ticks.
$15625\over100$ is 156.25. 156.25 $\in [1,255]$, so we use this prescaler.
We can use only integer match value. Let's use 156. Let's calculate the exact period:
Duration of one tick is $1\over15625$ or 0.000064 seconds. 156 ticks is then
.009984 seconds.

@<Start debounce timer@>=
  OCR0A = 156; /* 9.984ms */
  TIMSK0 |= 1 << OCIE0A; /* turn on OCIE0A; if it happens while USB RESET interrupt
    is processed, it does not change anything, as the device is going to be reset;
    if USB RESET happens whiled this interrupt is processed, it also does not change
    anything, as USB RESET is repeated several times by USB host, so it is safe
    that USB RESET interrupt is enabled (we cannot disable it because USB host
    may be rebooted) TODO: see also note in avr/TIPS */
  TCCR0A |= 1 << WGM01; /* CTC mode */
  TCCR0B |= 1 << CS02 | 1 << CS00; /* use 1024 prescaler and start timer */

@ @<Check \vb{A} (responsible for sending \.A and turning on \.{D5})@>=
    cli();
    if (button4_down) {
      @<Clear all buttons@>@;
      sei();
      if (!(PORTD & _BV(PD5))) /* transition happened */
        if (!(PORTB & _BV(PB0))) { /* LED off */
          while (!(UEINTX & _BV(TXINI))) { }
          UEINTX &= ~_BV(TXINI);
          UEDATX = 'A'; /* for on-line indication we send \.A to
            \.{tel}---to put it to initial state */
          UEINTX &= ~_BV(FIFOCON);
          PORTD |= _BV(PD5); /* turn LED on */
        }
    }
    else sei();

@ We clear all buttons, not only |button4_down|, to ensure that any key must not be pressed
in ``off-line'' state.

TODO: check via \.{\~/tcnt/test.w} that if interrupts are disabled and counter hits MATCH,
what will happen when interrupts are enabled again - will the interrupt fire again right
away or until next time when it happens (overflow should happen then - check this via test.w
too)
@^TODO@>

@<Clear all buttons@>=
button1_down = 0;
button2_down = 0;
button3_down = 0;
button4_down = 0;
button5_down = 0;
button6_down = 0;
button7_down = 0;
button8_down = 0;
button9_down = 0;
button10_down = 0;
button11_down = 0;
button12_down = 0;
button13_down = 0;
button14_down = 0;
button15_down = 0;
button16_down = 0;

@ @<Check \vb{1}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{2}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{3}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{4}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{5}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{6}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{7}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{8}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{9}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{*}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{0}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{\#}; turn on \.{C7} and send if pressed@>=
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

@ @<Check \vb{B}; send if pressed and turn off \.{D5}@>=    
    cli();
    if (button8_down) {
      button8_down = 0;
      sei();
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = 'B'; /* for off-line indication we send \.B to \.{tel}---to disable
        timeout signal handler (it is used for \.{avrtel} to put handset off-hook; in contrast
        with \.{avrtel}, here it is only used to go off-line (in \.{avrtel} it happens
        automatically as consequence of off-hook)) */
      UEINTX &= ~(1 << FIFOCON);
      PORTD &= ~(1 << PD5);
    }
    else sei();

@ These requests are sent automatically by the driver when
TTY is opened and closed, and manually via \\{ioctl}.

See \S6.2.14 in CDC spec.

@<Handle {\caps set control line state}@>=
if (UEINTX & 1 << RXSTPI) {
  (void) UEDATX; @+ (void) UEDATX;
  wValue = UEDATX | UEDATX << 8;
  UEINTX &= ~(1 << RXSTPI);
  UEINTX &= ~(1 << TXINI);
  if (wValue)
    PORTB &= ~_BV(PB0); /* \.{tel} started */
  else { /* \.{tel} exited */
      PORTB |= _BV(PB0); /* turn LED on */
      PORTD &= ~_BV(PD5); /* turn LED off */
  }
}

@* Matrix.
This is how keypad is connected:

$$\hbox to 15cm{\epsfbox{matrix-2.eps}\hfill \epsfbox{matrix-3.eps}}$$

@ This is the working principle:
$$\epsfxsize 7cm \epsfbox{keypad.eps}$$

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
\.{DDRx.y = 1}.
To unset output pin, do this:
\.{DDRx.y = 0}.

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

@ @<Get button@>=
    for (int i = PB4, @!done = 0; i <= PB7 && !done; i++) {
      DDRB |= 1 << i; /* output mode, low (i.e., ground) */
      _delay_us(1); /* before reading input pin for row which showed a LOW reading on
        previous column, wait
        for pullup of it to charge the stray capacitance\footnote\dag{mind that
        open-ended wire may be longer wire (where button is pressed)} and before reading input
        pin for whose row
        a button may be pressed, wait ground of \\{PB4-7} to
        discharge the stray capacitance\footnote\ddag{TODO: confirm this by doing test like on
        https://arduino.stackexchange.com/questions/54919/, but check transition
        not from not-pulled-up to pulled-up, but from
        not-grounded to grounded (with pullup enabled)} */
      switch (~PINB & 1 << PB2 ? 0xB2 : @|@t\hskip9.5pt@>
              ~PIND & 1 << PD3 ? 0xD3 : @|@t\hskip9.5pt@>
              ~PIND & 1 << PD2 ? 0xD2 : @|@t\hskip9.5pt@>
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
      DDRB &= ~(1 << i); /* input mode (i.e., Hi-Z)
        FIXME: think if setting |PORTB| to high instead of hi-z could be done here,
        and if yes, whether delay will be necessary; and if yes, then set PORTB to low above,
        instead of DDRB to high */
@^FIXME@>
    }

@ @<Global variables@>=
volatile uint8_t button1_down;
volatile uint8_t button2_down;
volatile uint8_t button3_down;
volatile uint8_t button4_down;
volatile uint8_t button5_down;
volatile uint8_t button6_down;
volatile uint8_t button7_down;
volatile uint8_t button8_down;
volatile uint8_t button9_down;
volatile uint8_t button10_down;
volatile uint8_t button11_down;
volatile uint8_t button12_down;
volatile uint8_t button13_down;
volatile uint8_t button14_down;
volatile uint8_t button15_down;
volatile uint8_t button16_down;

@ TODO: rm "static" and compare via dvidiff that it is treated correctly

@<Local variables...@>=
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

@ TODO: completely exclude buttons 12 and 16 from handling
@^TODO@>

@<Create ISR for debounce timer@>=
@.ISR@>@t}\begingroup\def\vb#1{\.{#1}\endgroup@>@=ISR@>
  (@.TIMER0\_COMPA\_vect@>@t}\begingroup\def\vb#1{\.{#1}\endgroup@>@=TIMER0_COMPA_vect@>)
  /* TODO: when you will finish all, check via \.{\~/tcnt/test.w} that
           this code does not exceed the period */
{
  @<Local variables of ISR for debounce timer@>@;

  @<Get button@>@;

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
              PORTC &= ~(1 << PC7);
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
              PORTC &= ~(1 << PC7); 
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
              PORTC &= ~(1 << PC7); 
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
            if (current_state4 != 0)
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
              PORTC &= ~(1 << PC7); 
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
              PORTC &= ~(1 << PC7); 
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
              PORTC &= ~(1 << PC7); 
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
            if (current_state8 != 0)
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
              PORTC &= ~(1 << PC7); 
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
              PORTC &= ~(1 << PC7); 
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
              PORTC &= ~(1 << PC7); 
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
            if (current_state12 != 0)
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
              PORTC &= ~(1 << PC7); 
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
              PORTC &= ~(1 << PC7); 
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
              PORTC &= ~(1 << PC7); 
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
            if (current_state16 != 0)
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

@i USB.w

@* Headers.

@<Header files@>=
#include <avr/boot.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
