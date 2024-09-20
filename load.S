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
                dd DESC_VIDEO_HIGH4 



