#ifndef __KERNEL_INTERRUPT_H
#define __KERNEL_INTERRUPT_H
#include "stdint.h"

/* 中断处理函数类型定义 */
typedef void* intr_handler;

enum intr_status {
    INTR_OFF,  // 中断关闭
    INTR_ON     // 中断打开
};
/* 中断初始化函数 */
void idt_init(void);
enum intr_status intr_enable(void);
enum intr_status intr_disable(void);
enum intr_status intr_get_status(void);
enum intr_status intr_set_status(enum intr_status status);

#endif  /* __KERNEL_INTERRUPT_H */
