\let\lheader\rheader
%\datethis
\secpagedepth=2 % begin new page only on *
\font\caps=cmcsc10 at 9pt

@* Program.

Button press indication LED is used without interrupts and timers, because
we block the program anyway inside the debounce interval, so use that to turn
the LED off.

Take to consideration that:

\item{1.} \\{ioctl} call blocks in application until it is
read in this program
\item{2.} data is read by USB host as soon as it is sent, even if \\{read}
call has not been done in application yet (i.e., it is buffered)

`\.B' and `\.C' are compensation for DTMF features absent in matrix:
We set debounce delay and thus cannot increase volume quickly, whereas
in DTMF pulse duration is permitted to be short.

TODO: decrease debounce on A. This is useful when we switch off (when done with a router) and
then immediately switch on to go to another router

NOTE: if necessary, you may set 16-bit timers here as if interrupts are not
enabled at all (if USB RESET interrupt happens, device is going to be reset anyway,
so it is safe that it is enabled (we cannot disable it because USB host may be
rebooted)
NOTE: if you decide to do keypress indication via timer, keep in mind that keypress
indication timeout
must not increase debounce delay (so that when next key is pressed, the timer is guaranteed
to expire - before it is set again)

@d F_CPU 16000000UL

@c
@<Header files@>@;
@<Type definitions@>@;
@<Global variables@>@;
@<Create ISR for connecting to USB host@>@;

void main(void)
{
  @<Connect to USB host (must be called first; |sei| is called here)@>@;
  int on_line = 0;
  DDRD |= 1 << PD5; /* to show on-line/off-line state */
  DDRB |= 1 << PB0; /* to show DTR/RTS state and to determine when transition happens */
  PORTB |= 1 << PB0; /* on when DTR/RTS is off */
  DDRC |= 1 << PC7; /* to indicate keypresses */
  @<Pullup input pins@>@;
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
    @<Get button@>@;
    if (dtr_rts && btn == 'A') { /* 'A' is special button, which does not use
                                    indicator led on |PC7| --- it has its own on |PD5| */
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
    if (dtr_rts && btn) {
      if (btn != 'A' && on_line) { /* (buttons are not sent if not on-line) */
        PORTC |= 1 << PC7;
        while (!(UEINTX & 1 << TXINI)) ;
        UEINTX &= ~(1 << TXINI);
        UEDATX = btn;
        UEINTX &= ~(1 << FIFOCON);
      }
      U8 prev_button = btn;
      int timeout;
      if (btn == 'B' || btn == 'C')
        timeout = 300; /* values smaller that this do not give mpc call
          enough time to finish before another mpc request arrives; it
          is manifested by the fact that when button is released, the volume
          continues to increase (decrease);
          TODO: find minimum possible |timeout| value by setting it to `0' and
          doing this: run tel in foreground, set volume to 0, press + button,
          when volume will approach 90 percent, release button - if volume will keep
          changing for some time - |timeout| must be increased */
      else timeout = 2000;
      (void) 0; /* do not allow one button to be pressed more frequently than
         debounce (i.e., if I mean to hold it, but it bounces,
         and the interval between bounces exceeds 1 $\mu s$ delay (used in matrix scanning code
         to eliminate capacitance),
         which is very small); also, the debounce interval must be a little greater
         than the blink time of the button press indicator led */
      (void) 0; /* HINT: see debounce
        handling in below preprocessor `if' (maybe also in git lg usb/kbd.ch */

      while (--timeout) { /* FIXME: call |@<Get |dtr_rts|@>| and check |dtr_rts| here?
           draw flowchart on graph paper and draw it in metapost
           and add it to TeX-part of this section
           (and add thorough explanation of code of this section to its TeX part)
        */
        if (!(prev_button == 'B' || prev_button == 'C')) {
          @<Get button@>@;
          if (btn == 0 && timeout < 1500) break; /* timeout $-$ debounce, you can't
            make it react more frequently than debounce interval;
            |timeout| time is allowed to release the button until it repeats;
            for `\.B' and `\.C' |timeout| is equal to |debounce|, i.e., repeat
            right away */
        }
        _delay_ms(1);
        if (prev_button == 'B' || prev_button == 'C') {
          if (timeout < 200) PORTC &= ~(1 << PC7); /* timeout $-$ indicator duration (should be
            less than debounce) */
        }
        else {
          if (timeout < 1900) PORTC &= ~(1 << PC7); /* timeout $-$ indicator duration (should be
            less than debounce) */
        }
      }
    }
  }
#if 0 /* this is how it was done in cdc.ch */
  while (1) {
    @<Get |dtr_rts|@>@;
    if (dtr_rts) {
      @<Get button@>@;
      if (btn != 0) {
        /* Send button */
        U8 prev_button = btn;
        int timeout = 2000;
        while (--timeout) {
          @<Get button@>@;
          if (btn != prev_button) break;
          _delay_ms(1);
        }
        while (1) {
          @<Get button@>@;
          if (btn != prev_button) break;
          /* Send button */
          _delay_ms(50);
        }
      }
    }
  }
#endif
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
U8 btn = 0;

@ @<Get button@>=
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
      case 0xB2:
        switch (i) {
        case PB4: btn = '1'; @+ break;
        case PB5: btn = '2'; @+ break;
        case PB6: btn = '3'; @+ break;
        case PB7: btn = 'A'; @+ break;
        }
        done = 1;
        break;
      case 0xD3:
        switch (i) {
        case PB4: btn = '4'; @+ break;
        case PB5: btn = '5'; @+ break;
        case PB6: btn = '6'; @+ break;
        case PB7: btn = 'B'; @+ break;
        }
        done = 1;
        break;
      case 0xD2:
        switch (i) {
        case PB4: btn = '7'; @+ break;
        case PB5: btn = '8'; @+ break;
        case PB6: btn = '9'; @+ break;
        case PB7: btn = 'C'; @+ break;
        }
        done = 1;
        break;
      case 0xD1:
        switch (i) {
        case PB4: btn = '*'; @+ break;
        case PB5: btn = '0'; @+ break;
        case PB6: btn = '#'; @+ break;
        case PB7: btn = 'D'; @+ break;
        }
        done = 1;
        break;
      default: @/
        btn = 0;
      }
      DDRF &= ~(1 << i);
    }

@i ../usb/IN-endpoint-management.w
@i ../usb/USB.w

@ Program headers are in separate section from USB headers.

@<Header files@>=
#include <avr/io.h>
#include <util/delay.h> /* |_delay_us|, |_delay_ms| */

@* Index.
