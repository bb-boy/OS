;; ===== Real mode (before data) =====
;; file offset: 0x0 - 0x3
;; addresses: 0x900 - 0x902

loader.bin:     file format binary


Disassembly of section .data:

00000900 <.data>:
     900:	e9 14              	jmp    0xe17

;; ===== Real mode (after data) =====
;; file offset: 0x517 - 0x5F7
;; addresses: 0xE17 - 0xEF6

loader.bin:     file format binary


Disassembly of section .data:

00000e17 <.data+0x517>:
     e17:	bc fd 0d             	mov    $0xdfd,%sp
     e1a:	b9 14 00             	mov    $0x14,%cx
     e1d:	bd 03 0e             	mov    $0xe03,%bp
     e20:	b8 01 13             	mov    $0x1301,%ax
     e23:	bb 1f 00             	mov    $0x1f,%bx
     e26:	ba 00 18             	mov    $0x1800,%dx
     e29:	cd 10                	int    $0x10n
     e2b:	66 31 db             	xor    %ebx,%ebx
     e2e:	66 ba 50 41 4d 53    	mov    $0x534d4150,%edx
     e34:	bf 07 0b             	mov    $0xb07,%di
     e37:	66 b8 20 e8 00 00    	mov    $0xe820,%eax
     e3d:	66 b9 14 00 00 00    	mov    $0x14,%ecx
     e43:	cd 15                	int    $0x15
     e45:	72 32                	jb     0xe79
     e47:	01 cf                	add    %cx,%di
     e49:	ff 06 fb 0b          	incw   0xbfb
     e4d:	66 83 fb 00          	cmp    $0x0,%ebx
     e51:	75 e4                	jne    0xe37
     e53:	8b 0e fb 0b          	mov    0xbfb,%cx
     e57:	66 bb 07 0b 00 00    	mov    $0xb07,%ebx
     e5d:	66 31 d2             	xor    %edx,%edx
     e60:	66 67 8b 03          	mov    (%ebx),%eax
     e64:	66 67 03 43 08       	add    0x8(%ebx),%eax
     e69:	66 83 c3 14          	add    $0x14,%ebx
     e6d:	66 39 c2             	cmp    %eax,%edx
     e70:	7d 03                	jge    0xe75
     e72:	66 89 c2             	mov    %eax,%edx
     e75:	e2 e9                	loop   0xe60
     e77:	eb 58                	jmp    0xed1
     e79:	b8 01 e8             	mov    $0xe801,%ax
     e7c:	cd 15                	int    $0x15
     e7e:	72 32                	jb     0xeb2
     e80:	b9 00 04             	mov    $0x400,%cx
     e83:	f7 e1                	mul    %cx
     e85:	66 c1 e2 10          	shl    $0x10,%edx
     e89:	66 25 ff ff 00 00    	and    $0xffff,%eax
     e8f:	66 09 c2             	or     %eax,%edx
     e92:	66 81 c2 00 00 10 00 	add    $0x100000,%edx
     e99:	66 89 d6             	mov    %edx,%esi
     e9c:	66 31 c0             	xor    %eax,%eax
     e9f:	89 d8                	mov    %bx,%ax
     ea1:	66 b9 00 00 01 00    	mov    $0x10000,%ecx
     ea7:	66 f7 e1             	mul    %ecx
     eaa:	66 01 c6             	add    %eax,%esi
     ead:	66 89 f2             	mov    %esi,%edx
     eb0:	eb 1f                	jmp    0xed1
     eb2:	b4 88                	mov    $0x88,%ah
     eb4:	cd 15                	int    $0x15
     eb6:	72 20                	jb     0xed8
     eb8:	66 25 ff ff 00 00    	and    $0xffff,%eax
     ebe:	b9 00 04             	mov    $0x400,%cx
     ec1:	f7 e1                	mul    %cx
     ec3:	66 c1 e2 10          	shl    $0x10,%edx
     ec7:	66 09 c2             	or     %eax,%edx
     eca:	66 81 c2 00 00 10 00 	add    $0x100000,%edx
     ed1:	66 89 16 03 0b       	mov    %edx,0xb03
     ed6:	eb 02                	jmp    0xeda
     ed8:	eb fe                	jmp    0xed8
     eda:	e4 92                	in     $0x92,%al
     edc:	0c 02                	or     $0x2,%al
     ede:	e6 92                	out    %al,$0x92
     ee0:	0f 01 16 fd 0d       	lgdtw  0xdfd
     ee5:	0f 20 c0             	mov    %cr0,%eax
     ee8:	66 83 c8 01          	or     $0x1,%eax
     eec:	0f 22 c0             	mov    %eax,%cr0
     eef:	66 ea f7 0e 00 00 08 	ljmpl  $0x8,$0xef7
     ef6:	 

