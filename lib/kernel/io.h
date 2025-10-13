#ifndef __LIB_IO_H
#define __LIB_IO_H
#include "stdint.h"

/* 向端口port写入一个字节*/
static inline void outb(uint16_t port,uint8_t data) {
    asm volatile("outb %b0, %w1" : : "a"(data), "Nd"(port));
}
/*volatile关键词告诉编译器，保留这条asm不删不并不重排*/


static inline void outsw(uint16_t port, const void* addr, uint32_t word_cnt) {
    asm volatile("cld; rep outsw" : "+S"(addr), "+c"(word_cnt) : "d"(port));
}
/*out string word命令，+S将addr的复制到esi寄存器中，+c把word_cnt的值复制到ecx寄存器中，把port复制到edx寄存器中*/

static inline uint8_t inb(uint16_t port) {
    uint8_t data;
    asm volatile("inb %w1, %b0" : "=a"(data) : "Nd"(port));
    return data;
}
/*inb %dx,%al,dl这里放的是端口号，al放的是返回值，b代表低八位，w代表低16位，N代表立即数约束*/

static inline void insw(uint16_t port, void* addr, uint32_t word_cnt) {
    asm volatile("cld; rep insw" : "+D"(addr), "+c"(word_cnt) : "d"(port) : "memory");
    /*memory告诉编译器，内存的内容可能被改变，不要把内存相关的操作和它重排*/
}


#endif
/*__LIB_IO_H*/