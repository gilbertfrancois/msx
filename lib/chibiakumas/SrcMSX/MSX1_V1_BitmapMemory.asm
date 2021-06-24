;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;				Screen Co-ordinate functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;IN (To function)
;SSCCCCCCCCRRRRRRR		S=Screen, C=Column, R=Row
;AHHHHHHHHLLLLLLLL
;OUT (To GPU)
;333222222211111111
;sssmrrrrrrrccccccc	=screen,row,col, M 1=write, 0=read
  ; 100000000000000  = half way down the screen!
;VDP_SetWriteAddress

GetScreenPos:						;return memory pos in HL of screen co-ord B,C (X,Y)
							;&80 bytes per line, so we need to shift C one to the 
							;right to get the last bit into L for the true memory loc
	ld (GetNextLinePos_Plus2-2),bc

GetScreenPosB:
	;ld (GetNextLinePosAlong_Plus2-2),bc
	push bc
		ld a,c
		and %11111000
		rrca
		rrca
		rrca
		ld h,a
		ld a,b
		and %00011111
		rlca	
		rlca
		rlca
		ld b,a
		ld a,c
		and %00000111
		or b
		ld l,a
		ld (GetNextLinePosAlong_Plus2-2),hl
		call VDP_SetWriteAddress
	pop bc
	ret

GetNextLine:
	push af
	push bc
		ld bc,&0000 ;<--- SM ***
GetNextLinePos_Plus2:
		inc c
		call GetScreenPos
	pop bc
	pop af
	ret

MoveAlong:
		ld hl,&0000 ;<--- SM ***
GetNextLinePosAlong_Plus2:
		push af
		push bc
			ld bc,8
			add hl,bc
			ld (GetNextLinePosAlong_Plus2-2),hl
			ld      a, l
			out     (VdpOut_Control), a
			ld      a, h
			or      64
			out     (VdpOut_Control), a
		pop bc
		pop af
	ret



VDP_SetReadAddress:
	ld C,0			;Bit 6=0 when reading, 1 when writing
	jr VDP_SetAddress
VDP_SetWriteAddress:
	ld C,64
VDP_SetAddress:
	ld      a, l
        out     (VdpOut_Control), a
        ld      a, h
        or      C
        out     (VdpOut_Control), a
	ret            

ScreenINIT:
	ld a, %00000010			;mode 2
	out (VdpOut_Control),a
	ld a,128+0				;0	-	-	-	-	-	-	M2	EXTVID
	out (VdpOut_Control),a

	ld a, %10000000+64		;(show screen)
	out (VdpOut_Control),a
	ld a,128+1				;1	4/16K	BL	GINT	M1	M3	-	SI	MAG
	out (VdpOut_Control),a

	ld a, %11111111			;Color table address
	out (VdpOut_Control),a
	ld a,128+3				;3	CT13	CT12	CT11	CT10	CT9	CT8	CT7	CT6
	out (VdpOut_Control),a
;in mode 2 control register #3 has a different meaning. Only bit 7 (CT13) sets the CT address. 
;Somewhat like control register #4 for the PG, bits 6 - 0 are an ANDmask over the top 7 bits of the character number.

	ld a, %00000011			;Pattern table address
	out (VdpOut_Control),a
	ld a,128+4				;4	-	-	-	-	-	PG13	PG12	PG11
	out (VdpOut_Control),a
;in mode 2 Only bit 2, PG13, sets the address of the PG (so it's either address 0 or 2000h). Bits 0 and 1 are an AND mask over the character number. The character number is 0 - 767 (2FFh) and these two bits are ANDed over the two highest bits of this value (2FFh is 10 bits, so over bit 8 and 9). So in effect, if bit 0 of control register #4 is set, the second array of 256 patterns in the PG is used for the middle 8 rows of characters, otherwise the first 256 patterns. If bit 1 is set, the third array of patterns is used in the PG, otherwise the first.
	ld a, &F0				;Text color
	out (VdpOut_Control),a
	ld a,128+7				;7	TC3	TC2	TC1	TC0	BD3	BD2	BD1	BD0
	out (VdpOut_Control),a

	ld hl,&0000
	call VDP_SetWriteAddress
	ld a,0
	ld bc,&17FF

FillRpt:
	xor a
	out (VdpOut_Data),a
	dec bc
	inc d

	ld a,b
	or c
	jr nz, FillRpt



	ld d,0
	ld hl,&1800
	call VDP_SetWriteAddress
	ld a,0
	ld bc,&300
FillRptn:
	ld a,d
	out (VdpOut_Data),a
	dec bc
	inc d
	ld a,b
	or c
	jr nz, FillRptn


	ld hl,&2000
	call VDP_SetWriteAddress
	ld a,0
	ld bc,&17FF
FillRptnb:
	ld a,&21
	out (VdpOut_Data),a
	dec bc
	ld a,b
	or c
	jr nz, FillRptnb

;The first 8 rows  byte from PN + 000h
;The middle 8 rows byte from PN + 100h
;The bottom 8 rows byte from PN + 200h

	ret

GetColMemPos:
	push bc

		ld a,c
		and %11111000
		rrca
		rrca
		rrca
		or &20	;Colors start at &2000
		ld h,a
		ld a,b
		and %00011111
		rlca	
		rlca
		rlca
		ld b,a
		ld a,c
		and %00000111
		or b
		ld l,a

		call VDP_SetWriteAddress
	pop bc
	ret




;Colour           Y     R-Y   B-Y   R     G     B     R    G    B
;0 Transparent
;1 Black         0.00  0.47  0.47  0.00  0.00  0.00    0    0    0
;2 Medium green  0.53  0.07  0.20  0.13	0.79  0.26   33  200   66
;3 Light green   0.67  0.17  0.27  0.37  0.86  0.47   94  220  120
;4 Dark blue     0.40  0.40  1.00  0.33  0.33  0.93   84   85  237
;5 Light blue    0.53  0.43  0.93  0.49  0.46  0.99  125  118  252
;6 Dark red      0.47  0.83  0.30  0.83	0.32  0.30  212   82   77
;7 Cyan          0.73  0.00  0.70  0.26	0.92  0.96   66  235  245
;8 Medium red    0.53  0.93  0.27  0.99	0.33  0.33  252   85   84
;9 Light red     0.67  0.93  0.27  1.13! 0.47  0.47  255  121  120
;A Dark yellow   0.73  0.57  0.07  0.83	0.76  0.33  212  193   84
;B Light yellow  0.80  0.57  0.17  0.90	0.81  0.50  230  206  128
;C Dark green    0.47  0.13  0.23  0.13	0.69  0.23   33  176   59
;D Magenta       0.53  0.73  0.67  0.79	0.36  0.73  201   91  186
;E Gray          0.80  0.47  0.47  0.80	0.80  0.80  204  204  204
;F White         1.00  0.47  0.47  1.00	1.00  1.00  255  255  255
