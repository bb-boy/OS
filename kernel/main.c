#include "print.h"
#include "init.h"

void main(void) {
   
    put_str("I am kernel\n");
    init_all();
    put_str("Initialization complete, enabling interrupts...\n");
    asm volatile ("sti");//临时开中断
    while(1);
}   