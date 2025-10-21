#include "debug.h"
#include "print.h"
#include "interrupt.h"

void panic_spin(char* filename, int line, const char* func, const char* condition) {
    intr_disable(); // 关中断
    put_str("\n\n!!!!!!!!!!!panic!!!!!!!!!!!\n");
    put_str("filename: ");
    put_str(filename);
    put_str("\nline:0x");
    put_int(line);
    put_str("\nfunction: ");
    put_str((char*)func);
    put_str("\ncondition: ");
    put_str((char*)condition);      //put_str需要char*类型参数
    put_str("\n!!!!!!!!!!!panic!!!!!!!!!!!\n");
    while(1);
}

