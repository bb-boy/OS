%line 1+1 kernel.S
[bits 32]
%line 4+1 kernel.S

[extern put_char]

[section .data]
intr_str db "interrupt occurred!!",0xa,0

[global intr_entry_table]
intr_entry_table:

%line 32+1 kernel.S

%line 14+1 kernel.S
[section .text]
intr0x00entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x00entry
%line 14+1 kernel.S
[section .text]
intr0x01entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x01entry
%line 14+1 kernel.S
[section .text]
intr0x02entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x02entry
%line 14+1 kernel.S
[section .text]
intr0x03entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x03entry
%line 14+1 kernel.S
[section .text]
intr0x04entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x04entry
%line 14+1 kernel.S
[section .text]
intr0x05entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x05entry
%line 14+1 kernel.S
[section .text]
intr0x06entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x06entry
%line 14+1 kernel.S
[section .text]
intr0x07entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x07entry
%line 14+1 kernel.S
[section .text]
intr0x08entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x08entry
%line 14+1 kernel.S
[section .text]
intr0x09entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x09entry
%line 14+1 kernel.S
[section .text]
intr0x0Aentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x0Aentry
%line 14+1 kernel.S
[section .text]
intr0x0Bentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x0Bentry
%line 14+1 kernel.S
[section .text]
intr0x0Centry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x0Centry
%line 14+1 kernel.S
[section .text]
intr0x0Dentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x0Dentry
%line 14+1 kernel.S
[section .text]
intr0x0Eentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x0Eentry
%line 14+1 kernel.S
[section .text]
intr0x0Fentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x0Fentry
%line 14+1 kernel.S
[section .text]
intr0x10entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x10entry
%line 14+1 kernel.S
[section .text]
intr0x11entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x11entry
%line 14+1 kernel.S
[section .text]
intr0x12entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x12entry
%line 14+1 kernel.S
[section .text]
intr0x13entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x13entry
%line 14+1 kernel.S
[section .text]
intr0x14entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x14entry
%line 14+1 kernel.S
[section .text]
intr0x15entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x15entry
%line 14+1 kernel.S
[section .text]
intr0x16entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x16entry
%line 14+1 kernel.S
[section .text]
intr0x17entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x17entry
%line 14+1 kernel.S
[section .text]
intr0x18entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x18entry
%line 14+1 kernel.S
[section .text]
intr0x19entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x19entry
%line 14+1 kernel.S
[section .text]
intr0x1Aentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x1Aentry
%line 14+1 kernel.S
[section .text]
intr0x1Bentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x1Bentry
%line 14+1 kernel.S
[section .text]
intr0x1Centry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x1Centry
%line 14+1 kernel.S
[section .text]
intr0x1Dentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x1Dentry
%line 14+1 kernel.S
[section .text]
intr0x1Eentry:

 nop
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x1Eentry
%line 14+1 kernel.S
[section .text]
intr0x1Fentry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x1Fentry
%line 14+1 kernel.S
[section .text]
intr0x20entry:

 push 0
 push intr_str
 call put_str
 add esp,4

 mov al,0x20
 out 0xa0,al
 out 0x20,al

 add esp,4
 iret

[section .data]
 dd intr0x20entry
