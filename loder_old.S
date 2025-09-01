%include "boot.inc"
section loader vstart=LOADER_BASE_ADDR  ;起始地址按照之前约定一样
LOADER_STACK_TOP equ LOADER_BASE_ADDR ;loader在实模式下的栈指针地址
jmp loader_start


GDT_BASE: dd 0x00000000
		dd 0x00000000
CODE_DESC: dd  0x0000ffff
		dd DESC_CODE_HIGH4
DATA_STACK_DESC: dd 0x0000ffff
			dd DESC_DATA_HIGH4
VIDEO_DESC: dd 0x80000007
		dd DESC_VIDEO_HIGH4

GDT_SIZE equ $ - GDT_BASE
GDT_LIMIT equ GDT_SIZE - 1
times 60 dq 0

gdt_ptr: dw GDT_LIMIT
		dd GDT_BASE

SELECTOR_CODE equ (0x0001<<3) + TI_GDT + RPL0
SELECTOR_DATA  equ (0x0002<<3) + TI_GDT + RPL0
SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0
 


loadermsg db 'i am loader in real.'


loader_start:
	mov sp, LOADER_BASE_ADDR
	mov cx, 20
	mov bp, loadermsg
	mov ax, 0x1301
	mov bx, 0x001f
	mov dx, 0x1800
	int 0x10


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

	.error_hlt:
	jmp $






	in al,0x92
	or al,0000_0010b
	out 0x92,al

	lgdt [gdt_ptr]

	mov eax, cr0
	or eax,0x00000001
	mov cr0,eax

	jmp dword SELECTOR_CODE:p_mode



[bits 32]

p_mode:
	mov ax,SELECTOR_DATA
	mov ss,ax
	mov ds,ax
	mov es,ax
	mov esp,LOADER_STACK_TOP
	mov ax,SELECTOR_VIDEO
	mov gs,ax
	mov byte [gs:160],'p'	

	jmp $
