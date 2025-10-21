#include "print.h"
#include "init.h"
#include "debug.h"

int main(void) {
   
    put_str("I am kernel\n");
    init_all();
    put_str("Initialization complete, enabling interrupts...\n");
    ASSERT(1==2);

    //asm volatile ("sti");//临时开中断
    while(1);
}   