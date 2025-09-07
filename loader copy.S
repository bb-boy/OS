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
 


loadermsg db 'i am loader in real.'  ; 定义字符串，用于显示在屏幕上

;------------------------------------------------------------------------------------------------------------------------------


loader_start:           ; loader开始执行的入口点
	mov sp, stack_top      ; 设置堆栈指针为栈顶地址
	mov cx, 20             ; 设置CX为20，用于显示字符串的长度
	mov bp, loadermsg      ; 将字符串地址加载到BP寄存器
	mov ax, 0x1301         ; 设置AH=0x13(文本模式)，AL=0x01(光标定位)
	mov bx, 0x001f         ; 设置BH=0(页面号)，BL=0x1f(白色文字，黑色背景)
	mov dx, 0x1800         ; 设置DH=0x18(行)，DL=0x0(列)
	int 0x10               ; 调用BIOS中断显示字符串


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

p_mode:                    		; 保护模式下的入口点
	mov ax,SELECTOR_DATA       ; 加载数据段选择子到AX寄存器
	mov ss,ax                  ; 设置堆栈段寄存器为数据段
	mov ds,ax                  ; 设置数据段寄存器为数据段
	mov es,ax                  ; 设置附加段寄存器为数据段
	mov esp,stack_top          ; 设置堆栈指针为栈顶地址
	mov ax,SELECTOR_VIDEO      ; 加载视频段选择子到AX寄存器
	mov gs,ax                  ; 设置图形段寄存器为视频段





;------------------------------------------开启页表-----------------------------
	call setup_page                           ; 构建页目录/页表（高半区映射、递归映射）
	sgdt [gdt_ptr]                            ; 保存当前 GDT 指针到内存（2B limit + 4B base）
	mov ebx, [gdt_ptr + 2]                    ; 取出 GDT 的基址到 EBX
	or dword [ebx + 0x18 + 4], 0xc0000000     ; 将选择子 0x18 的段基址 OR 上 3G（高半区）
	add dword [gdt_ptr + 2], 0xc0000000       ; 将 GDT 基址整体平移到高半区（供分页后 lgdt 使用）
	add esp, 0xc0000000                       ; 将当前栈指针切换到高半区映射
	mov eax, PAGE_DIR_TABLE_POS               ; 页目录物理地址
	mov cr3, eax                              ; 加载 CR3，设定页目录基址
	mov eax, cr0                              ; 读取 CR0 标志位
	or eax, 0x80000000                        ; 置位 PG(bit31)=1，开启分页
	mov cr0, eax                              ; 回写 CR0 生效
	lgdt [gdt_ptr]                            ; 使用高半区的 GDT 基址重载 GDT
	mov byte [gs:160], 'V'                    ; 在显存处写入字符，简单的分页后可见性测试
	jmp $                                     ; 暂停（可替换为跳转到内核 C 入口）

	setup_page:
		mov ecx, 4096                          ; 需要清零的字节数（页目录/页表区域 4KB）
		mov esi, 0                             ; 偏移计数器
	.clear_page_dir:
		mov byte [PAGE_DIR_TABLE_POS + esi], 0  ; 逐字节清零页目录所在内存
		inc esi                                ; 下一个字节
		loop .clear_page_dir                    ; ECX--，未到 0 则继续

	.create_pde:
		mov eax, PAGE_DIR_TABLE_POS             ; 页目录物理基址
		add eax, 0x1000                         ; 指向第 1 个页表物理基址
		mov ebx, eax                            ; EBX 暂存第 1 个页表地址（后续写 PTE）
		or eax, PG_US_U | PG_RW_W | PG_P        ; 带标志的页表地址（User/Write/Present）
		mov [PAGE_DIR_TABLE_POS + 0x0], eax     ; PDE[0]：低端恒等映射（0~4MB 由该页表覆盖的一部分）
		mov [PAGE_DIR_TABLE_POS + 0xc00], eax   ; PDE[768]：高半区 3G 起映射到同一页表
		sub eax, 0x1000                          ; 回到页目录物理基址 | flags
		mov [PAGE_DIR_TABLE_POS + 4092], eax    ; PDE[1023]：递归映射到页目录自身

		mov ecx, 256                            ; 填充第 1 个页表的前 256 项（按需覆盖物理内存）
		mov esi, 0                              ; PTE 索引
		mov edx, PG_US_U | PG_RW_W | PG_P       ; EDX 作为“当前物理页地址 | flags”，初始为 flags
	.create_pte:
		mov [ebx+esi*4], edx                    ; PTE[esi] ← 当前物理页地址 | flags
		add edx,4096                            ; 前进到下一个物理页
		inc esi                                 ; 下一个 PTE
		loop .create_pte                        ; 直到填满所需项

		mov eax, PAGE_DIR_TABLE_POS             ; 预备构造高半区剩余 PDE
		add eax, 0x2000                         ; EAX = 第 2 张页表的物理基址
		or eax, PG_US_U | PG_RW_W | PG_P        ; 加标志
		mov ebx, PAGE_DIR_TABLE_POS             ; EBX = 页目录基址
		mov ecx, 254                            ; 将 PDE[769..1022] 指向连续的页表（保留高半区地址空间）
		mov esi, 769                            ; 起始 PDE 索引 = 768+1
	.create_kernel_pde:
		mov [ebx+esi*4], eax                    ; PDE[esi] → 对应的页表（暂未填充 PTE，按需分配）
		inc esi
		add eax, 0x1000                         ; 下一张页表物理地址
		loop .create_kernel_pde
		ret                                     ; 返回，分页结构搭建完成















