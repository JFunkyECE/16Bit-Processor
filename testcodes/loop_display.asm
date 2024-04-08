LedDisplay:	equ		0xFFF2
DipSwitches:	equ		0xFFF0
Console:        equ             0xFC00


;.DATA
;.CODE
		org		0x456
                loadimm.upper   0x98
                loadimm.lower   0x2a
                mov             r3, r7          ; character

restart_loop:
                loadimm.upper   0x00
                loadimm.lower   0x01
                mov             r1, r7          ; direction to increment

                loadimm.upper   0x00
                loadimm.lower   0x00
                mov             r0, r7

                loadimm.upper   x_pos.hi
                loadimm.lower   x_pos.lo
                store           r7, r0

                loadimm.upper   y_pos.hi
                loadimm.lower   y_pos.lo
                store           r7, r0


;
; x_inc_limit = 20 ( 0x14 )
;
                loadimm.upper   0x00
                loadimm.lower   0x14
                mov             r0, r7
                loadimm.upper   x_inc_limit.hi
                loadimm.lower   x_inc_limit.lo
                store           r7, r0

;
; y_inc_limit = 15 ( 0x0f )
;
                loadimm.upper   0x00
                loadimm.lower   0x0f
                mov             r0, r7
                loadimm.upper   y_inc_limit.hi
                loadimm.lower   y_inc_limit.lo
                store           r7, r0

;
; x_dec_limit = -1 ( 0xFFFF )
;
                loadimm.upper   0xff
                loadimm.lower   0xff
                mov             r0, r7
                loadimm.upper   x_dec_limit.hi
                loadimm.lower   x_dec_limit.lo
                store           r7, r0

;
; y_dec_limit = 1 ( 0x01 )
;
                loadimm.upper   0x00
                loadimm.lower   0x00
                mov             r0, r7
                loadimm.upper   y_dec_limit.hi
                loadimm.lower   y_dec_limit.lo
                store           r7, r0

;
; top row
; write "*"
loop_1:         loadimm.upper   x_pos.hi
                loadimm.lower   x_pos.lo
                load            r0, r7

                loadimm.upper   y_pos.hi
                loadimm.lower   y_pos.lo
                load            r6, r7
                loadimm.upper   0x00
                loadimm.lower   0x14
                mul             r7, r6, r7
                add             r0, r0, r7
                 
                loadimm.upper   Console.hi
                loadimm.lower   Console.lo
                add             r7, r0, r7 
                store           r7, r3


; check direction                
                mov             r6, r1
                shr             r6, 1
                test            r6
                brr.z           increment_x

                shr             r6, 1
                test            r6
                brr.z           increment_y

                shr             r6, 1
                test            r6
                brr.z           decrement_x

;
; decrement y
;
decrement_y:    loadimm.upper   y_pos.hi
                loadimm.lower   y_pos.lo
                mov             r4, r7
                load            r6, r7

                loadimm.upper   0x00
                loadimm.lower   0x01
                sub             r6, r6, r7

                loadimm.upper   y_dec_limit.hi
                loadimm.lower   y_dec_limit.lo
                load            r7, r7
                sub             r7, r6, r7
                test            r7
                brr.z           dec_y1

                store           r4, r6
                brr             loop_1

dec_y1:         loadimm.lower   0x01
                loadimm.upper   0x00
                mov             r1, r7
                brr             update_limits


increment_x:    loadimm.upper   x_pos.hi
                loadimm.lower   x_pos.lo
                mov             r4, r7
                load            r6, r7

                loadimm.upper   0x00
                loadimm.lower   0x01
                add             r6, r6, r7

                loadimm.upper   x_inc_limit.hi
                loadimm.lower   x_inc_limit.lo
                load            r7, r7
                sub             r7, r6, r7
                test            r7
                brr.z           inc_x1

                store           r4, r6
                brr             loop_1

inc_x1:         loadimm.lower   0x02
                loadimm.upper   0x00
                mov             r1, r7
                brr             check_end


increment_y:    loadimm.upper   y_pos.hi
                loadimm.lower   y_pos.lo
                mov             r4, r7
                load            r6, r7

                loadimm.upper   0x00
                loadimm.lower   0x01
                add             r6, r6, r7

                loadimm.upper   y_inc_limit.hi
                loadimm.lower   y_inc_limit.lo
                load            r7, r7
                sub             r7, r6, r7
                test            r7
                brr.z           inc_y1

                store           r4, r6
                brr             loop_1

inc_y1:         loadimm.lower   0x04
                loadimm.upper   0x00
                mov             r1, r7
                brr             loop_1


decrement_x:    loadimm.upper   x_pos.hi
                loadimm.lower   x_pos.lo
                mov             r4, r7
                load            r6, r7

                loadimm.upper   0x00
                loadimm.lower   0x01
                sub             r6, r6, r7

                loadimm.upper   x_dec_limit.hi
                loadimm.lower   x_dec_limit.lo
                load            r7, r7
                sub             r7, r6, r7
                test            r7
                brr.z           dec_x1

                store           r4, r6
                brr             loop_1

dec_x1:         loadimm.lower   0x08
                loadimm.upper   0x00
                mov             r1, r7
                brr             loop_1


update_limits:
;
; x_inc_limit = 20 ( 0x14 )
;
                loadimm.upper   0x00
                loadimm.lower   0x01
                mov             r5, r7
                loadimm.upper   x_inc_limit.hi
                loadimm.lower   x_inc_limit.lo
                load            r6, r7
                sub             r6, r6, r5
                store           r7, r6

;
; y_inc_limit = 15 ( 0x0f )
;
                loadimm.upper   y_inc_limit.hi
                loadimm.lower   y_inc_limit.lo
                load            r6, r7
                sub             r6, r6, r5
                store           r7, r6

;
; x_dec_limit = -1 ( 0xFFFF )
;
                loadimm.upper   x_dec_limit.hi
                loadimm.lower   x_dec_limit.lo
                load            r6, r7
                add             r6, r6, r5
                store           r7, r6

;
; y_dec_limit = 1 ( 0x01 )
;
                loadimm.upper   y_dec_limit.hi
                loadimm.lower   y_dec_limit.lo
                load            r6, r7
                add             r6, r6, r5
                store           r7, r6
                brr             loop_1

check_end:      loadimm.upper   0x00
                loadimm.lower   0x07
                mov             r6, r7

                loadimm.upper   y_pos.hi
                loadimm.lower   y_pos.lo
                load            r7, r7
                sub             r7, r7, r6 
                test            r7
                brr.z           done_1
                brr             loop_1


done_1:         loadimm.upper   0x00
                loadimm.lower   0x0c
                mov             r6, r7

                loadimm.upper   x_pos.hi
                loadimm.lower   x_pos.lo
                load            r7, r7
                sub             r7, r7, r6 
                test            r7
                brr.z           flip
                brr             loop_1
 



;
; flip character
;
flip:           loadimm.lower   0x0A
                loadimm.upper   0x00
                nand            r7, r3, r7
                nand            r7, r7, r7
                test            r7
                brr.z           adv_y2

                loadimm.lower   0x20
                brr             adv_y3

adv_y2:         loadimm.lower   0x2a

adv_y3:         loadimm.upper   0x98
                mov             r3, r7
                brr             restart_loop


x_pos:          dw              0x0000
y_pos:          dw              0x0000
x_inc_limit:    dw              0x0000
y_inc_limit:    dw              0x0000
x_dec_limit:    dw              0x0000
y_dec_limit:    dw              0x0000


               end 
