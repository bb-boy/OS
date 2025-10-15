
./build/kernel.bin:     file format elf32-i386


Disassembly of section .text:

c0002500 <main>:
c0002500:	8d 4c 24 04          	lea    ecx,[esp+0x4]
c0002504:	83 e4 f0             	and    esp,0xfffffff0
c0002507:	ff 71 fc             	push   DWORD PTR [ecx-0x4]
c000250a:	55                   	push   ebp
c000250b:	89 e5                	mov    ebp,esp
c000250d:	51                   	push   ecx
c000250e:	83 ec 04             	sub    esp,0x4
c0002511:	83 ec 0c             	sub    esp,0xc
c0002514:	68 88 2d 00 c0       	push   0xc0002d88
c0002519:	e8 02 02 00 00       	call   c0002720 <put_str>
c000251e:	83 c4 10             	add    esp,0x10
c0002521:	e8 13 00 00 00       	call   c0002539 <init_all>
c0002526:	83 ec 0c             	sub    esp,0xc
c0002529:	68 98 2d 00 c0       	push   0xc0002d98
c000252e:	e8 ed 01 00 00       	call   c0002720 <put_str>
c0002533:	83 c4 10             	add    esp,0x10
c0002536:	fb                   	sti    
c0002537:	eb fe                	jmp    c0002537 <main+0x37>

c0002539 <init_all>:
c0002539:	55                   	push   ebp
c000253a:	89 e5                	mov    ebp,esp
c000253c:	83 ec 08             	sub    esp,0x8
c000253f:	83 ec 0c             	sub    esp,0xc
c0002542:	68 c9 2d 00 c0       	push   0xc0002dc9
c0002547:	e8 d4 01 00 00       	call   c0002720 <put_str>
c000254c:	83 c4 10             	add    esp,0x10
c000254f:	e8 5e 01 00 00       	call   c00026b2 <idt_init>
c0002554:	90                   	nop
c0002555:	c9                   	leave  
c0002556:	c3                   	ret    

c0002557 <outb>:
c0002557:	55                   	push   ebp
c0002558:	89 e5                	mov    ebp,esp
c000255a:	83 ec 08             	sub    esp,0x8
c000255d:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
c0002560:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
c0002563:	66 89 45 fc          	mov    WORD PTR [ebp-0x4],ax
c0002567:	89 d0                	mov    eax,edx
c0002569:	88 45 f8             	mov    BYTE PTR [ebp-0x8],al
c000256c:	0f b6 45 f8          	movzx  eax,BYTE PTR [ebp-0x8]
c0002570:	0f b7 55 fc          	movzx  edx,WORD PTR [ebp-0x4]
c0002574:	ee                   	out    dx,al
c0002575:	90                   	nop
c0002576:	c9                   	leave  
c0002577:	c3                   	ret    

c0002578 <pic_init>:
c0002578:	55                   	push   ebp
c0002579:	89 e5                	mov    ebp,esp
c000257b:	83 ec 08             	sub    esp,0x8
c000257e:	6a 11                	push   0x11
c0002580:	6a 20                	push   0x20
c0002582:	e8 d0 ff ff ff       	call   c0002557 <outb>
c0002587:	83 c4 08             	add    esp,0x8
c000258a:	6a 20                	push   0x20
c000258c:	6a 21                	push   0x21
c000258e:	e8 c4 ff ff ff       	call   c0002557 <outb>
c0002593:	83 c4 08             	add    esp,0x8
c0002596:	6a 04                	push   0x4
c0002598:	6a 21                	push   0x21
c000259a:	e8 b8 ff ff ff       	call   c0002557 <outb>
c000259f:	83 c4 08             	add    esp,0x8
c00025a2:	6a 01                	push   0x1
c00025a4:	6a 21                	push   0x21
c00025a6:	e8 ac ff ff ff       	call   c0002557 <outb>
c00025ab:	83 c4 08             	add    esp,0x8
c00025ae:	6a 11                	push   0x11
c00025b0:	68 a0 00 00 00       	push   0xa0
c00025b5:	e8 9d ff ff ff       	call   c0002557 <outb>
c00025ba:	83 c4 08             	add    esp,0x8
c00025bd:	6a 28                	push   0x28
c00025bf:	68 a1 00 00 00       	push   0xa1
c00025c4:	e8 8e ff ff ff       	call   c0002557 <outb>
c00025c9:	83 c4 08             	add    esp,0x8
c00025cc:	6a 02                	push   0x2
c00025ce:	68 a1 00 00 00       	push   0xa1
c00025d3:	e8 7f ff ff ff       	call   c0002557 <outb>
c00025d8:	83 c4 08             	add    esp,0x8
c00025db:	6a 01                	push   0x1
c00025dd:	68 a1 00 00 00       	push   0xa1
c00025e2:	e8 70 ff ff ff       	call   c0002557 <outb>
c00025e7:	83 c4 08             	add    esp,0x8
c00025ea:	68 fe 00 00 00       	push   0xfe
c00025ef:	6a 21                	push   0x21
c00025f1:	e8 61 ff ff ff       	call   c0002557 <outb>
c00025f6:	83 c4 08             	add    esp,0x8
c00025f9:	68 ff 00 00 00       	push   0xff
c00025fe:	68 a1 00 00 00       	push   0xa1
c0002603:	e8 4f ff ff ff       	call   c0002557 <outb>
c0002608:	83 c4 08             	add    esp,0x8
c000260b:	83 ec 0c             	sub    esp,0xc
c000260e:	68 d3 2d 00 c0       	push   0xc0002dd3
c0002613:	e8 08 01 00 00       	call   c0002720 <put_str>
c0002618:	83 c4 10             	add    esp,0x10
c000261b:	90                   	nop
c000261c:	c9                   	leave  
c000261d:	c3                   	ret    

c000261e <make_idt_desc>:
c000261e:	55                   	push   ebp
c000261f:	89 e5                	mov    ebp,esp
c0002621:	83 ec 04             	sub    esp,0x4
c0002624:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
c0002627:	88 45 fc             	mov    BYTE PTR [ebp-0x4],al
c000262a:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
c000262d:	89 c2                	mov    edx,eax
c000262f:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
c0002632:	66 89 10             	mov    WORD PTR [eax],dx
c0002635:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
c0002638:	66 c7 40 02 08 00    	mov    WORD PTR [eax+0x2],0x8
c000263e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
c0002641:	c6 40 04 00          	mov    BYTE PTR [eax+0x4],0x0
c0002645:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
c0002648:	0f b6 55 fc          	movzx  edx,BYTE PTR [ebp-0x4]
c000264c:	88 50 05             	mov    BYTE PTR [eax+0x5],dl
c000264f:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
c0002652:	c1 e8 10             	shr    eax,0x10
c0002655:	89 c2                	mov    edx,eax
c0002657:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
c000265a:	66 89 50 06          	mov    WORD PTR [eax+0x6],dx
c000265e:	90                   	nop
c000265f:	c9                   	leave  
c0002660:	c3                   	ret    

c0002661 <idt_desc_init>:
c0002661:	55                   	push   ebp
c0002662:	89 e5                	mov    ebp,esp
c0002664:	83 ec 18             	sub    esp,0x18
c0002667:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [ebp-0xc],0x0
c000266e:	eb 29                	jmp    c0002699 <idt_desc_init+0x38>
c0002670:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
c0002673:	8b 04 85 42 2f 00 c0 	mov    eax,DWORD PTR [eax*4-0x3fffd0be]
c000267a:	8b 55 f4             	mov    edx,DWORD PTR [ebp-0xc]
c000267d:	c1 e2 03             	shl    edx,0x3
c0002680:	81 c2 e0 2f 00 c0    	add    edx,0xc0002fe0
c0002686:	50                   	push   eax
c0002687:	68 8e 00 00 00       	push   0x8e
c000268c:	52                   	push   edx
c000268d:	e8 8c ff ff ff       	call   c000261e <make_idt_desc>
c0002692:	83 c4 0c             	add    esp,0xc
c0002695:	83 45 f4 01          	add    DWORD PTR [ebp-0xc],0x1
c0002699:	83 7d f4 20          	cmp    DWORD PTR [ebp-0xc],0x20
c000269d:	7e d1                	jle    c0002670 <idt_desc_init+0xf>
c000269f:	83 ec 0c             	sub    esp,0xc
c00026a2:	68 e5 2d 00 c0       	push   0xc0002de5
c00026a7:	e8 74 00 00 00       	call   c0002720 <put_str>
c00026ac:	83 c4 10             	add    esp,0x10
c00026af:	90                   	nop
c00026b0:	c9                   	leave  
c00026b1:	c3                   	ret    

c00026b2 <idt_init>:
c00026b2:	55                   	push   ebp
c00026b3:	89 e5                	mov    ebp,esp
c00026b5:	57                   	push   edi
c00026b6:	56                   	push   esi
c00026b7:	83 ec 10             	sub    esp,0x10
c00026ba:	83 ec 0c             	sub    esp,0xc
c00026bd:	68 fc 2d 00 c0       	push   0xc0002dfc
c00026c2:	e8 59 00 00 00       	call   c0002720 <put_str>
c00026c7:	83 c4 10             	add    esp,0x10
c00026ca:	e8 92 ff ff ff       	call   c0002661 <idt_desc_init>
c00026cf:	e8 a4 fe ff ff       	call   c0002578 <pic_init>
c00026d4:	b8 e0 2f 00 c0       	mov    eax,0xc0002fe0
c00026d9:	ba 00 00 00 00       	mov    edx,0x0
c00026de:	0f a4 c2 10          	shld   edx,eax,0x10
c00026e2:	c1 e0 10             	shl    eax,0x10
c00026e5:	89 c1                	mov    ecx,eax
c00026e7:	81 c9 07 01 00 00    	or     ecx,0x107
c00026ed:	89 ce                	mov    esi,ecx
c00026ef:	89 d0                	mov    eax,edx
c00026f1:	80 cc 00             	or     ah,0x0
c00026f4:	89 c7                	mov    edi,eax
c00026f6:	89 75 f0             	mov    DWORD PTR [ebp-0x10],esi
c00026f9:	89 7d f4             	mov    DWORD PTR [ebp-0xc],edi
c00026fc:	0f 01 5d f0          	lidtd  [ebp-0x10]
c0002700:	83 ec 0c             	sub    esp,0xc
c0002703:	68 0c 2e 00 c0       	push   0xc0002e0c
c0002708:	e8 13 00 00 00       	call   c0002720 <put_str>
c000270d:	83 c4 10             	add    esp,0x10
c0002710:	90                   	nop
c0002711:	8d 65 f8             	lea    esp,[ebp-0x8]
c0002714:	5e                   	pop    esi
c0002715:	5f                   	pop    edi
c0002716:	5d                   	pop    ebp
c0002717:	c3                   	ret    
c0002718:	66 90                	xchg   ax,ax
c000271a:	66 90                	xchg   ax,ax
c000271c:	66 90                	xchg   ax,ax
c000271e:	66 90                	xchg   ax,ax

c0002720 <put_str>:
c0002720:	53                   	push   ebx
c0002721:	51                   	push   ecx
c0002722:	31 c9                	xor    ecx,ecx
c0002724:	8b 5c 24 0c          	mov    ebx,DWORD PTR [esp+0xc]

c0002728 <put_str.goon>:
c0002728:	8a 0b                	mov    cl,BYTE PTR [ebx]
c000272a:	80 f9 00             	cmp    cl,0x0
c000272d:	74 0c                	je     c000273b <put_str.put_str_done>
c000272f:	51                   	push   ecx
c0002730:	e8 09 00 00 00       	call   c000273e <put_char>
c0002735:	83 c4 04             	add    esp,0x4
c0002738:	43                   	inc    ebx
c0002739:	eb ed                	jmp    c0002728 <put_str.goon>

c000273b <put_str.put_str_done>:
c000273b:	59                   	pop    ecx
c000273c:	5b                   	pop    ebx
c000273d:	c3                   	ret    

c000273e <put_char>:
c000273e:	60                   	pusha  
c000273f:	66 b8 18 00          	mov    ax,0x18
c0002743:	8e e8                	mov    gs,eax
c0002745:	66 ba d4 03          	mov    dx,0x3d4
c0002749:	b0 0e                	mov    al,0xe
c000274b:	ee                   	out    dx,al
c000274c:	66 ba d5 03          	mov    dx,0x3d5
c0002750:	ec                   	in     al,dx
c0002751:	88 c4                	mov    ah,al
c0002753:	66 ba d4 03          	mov    dx,0x3d4
c0002757:	b0 0f                	mov    al,0xf
c0002759:	ee                   	out    dx,al
c000275a:	66 ba d5 03          	mov    dx,0x3d5
c000275e:	ec                   	in     al,dx
c000275f:	66 89 c3             	mov    bx,ax
c0002762:	8b 4c 24 24          	mov    ecx,DWORD PTR [esp+0x24]
c0002766:	80 f9 0d             	cmp    cl,0xd
c0002769:	74 37                	je     c00027a2 <put_char.is_carriage_return>
c000276b:	80 f9 0a             	cmp    cl,0xa
c000276e:	74 32                	je     c00027a2 <put_char.is_carriage_return>
c0002770:	80 f9 08             	cmp    cl,0x8
c0002773:	74 02                	je     c0002777 <put_char.is_backspace>
c0002775:	eb 11                	jmp    c0002788 <put_char.put_other>

c0002777 <put_char.is_backspace>:
c0002777:	66 4b                	dec    bx
c0002779:	66 d1 e3             	shl    bx,1
c000277c:	65 66 67 c7 07 20 07 	mov    WORD PTR gs:[bx],0x720
c0002783:	66 d1 eb             	shr    bx,1
c0002786:	eb 60                	jmp    c00027e8 <put_char.set_cursor>

c0002788 <put_char.put_other>:
c0002788:	66 d1 e3             	shl    bx,1
c000278b:	65 67 88 0f          	mov    BYTE PTR gs:[bx],cl
c000278f:	66 43                	inc    bx
c0002791:	65 67 c6 07 07       	mov    BYTE PTR gs:[bx],0x7
c0002796:	66 d1 eb             	shr    bx,1
c0002799:	66 43                	inc    bx
c000279b:	66 81 fb d0 07       	cmp    bx,0x7d0
c00027a0:	7c 46                	jl     c00027e8 <put_char.set_cursor>

c00027a2 <put_char.is_carriage_return>:
c00027a2:	66 31 d2             	xor    dx,dx
c00027a5:	66 89 d8             	mov    ax,bx
c00027a8:	66 be 50 00          	mov    si,0x50
c00027ac:	66 f7 f6             	div    si
c00027af:	66 29 d3             	sub    bx,dx

c00027b2 <put_char.is_carriage_return_end>:
c00027b2:	66 83 c3 50          	add    bx,0x50
c00027b6:	66 81 fb d0 07       	cmp    bx,0x7d0

c00027bb <put_char.is_line_feed_end>:
c00027bb:	7c 2b                	jl     c00027e8 <put_char.set_cursor>

c00027bd <put_char.roll_screen>:
c00027bd:	fc                   	cld    
c00027be:	b9 c0 03 00 00       	mov    ecx,0x3c0
c00027c3:	be a0 80 0b c0       	mov    esi,0xc00b80a0
c00027c8:	bf 00 80 0b c0       	mov    edi,0xc00b8000
c00027cd:	f3 a5                	rep movs DWORD PTR es:[edi],DWORD PTR ds:[esi]
c00027cf:	bb 00 0f 00 00       	mov    ebx,0xf00
c00027d4:	b9 50 00 00 00       	mov    ecx,0x50

c00027d9 <put_char.cls>:
c00027d9:	65 66 c7 03 20 07    	mov    WORD PTR gs:[ebx],0x720
c00027df:	83 c3 02             	add    ebx,0x2
c00027e2:	e2 f5                	loop   c00027d9 <put_char.cls>
c00027e4:	66 bb 80 07          	mov    bx,0x780

c00027e8 <put_char.set_cursor>:
c00027e8:	66 ba d4 03          	mov    dx,0x3d4
c00027ec:	b0 0e                	mov    al,0xe
c00027ee:	ee                   	out    dx,al
c00027ef:	66 ba d5 03          	mov    dx,0x3d5
c00027f3:	88 f8                	mov    al,bh
c00027f5:	ee                   	out    dx,al
c00027f6:	66 ba d4 03          	mov    dx,0x3d4
c00027fa:	b0 0f                	mov    al,0xf
c00027fc:	ee                   	out    dx,al
c00027fd:	66 ba d5 03          	mov    dx,0x3d5
c0002801:	88 d8                	mov    al,bl
c0002803:	ee                   	out    dx,al

c0002804 <put_char.put_char_done>:
c0002804:	61                   	popa   
c0002805:	c3                   	ret    

c0002806 <put_int>:
c0002806:	60                   	pusha  
c0002807:	89 e5                	mov    ebp,esp
c0002809:	8b 45 24             	mov    eax,DWORD PTR [ebp+0x24]
c000280c:	89 c2                	mov    edx,eax
c000280e:	bf 07 00 00 00       	mov    edi,0x7
c0002813:	b9 08 00 00 00       	mov    ecx,0x8
c0002818:	bb 20 2f 00 c0       	mov    ebx,0xc0002f20

c000281d <put_int.16based_4bits>:
c000281d:	83 e2 0f             	and    edx,0xf
c0002820:	80 fa 09             	cmp    dl,0x9
c0002823:	7f 05                	jg     c000282a <put_int.is_A2F>
c0002825:	80 c2 30             	add    dl,0x30
c0002828:	eb 03                	jmp    c000282d <put_int.store>

c000282a <put_int.is_A2F>:
c000282a:	80 c2 37             	add    dl,0x37

c000282d <put_int.store>:
c000282d:	88 14 3b             	mov    BYTE PTR [ebx+edi*1],dl
c0002830:	4f                   	dec    edi
c0002831:	c1 e8 04             	shr    eax,0x4
c0002834:	89 c2                	mov    edx,eax
c0002836:	e2 e5                	loop   c000281d <put_int.16based_4bits>

c0002838 <put_int.ready_to_print>:
c0002838:	47                   	inc    edi

c0002839 <put_int.skip_prefix_0>:
c0002839:	83 ff 08             	cmp    edi,0x8
c000283c:	74 0c                	je     c000284a <put_int.full0>

c000283e <put_int.go_on_skip>:
c000283e:	8a 0c 3b             	mov    cl,BYTE PTR [ebx+edi*1]
c0002841:	47                   	inc    edi
c0002842:	80 f9 30             	cmp    cl,0x30
c0002845:	74 f2                	je     c0002839 <put_int.skip_prefix_0>
c0002847:	4f                   	dec    edi
c0002848:	eb 02                	jmp    c000284c <put_int.print_it>

c000284a <put_int.full0>:
c000284a:	b1 30                	mov    cl,0x30

c000284c <put_int.print_it>:
c000284c:	51                   	push   ecx
c000284d:	e8 ec fe ff ff       	call   c000273e <put_char>
c0002852:	83 c4 04             	add    esp,0x4
c0002855:	47                   	inc    edi
c0002856:	8a 0c 3b             	mov    cl,BYTE PTR [ebx+edi*1]
c0002859:	83 ff 08             	cmp    edi,0x8
c000285c:	7c ee                	jl     c000284c <put_int.print_it>
c000285e:	61                   	popa   
c000285f:	c3                   	ret    

c0002860 <intr0x00entry>:
c0002860:	6a 00                	push   0x0
c0002862:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002868:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c000286f:	75 0d                	jne    c000287e <intr0x00entry.skip_print>
c0002871:	68 28 2f 00 c0       	push   0xc0002f28
c0002876:	e8 a5 fe ff ff       	call   c0002720 <put_str>
c000287b:	83 c4 04             	add    esp,0x4

c000287e <intr0x00entry.skip_print>:
c000287e:	b0 20                	mov    al,0x20
c0002880:	e6 a0                	out    0xa0,al
c0002882:	e6 20                	out    0x20,al
c0002884:	83 c4 04             	add    esp,0x4
c0002887:	cf                   	iret   

c0002888 <intr0x01entry>:
c0002888:	6a 00                	push   0x0
c000288a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002890:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002897:	75 0d                	jne    c00028a6 <intr0x01entry.skip_print>
c0002899:	68 28 2f 00 c0       	push   0xc0002f28
c000289e:	e8 7d fe ff ff       	call   c0002720 <put_str>
c00028a3:	83 c4 04             	add    esp,0x4

c00028a6 <intr0x01entry.skip_print>:
c00028a6:	b0 20                	mov    al,0x20
c00028a8:	e6 a0                	out    0xa0,al
c00028aa:	e6 20                	out    0x20,al
c00028ac:	83 c4 04             	add    esp,0x4
c00028af:	cf                   	iret   

c00028b0 <intr0x02entry>:
c00028b0:	6a 00                	push   0x0
c00028b2:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c00028b8:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c00028bf:	75 0d                	jne    c00028ce <intr0x02entry.skip_print>
c00028c1:	68 28 2f 00 c0       	push   0xc0002f28
c00028c6:	e8 55 fe ff ff       	call   c0002720 <put_str>
c00028cb:	83 c4 04             	add    esp,0x4

c00028ce <intr0x02entry.skip_print>:
c00028ce:	b0 20                	mov    al,0x20
c00028d0:	e6 a0                	out    0xa0,al
c00028d2:	e6 20                	out    0x20,al
c00028d4:	83 c4 04             	add    esp,0x4
c00028d7:	cf                   	iret   

c00028d8 <intr0x03entry>:
c00028d8:	6a 00                	push   0x0
c00028da:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c00028e0:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c00028e7:	75 0d                	jne    c00028f6 <intr0x03entry.skip_print>
c00028e9:	68 28 2f 00 c0       	push   0xc0002f28
c00028ee:	e8 2d fe ff ff       	call   c0002720 <put_str>
c00028f3:	83 c4 04             	add    esp,0x4

c00028f6 <intr0x03entry.skip_print>:
c00028f6:	b0 20                	mov    al,0x20
c00028f8:	e6 a0                	out    0xa0,al
c00028fa:	e6 20                	out    0x20,al
c00028fc:	83 c4 04             	add    esp,0x4
c00028ff:	cf                   	iret   

c0002900 <intr0x04entry>:
c0002900:	6a 00                	push   0x0
c0002902:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002908:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c000290f:	75 0d                	jne    c000291e <intr0x04entry.skip_print>
c0002911:	68 28 2f 00 c0       	push   0xc0002f28
c0002916:	e8 05 fe ff ff       	call   c0002720 <put_str>
c000291b:	83 c4 04             	add    esp,0x4

c000291e <intr0x04entry.skip_print>:
c000291e:	b0 20                	mov    al,0x20
c0002920:	e6 a0                	out    0xa0,al
c0002922:	e6 20                	out    0x20,al
c0002924:	83 c4 04             	add    esp,0x4
c0002927:	cf                   	iret   

c0002928 <intr0x05entry>:
c0002928:	6a 00                	push   0x0
c000292a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002930:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002937:	75 0d                	jne    c0002946 <intr0x05entry.skip_print>
c0002939:	68 28 2f 00 c0       	push   0xc0002f28
c000293e:	e8 dd fd ff ff       	call   c0002720 <put_str>
c0002943:	83 c4 04             	add    esp,0x4

c0002946 <intr0x05entry.skip_print>:
c0002946:	b0 20                	mov    al,0x20
c0002948:	e6 a0                	out    0xa0,al
c000294a:	e6 20                	out    0x20,al
c000294c:	83 c4 04             	add    esp,0x4
c000294f:	cf                   	iret   

c0002950 <intr0x06entry>:
c0002950:	6a 00                	push   0x0
c0002952:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002958:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c000295f:	75 0d                	jne    c000296e <intr0x06entry.skip_print>
c0002961:	68 28 2f 00 c0       	push   0xc0002f28
c0002966:	e8 b5 fd ff ff       	call   c0002720 <put_str>
c000296b:	83 c4 04             	add    esp,0x4

c000296e <intr0x06entry.skip_print>:
c000296e:	b0 20                	mov    al,0x20
c0002970:	e6 a0                	out    0xa0,al
c0002972:	e6 20                	out    0x20,al
c0002974:	83 c4 04             	add    esp,0x4
c0002977:	cf                   	iret   

c0002978 <intr0x07entry>:
c0002978:	6a 00                	push   0x0
c000297a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002980:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002987:	75 0d                	jne    c0002996 <intr0x07entry.skip_print>
c0002989:	68 28 2f 00 c0       	push   0xc0002f28
c000298e:	e8 8d fd ff ff       	call   c0002720 <put_str>
c0002993:	83 c4 04             	add    esp,0x4

c0002996 <intr0x07entry.skip_print>:
c0002996:	b0 20                	mov    al,0x20
c0002998:	e6 a0                	out    0xa0,al
c000299a:	e6 20                	out    0x20,al
c000299c:	83 c4 04             	add    esp,0x4
c000299f:	cf                   	iret   

c00029a0 <intr0x08entry>:
c00029a0:	6a 00                	push   0x0
c00029a2:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c00029a8:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c00029af:	75 0d                	jne    c00029be <intr0x08entry.skip_print>
c00029b1:	68 28 2f 00 c0       	push   0xc0002f28
c00029b6:	e8 65 fd ff ff       	call   c0002720 <put_str>
c00029bb:	83 c4 04             	add    esp,0x4

c00029be <intr0x08entry.skip_print>:
c00029be:	b0 20                	mov    al,0x20
c00029c0:	e6 a0                	out    0xa0,al
c00029c2:	e6 20                	out    0x20,al
c00029c4:	83 c4 04             	add    esp,0x4
c00029c7:	cf                   	iret   

c00029c8 <intr0x09entry>:
c00029c8:	6a 00                	push   0x0
c00029ca:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c00029d0:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c00029d7:	75 0d                	jne    c00029e6 <intr0x09entry.skip_print>
c00029d9:	68 28 2f 00 c0       	push   0xc0002f28
c00029de:	e8 3d fd ff ff       	call   c0002720 <put_str>
c00029e3:	83 c4 04             	add    esp,0x4

c00029e6 <intr0x09entry.skip_print>:
c00029e6:	b0 20                	mov    al,0x20
c00029e8:	e6 a0                	out    0xa0,al
c00029ea:	e6 20                	out    0x20,al
c00029ec:	83 c4 04             	add    esp,0x4
c00029ef:	cf                   	iret   

c00029f0 <intr0x0Aentry>:
c00029f0:	6a 00                	push   0x0
c00029f2:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c00029f8:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c00029ff:	75 0d                	jne    c0002a0e <intr0x0Aentry.skip_print>
c0002a01:	68 28 2f 00 c0       	push   0xc0002f28
c0002a06:	e8 15 fd ff ff       	call   c0002720 <put_str>
c0002a0b:	83 c4 04             	add    esp,0x4

c0002a0e <intr0x0Aentry.skip_print>:
c0002a0e:	b0 20                	mov    al,0x20
c0002a10:	e6 a0                	out    0xa0,al
c0002a12:	e6 20                	out    0x20,al
c0002a14:	83 c4 04             	add    esp,0x4
c0002a17:	cf                   	iret   

c0002a18 <intr0x0Bentry>:
c0002a18:	6a 00                	push   0x0
c0002a1a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002a20:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002a27:	75 0d                	jne    c0002a36 <intr0x0Bentry.skip_print>
c0002a29:	68 28 2f 00 c0       	push   0xc0002f28
c0002a2e:	e8 ed fc ff ff       	call   c0002720 <put_str>
c0002a33:	83 c4 04             	add    esp,0x4

c0002a36 <intr0x0Bentry.skip_print>:
c0002a36:	b0 20                	mov    al,0x20
c0002a38:	e6 a0                	out    0xa0,al
c0002a3a:	e6 20                	out    0x20,al
c0002a3c:	83 c4 04             	add    esp,0x4
c0002a3f:	cf                   	iret   

c0002a40 <intr0x0Centry>:
c0002a40:	6a 00                	push   0x0
c0002a42:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002a48:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002a4f:	75 0d                	jne    c0002a5e <intr0x0Centry.skip_print>
c0002a51:	68 28 2f 00 c0       	push   0xc0002f28
c0002a56:	e8 c5 fc ff ff       	call   c0002720 <put_str>
c0002a5b:	83 c4 04             	add    esp,0x4

c0002a5e <intr0x0Centry.skip_print>:
c0002a5e:	b0 20                	mov    al,0x20
c0002a60:	e6 a0                	out    0xa0,al
c0002a62:	e6 20                	out    0x20,al
c0002a64:	83 c4 04             	add    esp,0x4
c0002a67:	cf                   	iret   

c0002a68 <intr0x0Dentry>:
c0002a68:	6a 00                	push   0x0
c0002a6a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002a70:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002a77:	75 0d                	jne    c0002a86 <intr0x0Dentry.skip_print>
c0002a79:	68 28 2f 00 c0       	push   0xc0002f28
c0002a7e:	e8 9d fc ff ff       	call   c0002720 <put_str>
c0002a83:	83 c4 04             	add    esp,0x4

c0002a86 <intr0x0Dentry.skip_print>:
c0002a86:	b0 20                	mov    al,0x20
c0002a88:	e6 a0                	out    0xa0,al
c0002a8a:	e6 20                	out    0x20,al
c0002a8c:	83 c4 04             	add    esp,0x4
c0002a8f:	cf                   	iret   

c0002a90 <intr0x0Eentry>:
c0002a90:	6a 00                	push   0x0
c0002a92:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002a98:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002a9f:	75 0d                	jne    c0002aae <intr0x0Eentry.skip_print>
c0002aa1:	68 28 2f 00 c0       	push   0xc0002f28
c0002aa6:	e8 75 fc ff ff       	call   c0002720 <put_str>
c0002aab:	83 c4 04             	add    esp,0x4

c0002aae <intr0x0Eentry.skip_print>:
c0002aae:	b0 20                	mov    al,0x20
c0002ab0:	e6 a0                	out    0xa0,al
c0002ab2:	e6 20                	out    0x20,al
c0002ab4:	83 c4 04             	add    esp,0x4
c0002ab7:	cf                   	iret   

c0002ab8 <intr0x0Fentry>:
c0002ab8:	6a 00                	push   0x0
c0002aba:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002ac0:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002ac7:	75 0d                	jne    c0002ad6 <intr0x0Fentry.skip_print>
c0002ac9:	68 28 2f 00 c0       	push   0xc0002f28
c0002ace:	e8 4d fc ff ff       	call   c0002720 <put_str>
c0002ad3:	83 c4 04             	add    esp,0x4

c0002ad6 <intr0x0Fentry.skip_print>:
c0002ad6:	b0 20                	mov    al,0x20
c0002ad8:	e6 a0                	out    0xa0,al
c0002ada:	e6 20                	out    0x20,al
c0002adc:	83 c4 04             	add    esp,0x4
c0002adf:	cf                   	iret   

c0002ae0 <intr0x10entry>:
c0002ae0:	6a 00                	push   0x0
c0002ae2:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002ae8:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002aef:	75 0d                	jne    c0002afe <intr0x10entry.skip_print>
c0002af1:	68 28 2f 00 c0       	push   0xc0002f28
c0002af6:	e8 25 fc ff ff       	call   c0002720 <put_str>
c0002afb:	83 c4 04             	add    esp,0x4

c0002afe <intr0x10entry.skip_print>:
c0002afe:	b0 20                	mov    al,0x20
c0002b00:	e6 a0                	out    0xa0,al
c0002b02:	e6 20                	out    0x20,al
c0002b04:	83 c4 04             	add    esp,0x4
c0002b07:	cf                   	iret   

c0002b08 <intr0x11entry>:
c0002b08:	6a 00                	push   0x0
c0002b0a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002b10:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002b17:	75 0d                	jne    c0002b26 <intr0x11entry.skip_print>
c0002b19:	68 28 2f 00 c0       	push   0xc0002f28
c0002b1e:	e8 fd fb ff ff       	call   c0002720 <put_str>
c0002b23:	83 c4 04             	add    esp,0x4

c0002b26 <intr0x11entry.skip_print>:
c0002b26:	b0 20                	mov    al,0x20
c0002b28:	e6 a0                	out    0xa0,al
c0002b2a:	e6 20                	out    0x20,al
c0002b2c:	83 c4 04             	add    esp,0x4
c0002b2f:	cf                   	iret   

c0002b30 <intr0x12entry>:
c0002b30:	6a 00                	push   0x0
c0002b32:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002b38:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002b3f:	75 0d                	jne    c0002b4e <intr0x12entry.skip_print>
c0002b41:	68 28 2f 00 c0       	push   0xc0002f28
c0002b46:	e8 d5 fb ff ff       	call   c0002720 <put_str>
c0002b4b:	83 c4 04             	add    esp,0x4

c0002b4e <intr0x12entry.skip_print>:
c0002b4e:	b0 20                	mov    al,0x20
c0002b50:	e6 a0                	out    0xa0,al
c0002b52:	e6 20                	out    0x20,al
c0002b54:	83 c4 04             	add    esp,0x4
c0002b57:	cf                   	iret   

c0002b58 <intr0x13entry>:
c0002b58:	6a 00                	push   0x0
c0002b5a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002b60:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002b67:	75 0d                	jne    c0002b76 <intr0x13entry.skip_print>
c0002b69:	68 28 2f 00 c0       	push   0xc0002f28
c0002b6e:	e8 ad fb ff ff       	call   c0002720 <put_str>
c0002b73:	83 c4 04             	add    esp,0x4

c0002b76 <intr0x13entry.skip_print>:
c0002b76:	b0 20                	mov    al,0x20
c0002b78:	e6 a0                	out    0xa0,al
c0002b7a:	e6 20                	out    0x20,al
c0002b7c:	83 c4 04             	add    esp,0x4
c0002b7f:	cf                   	iret   

c0002b80 <intr0x14entry>:
c0002b80:	6a 00                	push   0x0
c0002b82:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002b88:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002b8f:	75 0d                	jne    c0002b9e <intr0x14entry.skip_print>
c0002b91:	68 28 2f 00 c0       	push   0xc0002f28
c0002b96:	e8 85 fb ff ff       	call   c0002720 <put_str>
c0002b9b:	83 c4 04             	add    esp,0x4

c0002b9e <intr0x14entry.skip_print>:
c0002b9e:	b0 20                	mov    al,0x20
c0002ba0:	e6 a0                	out    0xa0,al
c0002ba2:	e6 20                	out    0x20,al
c0002ba4:	83 c4 04             	add    esp,0x4
c0002ba7:	cf                   	iret   

c0002ba8 <intr0x15entry>:
c0002ba8:	6a 00                	push   0x0
c0002baa:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002bb0:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002bb7:	75 0d                	jne    c0002bc6 <intr0x15entry.skip_print>
c0002bb9:	68 28 2f 00 c0       	push   0xc0002f28
c0002bbe:	e8 5d fb ff ff       	call   c0002720 <put_str>
c0002bc3:	83 c4 04             	add    esp,0x4

c0002bc6 <intr0x15entry.skip_print>:
c0002bc6:	b0 20                	mov    al,0x20
c0002bc8:	e6 a0                	out    0xa0,al
c0002bca:	e6 20                	out    0x20,al
c0002bcc:	83 c4 04             	add    esp,0x4
c0002bcf:	cf                   	iret   

c0002bd0 <intr0x16entry>:
c0002bd0:	6a 00                	push   0x0
c0002bd2:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002bd8:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002bdf:	75 0d                	jne    c0002bee <intr0x16entry.skip_print>
c0002be1:	68 28 2f 00 c0       	push   0xc0002f28
c0002be6:	e8 35 fb ff ff       	call   c0002720 <put_str>
c0002beb:	83 c4 04             	add    esp,0x4

c0002bee <intr0x16entry.skip_print>:
c0002bee:	b0 20                	mov    al,0x20
c0002bf0:	e6 a0                	out    0xa0,al
c0002bf2:	e6 20                	out    0x20,al
c0002bf4:	83 c4 04             	add    esp,0x4
c0002bf7:	cf                   	iret   

c0002bf8 <intr0x17entry>:
c0002bf8:	6a 00                	push   0x0
c0002bfa:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002c00:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002c07:	75 0d                	jne    c0002c16 <intr0x17entry.skip_print>
c0002c09:	68 28 2f 00 c0       	push   0xc0002f28
c0002c0e:	e8 0d fb ff ff       	call   c0002720 <put_str>
c0002c13:	83 c4 04             	add    esp,0x4

c0002c16 <intr0x17entry.skip_print>:
c0002c16:	b0 20                	mov    al,0x20
c0002c18:	e6 a0                	out    0xa0,al
c0002c1a:	e6 20                	out    0x20,al
c0002c1c:	83 c4 04             	add    esp,0x4
c0002c1f:	cf                   	iret   

c0002c20 <intr0x18entry>:
c0002c20:	6a 00                	push   0x0
c0002c22:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002c28:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002c2f:	75 0d                	jne    c0002c3e <intr0x18entry.skip_print>
c0002c31:	68 28 2f 00 c0       	push   0xc0002f28
c0002c36:	e8 e5 fa ff ff       	call   c0002720 <put_str>
c0002c3b:	83 c4 04             	add    esp,0x4

c0002c3e <intr0x18entry.skip_print>:
c0002c3e:	b0 20                	mov    al,0x20
c0002c40:	e6 a0                	out    0xa0,al
c0002c42:	e6 20                	out    0x20,al
c0002c44:	83 c4 04             	add    esp,0x4
c0002c47:	cf                   	iret   

c0002c48 <intr0x19entry>:
c0002c48:	6a 00                	push   0x0
c0002c4a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002c50:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002c57:	75 0d                	jne    c0002c66 <intr0x19entry.skip_print>
c0002c59:	68 28 2f 00 c0       	push   0xc0002f28
c0002c5e:	e8 bd fa ff ff       	call   c0002720 <put_str>
c0002c63:	83 c4 04             	add    esp,0x4

c0002c66 <intr0x19entry.skip_print>:
c0002c66:	b0 20                	mov    al,0x20
c0002c68:	e6 a0                	out    0xa0,al
c0002c6a:	e6 20                	out    0x20,al
c0002c6c:	83 c4 04             	add    esp,0x4
c0002c6f:	cf                   	iret   

c0002c70 <intr0x1Aentry>:
c0002c70:	6a 00                	push   0x0
c0002c72:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002c78:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002c7f:	75 0d                	jne    c0002c8e <intr0x1Aentry.skip_print>
c0002c81:	68 28 2f 00 c0       	push   0xc0002f28
c0002c86:	e8 95 fa ff ff       	call   c0002720 <put_str>
c0002c8b:	83 c4 04             	add    esp,0x4

c0002c8e <intr0x1Aentry.skip_print>:
c0002c8e:	b0 20                	mov    al,0x20
c0002c90:	e6 a0                	out    0xa0,al
c0002c92:	e6 20                	out    0x20,al
c0002c94:	83 c4 04             	add    esp,0x4
c0002c97:	cf                   	iret   

c0002c98 <intr0x1Bentry>:
c0002c98:	6a 00                	push   0x0
c0002c9a:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002ca0:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002ca7:	75 0d                	jne    c0002cb6 <intr0x1Bentry.skip_print>
c0002ca9:	68 28 2f 00 c0       	push   0xc0002f28
c0002cae:	e8 6d fa ff ff       	call   c0002720 <put_str>
c0002cb3:	83 c4 04             	add    esp,0x4

c0002cb6 <intr0x1Bentry.skip_print>:
c0002cb6:	b0 20                	mov    al,0x20
c0002cb8:	e6 a0                	out    0xa0,al
c0002cba:	e6 20                	out    0x20,al
c0002cbc:	83 c4 04             	add    esp,0x4
c0002cbf:	cf                   	iret   

c0002cc0 <intr0x1Centry>:
c0002cc0:	6a 00                	push   0x0
c0002cc2:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002cc8:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002ccf:	75 0d                	jne    c0002cde <intr0x1Centry.skip_print>
c0002cd1:	68 28 2f 00 c0       	push   0xc0002f28
c0002cd6:	e8 45 fa ff ff       	call   c0002720 <put_str>
c0002cdb:	83 c4 04             	add    esp,0x4

c0002cde <intr0x1Centry.skip_print>:
c0002cde:	b0 20                	mov    al,0x20
c0002ce0:	e6 a0                	out    0xa0,al
c0002ce2:	e6 20                	out    0x20,al
c0002ce4:	83 c4 04             	add    esp,0x4
c0002ce7:	cf                   	iret   

c0002ce8 <intr0x1Dentry>:
c0002ce8:	6a 00                	push   0x0
c0002cea:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002cf0:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002cf7:	75 0d                	jne    c0002d06 <intr0x1Dentry.skip_print>
c0002cf9:	68 28 2f 00 c0       	push   0xc0002f28
c0002cfe:	e8 1d fa ff ff       	call   c0002720 <put_str>
c0002d03:	83 c4 04             	add    esp,0x4

c0002d06 <intr0x1Dentry.skip_print>:
c0002d06:	b0 20                	mov    al,0x20
c0002d08:	e6 a0                	out    0xa0,al
c0002d0a:	e6 20                	out    0x20,al
c0002d0c:	83 c4 04             	add    esp,0x4
c0002d0f:	cf                   	iret   

c0002d10 <intr0x1Eentry>:
c0002d10:	90                   	nop
c0002d11:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002d17:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002d1e:	75 0d                	jne    c0002d2d <intr0x1Eentry.skip_print>
c0002d20:	68 28 2f 00 c0       	push   0xc0002f28
c0002d25:	e8 f6 f9 ff ff       	call   c0002720 <put_str>
c0002d2a:	83 c4 04             	add    esp,0x4

c0002d2d <intr0x1Eentry.skip_print>:
c0002d2d:	b0 20                	mov    al,0x20
c0002d2f:	e6 a0                	out    0xa0,al
c0002d31:	e6 20                	out    0x20,al
c0002d33:	83 c4 04             	add    esp,0x4
c0002d36:	cf                   	iret   

c0002d37 <intr0x1Fentry>:
c0002d37:	6a 00                	push   0x0
c0002d39:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002d3f:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002d46:	75 0d                	jne    c0002d55 <intr0x1Fentry.skip_print>
c0002d48:	68 28 2f 00 c0       	push   0xc0002f28
c0002d4d:	e8 ce f9 ff ff       	call   c0002720 <put_str>
c0002d52:	83 c4 04             	add    esp,0x4

c0002d55 <intr0x1Fentry.skip_print>:
c0002d55:	b0 20                	mov    al,0x20
c0002d57:	e6 a0                	out    0xa0,al
c0002d59:	e6 20                	out    0x20,al
c0002d5b:	83 c4 04             	add    esp,0x4
c0002d5e:	cf                   	iret   

c0002d5f <intr0x20entry>:
c0002d5f:	6a 00                	push   0x0
c0002d61:	ff 05 3e 2f 00 c0    	inc    DWORD PTR ds:0xc0002f3e
c0002d67:	83 3d 3e 2f 00 c0 01 	cmp    DWORD PTR ds:0xc0002f3e,0x1
c0002d6e:	75 0d                	jne    c0002d7d <intr0x20entry.skip_print>
c0002d70:	68 28 2f 00 c0       	push   0xc0002f28
c0002d75:	e8 a6 f9 ff ff       	call   c0002720 <put_str>
c0002d7a:	83 c4 04             	add    esp,0x4

c0002d7d <intr0x20entry.skip_print>:
c0002d7d:	b0 20                	mov    al,0x20
c0002d7f:	e6 a0                	out    0xa0,al
c0002d81:	e6 20                	out    0x20,al
c0002d83:	83 c4 04             	add    esp,0x4
c0002d86:	cf                   	iret   

Disassembly of section .rodata:

c0002d88 <.rodata>:
c0002d88:	49                   	dec    ecx
c0002d89:	20 61 6d             	and    BYTE PTR [ecx+0x6d],ah
c0002d8c:	20 6b 65             	and    BYTE PTR [ebx+0x65],ch
c0002d8f:	72 6e                	jb     c0002dff <intr0x20entry.skip_print+0x82>
c0002d91:	65 6c                	gs ins BYTE PTR es:[edi],dx
c0002d93:	0a 00                	or     al,BYTE PTR [eax]
c0002d95:	00 00                	add    BYTE PTR [eax],al
c0002d97:	00 49 6e             	add    BYTE PTR [ecx+0x6e],cl
c0002d9a:	69 74 69 61 6c 69 7a 	imul   esi,DWORD PTR [ecx+ebp*2+0x61],0x617a696c
c0002da1:	61 
c0002da2:	74 69                	je     c0002e0d <intr0x20entry.skip_print+0x90>
c0002da4:	6f                   	outs   dx,DWORD PTR ds:[esi]
c0002da5:	6e                   	outs   dx,BYTE PTR ds:[esi]
c0002da6:	20 63 6f             	and    BYTE PTR [ebx+0x6f],ah
c0002da9:	6d                   	ins    DWORD PTR es:[edi],dx
c0002daa:	70 6c                	jo     c0002e18 <intr0x20entry.skip_print+0x9b>
c0002dac:	65 74 65             	gs je  c0002e14 <intr0x20entry.skip_print+0x97>
c0002daf:	2c 20                	sub    al,0x20
c0002db1:	65 6e                	outs   dx,BYTE PTR gs:[esi]
c0002db3:	61                   	popa   
c0002db4:	62 6c 69 6e          	bound  ebp,QWORD PTR [ecx+ebp*2+0x6e]
c0002db8:	67 20 69 6e          	and    BYTE PTR [bx+di+0x6e],ch
c0002dbc:	74 65                	je     c0002e23 <intr0x20entry.skip_print+0xa6>
c0002dbe:	72 72                	jb     c0002e32 <intr0x20entry.skip_print+0xb5>
c0002dc0:	75 70                	jne    c0002e32 <intr0x20entry.skip_print+0xb5>
c0002dc2:	74 73                	je     c0002e37 <intr0x20entry.skip_print+0xba>
c0002dc4:	2e 2e 2e 0a 00       	cs cs or al,BYTE PTR cs:[eax]
c0002dc9:	69 6e 69 74 5f 61 6c 	imul   ebp,DWORD PTR [esi+0x69],0x6c615f74
c0002dd0:	6c                   	ins    BYTE PTR es:[edi],dx
c0002dd1:	0a 00                	or     al,BYTE PTR [eax]
c0002dd3:	20 20                	and    BYTE PTR [eax],ah
c0002dd5:	20 70 69             	and    BYTE PTR [eax+0x69],dh
c0002dd8:	63 5f 69             	arpl   WORD PTR [edi+0x69],bx
c0002ddb:	6e                   	outs   dx,BYTE PTR ds:[esi]
c0002ddc:	69 74 20 64 6f 6e 65 	imul   esi,DWORD PTR [eax+eiz*1+0x64],0xa656e6f
c0002de3:	0a 
c0002de4:	00 20                	add    BYTE PTR [eax],ah
c0002de6:	20 20                	and    BYTE PTR [eax],ah
c0002de8:	69 64 74 5f 64 65 73 	imul   esp,DWORD PTR [esp+esi*2+0x5f],0x63736564
c0002def:	63 
c0002df0:	5f                   	pop    edi
c0002df1:	69 6e 69 74 20 64 6f 	imul   ebp,DWORD PTR [esi+0x69],0x6f642074
c0002df8:	6e                   	outs   dx,BYTE PTR ds:[esi]
c0002df9:	65 0a 00             	or     al,BYTE PTR gs:[eax]
c0002dfc:	69 64 74 5f 69 6e 69 	imul   esp,DWORD PTR [esp+esi*2+0x5f],0x74696e69
c0002e03:	74 
c0002e04:	20 73 74             	and    BYTE PTR [ebx+0x74],dh
c0002e07:	61                   	popa   
c0002e08:	72 74                	jb     c0002e7e <intr0x20entry.skip_print+0x101>
c0002e0a:	0a 00                	or     al,BYTE PTR [eax]
c0002e0c:	20 20                	and    BYTE PTR [eax],ah
c0002e0e:	20 6c 69 64          	and    BYTE PTR [ecx+ebp*2+0x64],ch
c0002e12:	74 20                	je     c0002e34 <intr0x20entry.skip_print+0xb7>
c0002e14:	64 6f                	outs   dx,DWORD PTR fs:[esi]
c0002e16:	6e                   	outs   dx,BYTE PTR ds:[esi]
c0002e17:	65 0a 00             	or     al,BYTE PTR gs:[eax]

Disassembly of section .eh_frame:

c0002e1c <.eh_frame>:
c0002e1c:	14 00                	adc    al,0x0
c0002e1e:	00 00                	add    BYTE PTR [eax],al
c0002e20:	00 00                	add    BYTE PTR [eax],al
c0002e22:	00 00                	add    BYTE PTR [eax],al
c0002e24:	01 7a 52             	add    DWORD PTR [edx+0x52],edi
c0002e27:	00 01                	add    BYTE PTR [ecx],al
c0002e29:	7c 08                	jl     c0002e33 <intr0x20entry.skip_print+0xb6>
c0002e2b:	01 1b                	add    DWORD PTR [ebx],ebx
c0002e2d:	0c 04                	or     al,0x4
c0002e2f:	04 88                	add    al,0x88
c0002e31:	01 00                	add    DWORD PTR [eax],eax
c0002e33:	00 20                	add    BYTE PTR [eax],ah
c0002e35:	00 00                	add    BYTE PTR [eax],al
c0002e37:	00 1c 00             	add    BYTE PTR [eax+eax*1],bl
c0002e3a:	00 00                	add    BYTE PTR [eax],al
c0002e3c:	c4                   	(bad)  
c0002e3d:	f6 ff                	idiv   bh
c0002e3f:	ff                   	(bad)  
c0002e40:	39 00                	cmp    DWORD PTR [eax],eax
c0002e42:	00 00                	add    BYTE PTR [eax],al
c0002e44:	00 44 0c 01          	add    BYTE PTR [esp+ecx*1+0x1],al
c0002e48:	00 49 10             	add    BYTE PTR [ecx+0x10],cl
c0002e4b:	05 02 75 00 41       	add    eax,0x41007502
c0002e50:	0f 03 75 7c          	lsl    esi,WORD PTR [ebp+0x7c]
c0002e54:	06                   	push   es
c0002e55:	00 00                	add    BYTE PTR [eax],al
c0002e57:	00 1c 00             	add    BYTE PTR [eax+eax*1],bl
c0002e5a:	00 00                	add    BYTE PTR [eax],al
c0002e5c:	40                   	inc    eax
c0002e5d:	00 00                	add    BYTE PTR [eax],al
c0002e5f:	00 d9                	add    cl,bl
c0002e61:	f6 ff                	idiv   bh
c0002e63:	ff 1e                	call   FWORD PTR [esi]
c0002e65:	00 00                	add    BYTE PTR [eax],al
c0002e67:	00 00                	add    BYTE PTR [eax],al
c0002e69:	41                   	inc    ecx
c0002e6a:	0e                   	push   cs
c0002e6b:	08 85 02 42 0d 05    	or     BYTE PTR [ebp+0x50d4202],al
c0002e71:	5a                   	pop    edx
c0002e72:	c5 0c 04             	lds    ecx,FWORD PTR [esp+eax*1]
c0002e75:	04 00                	add    al,0x0
c0002e77:	00 1c 00             	add    BYTE PTR [eax+eax*1],bl
c0002e7a:	00 00                	add    BYTE PTR [eax],al
c0002e7c:	60                   	pusha  
c0002e7d:	00 00                	add    BYTE PTR [eax],al
c0002e7f:	00 d7                	add    bh,dl
c0002e81:	f6 ff                	idiv   bh
c0002e83:	ff 21                	jmp    DWORD PTR [ecx]
c0002e85:	00 00                	add    BYTE PTR [eax],al
c0002e87:	00 00                	add    BYTE PTR [eax],al
c0002e89:	41                   	inc    ecx
c0002e8a:	0e                   	push   cs
c0002e8b:	08 85 02 42 0d 05    	or     BYTE PTR [ebp+0x50d4202],al
c0002e91:	5d                   	pop    ebp
c0002e92:	c5 0c 04             	lds    ecx,FWORD PTR [esp+eax*1]
c0002e95:	04 00                	add    al,0x0
c0002e97:	00 1c 00             	add    BYTE PTR [eax+eax*1],bl
c0002e9a:	00 00                	add    BYTE PTR [eax],al
c0002e9c:	80 00 00             	add    BYTE PTR [eax],0x0
c0002e9f:	00 d8                	add    al,bl
c0002ea1:	f6 ff                	idiv   bh
c0002ea3:	ff a6 00 00 00 00    	jmp    DWORD PTR [esi+0x0]
c0002ea9:	41                   	inc    ecx
c0002eaa:	0e                   	push   cs
c0002eab:	08 85 02 42 0d 05    	or     BYTE PTR [ebp+0x50d4202],al
c0002eb1:	02 a2 c5 0c 04 04    	add    ah,BYTE PTR [edx+0x4040cc5]
c0002eb7:	00 1c 00             	add    BYTE PTR [eax+eax*1],bl
c0002eba:	00 00                	add    BYTE PTR [eax],al
c0002ebc:	a0 00 00 00 5e       	mov    al,ds:0x5e000000
c0002ec1:	f7 ff                	idiv   edi
c0002ec3:	ff 43 00             	inc    DWORD PTR [ebx+0x0]
c0002ec6:	00 00                	add    BYTE PTR [eax],al
c0002ec8:	00 41 0e             	add    BYTE PTR [ecx+0xe],al
c0002ecb:	08 85 02 42 0d 05    	or     BYTE PTR [ebp+0x50d4202],al
c0002ed1:	7f c5                	jg     c0002e98 <intr0x20entry.skip_print+0x11b>
c0002ed3:	0c 04                	or     al,0x4
c0002ed5:	04 00                	add    al,0x0
c0002ed7:	00 1c 00             	add    BYTE PTR [eax+eax*1],bl
c0002eda:	00 00                	add    BYTE PTR [eax],al
c0002edc:	c0 00 00             	rol    BYTE PTR [eax],0x0
c0002edf:	00 81 f7 ff ff 51    	add    BYTE PTR [ecx+0x51fffff7],al
c0002ee5:	00 00                	add    BYTE PTR [eax],al
c0002ee7:	00 00                	add    BYTE PTR [eax],al
c0002ee9:	41                   	inc    ecx
c0002eea:	0e                   	push   cs
c0002eeb:	08 85 02 42 0d 05    	or     BYTE PTR [ebp+0x50d4202],al
c0002ef1:	02 4d c5             	add    cl,BYTE PTR [ebp-0x3b]
c0002ef4:	0c 04                	or     al,0x4
c0002ef6:	04 00                	add    al,0x0
c0002ef8:	24 00                	and    al,0x0
c0002efa:	00 00                	add    BYTE PTR [eax],al
c0002efc:	e0 00                	loopne c0002efe <intr0x20entry.skip_print+0x181>
c0002efe:	00 00                	add    BYTE PTR [eax],al
c0002f00:	b2 f7                	mov    dl,0xf7
c0002f02:	ff                   	(bad)  
c0002f03:	ff 66 00             	jmp    DWORD PTR [esi+0x0]
c0002f06:	00 00                	add    BYTE PTR [eax],al
c0002f08:	00 41 0e             	add    BYTE PTR [ecx+0xe],al
c0002f0b:	08 85 02 42 0d 05    	or     BYTE PTR [ebp+0x50d4202],al
c0002f11:	45                   	inc    ebp
c0002f12:	87 03                	xchg   DWORD PTR [ebx],eax
c0002f14:	86 04 02             	xchg   BYTE PTR [edx+eax*1],al
c0002f17:	5b                   	pop    ebx
c0002f18:	c6 41 c7 41          	mov    BYTE PTR [ecx-0x39],0x41
c0002f1c:	c5 0c 04             	lds    ecx,FWORD PTR [esp+eax*1]
c0002f1f:	04                   	.byte 0x4

Disassembly of section .data:

c0002f20 <put_int_buffer>:
	...

c0002f28 <intr_str>:
c0002f28:	69 6e 74 65 72 72 75 	imul   ebp,DWORD PTR [esi+0x74],0x75727265
c0002f2f:	70 74                	jo     c0002fa5 <intr_entry_table+0x63>
c0002f31:	20 6f 63             	and    BYTE PTR [edi+0x63],ch
c0002f34:	63 75 72             	arpl   WORD PTR [ebp+0x72],si
c0002f37:	72 65                	jb     c0002f9e <intr_entry_table+0x5c>
c0002f39:	64 21 21             	and    DWORD PTR fs:[ecx],esp
c0002f3c:	0a 00                	or     al,BYTE PTR [eax]

c0002f3e <intr_count>:
c0002f3e:	00 00                	add    BYTE PTR [eax],al
	...

c0002f42 <intr_entry_table>:
c0002f42:	60                   	pusha  
c0002f43:	28 00                	sub    BYTE PTR [eax],al
c0002f45:	c0 88 28 00 c0 b0 28 	ror    BYTE PTR [eax-0x4f3fffd8],0x28
c0002f4c:	00 c0                	add    al,al
c0002f4e:	d8 28                	fsubr  DWORD PTR [eax]
c0002f50:	00 c0                	add    al,al
c0002f52:	00 29                	add    BYTE PTR [ecx],ch
c0002f54:	00 c0                	add    al,al
c0002f56:	28 29                	sub    BYTE PTR [ecx],ch
c0002f58:	00 c0                	add    al,al
c0002f5a:	50                   	push   eax
c0002f5b:	29 00                	sub    DWORD PTR [eax],eax
c0002f5d:	c0 78 29 00          	sar    BYTE PTR [eax+0x29],0x0
c0002f61:	c0 a0 29 00 c0 c8 29 	shl    BYTE PTR [eax-0x373fffd7],0x29
c0002f68:	00 c0                	add    al,al
c0002f6a:	f0 29 00             	lock sub DWORD PTR [eax],eax
c0002f6d:	c0 18 2a             	rcr    BYTE PTR [eax],0x2a
c0002f70:	00 c0                	add    al,al
c0002f72:	40                   	inc    eax
c0002f73:	2a 00                	sub    al,BYTE PTR [eax]
c0002f75:	c0 68 2a 00          	shr    BYTE PTR [eax+0x2a],0x0
c0002f79:	c0 90 2a 00 c0 b8 2a 	rcl    BYTE PTR [eax-0x473fffd6],0x2a
c0002f80:	00 c0                	add    al,al
c0002f82:	e0 2a                	loopne c0002fae <intr_entry_table+0x6c>
c0002f84:	00 c0                	add    al,al
c0002f86:	08 2b                	or     BYTE PTR [ebx],ch
c0002f88:	00 c0                	add    al,al
c0002f8a:	30 2b                	xor    BYTE PTR [ebx],ch
c0002f8c:	00 c0                	add    al,al
c0002f8e:	58                   	pop    eax
c0002f8f:	2b 00                	sub    eax,DWORD PTR [eax]
c0002f91:	c0 80 2b 00 c0 a8 2b 	rol    BYTE PTR [eax-0x573fffd5],0x2b
c0002f98:	00 c0                	add    al,al
c0002f9a:	d0 2b                	shr    BYTE PTR [ebx],1
c0002f9c:	00 c0                	add    al,al
c0002f9e:	f8                   	clc    
c0002f9f:	2b 00                	sub    eax,DWORD PTR [eax]
c0002fa1:	c0 20 2c             	shl    BYTE PTR [eax],0x2c
c0002fa4:	00 c0                	add    al,al
c0002fa6:	48                   	dec    eax
c0002fa7:	2c 00                	sub    al,0x0
c0002fa9:	c0 70 2c 00          	shl    BYTE PTR [eax+0x2c],0x0
c0002fad:	c0 98 2c 00 c0 c0 2c 	rcr    BYTE PTR [eax-0x3f3fffd4],0x2c
c0002fb4:	00 c0                	add    al,al
c0002fb6:	e8 2c 00 c0 10       	call   d0c02fe7 <idt+0x10c00007>
c0002fbb:	2d 00 c0 37 2d       	sub    eax,0x2d37c000
c0002fc0:	00 c0                	add    al,al
c0002fc2:	5f                   	pop    edi
c0002fc3:	2d                   	.byte 0x2d
c0002fc4:	00 c0                	add    al,al

Disassembly of section .bss:

c0002fe0 <idt>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    edi
   1:	43                   	inc    ebx
   2:	43                   	inc    ebx
   3:	3a 20                	cmp    ah,BYTE PTR [eax]
   5:	28 55 62             	sub    BYTE PTR [ebp+0x62],dl
   8:	75 6e                	jne    78 <SELECTOR_VIDEO+0x60>
   a:	74 75                	je     81 <SELECTOR_VIDEO+0x69>
   c:	20 31                	and    BYTE PTR [ecx],dh
   e:	31 2e                	xor    DWORD PTR [esi],ebp
  10:	34 2e                	xor    al,0x2e
  12:	30 2d 31 75 62 75    	xor    BYTE PTR ds:0x75627531,ch
  18:	6e                   	outs   dx,BYTE PTR ds:[esi]
  19:	74 75                	je     90 <SELECTOR_VIDEO+0x78>
  1b:	31 7e 32             	xor    DWORD PTR [esi+0x32],edi
  1e:	32 2e                	xor    ch,BYTE PTR [esi]
  20:	30 34 2e             	xor    BYTE PTR [esi+ebp*1],dh
  23:	32 29                	xor    ch,BYTE PTR [ecx]
  25:	20 31                	and    BYTE PTR [ecx],dh
  27:	31 2e                	xor    DWORD PTR [esi],ebp
  29:	34 2e                	xor    al,0x2e
  2b:	30 00                	xor    BYTE PTR [eax],al
