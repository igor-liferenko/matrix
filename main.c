/*
  Test program. F_CPU around 8 MHz is assumed for about
  10 ms debounce intervall.   $Rev: 563 $
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include "debounce.h"

// Called at about 100Hz (122Hz)
ISR(TIMER0_OVF_vect)
{
    // Debounce buttons. debounce() is declared static inline
    // in debounce.h so we will not suffer from the added overhead
    // of a (external) function call    
    debounce();
}

int main(void)
{
    // BORTB output
    DDRB = 0xFF;
    // High turns off LED's on STK500
    PORTB = 0xFF;

    // Timer0 normal mode, presc 1:256
    TCCR0B = 1<<CS02;
    // Overflow interrupt. (at 8e6/256/256 = 122 Hz)
    TIMSK0 = 1<<TOIE0;

    debounce_init();

    // Enable global interrupts
    sei();
    
    while(1)
    {
	if (button_down(BUTTON1_MASK))
	{
	    // Toggle PB0
	    PORTB ^= 1<<PB0;
	}
	if (button_down(BUTTON2_MASK))
	{
	    // Toggle PB1
	    PORTB ^= 1<<PB1;
	}
    }
}
