%include "boot.inc"
section loader vstart = LOADER_BASE_ADDR    ;从硬盘加载到内存时把这个section加载到内存的LOADER_BASE_ADDR这个位置
LOADER_STACK_TOP equ LOADER_BASE_ADDR   ;栈顶的位置，栈的递减的，最小只能减小到loader的起始地址
jmp loader_start

;构建全局描述符表，

GDT_BASE: dd 0x00000000 
            dd 0x00000000    ;gdt的第0个元素为64位全0，方式因为gdtr未初始化造成读错数据

CODE_DESC: dd 0x0000FFFF
       dd DESC_CODE_HIGH4   ;代码段描述符

DATA_STACK_DESC: dd 0x0000FFFF
                    dd DESC_DATA_HIGH4   ;数据段和栈段描述符

VIDEO_DESC: dd 0x80000007           ;低16位是段界限的0-16位置，文本模式的显示适配器的内存地址是0xb8000-0xbffff,所以段界限是0x7fff，粒度是4k，故段界限的低16位是0x0007
                dd DESC_VIDEO_HIGH4   ;段描述符的高32位的低8位是段基址的16-23位，段基址的低16位是低32位

GDT_SIZE equ $-GDT_BASE
GDT_LIMIT equ GDT_SIZE-1   
times 60 dq 0                ;define quadword定义四个字，预留60个描述符


;构建选择子，选择子0-1位是特权级，2位是0表示在gdt中索引，为0在ldt中索引，3-15位是gdt中的索引号，选择子存储在段寄存器中，由于段寄存器是16位的，所以选择子也是16位的
SELECTOR_CODE equ (0x0001<<3)+T1_GDT+RPL0       ;1表示代码段在gdt中的索引号，T1表示在gdt中索引，rpl0表示最高特权级
SELECTOR_DATA equ (0x0002<<3)+T1_GDT+RPL0        ;数据段的索引号是2
SELECTOR_VIDEO equ (0x0003<<3)+T1_GDT+RPL0        ;显存段的索引号是3


;定义gdt的指针，gdt的指针存放在gdtr中，gdtr的高32位是gdt的起始地址，低16位是以字节为单位的gdt的界限，为段的大小减一
gdt_ptr dw GDT_LIMIT
       dd GDT_BASE    ;声明一个变量变量，用于存放指针和段界限

loadermsg db '2 loader in real.' ;0用于字符串结束
;定义一个loadermsg标签用来表示一个字符串的起始地址，db定义一个或多个字节的数据，后面所有的字符都被转换为ascii码存储
;my_byte db 0x12,定义一个字节存储0x12

loader_start:
       mov sp,LOADER_BASE_ADDR
       mov bp,loadermsg  ;bp中存放字符串的起始地址
       mov cx,17          ;cx存放字符数
       mov ax,0x1301       ;0x1301 是 BIOS 视频服务的 int 0x10 的子功能号，0x13 表示显示字符串，01 表示显示字符串时不移动光标
       mov bx,0x001f       ;BX 用于存储文本的显示属性。0x001f 指定文本的颜色属性。低 4 位 0xF 是前景色（白色），高 4 位 0x1 是背景色（蓝色）。 
       mov dx,0x1800        ;显示在0x18即24行  00列，文本模式为25*80
       int 0x10          ;调用0x10号中断



;---------------------------------准备进入保护模式-----------------------------
;打开A20，关闭地址回环，在8086中只有A0-A19条地址线，因此只能访问1M的空间，在80286cpu中有24条地址线，即有A0-A23，打开A20的目的就是为了关闭地址回环
;加载gdt
;将cr0的pe位置置为0，控制寄存器CR0的第0 位，即PE 位，Protection Enable，此位用于启用保护模式，是保护模式的开关

;------------------打开A20----------------------
in al,0x92
or al,0000_0010B     ;将端口0x92端口的第一位置为1
out 0x92,al

;------------------加载gdt----------------------
lgdt [gdt_ptr]

;------------------cr0的PE位置为1（第0位）--------------

mov eax,cr0
or eax,0x00000001
mov cr0,eax

jmp dword SELECTOR_CODE:p_mode_start       ;跳转指令，用于清空流水线,69-74行有16位和32位的指令，指令的执行都是按照流水线执行的，会出现指令解析的错误
;double word表示汇编语言的一种数据类型，dd是伪指令


[bits 32]
p_mode_start:
       mov ax,SELECTOR_DATA
       mov ds,ax 
       mov es,ax
       mov ss,ax
       mov esp,LOADER_STACK_TOP
       mov ax,SELECTOR_VIDEO
       mov gs,ax

       mov byte [gs:160],'P'  ;gs表示内存中的显存段地址，文本显示模式下为25*80，一个字符是两个字节，高字节是属性，低字节是ascii码，
       jmp $


