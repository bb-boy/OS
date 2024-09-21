%include "boot.inc"
section loader vstart = LOADER_BASE_ADDR    ; 从硬盘加载到内存时把 loader 加载到内存的 LOADER_BASE_ADDR 这个位置
LOADER_STACK_TOP equ LOADER_BASE_ADDR       ; 栈顶的位置
jmp loader_start

; 构建全局描述符表
GDT_BASE:         dd 0x00000000 
                 dd 0x00000000    ; gdt 的第 0 个元素为 64 位全 0，防止因为 gdtr 未初始化造成读错数据

CODE_DESC:        dd 0x0000FFFF
                 dd DESC_CODE_HIGH4   ; 代码段描述符

DATA_STACK_DESC:  dd 0x0000FFFF
                 dd DESC_DATA_HIGH4   ; 数据段和栈段描述符

VIDEO_DESC:       dd 0x80000007           ; 低 16 位是段界限的 0-16 位置，文本模式的显示适配器的内存地址是 0xb8000-0xbffff，所以段界限是 0x7fff，粒度是 4k，故段界限的低 16 位是 0x0007
                 dd DESC_VIDEO_HIGH4   ; 段描述符的高 32 位的低 8 位是段基址的 16-23 位，段基址的低 16 位是低 32 位

GDT_SIZE equ $ - GDT_BASE
GDT_LIMIT equ GDT_SIZE - 1   
times 60 dq 0                ; define quadword 定义四个字，预留 60 个描述符

; 构建选择子，选择子 0-1 位是特权级，2 位是 0 表示在 gdt 中索引，为 1 在 ldt 中索引，3-15 位是 gdt 中的索引号，选择子存储在段寄存器中，由于段寄存器是 16 位的，所以选择子也是 16 位的
SELECTOR_CODE equ (0x0001 << 3) + TI_GDT + RPL0       ; 1 表示代码段在 gdt 中的索引号，TI 表示在 gdt 中索引，rpl0 表示最高特权级
SELECTOR_DATA equ (0x0002 << 3) + TI_GDT + RPL0        ; 数据段的索引号是 2
SELECTOR_VIDEO equ (0x0003 << 3) + TI_GDT + RPL0       ; 显存段的索引号是 3

; 定义 gdt 的指针，gdt 的指针存放在 gdtr 中，gdtr 的高 32 位是 gdt 的起始地址，低 16 位是以字节为单位的 gdt 的界限，为段的大小减一
gdt_ptr dw GDT_LIMIT
        dd GDT_BASE    ; 声明一个变量，用于存放指针和段界限
loadermsg db 'I am loader in real.'       ; 定义一个 loadermsg 标签用来表示一个字符串的起始地址，db 定义一个或多个字节的数据，后面所有的字符都被转换为 ascii 码存储

loader_start:
  mov sp, LOADER_BASE_ADDR
  mov bp, loadermsg    ; bp 中存放字符串的起始地址
  mov cx, 20           ; cx 存放字符数
  mov ax, 0x1301       ; 0x1301 是 BIOS 视频服务的 int 0x10 的子功能号，0x13 表示显示字符串，01 表示显示字符串时不移动光标
  mov bx, 0x001f       ; BX 用于存储文本的显示属性。低 4 位 0xF 是前景色（白色），高 4 位 0x1 是背景色（蓝色）。
  mov dx, 0x1800       ; 显示在 0x18 即 24 行 00 列，文本模式为 25*80
  int 0x10             ; 调用 0x10 号中断

; ---------------------------------准备进入保护模式-----------------------------
; 打开 A20，关闭地址回环，在 8086 中只有 A0-A19 条地址线，因此只能访问 1M 的空间，在 80286 CPU 中有 24 条地址线，即有 A0-A23，打开 A20 的目的就是为了关闭地址回环
; 加载 gdt
; 将 cr0 的 pe 位设置为 1，控制寄存器 CR0 的第 0 位，即 PE 位，Protection Enable，此位用于启用保护模式，是保护模式的开关

; ------------------打开 A20----------------------
in al, 0x92
or al, 0000_0010B      ; 将端口 0x92 端口的第一位置为 1
out 0x92, al

; ------------------加载 gdt----------------------
lgdt [gdt_ptr]

; ------------------设置 cr0 的 PE 位为 1（第 0 位）--------------
mov eax, cr0
or eax, 0x00000001
mov cr0, eax

jmp dword SELECTOR_CODE:p_mode_start       ; 跳转指令，用于清空流水线, 69-74 行有 16 位和 32 位的指令，指令的执行都是按照流水线执行的，会出现指令解析的错误

[bits 32]
p_mode_start:
  mov ax, SELECTOR_DATA
  mov ds, ax 
  mov es, ax
  mov ss, ax
  mov esp, LOADER_STACK_TOP
  mov ax, SELECTOR_VIDEO
  mov gs, ax

  mov byte [gs:160], 'p'  ; gs 表示内存中的显存段地址，文本显示模式下为 25*80，一个字符是两个字节，高字节是属性，低字节是 ascii 码，
 
  jmp $
