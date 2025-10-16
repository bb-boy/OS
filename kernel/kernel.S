[bits 32]
%define ERROR_CODE nop
%define ZERO push 0

extern idt_table

extern put_str  ;;;;声明外部函数put_str

section .data
intr_str db "interrupt occurred!!",0xa,0    ; 定义一个字符串，内容是 "interrupt occurred!!"，后面跟着换行符（0xA）和一个字节 a
intr_count dd 0                              ; 中断计数器，用于只执行一次

global intr_entry_table
intr_entry_table:

%macro VECTOR 2
section .text
intr%1entry:

    %2
    push ds
    push es
    push fs 
    push gs
    pushad

    ; 检查是否是 IRQ0 (0x20)，如果是则检查计数器

    
    
    push intr_str
    call put_str
    add esp,4



.send_eoi:
    mov al,0x20
    out 0xa0,al   ;向从片发送中断结束信号
    out 0x20,al   ;向主片发送中断结束信号

    push %1
    call [idt_table + %1*4]
    jmp intr_exit

section .data
    dd intr%1entry
%endmacro   

section .text
global intr_exit
intr_exit:
    add esp,4
    popad
    pop gs
    pop fs
    pop es
    pop ds
    add esp,4
    iret

VECTOR 0x00,ZERO          ;0#DE
VECTOR 0x01,ZERO          ;1#DB   
VECTOR 0x02,ZERO          ;2#NMI
VECTOR 0x03,ZERO          ;3#BP     
VECTOR 0x04,ZERO          ;4#OF
VECTOR 0x05,ZERO          ;5#BR
VECTOR 0x06,ZERO          ;6#UD
VECTOR 0x07,ZERO          ;7#NM
VECTOR 0x08,ERROR_CODE
VECTOR 0x09,ZERO          ;9#Coprocessor Segment Overrun
VECTOR 0x0A,ERROR_CODE
VECTOR 0x0B,ERROR_CODE
VECTOR 0x0C,ERROR_CODE     
VECTOR 0x0D,ERROR_CODE       ;13#GP
VECTOR 0x0E,ERROR_CODE        ;14#PF
VECTOR 0x0F,ZERO
VECTOR 0x10,ZERO          ;16#MF
VECTOR 0x11,ERROR_CODE        ;17#AC
VECTOR 0x12,ZERO          ;18#MC
VECTOR 0x13,ZERO          ;19#XM
VECTOR 0x14,ZERO          ;20#VE
VECTOR 0x15,ZERO
VECTOR 0x16,ZERO
VECTOR 0x17,ZERO
VECTOR 0x18,ZERO
VECTOR 0x19,ZERO
VECTOR 0x1A,ZERO
VECTOR 0x1B,ZERO
VECTOR 0x1C,ZERO
VECTOR 0x1D,ZERO
VECTOR 0x1E,ERROR_CODE    ;30#SX
VECTOR 0x1F,ZERO
VECTOR 0x20,ZERO          ;32#IRQ0


;当异常触发时（比如除零 #DE）：
;
;CPU 根据异常类型选定向量号 n（0..31，架构固定分配）。
;读取 IDTR（你用 lidt 装载的 IDT 基址与界限）。
;计算目标门描述符地址：IDT.base + n*8（32 位下每项 8 字节）。
;取出门描述符，做合法性检查：
;类型必须是中断门(0xE)或陷阱门(0xF)，P 位为 1，段选择子指向可执行代码段等；
;异常是硬件产生，一般不做 DPL 限制（软件 int 指令才校验 DPL）。
;若检查失败，可能引发 #NP/#GP；若在处理已有异常时再出错可能升级为 #DF，最后可能三重故障重启。
;构造栈帧并切换到目标：
; 若 CPL 变化（环级切换），先压入旧 SS, ESP；
; 压入 EFLAGS, CS, EIP；
; 对“带错误码”的异常，CPU 自动再压入 error code；
; 中断门会清 IF（屏蔽后续外部中断），陷阱门不清 IF；
; 跳到门描述符里的目标 CS:EIP 执行你的入口（比如 intr0x0Eentry）。
; 你的入口处理后用 iret 返回，CPU 弹出相应栈帧并恢复现场

