Contents of the .eh_frame section:


00000000 00000014 00000000 CIE
  Version:               1
  Augmentation:          "zR"
  Code alignment factor: 1
  Data alignment factor: -4
  Return address column: 8
  Augmentation data:     1b
  DW_CFA_def_cfa: r4 (esp) ofs 4
  DW_CFA_offset: r8 (eip) at cfa-4
  DW_CFA_nop
  DW_CFA_nop

00000018 0000001c 0000001c FDE cie=00000000 pc=00000000..00000021
  DW_CFA_advance_loc: 1 to 00000001
  DW_CFA_def_cfa_offset: 8
  DW_CFA_offset: r5 (ebp) at cfa-8
  DW_CFA_advance_loc: 2 to 00000003
  DW_CFA_def_cfa_register: r5 (ebp)
  DW_CFA_advance_loc: 29 to 00000020
  DW_CFA_restore: r5 (ebp)
  DW_CFA_def_cfa: r4 (esp) ofs 4
  DW_CFA_nop
  DW_CFA_nop

00000038 0000001c 0000003c FDE cie=00000000 pc=00000021..000000c7
  DW_CFA_advance_loc: 1 to 00000022
  DW_CFA_def_cfa_offset: 8
  DW_CFA_offset: r5 (ebp) at cfa-8
  DW_CFA_advance_loc: 2 to 00000024
  DW_CFA_def_cfa_register: r5 (ebp)
  DW_CFA_advance_loc1: 162 to 000000c6
  DW_CFA_restore: r5 (ebp)
  DW_CFA_def_cfa: r4 (esp) ofs 4
  DW_CFA_nop

00000058 0000001c 0000005c FDE cie=00000000 pc=000000c7..0000010a
  DW_CFA_advance_loc: 1 to 000000c8
  DW_CFA_def_cfa_offset: 8
  DW_CFA_offset: r5 (ebp) at cfa-8
  DW_CFA_advance_loc: 2 to 000000ca
  DW_CFA_def_cfa_register: r5 (ebp)
  DW_CFA_advance_loc: 63 to 00000109
  DW_CFA_restore: r5 (ebp)
  DW_CFA_def_cfa: r4 (esp) ofs 4
  DW_CFA_nop
  DW_CFA_nop

00000078 0000001c 0000007c FDE cie=00000000 pc=0000010a..0000015b
  DW_CFA_advance_loc: 1 to 0000010b
  DW_CFA_def_cfa_offset: 8
  DW_CFA_offset: r5 (ebp) at cfa-8
  DW_CFA_advance_loc: 2 to 0000010d
  DW_CFA_def_cfa_register: r5 (ebp)
  DW_CFA_advance_loc1: 77 to 0000015a
  DW_CFA_restore: r5 (ebp)
  DW_CFA_def_cfa: r4 (esp) ofs 4
  DW_CFA_nop

00000098 0000001c 0000009c FDE cie=00000000 pc=0000015b..000001a5
  DW_CFA_advance_loc: 1 to 0000015c
  DW_CFA_def_cfa_offset: 8
  DW_CFA_offset: r5 (ebp) at cfa-8
  DW_CFA_advance_loc: 2 to 0000015e
  DW_CFA_def_cfa_register: r5 (ebp)
  DW_CFA_advance_loc1: 70 to 000001a4
  DW_CFA_restore: r5 (ebp)
  DW_CFA_def_cfa: r4 (esp) ofs 4
  DW_CFA_nop

000000b8 0000001c 000000bc FDE cie=00000000 pc=000001a5..0000029b
  DW_CFA_advance_loc: 1 to 000001a6
  DW_CFA_def_cfa_offset: 8
  DW_CFA_offset: r5 (ebp) at cfa-8
  DW_CFA_advance_loc: 2 to 000001a8
  DW_CFA_def_cfa_register: r5 (ebp)
  DW_CFA_advance_loc1: 242 to 0000029a
  DW_CFA_restore: r5 (ebp)
  DW_CFA_def_cfa: r4 (esp) ofs 4
  DW_CFA_nop

000000d8 00000024 000000dc FDE cie=00000000 pc=0000029b..00000306
  DW_CFA_advance_loc: 1 to 0000029c
  DW_CFA_def_cfa_offset: 8
  DW_CFA_offset: r5 (ebp) at cfa-8
  DW_CFA_advance_loc: 2 to 0000029e
  DW_CFA_def_cfa_register: r5 (ebp)
  DW_CFA_advance_loc: 5 to 000002a3
  DW_CFA_offset: r7 (edi) at cfa-12
  DW_CFA_offset: r6 (esi) at cfa-16
  DW_CFA_advance_loc1: 96 to 00000303
  DW_CFA_restore: r6 (esi)
  DW_CFA_advance_loc: 1 to 00000304
  DW_CFA_restore: r7 (edi)
  DW_CFA_advance_loc: 1 to 00000305
  DW_CFA_restore: r5 (ebp)
  DW_CFA_def_cfa: r4 (esp) ofs 4

