%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR ;起始地址按照之前约定一样
LOADER_STACK_TOP equ LOADER_BASE_ADDR ;loader在实模式下的栈指针地址
jmp loader_start

;构建gdt及其内部描述符
GDT_BASE: dd 0x00000000             ;低4字节
          dd 0x00000000             ;高4字节，无效描述符，防止选择子未初始化
CODE_DESC: dd 0x0000FFFF            ;dd是伪指令，表示define double-word,也就是定义双字变量,这里的0xFFFF表示段界限
            dd DESC_CODE_HIGH4      ;代码段描述符
DATA_STACK_DESC: dd 0x0000FFFF      
                  dd DESC_DATA_HIGH4    ;栈段描述符，也就是数据段描述符,这俩共用一个段是因为方便，至于为什么这里栈的P位为什么不是1,也就是向下扩展，这是因为段描述符是由CPU检查的，而CPU并不知道这个段的作用，程序员若要实现栈向下扩展只需要使得其esp在push时减小即可
VIDEO_DESC: dd 0x80000007           ;limit=(0xbffff-0xb8000)/4k=0x7，这里的0xb8000~0xbffff是实模式下文本模式显存适配器的内存地址，因此段界限即为上述方程
            dd DESC_VIDEO_HIGH4 ;此时dpl为0，此乃显存段描述符
;以上共填充了3个段描述符 + 1个首段无效描述符



GDT_SIZE equ $ - GDT_BASE           ;计算当前GDT已经填充的大小
GDT_LIMIT equ GDT_SIZE - 1          ;
times 60 dq 0                       ;此处预留60个描述符空位，这里跟上面一致，表示define quad-word ,也就是定义60个以0填充的段描述符,这里的times是循环次数


;以上代码加起来4*8+60*8=512bytes
------------------------------------------------------------------------------------------------------------------------------------



;------ 这里定义选择子------------
SELECTOR_CODE equ (0x0001<<3) + TI_GDT + RPL0   ;相当于(CODE_DESC - GDT_BASE)/8 + TI_GDT + RPL0
SELECTOR_DATA equ (0x0002<<3) + TI_GDT + RPL0   ;同上类似
SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0   ;同上类似



;-------------- 以下定义gdt的指针，前2字节是gdt的界限，后4字节是gdt的起始地址 ---------
gdt_ptr dw GDT_LIMIT    ;define word
  dd GDT_BASE


total_mem_bytes dd 0                ；用于保存内存容量
ards_buf times 244 db 0             
ards_nr dw 0                        ;用于记录ARDS结构体数量

;此部分代码 4+244+2+6=256bytes  gdt_ptr+total_mem_bytes+ards_buf+ards_nr
------------------------------------------------------------------------------




loadermsg db 'I am loader in real.'         ；在内存中定义一个字符串常量
；dw 是汇编语言中的伪指令（pseudo-instruction）。它不是CPU执行的机器指令，而是指导汇编器如何在内存中分配和初始化数据的指令。具体来说：dw 表示 "define word"（定义字）
；它告诉汇编器分配2个字节（16位）的内存空间并用指定的值初始化这段内存类似地，dd 也是伪指令，表示 "define double word"（定义双字），分配4个字节（32位）的内存空间


--------------------- 显示字符串在屏幕上 -----------------------------------
loader_start:

  mov sp ,LOADER_BASE_ADDR
  mov bp ,loadermsg     ;ES:BP = 字符串地址
  mov cx ,20            ;CX = 字符串长度                ;注意这里使用的是BIOS中断，一旦进入保护模式就没有BIOS中断了
  mov ax ,0x1301        ;AH = 13H,AL = 01H
  mov bx ,0x001f        ;页号为0,蓝底粉红字
  mov dx ,0x1800        
  int 0x10              ;10H号中断
;----------------------------------------------
;INT 0x10   功能号：0x13    功能描述：打印字符串
;----------------------------------------------
;输入：
;AH子功能号=13H
;BH = 页号
;BL = 属性
;CX = 字符串长度
;(DH,DL) = 字符串地址
;AL = 显示输出方式
; 0 -- 字符串只含显示字符，显示属性在BL中，显示后光标位置不变
; 1 -- 字符串只含显示字符，显示属性在BL中，显示后光标位置改变
; 2 -- 字符串只含显示字符和显示属性，显示后光标位置不变
; 3 -- 字符串只含显示字符和显示属性，显示后光标位置改变
; 无返回值
------------------------------------------------------------------------------------
xor ebx, ebx               ; 第一次调用，ebx 必须为 0（后续BIOS会返回新的ebx做链表迭代）
mov edx, 0x534d4150        ; 'SMAP'标志，必须填，整个循环不变
mov di, ards_buf           ; di指向内存缓冲区，用于存放ARDS结构

.e820_mem_get_loop:
mov eax, 0x0000e820        ; eax: 子功能号，每次调用都要重置
mov ecx, 20                ; ARDS结构大小20字节，ecx填结构长度
int 0x15                   ; BIOS中断，取ARDS
jc .e820_failed_so_try_e801 ; 若CF置位，出错，尝试下一个方法
add di, cx                 ; di增加20，指向下一个ARDS写入位置
inc word [ards_nr]         ; 已获取的ARDS数量加1
cmp ebx, 0                 ; 如果ebx返回为0，表明ARDS已全部返回
jnz .e820_mem_get_loop     ; 如果非0，则继续获取下一个ARDS





mov cx, [ards_nr]          ; 用cx保存ARDS数量
mov ebx, ards_buf          ; ebx指向ARDS缓冲区起始
xor edx, edx               ; edx用于存最大内存容量，先清零

.find_max_mem_area:
mov eax, [ebx]             ; eax = base_addr_low（内存块起始地址低32位）
add eax, [ebx+8]           ; eax += length_low（内存块长度低32位，得末尾地址）
add ebx, 20                ; 指向下一个ARDS
cmp edx, eax               ; edx存最大值，逐个比较
jge .next_ards             ; 如果当前最大>=本块末尾，不更新
mov edx, eax               ; 否则用本块末尾更新最大值
.next_ards:
loop .find_max_mem_area    ; 遍历所有ARDS结构
jmp .mem_get_ok            ; 跳到成功出口







.e820_failed_so_try_e801:
mov ax, 0xe801
int 0x15
jc .e801_failed_so_try88   ; 如果出错，降级下一种方式

; 1. 算低15MB容量 (ax,cx存的都是KB)
mov cx, 0x400              ; 1024
mul cx                     ; ax*cx, 得到低15MB的总字节数，结果存edx:eax
shl edx, 16                ; edx左移16位，为组合高低16位
and eax, 0x0000FFFF        ; 只保留低16位
or edx, eax                ; 合成完整的32位容量
add edx, 0x100000          ; 补上1MB，因e801通常返回15MB，不含1MB基础区
mov esi, edx               ; esi备份低15MB容量

; 2. 算16MB以上容量 (bx,dx存的都是64KB块数)
xor eax, eax
mov ax, bx
mov ecx, 0x10000           ; 65536（即64KB）
mul ecx                    ; ax*ecx = bx*64KB = 16MB以上容量
add esi, eax               ; 累加到esi（edx一般为0，因为最大只到4G）
mov edx, esi               ; edx = 总内存字节数
jmp .mem_get_ok





.e801_failed_so_try88:
mov ah, 0x88
int 0x15
jc .error_hlt              ; 如果再失败，系统只能报错停机

and eax, 0x0000FFFF        ; 只保留ax（单位：KB）

mov cx, 0x400              ; 1024
mul cx                     ; ax*1024 得到字节
shl edx, 16
or edx, eax                ; 组合成32位容量
add edx, 0x100000          ; 补1MB



.mem_get_ok:
mov [total_mem_bytes], edx ; 总物理内存容量写入全局变量（单位：字节）















;---------------- 准备进入保护模式 ------------------------------------------------
;1 打开A20
;2 加载gdt
;3.将CR0的PE位置0,

;------------=- 打开A20 --------------
in al,0x92           ; 读端口0x92
or al,0000_0010B     ; 置A20门（bit1=1）
out 0x92,al          ; 写回端口




;------------- 加载GDT --------------
lgdt [gdt_ptr]



;------------- CR0第0位置1 ----------
mov eax, cr0
or eax, 0x00000001
mov cr0, eax

jmp dword SELECTOR_CODE:p_mode_start ;刷新流水线


--------------------------------------------------------------------------------------

[bits 32]
p_mode_start:
  mov ax, SELECTOR_DATA
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov esp, LOADER_STACK_TOP
  mov ax, SELECTOR_VIDEO
  mov gs, ax

  mov byte [gs:160], 'p'

  jmp $