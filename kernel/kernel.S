[bits 32]
%define ERROR_CODE nop
%define ZERO push 0


extern put_str  ;;;;声明外部函数put_str

section .data
intr_str db "interrupt occurred!!",0xa,0    ; 定义一个字符串，内容是 "interrupt occurred!!"，后面跟着换行符（0xA）和一个字节 a

global intr_entry_table
intr_entry_table:

%macro VECTOR 2
section .text
intr%1entry:

    %2
    push intr_str
    call put_str
    add esp,4

    mov al,0x20
    out 0xa0,al   ;向主片发送中断结束信号
    out 0x20,al   ;向从片发送中断结束信号

    add esp,4
    iret

section .data
    dd intr%1entry
%endmacro   

VECTOR 0x00,ZERO          ;0#DE
VECTOR 0x01,ZERO          ;1#DB   
VECTOR 0x02,ZERO          ;2#NMI
VECTOR 0x03,ZERO          ;3#BP     
VECTOR 0x04,ZERO          ;4#OF
VECTOR 0x05,ZERO          ;5#BR
VECTOR 0x06,ZERO          ;6#UD
VECTOR 0x07,ZERO          ;7#NM
VECTOR 0x08,ZERO
VECTOR 0x09,ZERO          ;9#Coprocessor Segment Overrun
VECTOR 0x0A,ZERO
VECTOR 0x0B,ZERO
VECTOR 0x0C,ZERO        
VECTOR 0x0D,ZERO          ;13#GP
VECTOR 0x0E,ZERO          ;14#PF
VECTOR 0x0F,ZERO
VECTOR 0x10,ZERO          ;16#MF
VECTOR 0x11,ZERO          ;17#AC
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