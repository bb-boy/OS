
%include "boot.inc"     ; 包含引导程序使用的常量和宏定义
section loader vstart=LOADER_BASE_ADDR  ; 定义loader段，起始地址为LOADER_BASE_ADDR (0x900)
;LOADER_STACK_TOP equ LOADER_BASE_ADDR ;loader在实模式下的栈指针地址
jmp loader_start        ; 跳转到loader_start标签开始执行,这个jmp命令不可以删除，
;这个 jmp loader_start 是用来**跳过前面整块数据（GDT、缓冲区、栈等）**的——CPU 从 LOADER_BASE_ADDR 开始执行时，第一条必须是“可执行的指令”。如果你把它删掉，处理器会把 GDT_BASE 这些 dd/dq 数据当作指令去执行，直接跑飞/死机。


;-------------------------------------------------数据区---------------------------------------------------------------
GDT_BASE: dd 0x00000000     ; GDT起始地址的低32位，初始值为0
		dd 0x0000     ; GDT起始地址的高32位，初始值为0
CODE_DESC: dd  0x0000ffff   ; 代码段描述符的低32位，段界限为0xFFFF(64KB)
		dd DESC_CODE_HIGH4  ; 代码段描述符的高32位，通过宏DESC_CODE_HIGH4生成
DATA_STACK_DESC: dd 0x0000ffff  ; 数据/栈段描述符的低32位，段界限为0xFFFF(64KB)
			dd DESC_DATA_HIGH4  ; 数据/栈段描述符的高32位，通过宏DESC_DATA_HIGH4生成
VIDEO_DESC: dd 0x80000007   ; 视频段描述符的低32位，特殊处理的视频段描述符
		dd DESC_VIDEO_HIGH4  ; 视频段描述符的高32位，通过宏DESC_VIDEO_HIGH4生成

GDT_SIZE equ $ - GDT_BASE   ; 计算GDT的大小，$表示当前位置
GDT_LIMIT equ GDT_SIZE - 1  ; GDT界限，等于大小减1
times 60 dq 0               ; 预留60个双字(60*8=480字节)空间，用于GDT后续扩展



total_mem_bytes dd 0                ; 全局变量，用于保存检测到的总内存容量（单位：字节），在内存的0xb03位置
ards_buf times 244 db 0             ; 缓冲区，用于存储ARDS结构体信息，大小为244字节
ards_nr dw 0                        ; 全局变量，记录ARDS结构体的数量


STACK_SIZE      equ 512             ; 定义栈大小为 512 字节
loader_stack:                       ; 定义栈空间起始地址
    times STACK_SIZE db 0         ; 预留 512 字节的空间用于栈
stack_top:                          ; 定义一个标签表示栈顶位置


gdt_ptr: dw GDT_LIMIT              ; GDT限制值，低16位
		dd GDT_BASE              ; GDT基地址，高32位

SELECTOR_CODE equ (0x0001<<3) + TI_GDT + RPL0  ; 代码段选择子，索引1，GDT中，特权级0
SELECTOR_DATA  equ (0x0002<<3) + TI_GDT + RPL0 ; 数据段选择子，索引2，GDT中，特权级0
SELECTOR_VIDEO equ (0x0003<<3) + TI_GDT + RPL0 ; 视频段选择子，索引3，GDT中，特权级0
 




;------------------------------------------------------------------------------------------------------------------------------


loader_start:           ; loader开始执行的入口点
	mov sp, stack_top      ; 设置堆栈指针为栈顶地址
	


	xor ebx, ebx               ; 第一次调用，ebx必须为0（后续BIOS会返回新的ebx做链表迭代）
	mov edx, 0x534d4150        ; 'SMAP'标志，必须填，整个循环不变
	mov di, ards_buf           ; di指向内存缓冲区，用于存放ARDS结构

	.e820_mem_get_loop:        ; E820内存获取循环开始
	mov eax, 0x0000e820        ; eax: 子功能号，每次调用都要重置为0x0000e820
	mov ecx, 20                ; ARDS结构大小20字节，ecx填结构长度
	int 0x15                   ; BIOS中断，获取内存信息（E820方式）
	jc .e820_failed_so_try_e801 ; 若CF置位，出错，尝试下一个方法(e801)
	add di, cx                 ; di增加20，指向下一个ARDS写入位置
	inc word [ards_nr]         ; 已获取的ARDS数量加1
	cmp ebx, 0                 ; 如果ebx返回为0，表明ARDS已全部返回
	jnz .e820_mem_get_loop     ; 如果非0，则继续获取下一个ARDS




	mov cx, [ards_nr]          ; 用cx保存ARDS数量
	mov ebx, ards_buf          ; ebx指向ARDS缓冲区起始地址
	xor edx, edx               ; edx用于存最大内存容量，先清零

	.find_max_mem_area:        ; 查找最大内存区域的循环开始
	mov eax, [ebx]             ; eax = base_addr_low（内存块起始地址低32位）
	add eax, [ebx+8]           ; eax += length_low（内存块长度低32位，得末尾地址）
	add ebx, 20                ; 指向下一个ARDS结构体
	cmp edx, eax               ; edx存最大值，逐个比较
	jge .next_ards             ; 如果当前最大>=本块末尾，不更新
	mov edx, eax               ; 否则用本块末尾更新最大值
	.next_ards:                ; 处理下一个ARDS结构体
	loop .find_max_mem_area    ; 遍历所有ARDS结构体
	jmp .mem_get_ok            ; 跳到成功出口
	






	.e820_failed_so_try_e801:  ; 当E820方法失败时，尝试E801方法
	mov ax, 0xe801             ; 设置AX=0xe801，调用BIOS中断获取内存信息
	int 0x15                   ; BIOS中断调用
	jc .e801_failed_so_try88   ; 如果出错，降级到方法88

	; 1. 算低15MB容量 (ax,cx存的都是KB)
	mov cx, 0x400              ; 1024，准备计算低15MB的总字节数
	mul cx                     ; ax*cx, 得到低15MB的总字节数，结果存edx:eax
	shl edx, 16                ; edx左移16位，为组合高低16位
	and eax, 0x0000FFFF        ; 只保留低16位
	or edx, eax                ; 合成完整的32位容量
	add edx, 0x100000          ; 补上1MB，因e801通常返回15MB，不含1MB基础区
	mov esi, edx               ; esi备份低15MB容量

	; 2. 算16MB以上容量 (bx,dx存的都是64KB块数)
	xor eax, eax               ; 清空EAX寄存器
	mov ax, bx                 ; 将BX的值移动到AX
	mov ecx, 0x10000           ; 65536（即64KB），准备计算16MB以上内存容量
	mul ecx                    ; ax*ecx = bx*64KB = 16MB以上容量
	add esi, eax               ; 累加到esi（edx一般为0，因为最大只到4G）
	mov edx, esi               ; edx = 总内存字节数
	jmp .mem_get_ok            ; 跳转到成功出口





	.e801_failed_so_try88:     ; 当E801方法也失败时，尝试88方法
	mov ah, 0x88               ; 设置AH=0x88，调用BIOS中断获取内存信息
	int 0x15                   ; BIOS中断调用
	jc .error_hlt              ; 如果再失败，系统只能报错停机

	and eax, 0x0000FFFF        ; 只保留ax（单位：KB）

	mov cx, 0x400              ; 1024，用于转换KB到字节
	mul cx                     ; ax*1024 得到字节
	shl edx, 16                ; 左移16位，为组合高低16位
	or edx, eax                ; 组合成32位容量
	add edx, 0x100000          ; 补1MB



	.mem_get_ok:               ; 内存获取成功的出口点
	mov [total_mem_bytes], edx ; 总物理内存容量写入全局变量（单位：字节）
	jmp .prepare_to_protect_mode ; 跳转到准备进入保护模式的步骤
	
	.error_hlt:                ; 错误处理：系统停机
	jmp $                      ; 无限循环停机





	.prepare_to_protect_mode:  ; 准备进入保护模式的步骤
	in al,0x92                 ; 读取端口0x92的值到AL寄存器
	or al,0000_0010b           ; 设置AL的第1位为1，启用A20地址线
	out 0x92,al                ; 将修改后的AL值写回端口0x92

	lgdt [gdt_ptr]             ; 加载GDT指针到GDTR寄存器

	mov eax, cr0               ; 将CR0控制寄存器的值加载到EAX
	or eax,0x00000001         ; 设置CR0的第0位为1，开启保护模式标志
	mov cr0,eax                ; 将修改后的EAX值写回CR0寄存器

	jmp dword SELECTOR_CODE:p_mode  ; 使用长跳转切换到保护模式代码段



[bits 32]                  ; 切换到32位汇编模式

p_mode:                    ; 保护模式下的入口点
	mov ax,SELECTOR_DATA       ; 加载数据段选择子到AX寄存器
	mov ss,ax                  ; 设置堆栈段寄存器为数据段
	mov ds,ax                  ; 设置数据段寄存器为数据段
	mov es,ax                  ; 设置附加段寄存器为数据段
	mov esp,stack_top          ; 设置堆栈指针为栈顶地址
	mov ax,SELECTOR_VIDEO      ; 加载视频段选择子到AX寄存器
	mov gs,ax                  ; 设置图形段寄存器为视频段

	mov eax,KERNEL_START_SECTOR;
	mov ebx,KERNEL_BIN_BASE_ADDR;
	mov ecx,200;
	call rd_disk_m_32;
	; 验证内核是否正确加载到内存
	mov eax, [KERNEL_BIN_BASE_ADDR]    ; 读取ELF魔数
	cmp eax, 0x464C457F               ; 检查是否为ELF文件
	jne .kernel_error

	; s显示内核验证成功,x表示内核加载错误
	mov byte [gs:176], 'K'            ; Verified
	mov byte [gs:177], 0x0A
	jmp .kernel_verified

	.kernel_error:
    	mov byte [gs:176], 'X'        ; Error
    	mov byte [gs:177], 0x0C       ; 红色
    	jmp $                         ; 停机

	.kernel_verified:

;------------------------------------------开启页表-----------------------------
	call setup_page
	sgdt [gdt_ptr]
	mov ebx, [gdt_ptr + 2]
	or dword [ebx + 0x18 + 4], 0xc0000000
	add dword [gdt_ptr + 2], 0xc0000000
	add esp, 0xc0000000
	mov eax, PAGE_DIR_TABLE_POS
	mov cr3, eax
	mov eax, cr0
	or eax, 0x80000000
	mov cr0, eax
	lgdt [gdt_ptr]
	mov byte [gs:160], 'V'
	jmp SELECTOR_CODE:enter_kernel
enter_kernel:
	mov byte [gs:178], 'E'     ; Enter kernel
    mov byte [gs:179], 0x0C    
	
	call kernel_init	;初始化内核
	mov byte [gs:180], 'K'     ; Kernel init done
    mov byte [gs:181], 0x0A    ; 绿色

	mov esp, 0xc0000000 + 0x9f000	;设置内核栈
	mov byte [gs:182], 'J'     ; Jump to kernel
    mov byte [gs:183], 0x0E    ; 黄色

	jmp KERNEL_ENTRY_POINT	;;进入内核

	


	setup_page:
		mov ecx, 4096
		mov esi, 0
	.clear_page_dir:
		mov byte [PAGE_DIR_TABLE_POS + esi], 0
		inc esi
		loop .clear_page_dir

	.create_pde:
		mov eax, PAGE_DIR_TABLE_POS
		add eax, 0x1000
		mov ebx, eax
		or eax, PG_US_U | PG_RW_W | PG_P
		mov [PAGE_DIR_TABLE_POS + 0x0], eax
		mov [PAGE_DIR_TABLE_POS + 0xc00], eax
		sub eax, 0x1000
		mov [PAGE_DIR_TABLE_POS + 4092], eax

		mov ecx, 256
		mov esi, 0
		mov edx, PG_US_U | PG_RW_W | PG_P
	.create_pte:
		mov [ebx+esi*4], edx
		add edx,4096
		inc esi
		loop .create_pte

		mov eax, PAGE_DIR_TABLE_POS
		add eax, 0x2000
		or eax, PG_US_U | PG_RW_W | PG_P
		mov ebx, PAGE_DIR_TABLE_POS
		mov ecx, 254
		mov esi, 769
	.create_kernel_pde:
		mov [ebx+esi*4], eax
		inc esi
		add eax, 0x1000
		loop .create_kernel_pde
		ret


;----------------拷贝kernel.bin中的segment到编译的地址-------------------
kernel_init:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

	mov dx,[KERNEL_BIN_BASE_ADDR+42];读取程序头表中一个条目的大小
	mov ebx,[KERNEL_BIN_BASE_ADDR+28];读取程序头表相对与文件头的偏移
	add ebx,KERNEL_BIN_BASE_ADDR;获得程序头表的物理地址
	mov cx,[KERNEL_BIN_BASE_ADDR+44];读取程序头表中条目的数量

.each_segment:
		cmp byte [ebx+0],PT_NULL
		je .PTNULL
		

		push dword [ebx+16];把这个条目对应的段的大小压入栈（memcpy的第三个参数）
		mov eax,[ebx+4];读取这个段相对于文件的偏移量
		add eax,KERNEL_BIN_BASE_ADDR;获得这个段在内存中的地址
		push eax;把这个段的地址压入栈（memcpy的第二个参数）
		push dword [ebx+8];目的地址入栈（memcpy的第一个参数）
		call mem_cpy
		add esp,12;清理栈
.PTNULL:
		add ebx,edx;下一个程序头表条目
		loop .each_segment
		ret

;---------------------mem_cpy函数---------------------------

mem_cpy:
	cld 			  
	; cld (Clear Direction Flag)：这是清除方向标志位 DF 的指令。在x86架构中，字符串操作指令（比如后面要用的 movsb）的行为受 DF 标志位影响。
	;当 DF = 0 时（通过 cld 设置），内存地址会自动增加。
	;当 DF = 1 时（通过 std 设置），内存地址会自动减少。
	;在这里，我们希望从头到尾地复制内存，所以需要地址是递增的。cld 是确保这一点的关键步骤。
	push ebp  
	;保存调用者 (kernel_init) 的 ebp 值
	mov ebp, esp
	;设置当前函数的栈帧基址
	push ecx;外层循环用到的cx寄存器要保存
	mov edi, [ebp + 8] ; 目的地址
	mov esi, [ebp + 12]; 源地址
	mov ecx, [ebp + 16]; 拷贝字节数
	rep movsb;
	;movsb 就是从 esi 指向的地方复制1个字节到 edi 指向的地方，然后把 esi 和 edi 都向前移动一个位置，为复制下一个字节做准备。
	;rep 前缀会让 movsb 重复执行 ecx 次，也就是完成整个内存块的复制。
	;总结：rep movsb 的作用就是快速地
	
	;恢复环境
	pop ecx
	pop ebp
	ret


rd_disk_m_32:
	mov esi,eax  ;备份LBA扇区号
    mov edi,ecx   ;备份读入的扇区数


	;读写硬盘
	;第一步设置要读取的扇区数，往sector count寄存器中写入待读取的扇区数,sector count寄存器是8位寄存器
	;最大值是255，0表示256，主通道的0x1f2端口是sector count寄存器
    mov edx,0x1F2      ;端口号存入dx寄存器中
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
    out dx,al    ;eax右移8位，将高8位写入端口0x1f5中

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


	;数据已经准备好了，可以读取数据了
	; 第5步：从0x1f0端口读取数据
		mov eax,edi      ; 取出要读取的扇区数
		mov edx,128      ; 512字节/4字节=128次
		mul edx          ; 计算总的读取次数
		mov ecx,eax      ; ECX = 总读取次数
	
		mov edx,0x1f0    ; 数据端口
	.go_on_read:
		in eax,dx        ; 读取4字节
		mov [ebx],eax    ; 写入内存
		add ebx,4        ; 内存地址+4
		loop .go_on_read ; 循环直到读完
		ret		