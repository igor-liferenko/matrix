/*
  Test program. F_CPU around 8 MHz is assumed for about
  10 ms debounce intervall.   $Rev: 563 $
 */

#include <avr/io.h>
#include <avr/interrupt.h>
#include "debounce.h"

// Called at about 100Hz (122Hz, which is 8.197ms)
ISR(TIMER0_COMPA_vect)
{
    // Debounce buttons. debounce() is declared static inline
    // in debounce.h so we will not suffer from the added overhead
    // of a (external) function call    
    debounce();
}

int main(void)
{
    PORTD |= 1 << PD5;
    DDRD |= 1 << PD5;

    OCR0A = 156;
    TCCR0A |= 1 << WGM01;
    TCCR0B |= 1 << CS02 | 1 << CS00;
    TIMSK0 |= 1 << OCIE0A;

    debounce_init();

    // Enable global interrupts
    sei();
    
    while(1)
    {
	if (button_down(BUTTON1_MASK))
	{
	    PORTD ^= 1<<PD5;
	}
/*	if (button_down(BUTTON2_MASK))
	{
	    PORTB ^= 1<<PB1;
	}*/
    }
}
