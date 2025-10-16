#include "timer.h"
#include "io.h"
#include "print.h"

#define IRQ0_FREQUENCY 100      // IRQ0 frequency in Hz
#define INPUT_FREQUENCY 1193180 // Input frequency for the timer
#define COUNTER0_VALUE (INPUT_FREQUENCY / IRQ0_FREQUENCY) // Counter value for desired frequency
#define COUNTER0_PORT 0x40      // Port for counter 0
#define COUNTER0_NO 0           // Counter 0 number
#define COUNTER_MODE 2          // Mode 2: Rate Generator
#define READ_WRITE_LATCH 3      // Read/Write Latch: lobyte/hibyte
#define PIT_CONTROL_PORT 0x43   // Control port for the PIT


/**/
static void frequency_set(uint8_t counter_port, uint8_t counter_no, uint8_t rwl, uint8_t counter_mode, uint16_t counter_value) {
    // Set the PIT control word
    outb(PIT_CONTROL_PORT, (uint8_t)(counter_no << 6 | rwl << 4 | counter_mode << 1));
    // Set the counter value (low byte first, then high byte)
    outb(counter_port, (uint8_t)(counter_value & 0xFF));       // Low byte
    outb(counter_port, (uint8_t)((counter_value >> 8) & 0xFF)); // High byte
}

void timer_init() {
    put_str("timer_init start\n");
    frequency_set(COUNTER0_PORT, COUNTER0_NO, READ_WRITE_LATCH, COUNTER_MODE, COUNTER0_VALUE);
    put_str("timer_init done\n");
}
