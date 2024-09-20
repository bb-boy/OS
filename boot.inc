;---------------loader and kernel --------------
LOADER_BASE_ADDR equ 0x900      ;loader加载到内存中的地址
LOADER_START_SECTOR equ 0x2     ;loader在硬盘中的扇区号


;----------------gdt描述符属性------------------------
DESC_G_4K  equ 1_00000000000000000000000b 
;段描述符的高32位的第23位是G字段，表示的是粒度，G为0表示的段界限的单位是1B，为1表示4KB
DESC_D_32   equ 1_0000000000000000000000b
;高32位的第22位是D/B字段，表示有效地址和操作数的大小，若为0表示16位操作数或地址，若为1表示32位操作数或地址
DESC_L  equ 0_000000000000000000000b
;第21位设置是否为64位代码段，为1表示64位代码段，为0表示32位代码段

DESC_AVL    equ     0_00000000000000000000b   
;第20位是表示可用的，是对用户而言，暂且置为0

DESC_LIMIT_CODE2    equ     1111_0000000000000000b
;高32位中的16~19位表示段界限的16~19位
DESC_LIMIT_DATA2    equ     DESC_LIMIT_CODE2
DESC_LIMIT_VIDEO2   equ     0000_0000000000000000b

DESC_P      equ     1_000000000000000b
;高位中的第15表示段是否存在于内存中，存在为1
DESC_DPL_0      equ     00_0000000000000b  
;高位的第13、14位是DPL字段，描述特权级，0为最高级,数字越小特权级越大
DESC_DPL_1      equ     01_0000000000000b
DESC_DPL_2      equ     10_0000000000000b
DESC_DPL_3      equ     11_0000000000000b


DESC_S_CODE     equ     1_000000000000b   
;第12位描述是否为系统段，1表示非系统段
DESC_S_DATA     equ     DESC_S_CODE
DESC_S_sys     equ     0_000000000000b  

;8到11位为type字段，用来制定本描述符的类型，type字段要和S字段搭配使用才有意义，如果是非系统段，非系统段分为代码段和数据段，x为1是代码段
;如果是代码段，11~8位分别代表XCRA，x代表是否可执行，R代表是否可读，C代表是否是一致性代码，A代表是否被CPU访问过


DESC_TYPE_CODE      equ     1000_00000000b  
;代码是可执行的，非一致性，不可读，已访问位a为0


;如果代码是数据段，11~8位依次是xewa，x表示是否可执行，数据段一般为0，w表示是否可写，数据段一般为1，e为1表示向下扩展，地址越来越低
;为0表示向上扩展，地址越来越高，一般用于数据段或者代码段
DESC_TYPE_DATA      equ     0010_00000000b  
;表示数据段 不可执行  向上扩展  不可写 已访问位为0



;拼接段描述符的高32位，由于是平坦模型，段描述符的段基址字段都为0，高32位中的0~7和24~31都为0
DESC_CODE_HIGH4     equ    (0x00 << 24) +  DESC_G_4K  + DESC_D_32 + DESC_L +DESC_AVL + DESC_LIMIT_CODE2 +DESC_P + DESC_DPL_0 + DESC_S_CODE + DESC_TYPE_CODE +0x00

DESC_DATA_HIGH4     equ     (0x00 << 24) + DESC_G_4K+DESC_D_32+DESC_L+DESC_AVL+DESC_LIMIT_DATA2+DESC_P+DESC_DPL_0+DESC_S_DATA+DESC_TYPE_DATA+0x00

DESC_VIDEO_HIGH4    equ     (0x00 << 24) + DESC_G_4K+DESC_D_32+DESC_L+DESC_AVL+DESC_LIMIT_VIDEO2+DESC_P+DESC_DPL_0+DESC_S_DATA+DESC_TYPE_DATA+0X0b                                
 


;----------------------------选择子属性-----------------------------------------

;GDTR寄存器为48位，高32位是gdt的起始地址，低16位分为两部分，上13位是索引位置（gdt的数组下标），第2位是TI位，为0时在gdt中索引，为1在LDT中索引，第0-1为表示特权级
;gdt最多为64KB，最多可以有8K个索引项

RPL0    equ  00b
RPL1    equ  01b
RPL2    equ  10b
RPL3   equ  11b
TI_GDT          equ     000b  
TI_LDT          equ     100b  
















