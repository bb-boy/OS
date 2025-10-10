TI_GDT equ 0
RPL0 equ 0
SELECTOR_VIDEO equ 0x0003<<3 + TI_GDT + RPL0


[bits 32]

section .data
put_int_buffer dq 0 ;存放转换后的字符串,define quadword


section .text
;-----------------------------------put_str------------------------
global put_str
put_str:
    push ebx
    push ecx
    xor ecx,ecx
    mov ebx,[esp+8+4] ;取出栈中的字符串指针
.goon:
    mov cl,[ebx]      ;取出字符串的一个字符
    cmp cl,0          ;判断是否是字符串结束符
    jz .put_str_done  ;如果是结束符则跳转到结束
    push ecx          ;把字符压入栈中
    call put_char     ;调用put_char函数
    add esp,4        ;清理栈
    inc ebx          ;指向下一个字符
    jmp .goon        ;继续处理下一个字符
.put_str_done:
    pop ecx
    pop ebx
    ret

;--------------------------------------put_char-------------------------
;把栈中的一个字符写入光标所在处
global put_char
put_char:
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
    cmp bx,2000 ;判断光标位置是否超出范围
    jl .set_cursor


.is_line_feed:
.is_carriage_return:
    xor dx,dx
    mov ax,bx
    mov si,80

    div si          ;ax/si除以80，商在ax中，余数在dx中
    sub bx,dx
.is_carriage_return_end:
    add bx,80
    cmp bx,2000


.is_line_feed_end:
    jl .set_cursor


.roll_screen:
    cld
    mov ecx,960 ;
    mov esi,0xc00b80a0
    mov edi,0xc00b8000
    rep movsd   ;将屏幕内容向上移动一行
    mov ebx,3840    ;屏幕最后一行的起始位置
     ;清除最后一行
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

;-------------------------------------put_int-----------------------
global put_int
put_int:
    pushad
    mov ebp,esp
    mov eax,[ebp+32+4] ;取出栈中的整数
    mov edx,eax ;备份eax

    mov edi,7  ;字符索引，处理的第一个字符放在buffer的最后
    mov ecx,8   ;用于loop循环，一个32位数需要处理8次
    mov ebx,put_int_buffer  ;ebx存放buffer的地址

.16based_4bits:
    and edx,0x0f      ;取最低4位
    cmp dl,9     ;比较是否是0-9
    jg .is_A2F  ;如果大于9则是A-F，就跳转处理
    add dl,'0'  ;把数字转换成ascii码
    jmp .store;跳到保存字符的ascii到buffer部分
.is_A2F:
    add dl,'A'-10
.store: 
    mov [ebx+edi],dl    ;保存字符的ascii到buffer
    dec edi     ;字符索引-1
    shr eax,4         ;把整数右移4位
    mov edx,eax         ;处理下一个低四位
    loop .16based_4bits

.ready_to_print:
    inc edi ;索引从-1变为0
.skip_prefix_0:
    cmp edi,8   ;判断当前是否已经处理完所有8个字符
    je .full0   ;如果是8，则表示这个字符串都是0，处理成"0"
    
.go_on_skip:
    mov cl,[ebx+edi]    ;取出当前字符
    inc edi ;索引+1
    cmp cl,'0'  ;判断是否是'0'

    je .skip_prefix_0   ;如果是'0'，则跳回去继续寻找下一个
    dec edi         ;回到第一个非0字符处
    jmp .print_it 
.full0:
    mov cl,'0'

.print_it:
    push ecx ;待打印字符入栈
    call put_char
    add esp,4   ;清理栈
    inc edi ;打印下一个字符
    mov cl,[ebx+edi]    ;待打印字符入栈
    cmp edi,8   ;判断是否已经处理完所有8个字符
    jl .print_it ;如果没有处理完，则继续打印
    popad
    ret
