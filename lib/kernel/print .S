TI_GDT equ 0
RPL0 equ 0
SELECTOR_VIDEO equ 0x0003<<3 + TI_GDT + RPL0


[bits 32]
section .text
;--------------------------------------put_char-------------------------
;把栈中的一个字符写入光标所在处
global put_char:
    pushad
    ;这是一条x86汇编指令，用于将所有32位通用寄存器（EAX、ECX、EDX、EBX、ESP、EBP、ESI、EDI）按顺序压入栈中。这是函数开头常见的保存现场操作
    mov ax,SELECTOR_VIDEO
    mov gs,ax
    ;不能打立即数送入段寄存器，这里使用ax中继

;;;;;;;;get current location of cursor
    mov dx,0x3D4
    mov al,0x0E         ;0x0E是光标位置高8位寄存器
    out dx,al           ;把0x0E送入0x3D4端口
    mov dx,0x3D5        ;0x3D5是数据端口
    in al,dx          ;把光标位置高8位送入al
    mov ah,al         ;高8位存入ah
     
     ;读光标位置低8位

    mov dx,0x3D4         
    mov al,0x0F         ;0x0F是光标位置低8位寄存器
    out dx,al           ;把0x0F送入0x3D4
    mov dx,0x3D5        ;0x3D5是数据端口`
    in al,dx          ;把光标位置低8位送入al
    ;现在光标位置的高8位在ah中，低8位在al

    mov bx,ax         ;把光标位置存入bx中

    mov ecx,[esp+32+4] ;取出栈中的字符
    cmp cl,0xd       ;判断是否是回车符
    jz .is_carriage_return
    cmp cl,0xa       ;判断是否是换行符
    jz .is_line_feed
    cmp cl,0x8       ;判断是否是退格符
    jz .is_backspace
    jmp .put_other

.is_backspace:
    dec bx           ;光标位置-1
    shl bx,1        ;乘以2，因为每个字符占2个字节
    mov word [gs:bx],0x0720  ;把光标位置的字符清空
    shr bx,1        ;除以2
    jmp .set_cursor

.put_other:
    shl bx,1        ;乘以2，因为每个字符占2个字节
    mov [gs:bx],cl
    inc bx 
    mov byte [gs:bx],0x07   ;属性字节，黑底白字
    shr bx,1        ;除以2
    inc bx
    cmp bx,2000
    jl .set_cursor


.is_line_feed:
.is_carriage_return:
    xor dx,dx
    mov ax,bx
    mov si,80

    div si          ;ax/bx除以80，商在al中，余数在ah中
    sub bx,dx
.is_carriage_return_end:
    add bx,80
    cmp bx,2000


.is_line_feed_end:
    jl .set_cursor










.roll_screen:
    cld
    mov ecx,960
    mov esi,0xc00b80a0
    mov edi,0xc00b8000
    rep movsd
    mov ebx,3840
    mov ecx,80

.cls:
    mov word [gs:ebx],0x0720
    add ebx,2
    loop .cls
    mov bx,1920

.set_cursor:
    mov dx,0x3D4
    mov al,0x0E
    out dx,al
    mov dx,0x03d5
    mov al,bh
    out dx,al

    mov dx,0x3D4
    mov al,0x0F
    out dx,al
    mov dx,0x3D5
    mov al,bl
    out dx,al
.put_char_done:
    popad
    ret



    
    
