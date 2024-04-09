LedDisplay:	equ		0xFFF2
DipSwitches:	equ		0xFFF0
Console:        equ             0xFC00


;.DATA
;.CODE
		org		0x456
start:		loadimm.upper   0x00
                loadimm.lower   0x01
                mov             r1,r7

;                loadimm.upper   textx.hi
;                loadimm.lower   textx.lo
;                org             0x800
;                mov             r4,r5,r7
;                mov             r1,r9


copy_3:         loadimm.upper   text.hi
                loadimm.lower   text.lo
                mov             r4, r7

copy_2:        mov             r6, r4

               loadimm.upper   0x00
               loadimm.lower   0x14
               mov             r3, r7

                loadimm.upper   Console.hi
                loadimm.lower   Console.lo
                mov             r5, r7

copy:           load            r0, r6
                nop
                nop
                nop
                store           r5, r0 

                add             r5, r5, r1
                add             r6, r6, r1
                sub             r3, r3, r1
                test            r3
                brr.z           copy_4

                loadimm.upper   text1.hi
                loadimm.lower   text1.lo
                sub             r7, r6, r7
                test            r7
                brr.z           copy_39
                brr             copy

copy_39:        loadimm.upper   text.hi
                loadimm.lower   text.lo
                mov             r6, r7
                brr             copy


copy_4:         add             r4, r4, r1
                loadimm.upper   text1.hi
                loadimm.lower   text1.lo
                sub             r0, r4, r7
                test            r0
                brr.z           start
                brr             copy_2


text:           dw              0xE02a, 0xE02a, 0xE02a, 0x0020, 0x9848, 0x9845, 0x984C, 0x984C,0x984F, 32, 0x9857, 0x984f, 0x9852, 0x984c, 0x9844, 0x20, 0xE02A, 0xE02A, 0xE02A, 32, 32, 32, 32, 32, 32, 32, 32
text1:          
                end 
