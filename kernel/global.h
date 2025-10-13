#ifndef __KERNEL_GLOBAL_H
#define __KERNEL_GLOBAL_H
#include "stdint.h"

#define RPL0 0
#define RPL1 1
#define RPL2 2
#define RPL3 3

#define TI_GDT 0
#define TI_LDT 1

#define SELECTOR_K_CODE  ((1 << 3) + (TI_GDT << 2) + RPL0)  // 内核代码段选择子 0x08
#define SELECTOR_K_DATA  ((2 << 3) + (TI_GDT << 2) + RPL0)  // 内核数据段选择子 0x10
#define SELECTOR_K_STACK SELECTOR_K_DATA                      // 内核栈段选择子     
#define SELECTOR_K_GS    ((3 << 3) + (TI_GDT << 2) + RPL0)  // 内核gs段选择子 0x18, 用于存放当前线程pcb地址


/*IDT描述符属性*/
#define IDT_DESC_P      1     // P位，表示中断是否存在
#define IDT_DESC_DPL0   0       //目标段特权级
#define IDT_DESC_DPL3   3
#define IDT_DESC_32_TYPE  0xE    // 32位中断门类型属性值, P=1, DPL=0, Type=1110B，表示进入中断后清IF，关中断，用32位偏移
#define IDT_DESC_16_TYPE  0x6    // 16位中断

#define IDT_DESC_ATTR_DPL0  ((IDT_DESC_P << 7) + (IDT_DESC_DPL0 << 5) + IDT_DESC_32_TYPE)    //定义门描述符的属性
#define IDT_DESC_ATTR_DPL3  ((IDT_DESC_P << 7) + (IDT_DESC_DPL3 << 5) + IDT_DESC_32_TYPE)

#endif
