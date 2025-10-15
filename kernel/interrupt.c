#include "interrupt.h"
#include "stdint.h"
#include "global.h"
#include "io.h"
#include "print.h"

#define IDT_DESC_CNT 0x21   // 目前总共支持的中断数
#define PIC_M_CTRL 0x20 // 主片的控制端口
#define PIC_M_DATA 0x21 // 主片的数据端口
#define PIC_S_CTRL 0xA0 // 从片的控制端口
#define PIC_S_DATA 0xA1 // 从片的数据端口

/* 中断门描述符结构体*/
struct gate_desc {
    uint16_t func_offset_low_word;  // 中断处理函数地址的低16位
    uint16_t selector;               // 代码段选择子
    uint8_t  dcount;                 // 该字段没有实际意义, 只为了适应门描述符结构体而存在
    uint8_t  attribute;              // 描述符属性
    uint16_t func_offset_high_word; // 中断处理函数地址的高16位
};

//静态函数声明
static void make_idt_desc(struct gate_desc* p_gdesc, uint8_t attr,intr_handler function);
static struct gate_desc idt[IDT_DESC_CNT]; // IDT
extern intr_handler intr_entry_table[IDT_DESC_CNT]; // 声明引用在kernel.S中定义的中断处理函数入口数组

char* intr_name[IDT_DESC_CNT];
intr_handler idt_table[IDT_DESC_CNT];
extern intr_handler intr_entry_table[IDT_DESC_CNT];
/*初始化可编程中断控制器*/
static void pic_init(void) {
    // 初始化主片
    outb(PIC_M_CTRL, 0x11); // ICW1: 边沿触发,级联8259,需要ICW4
    outb(PIC_M_DATA, 0x20); // ICW2: 起始中断向量号为0x20,也就是IR[0-7]为0x20~0x27
    outb(PIC_M_DATA, 0x04); // ICW3: IR2接从片
    outb(PIC_M_DATA, 0x01); // ICW4: 8086模式,正常EOI,手动发送信号清空ISR

    // 初始化从片
    outb(PIC_S_CTRL, 0x11); // ICW1: 边沿触发,级联8259,需要ICW4
    outb(PIC_S_DATA, 0x28); // ICW2: 起始中断向量号为0x28,也就是IR[8-15]为0x28~0x2F
    outb(PIC_S_DATA, 0x02); // ICW3: 设置从片连接到主片的IR2引脚
    outb(PIC_S_DATA, 0x01); // ICW4: 8086模式,正常EOI

    // 打开主片上IR0时钟中断，其他全部关闭
    outb(PIC_M_DATA, 0xfe);
    outb(PIC_S_DATA, 0xff);
    put_str("   pic_init done\n");
}

   

//创建中断描述符
static void make_idt_desc(struct gate_desc* p_gdesc, uint8_t attr,intr_handler function) {
    p_gdesc->func_offset_low_word = (uint32_t)function & 0x0000FFFF;
    p_gdesc->selector = SELECTOR_K_CODE;
    p_gdesc->dcount = 0;
    p_gdesc->attribute = attr;
    p_gdesc->func_offset_high_word = ((uint32_t)function & 0xFFFF0000) >> 16;
}

/* 中断描述符初始化 */
static void idt_desc_init(void) {
    int i;
    for(i = 0; i < IDT_DESC_CNT; i++) {
        make_idt_desc(&idt[i], IDT_DESC_ATTR_DPL0, intr_entry_table[i]);
    }
    put_str("   idt_desc_init done\n");
}

static void general_intr_handler(uint8_t vec_nr) {
    if(vec_nr == 0x27 || vec_nr == 0x2f) {
        return; // IRQ7和IRQ15会产生伪中断(spurious interrupt),无需处理
    }
    put_str("int vector: 0x");
    put_int(vec_nr);    
    put_char('\n');

}

static void exception_init(void) {
    int i;
    for(i = 0; i < IDT_DESC_CNT; i++) {
        idt_table[i] = general_intr_handler;
        intr_name[i] = "unknown";
    }
    intr_name[0] = "#DE Divide Error";
    intr_name[1] = "#DB Debug Exception";
    intr_name[2] = "NMI Interrupt";
    intr_name[3] = "#BP Breakpoint Exception";
    intr_name[4] = "#OF Overflow Exception";
    intr_name[5] = "#BR BOUND Range Exceeded Exception";
    intr_name[6] = "#UD Invalid Opcode Exception";
    intr_name[7] = "#NM Device Not Available Exception";
    intr_name[8] = "#DF Double Fault Exception";
    intr_name[9] = "Coprocessor Segment Overrun";
    intr_name[10] = "#TS Invalid TSS Exception";
    intr_name[11] = "#NP Segment Not Present";
    intr_name[12] = "#SS Stack Fault Exception";
    intr_name[13] = "#GP General Protection Exception";
    intr_name[14] = "#PF Page-Fault Exception";
    // 15 Intel 保留
    intr_name[16] = "#MF x87 FPU Floating-Point Error";
    intr_name[17] = "#AC Alignment Check Exception";
    intr_name[18] = "#MC Machine-Check Exception";
    intr_name[19] = "#XF SIMD Floating-Point Exception";    
}

void idt_init(){
    put_str("idt_init start\n");
    idt_desc_init(); // 初始化中断描述符表
    exception_init(); // 异常名初始化并注册一般中断处理函数
    pic_init();      // 初始化8259A
    // 加载idt
    uint64_t idt_operand = ((sizeof(idt) - 1) | ((uint64_t)(uint32_t)idt << 16));
    asm volatile("lidt %0" : : "m"(idt_operand));//m代表内存约束，这里m参数会让编译器这里需要的是变量地址
    put_str("   lidt done\n");
}