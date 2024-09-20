;主引导程序
;--------------------------------------------------------
%include "boot.inc"
SECTION MBR vstart=0x7c00
    mov ax,cs
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov fs,ax
    mov sp,0x7c00
    mov ax,0xb800
    mov gs,ax

;清屏
;利用0x06号功能，上卷全部行，则可清屏
;--------------------------------------------------------
;INT 0x10   功能号：0x06  功能描述：上卷窗口
;----------------------------------------------------------
;AH功能号=0x06
;AL = 上卷的行数（0表示上卷全部行)
;BH = 上卷行属性
;(CL,CH) = 窗口左上角的（X,Y)位置
;(DL,DH) = 窗口右下角的 (X,Y)位置
    mov ax,0x0600
    mov bx,0x0700
    mov cx,0
    mov dx,184fh
    int 10h    ;设置参数，并调用中断

;输出字符串MBR

    mov byte [gs:0x00],'1'
    mov byte [gs:0x01],0xA4

    mov byte [gs:0x02],' '
    mov byte [gs:0x03],0xA4

    mov byte [gs:0x04],'M'
    mov byte [gs:0x05],0xA4

    mov byte [gs:0x06],'B'
    mov byte [gs:0x07],0xA4

    mov byte [gs:0x08],'R'
    mov byte [gs:0x09],0xA4

    mov eax,LOADER_START_SECTOR  ;起始扇区地址
    mov bx, LOADER_BASE_ADDR       ;写入的地址
    mov cx,4                        ;待写入的扇区数
    call rd_disk_m_16               ;读取程序的起始部分

    jmp LOADER_BASE_ADDR


;--------------------------------------
;读取硬盘n个扇区
rd_disk_m_16:
    mov esi,eax  ;备份LBA扇区号
    mov di,cx   ;备份读入的扇区数


;读写硬盘
;第一步设置要读取的扇区数，往sector count寄存器中写入待读取的扇区数,sector count寄存器是8位寄存器
;最大值是255，0表示256，主通道的0x1f2端口是sector count寄存器
    mov dx,0x1F2      ;端口号存入dx寄存器中
    mov al,cl          ;扇区数存入al中
    out dx,al             ;扇区数写入端口中


;第二步：将LBA地址存入0x1f3~0x1f6
;eax寄存器中存放着28为LBA扇区号，主通道的0x1f3/0x1f4/0x1f5,分别存放LBA低八位，中八位，高八位
;device寄存器的低四位，用来存储LBA地址的24~27位，0x1f6是device寄存器

    mov eax,esi            ;恢复eax
    mov dx,0x1F3
    out dx,al     ;LBA低八位写入端口0x1f3

    mov dx,0x1F4
    mov cl,8
    shr eax,cl
    out dx,al    ;LBA中八位写入端口0x1f4


    mov dx,0x1F5
    shr eax,cl
    out dx,al    ;eax右移8位，将低8位写入端口0x1f5中

;设置device寄存器，低四位表示LBA地址的24~27位，第4位表示主盘或从盘，0表示主盘
;第6位表示启用LBA模式，第5和7位成为MBS位，都置为1,eax的高4位都为0，device的高4位为1110

    shr eax,cl    ;右移8位
    and al,0x0f   ;and操作 and1不改变原来的数字，and0结果都为0
    or al,0xe0    ;or0不改变原来的数值，or1结果都为1
    mov dx,0x1F6
    out dx,al   


;第三步：向0x1f7端口写入读命令，status寄存器置为0x20，硬盘就开始工作
    
    mov dx,0x1F7
    mov al,0x20
    out dx,al

;第四步：检查硬盘状态
;status寄存器第4位为1表示硬盘已经准备好数据，第7位为1表示硬盘正忙
   .not_ready:
        nop
        in al,dx  ;读取status寄存器中的数据
        and al,0x88   ;4和7位只有10和01这两种情况，都和1进行and操作，若为0x08则表示数据已经准备好了
        cmp al,0x08
        jnz .not_ready ;若结果不是0则跳回.not_ready继续轮询


;第5步：从0x1f0端口读取数据
    mov ax,di
    mov dx,256
    mul dx
    mov cx,ax        ;di表示要读取的扇区数，每次读取一个字即两个字节，所以一个扇区读取256次，cx表示loop的次数


    mov dx,0x1f0
   .go_on_read:
        in ax,dx
        mov [bx],ax
        add bx,2
        loop .go_on_read
        ret

times 510-($-$$) db 0   ;db =define byte,times是汇编中的伪指令，表示重复生成数据
db 0x55,0xaa















 





