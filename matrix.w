\let\lheader\rheader
%\datethis
\secpagedepth=2 % begin new page only on *
\font\caps=cmcsc10 at 9pt

%\let\maybe=\iffalse

@* Program.
The interface here is preserved the same as in {\caps avrtel} (namely, if DTR/RTS
is not `on', on-line led does not work and buttons are not sent; also, ``on-line''
concept is from there, though it is reasonable by itself) --- in order to use the same
\.{tel} program for both (each on its own router). The relevant places are marked
with ``avrtel'' in index.

@c
@<Header files@>@;
@<Type \null definitions@>@;
@<Global variables@>@;

void main(void)
{
  @<Disable WDT@>@;
  @<Connect to USB host@>@;

  UENUM = EP1;

  int on_line = 0;
  DDRD |= 1 << PD5; /* |PD5| is used to show on-line/off-line state
                       and to determine when transition happens */
  DDRB |= 1 << PB0; /* |PB0| is used to show DTR/RTS state and and to determine
    when transition happens */
  PORTB |= 1 << PB0; /* led on */

  @<Handle matrix@>@;
}

@ Add led between ground and PB6 (via 330 ohm resistor).

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

@<Handle matrix@>=
  DDRB |= 1 << PB6; /* to indicate keypresses */
  @<Pullup input pins@>@;
  while (1) {
    @<Get |dtr_rts|@>@;
    if (dtr_rts) {
      PORTB &= ~(1 << PB0); /* led off */
    }
    else {
      if (!(PORTB & 1 << PB0)) { /* transition happened */
        on_line = 0; /* do the same as in \.{avrtel},
          where off-line automatically happens when base station is un-powered */
@^avrtel@>
      }
      PORTB |= 1 << PB0; /* led on */
    }
    @<Get button@>@;
    if (dtr_rts && btn == 'A') { // 'A' is special button, which does not use
      // indicator led on PB6 - it has its own - PD5
      on_line = !on_line;
    }
    @<Check |on_line| and indicate it via |PD5| and if it changed write to USB `\.@@' or `\.\%'
      (the latter only if |dtr_rts|)@>@;
    if (dtr_rts && btn) {
      if (btn != 'A' && on_line) {
        PORTB |= 1 << PB6;
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
      // do not allow one button to be pressed more frequently than
      // debounce (i.e., if I mean to hold it, but it bounces,
      // and the interval between bounces exceeds 1 $\mu s$ delay (used in matrix scanning code
      // to eliminate capacitance),
      // which is very small); also, the debounce interval must be a little greater
      // than the blink time of the button press indicator led

      while (--timeout) { /* HINT: see debounce
        handling in below preprocessor `if' (maybe also in git lg usb/kbd.ch */
        /* FIXME: call |@<Get |dtr_rts|@>| and check |dtr_rts| here?
           draw flowchart on graph paper and draw it in metapost
           and add it to TeX-part of this section
           (and add thorough explanation of code of this section to its TeX part)
        */
        if (!(prev_button == 'B' || prev_button == 'C')) {
          @<Get button@>@;
          if (btn == 0 && timeout < 1500) break; /* timeout - debounce, you can't
            make it react more frequently than debounce interval;
            |timeout| time is allowed to release the button until it repeats;
            for `\.B' and `\.C' |timeout| is equal to |debounce|, i.e., repeat
            right away */
        }
        _delay_ms(1);
        if (prev_button == 'B' || prev_button == 'C') {
          if (timeout < 200) PORTB &= ~(1 << PB6); /* timeout - indicator duration (should be less
            than debounce) */
        }
        else {
          if (timeout < 1900) PORTB &= ~(1 << PB6); /* timeout - indicator duration (should be less
            than debounce) */
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

@ We check if buttons must be sent by using the variable |on_line|.

For on-line indication we send `\.@@' character to \.{tel}---to put
it to initial state.
For off-line indication we send `\.\%' character to \.{tel}---to disable
DTR/RTS reset after timeout (it is used for \.{avrtel} to reset power on base station).
@^avrtel@>

@<Check |on_line| and indicate it via |PD5| and if it changed write to USB `\.@@' or `\.\%'
  (the latter only if |dtr_rts|)@>=
if (!on_line) {
  if (PORTD & 1 << PD5) { /* transition happened */
    if (dtr_rts) { /* off-line was not caused by DTR/RTS reset */
      while (!(UEINTX & 1 << TXINI)) ;
      UEINTX &= ~(1 << TXINI);
      UEDATX = '%';
      UEINTX &= ~(1 << FIFOCON);
    }
  }
  PORTD &= ~(1 << PD5);
}
else { /* on-line */
  if (!(PORTD & 1 << PD5)) { /* transition happened */
    while (!(UEINTX & 1 << TXINI)) ;
    UEINTX &= ~(1 << TXINI);
    UEDATX = '@@';
    UEINTX &= ~(1 << FIFOCON);
  }
  PORTD |= 1 << PD5;
}

@ No other requests except {\caps set control line state} come
after connection is established.

@<Get |dtr_rts|@>=
UENUM = EP0;
if (UEINTX & 1 << RXSTPI) {
  (void) UEDATX; @+ (void) UEDATX;
  @<Handle {\caps set control line state}@>@;
}
UENUM = EP1; /* restore */

@ Used in USB\_RESET interrupt handler.
Reset is used to go to beginning of connection loop (because we cannot
use \&{goto} from within interrupt handler). Watchdog reset is used because
in atmega32u4 there is no simpler way to reset MCU.

@<Reset MCU@>=
WDTCSR |= 1 << WDCE | 1 << WDE; /* allow to enable WDT */
WDTCSR = 1 << WDE; /* enable WDT */
while (1) ;

@ When reset is done via watchdog, WDRF (WatchDog Reset Flag) is set in MCUSR register.
WDE (WatchDog system reset Enable) is always set in WDTCSR when WDRF is set. It
is necessary to clear WDE to stop MCU from eternal resetting:
on MCU start we always clear |WDRF| and WDE
(nothing will change if they are not set).
To avoid unintentional changes of WDE, a special write procedure must be followed
to change the WDE bit. To clear WDE, WDRF must be cleared first.

Datasheet says that |WDE| is always set to one when |WDRF| is set to one,
but it does not say if |WDE| is always set to zero when |WDRF| is not set
(by default it is zero).
So we must always clear |WDE| independent of |WDRF|.

This should be done right at the beginning of |main|, in order to be in
time before WDT is triggered.
We don't call \\{wdt\_reset} because initialization code,
that \.{avr-gcc} adds, has enough time to execute before watchdog
timer (16ms in this program) expires:

$$\vbox{\halign{\tt#\cr
  eor r1, r1 (1 cycle)\cr
  out 0x3f, r1 (1 cycle)\cr
  ldi r28, 0xFF (1 cycle)\cr
  ldi r29, 0x0A (1 cycle)\cr
  out 0x3e, r29 (1 cycle)\cr
  out 0x3d, r28 (1 cycle)\cr
  call <main> (4 cycles)\cr
}}$$

At 16MHz each cycle is 62.5 nanoseconds, so it is 7 instructions,
taking 10 cycles, multiplied by 62.5 is 625 nanoseconds.

What the above code does: zero r1 register, clear SREG, initialize program stack
(to the stack processor writes addresses for returning from subroutines and interrupt
handlers). To the stack pointer is written address of last cell of RAM.

Note, that ns is $10^{-9}$, $\mu s$ is $10^{-6}$ and ms is $10^{-3}$.

@<Disable WDT@>=
if (MCUSR & 1 << WDRF) /* takes 2 instructions if |WDRF| is set to one:
    \.{in} (1 cycle),
    \.{sbrs} (2 cycles), which is 62.5*3 = 187.5 nanoseconds
    more, but still within 16ms; and it takes 5 instructions if |WDRF|
    is not set: \.{in} (1 cycle), \.{sbrs} (2 cycles), \.{rjmp} (2 cycles),
    which is 62.5*5 = 312.5 ns more, but still within 16ms */
  MCUSR &= ~(1 << WDRF); /* takes 3 instructions: \.{in} (1 cycle),
    \.{andi} (1 cycle), \.{out} (1 cycle), which is 62.5*3 = 187.5 nanoseconds
    more, but still within 16ms */
if (WDTCSR & 1 << WDE) { /* takes 2 instructions: \.{in} (1 cycle),
    \.{sbrs} (2 cycles), which is 62.5*3 = 187.5 nanoseconds
    more, but still within 16ms */
  WDTCSR |= 1 << WDCE; /* allow to disable WDT (\.{lds} (2 cycles), \.{ori}
    (1 cycle), \.{sts} (2 cycles)), which is 62.5*5 = 312.5 ns more, but
    still within 16ms) */
  WDTCSR = 0x00; /* disable WDT (\.{sts} (2 cycles), which is 62.5*2 = 125 ns more,
    but still within 16ms)\footnote*{`\&=' must not be used here, because
    the following instructions will be used: \.{lds} (2 cycles),
    \.{andi} (1 cycle), \.{sts} (2 cycles), but according to datasheet \S8.2
    this must not exceed 4 cycles, whereas with `=' at most the
    following instructions are used: \.{ldi} (1 cycle) and \.{sts} (2 cycles),
    which is within 4 cycles.} */
}

@ @d EP0 0 /* selected by default */
@d EP0_SIZE 32 /* 32 bytes\footnote\dag{Must correspond to |UECFG1X| of |EP0|.}
                  (max for atmega32u4) */

@c
ISR(USB_GEN_vect)
{
  UDINT &= ~(1 << EORSTI); /* for the interrupt handler to be called for next USB\_RESET */
  if (!connected) {
    UECONX |= 1 << EPEN;
    UECFG1X = 1 << EPSIZE1; /* 32 bytes\footnote\ddag{Must correspond to |EP0_SIZE|.} */
    UECFG1X |= 1 << ALLOC;
  }
  else {
    @<Reset MCU@>@;
  }
}


@* Matrix.
This is how keypad is connected:

$$\hbox to15cm{\vbox to7.72583333333333cm{\vfil\special{psfile=matrix.1
  clip llx=-1 lly=-208 urx=179 ury=11 rwi=1800}}\kern9.78cm
  \vbox to7.72583333333333cm{\vfil\special{psfile=matrix.2
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
PORTB |= 1 << PB4 | 1 << PB5;
PORTE |= 1 << PE6;
PORTD |= 1 << PD7;

@ @<Global variables@>=
U8 btn = 0;

@
% NOTE: use index into an array of Pxn if pins in "for" are not consequtive:
% int a[3] = { PF3, PD4, PB5 }; ... for (int i = 0, ... DDRF |= 1 << a[i]; ... switch (a[i]) ...

% NOTE: use array of indexes to separate bits if pin numbers in "switch" collide:
% int b[256] = {0};
% if (~PINB & 1 << PB4) b[0xB4] = 1 << 0; ... if ... b[0xB5] = 1 << 1; ... b[0xE6] = 1 << 2; ...
% switch (b[0xB4] | ...) ... case b[0xB4]: ...
% (here # in woven output will represent P)

@<Get button@>=
    for (int i = PF4, done = 0; i <= PF7 && !done; i++) {
      DDRF |= 1 << i;
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
      switch (~PINB & (1 << PB4 | 1 << PB5) | ~PINE & 1 << PE6 | ~PIND & 1 << PD7) {
      case 1 << PB4:
        switch (i) {
        case PF4: btn = '1'; @+ break;
        case PF5: btn = '2'; @+ break;
        case PF6: btn = '3'; @+ break;
        case PF7: btn = 'A'; @+ break;
        }
        done = 1;
        break;
      case 1 << PB5:
        switch (i) {
        case PF4: btn = '4'; @+ break;
        case PF5: btn = '5'; @+ break;
        case PF6: btn = '6'; @+ break;
        case PF7: btn = 'B'; @+ break;
        }
        done = 1;
        break;
      case 1 << PE6:
        switch (i) {
        case PF4: btn = '7'; @+ break;
        case PF5: btn = '8'; @+ break;
        case PF6: btn = '9'; @+ break;
        case PF7: btn = 'C'; @+ break;
        }
        done = 1;
        break;
      case 1 << PD7:
        switch (i) {
        case PF4: btn = '*'; @+ break;
        case PF5: btn = '0'; @+ break;
        case PF6: btn = '#'; @+ break;
        case PF7: btn = 'D'; @+ break;
        }
        done = 1;
        break;
      default: @/
        btn = 0;
      }
      DDRF &= ~(1 << i);
    }

@i ../usb/establishing-usb-connection.w
@i ../usb/CONTROL-endpoint-management.w
@i ../usb/IN-endpoint-management.w
@i ../usb/usb_stack.w

@* Headers.
\secpagedepth=1 % index on current page

@<Header files@>=
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <avr/boot.h> /* |boot_signature_byte_get| */
#define F_CPU 16000000UL
#include <util/delay.h> /* |_delay_us|, |_delay_ms| */

@* Index.
