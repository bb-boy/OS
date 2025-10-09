;; ===== Protected mode =====
;; file offset: 0x5F7 - 0x807
;; addresses: 0xEF7 - 0x1106

loader.bin:     file format binary


Disassembly of section .data:

00000ef7 <.data+0x5f7>:
     ef7:	66 b8 10 00          	mov    $0x10,%ax
     efb:	8e d0                	mov    %eax,%ss
     efd:	8e d8                	mov    %eax,%ds
     eff:	8e c0                	mov    %eax,%es
     f01:	bc fd 0d 00 00       	mov    $0xdfd,%esp
     f06:	66 b8 18 00          	mov    $0x18,%ax
     f0a:	8e e8                	mov    %eax,%gs
     f0c:	b8 09 00 00 00       	mov    $0x9,%eax
     f11:	bb 00 00 07 00       	mov    $0x70000,%ebx
     f16:	b9 c8 00 00 00       	mov    $0xc8,%ecx
     f1b:	e8 91 01 00 00       	call   0x10b1
     f20:	a1 00 00 07 00       	mov    0x70000,%eax
     f25:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
     f2a:	75 12                	jne    0xf3e
     f2c:	65 c6 05 b0 00 00 00 	movb   $0x53,%gs:0xb0
     f33:	53 
     f34:	65 c6 05 b1 00 00 00 	movb   $0xa,%gs:0xb1
     f3b:	0a 
     f3c:	eb 12                	jmp    0xf50
     f3e:	65 c6 05 b0 00 00 00 	movb   $0x58,%gs:0xb0
     f45:	58 
     f46:	65 c6 05 b1 00 00 00 	movb   $0xc,%gs:0xb1
     f4d:	0c 
     f4e:	eb fe                	jmp    0xf4e
     f50:	e8 8c 00 00 00       	call   0xfe1
     f55:	0f 01 05 fd 0d 00 00 	sgdtl  0xdfd
     f5c:	8b 1d ff 0d 00 00    	mov    0xdff,%ebx
     f62:	81 4b 1c 00 00 00 c0 	orl    $0xc0000000,0x1c(%ebx)
     f69:	81 05 ff 0d 00 00 00 	addl   $0xc0000000,0xdff
     f70:	00 00 c0 
     f73:	81 c4 00 00 00 c0    	add    $0xc0000000,%esp
     f79:	b8 00 00 10 00       	mov    $0x100000,%eax
     f7e:	0f 22 d8             	mov    %eax,%cr3
     f81:	0f 20 c0             	mov    %cr0,%eax
     f84:	0d 00 00 00 80       	or     $0x80000000,%eax
     f89:	0f 22 c0             	mov    %eax,%cr0
     f8c:	0f 01 15 fd 0d 00 00 	lgdtl  0xdfd
     f93:	65 c6 05 a0 00 00 00 	movb   $0x56,%gs:0xa0
     f9a:	56 
     f9b:	ea a2 0f 00 00 08 00 	ljmp   $0x8,$0xfa2
     fa2:	65 c6 05 b2 00 00 00 	movb   $0x45,%gs:0xb2
     fa9:	45 
     faa:	65 c6 05 b3 00 00 00 	movb   $0xc,%gs:0xb3
     fb1:	0c 
     fb2:	e8 a4 00 00 00       	call   0x105b
     fb7:	65 c6 05 b4 00 00 00 	movb   $0x4b,%gs:0xb4
     fbe:	4b 
     fbf:	65 c6 05 b5 00 00 00 	movb   $0xa,%gs:0xb5
     fc6:	0a 
     fc7:	bc 00 f0 09 c0       	mov    $0xc009f000,%esp
     fcc:	65 c6 05 b6 00 00 00 	movb   $0x4a,%gs:0xb6
     fd3:	4a 
     fd4:	65 c6 05 b7 00 00 00 	movb   $0xe,%gs:0xb7
     fdb:	0e 
     fdc:	e9 1f 05 00 c0       	jmp    0xc0001500
     fe1:	b9 00 10 00 00       	mov    $0x1000,%ecx
     fe6:	be 00 00 00 00       	mov    $0x0,%esi
     feb:	c6 86 00 00 10 00 00 	movb   $0x0,0x100000(%esi)
     ff2:	46                   	inc    %esi
     ff3:	e2 f6                	loop   0xfeb
     ff5:	b8 00 00 10 00       	mov    $0x100000,%eax
     ffa:	05 00 10 00 00       	add    $0x1000,%eax
     fff:	89 c3                	mov    %eax,%ebx
    1001:	83 c8 07             	or     $0x7,%eax
    1004:	a3 00 00 10 00       	mov    %eax,0x100000
    1009:	a3 00 0c 10 00       	mov    %eax,0x100c00
    100e:	2d 00 10 00 00       	sub    $0x1000,%eax
    1013:	a3 fc 0f 10 00       	mov    %eax,0x100ffc
    1018:	b9 00 01 00 00       	mov    $0x100,%ecx
    101d:	be 00 00 00 00       	mov    $0x0,%esi
    1022:	ba 07 00 00 00       	mov    $0x7,%edx
    1027:	89 14 b3             	mov    %edx,(%ebx,%esi,4)
    102a:	81 c2 00 10 00 00    	add    $0x1000,%edx
    1030:	46                   	inc    %esi
    1031:	e2 f4                	loop   0x1027
    1033:	b8 00 00 10 00       	mov    $0x100000,%eax
    1038:	05 00 20 00 00       	add    $0x2000,%eax
    103d:	83 c8 07             	or     $0x7,%eax
    1040:	bb 00 00 10 00       	mov    $0x100000,%ebx
    1045:	b9 fe 00 00 00       	mov    $0xfe,%ecx
    104a:	be 01 03 00 00       	mov    $0x301,%esi
    104f:	89 04 b3             	mov    %eax,(%ebx,%esi,4)
    1052:	46                   	inc    %esi
    1053:	05 00 10 00 00       	add    $0x1000,%eax
    1058:	e2 f5                	loop   0x104f
    105a:	c3                   	ret    
    105b:	31 c0                	xor    %eax,%eax
    105d:	31 db                	xor    %ebx,%ebx
    105f:	31 c9                	xor    %ecx,%ecx
    1061:	31 d2                	xor    %edx,%edx
    1063:	66 8b 15 2a 00 07 00 	mov    0x7002a,%dx
    106a:	8b 1d 1c 00 07 00    	mov    0x7001c,%ebx
    1070:	81 c3 00 00 07 00    	add    $0x70000,%ebx
    1076:	66 8b 0d 2c 00 07 00 	mov    0x7002c,%cx
    107d:	80 3b 00             	cmpb   $0x0,(%ebx)
    1080:	74 17                	je     0x1099
    1082:	ff 73 10             	push   0x10(%ebx)
    1085:	8b 43 04             	mov    0x4(%ebx),%eax
    1088:	05 00 00 07 00       	add    $0x70000,%eax
    108d:	50                   	push   %eax
    108e:	ff 73 08             	push   0x8(%ebx)
    1091:	e8 08 00 00 00       	call   0x109e
    1096:	83 c4 0c             	add    $0xc,%esp
    1099:	01 d3                	add    %edx,%ebx
    109b:	e2 e0                	loop   0x107d
    109d:	c3                   	ret    
    109e:	fc                   	cld    
    109f:	55                   	push   %ebp
    10a0:	89 e5                	mov    %esp,%ebp
    10a2:	51                   	push   %ecx
    10a3:	8b 7d 08             	mov    0x8(%ebp),%edi
    10a6:	8b 75 0c             	mov    0xc(%ebp),%esi
    10a9:	8b 4d 10             	mov    0x10(%ebp),%ecx
    10ac:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
    10ae:	59                   	pop    %ecx
    10af:	5d                   	pop    %ebp
    10b0:	c3                   	ret    
    10b1:	89 c6                	mov    %eax,%esi  *保护模式下读盘断点*
    10b3:	89 cf                	mov    %ecx,%edi
    10b5:	ba f2 01 00 00       	mov    $0x1f2,%edx
    10ba:	88 c8                	mov    %cl,%al
    10bc:	ee                   	out    %al,(%dx)
    10bd:	89 f0                	mov    %esi,%eax
    10bf:	66 ba f3 01          	mov    $0x1f3,%dx
    10c3:	ee                   	out    %al,(%dx)
    10c4:	66 ba f4 01          	mov    $0x1f4,%dx
    10c8:	b1 08                	mov    $0x8,%cl
    10ca:	d3 e8                	shr    %cl,%eax
    10cc:	ee                   	out    %al,(%dx)
    10cd:	66 ba f5 01          	mov    $0x1f5,%dx
    10d1:	d3 e8                	shr    %cl,%eax
    10d3:	ee                   	out    %al,(%dx)
    10d4:	d3 e8                	shr    %cl,%eax
    10d6:	24 0f                	and    $0xf,%al
    10d8:	0c e0                	or     $0xe0,%al
    10da:	66 ba f6 01          	mov    $0x1f6,%dx
    10de:	ee                   	out    %al,(%dx)
    10df:	66 ba f7 01          	mov    $0x1f7,%dx
    10e3:	b0 20                	mov    $0x20,%al
    10e5:	ee                   	out    %al,(%dx)
    10e6:	90                   	nop                    从这里开始等待硬盘就绪       
    10e7:	ec                   	in     (%dx),%al
    10e8:	24 88                	and    $0x88,%al
    10ea:	3c 08                	cmp    $0x8,%al
    10ec:	75 f8                	jne    0x10e6
    10ee:	89 f8                	mov    %edi,%eax
    10f0:	ba 80 00 00 00       	mov    $0x80,%edx
    10f5:	f7 e2                	mul    %edx
    10f7:	89 c1                	mov    %eax,%ecx
    10f9:	ba f0 01 00 00       	mov    $0x1f0,%edx
    10fe:	ed                   	in     (%dx),%eax
    10ff:	89 03                	mov    %eax,(%ebx)
    1101:	83 c3 04             	add    $0x4,%ebx
    1104:	e2 f8                	loop   0x10fe

