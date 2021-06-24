GetColMemPos:	;Get a BC (XY) color memory pos, 32 chars per line, 8 bytes of color per char,
				; this command uses Y as a bitmap line number (0-192), not a tile number (0-24)
	push bc
		ld a,c			
		and %11111000
		rrca
		rrca
		rrca
		or &20				;Colors start at &2000
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
	
	
CopyToVDP:							;Send data to the VDP using OUT commands
	push bc
	push hl
		ex de,hl
		call VDP_SetWriteAddress
	pop hl
	pop bc
	inc b
	inc c
CopyToVDP2:
	ld a,(hl)
	out (VdpOut_Data),a
	inc hl
	dec c
	jr nz,CopyToVDP2
	dec b
	jr nz,CopyToVDP2
	ret

ScreenINIT:
	ret
DOINIT:

	ld a, %00000010			;mode 2
	out (VdpOut_Control),a
	ld a,128+0				;0	-	-	-	-	-	-	M2	EXTVID
	out (VdpOut_Control),a

	ld a, %01000000		;(show screen)
	out (VdpOut_Control),a
	ld a,128+1				;1	4/16K	BL	GINT	M1	M3	-	SI	MAG
	out (VdpOut_Control),a

	ld a, %10011111			;Color table address ;%10011111=tile mode ; %11111111= bitmap mode
	out (VdpOut_Control),a
	ld a,128+3				;3	CT13	CT12	CT11	CT10	CT9	CT8	CT7	CT6
	out (VdpOut_Control),a
;in mode 2 control register #3 has a different meaning. Only bit 7 (CT13) sets the CT address. 
;Somewhat like control register #4 for the PG, bits 6 - 0 are an ANDmask over the top 7 bits of the character number.


	
	;Set Sprite attrib table to &1B00
	ld a,%00110110		
	out (VdpOut_Control),a
	ld a,128+5		
	out (VdpOut_Control),a
	
	
	
	;ld a,%00000000		
	;out (VdpOut_Control),a
	;ld a,128+11
	;out (VdpOut_Control),a
	
	;Set Sprite Pattern table to &3800
	ld a,%00000111
	out (VdpOut_Control),a
	ld a,128+6
	out (VdpOut_Control),a


	ld a, %00000000			;Pattern table address
	out (VdpOut_Control),a
	ld a,128+4				;4	-	-	-	-	-	PG13	PG12	PG11
	out (VdpOut_Control),a
;in mode 2 Only bit 2, PG13, sets the address of the PG (so it's either address 0 or 2000h). Bits 0 and 1 are an AND mask over the character number. The character number is 0 - 767 (2FFh) and these two bits are ANDed over the two highest bits of this value (2FFh is 10 bits, so over bit 8 and 9). So in effect, if bit 0 of control register #4 is set, the second array of 256 patterns in the PG is used for the middle 8 rows of characters, otherwise the first 256 patterns. If bit 1 is set, the third array of patterns is used in the PG, otherwise the first.
	ld a, &F0				;Text color
	out (VdpOut_Control),a
	ld a,128+7				;7	TC3	TC2	TC1	TC0	BD3	BD2	BD1	BD0
	out (VdpOut_Control),a

	ld	hl, BitmapFont
	ld	de, &0000 		; $8000
	ld	bc, 8*96		; the ASCII character set: 256 characters, each with 8 bytes of display data
	call	CopyToVDP	; load tile data	
	
	
CLS:
	ld hl,&1800				;Set all the tiles to Zero
	call VDP_SetWriteAddress
	ld bc,&17FF
	;ld d,0
FillRpt:
	xor a;					;Write a Zero
	out (VdpOut_Data),a
	dec bc
	ld a,b
	or c
	jr nz, FillRpt


	ld hl,&2000				;Clear all the color info, 8 lines per tile, 32x24 tiles=&1800
	call VDP_SetWriteAddress
	ld a,0
	ld bc,&1800
FillRptnb:
	ld a,&F0				;Foreground / Background... F0=White/Black
	out (VdpOut_Data),a
	dec bc
	ld a,b
	or c
	jr nz, FillRptnb
	ret
	
VDP_SetReadAddress:
	ld C,0			;Bit 6=0 when reading, 1 when writing
	jr VDP_SetAddress
prepareVram:
VDP_SetWriteAddress:
	ld C,64			;&40/64/Bit6
VDP_SetAddress:
	ld      a, l
        out     (VdpOut_Control), a
        ld      a, h
        or      C
        out     (VdpOut_Control), a
	ret            
	
SetHardwareSprite:
	rlca					;4 bytes per sprite
	rlca
	push bc
	push hl
		ld h,&1B			;Sprite Attribs start at &1B00
		ld l,a
		call VDP_SetWriteAddress
	pop hl
	pop bc
	ld a,c
	out (VdpOut_Data),a		;y
	ld a,B
	out (VdpOut_Data),a		;x
	ld a,h
	out (VdpOut_Data),a		;Pattern
	ld a,l
	out (VdpOut_Data),a		;Color + 'EC'
	;'EC' - early clock - shifts sprite 32 pixels left so sprites can be offscreen left

	ld a,%00001000			;turn on sprites
	out (VdpOut_Control),a	;Set up Vram  [VR=1] [SPD=SpriteDisable] 
	ld a,128+8				
	out (VdpOut_Control),a	;R#8  [MS ] [LP ] [TP ] [CB ] [VR ] [ 0 ] [SPD] [BW ] 
	ret
	
	
	