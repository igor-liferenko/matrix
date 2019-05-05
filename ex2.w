/*
  Example of debouncing one button.
  $Rev: 1003 $
 */

#include <avr/io.h>
#include <util/delay.h>

// Connect a button from ground to pin 0 on PORTA
#define BUTTON_MASK (1<<PF4)
#define BUTTON_PIN  PINF
#define BUTTON_PORT PORTF

// Connect a LED from ground via a resistor to pin 0 on PORTB
#define LED_MASK (1<<PD5)
#define LED_PORT PORTD
#define LED_DDR  DDRD

// Variable to tell main that the button is pressed (and debounced).
// Main will clear it after a detected button press.
volatile uint8_t button_down;
volatile uint8_t button_up;

// Check button state and set the button_down variable if a debounced
// button down press is detected.
// Call this function about 100 times per second.
static inline void debounce(void)
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

int main(void)
{
    // Enable internal pullup resistor on the input pin
    BUTTON_PORT |= BUTTON_MASK;

    // Set to output
    LED_PORT |= LED_MASK;
    LED_DDR |= LED_MASK;

    while(1)
    {
	// Update button_state
	debounce();
        // Check if the button is pressed.
        if (button_down)
        {
	    // Clear flag
	    button_down = 0;
            // Toggle the LED
            LED_PORT &= ~(LED_MASK);
        }
        if (button_up) {
          button_up = 0;
          LED_PORT |= LED_MASK;
        }
	// Delay for a while so we don't check to button too often
	_delay_ms(10);
    }
}
