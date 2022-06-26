
;For Cartridge	
	org &4000				;Base Cart Address
	db "AB"					;Fixed Header
	dw ProgramStart 		;Pointer to start of program
	db 00,00,00,00,00,00	;Unused

	
	;;;Effectively Code starts at address &400A
	

VdpOut_Data equ &98			;For Data writes
VdpOut_Control equ &99		;For Reg settings /Selecting Dest addr in VRAM

VdpBuffer equ &C000
VdpBufferH equ &C0

ProgramStart:			;Program Code Starts Here

	;Set up our screen
	ld c,VdpOut_Control
	ld b,VDPScreenInitData_End-VDPScreenInitData
	ld hl,VDPScreenInitData
	otir	
	
	
	ld hl,&0000+128*8		;Define Tiles 128+ (8 Bytes per tile)
	call VDP_SetWriteAddress

	ld hl,TestSprite		;Copy Tile pixel Data
	ld de,TestSpriteEnd-TestSprite
	call OutiDE

	
	ld hl,&2000+128*8		;Define Tile Palette 128+ (8 Bytes per tile)
	call VDP_SetWriteAddress
	
	ld hl,TestSpritePalette ;Copy Tile Palette Data
	ld de,TestSpritePalette_End-TestSpritePalette
	call OutiDE
	
	
	ld bc,&0808				;Position (X,Y)
	ld hl,&0606				;Size (W,H)
	ld de,&0000+128			;First Tile Num
	call FillAreaWithTiles	;Draw Tiles as a grid
	
	ld bc,&0000				;Position (X,Y)
	ld hl,&0606				;Size (W,H)
	ld de,&0000+128			;First Tile Num
	call FillAreaWithTiles	;Draw Tiles as a grid
	
	ld hl,&1800
	call VDP_SetWriteAddress
	ld hl,VdpBuffer
	ld de,768
	call OutiDE
	

	ld de,0
ScrollAgain:
	
PauseAgain:
	dec bc
	ld a,b
	or c
	jr nz,PauseAgain
	
;MSX SoftScroll
	push de
		ld hl,&1800				;Tilemap
		call VDP_SetWriteAddress
	
		ld hl,VdpBuffer			;Tilemap cache (&C000)
		add hl,de				;Add scroll offset
	
		ld de,768
		call OutiDE				;Send to VRAM
	pop de
	inc de			;Scroll Across
	;ld hl,32		;Scroll down
	;add hl,de		;Scroll down
	;ex de,hl		;Scroll down
	ld bc,&FFFF		;Delay
	
	
	
;MSX2 HVShift	
	; ld a,e	
	; ;;   YYYYXXXX
	; add %00000001				;Xoffset
	; ;add %00010000				;Yoffset
	; ;sub %00000001				;Xoffset
	; ;sub %00010000				;Yoffset
	; ld e,a
	; out (VdpOut_Control), a
	; ld a,128+18					;offset
	; out (VdpOut_Control), a
	; inc de						;Next Tile
	; ld bc,$FFFF					;Delay
	
;MSX2 HVShift + SoftScroll
	; ld a,e
	; and %00000111				;8 pixel shift
	; out (VdpOut_Control), a
	; ld a,128+18
	; out (VdpOut_Control), a

	 ; push de
		 ; ld hl,&1800			;Tilemap
		 ; call VDP_SetWriteAddress
		; srl d					;Remaining bits for soft shift
		; rr e
		; srl d
		; rr e
		; srl d
		; rr e
	
		; ld hl,VdpBuffer			;Tilemap cache (&C000)
		; add hl,de				;Add scroll offset
		; ld de,768
		; call OutiDE				;Send to VRAM
	 ; pop de
	 ; inc de						;Shift position
	 ; ld bc,&2FFF				;Delay

	
;MSX2 Vscroll
	;ld bc,3000					;Delay
	;ld a,e	
	;out (VdpOut_Control), a
	;ld a,128+23					;Vscroll
	;out (VdpOut_Control), a
	;inc de 						;Scroll vertically
	
	
;MSX2+ HShift	
	; ld bc,5000					;Delay
	; push de
		; ld a,e
		; and %00000111
		; out (VdpOut_Control), a
		; ld a,128+27				;Hscroll
		; out (VdpOut_Control), a
		
		; rr d
		; rr e
		; rr e
		; rr e
		; ld a,e
		; and %00111111
		; xor %00111111
		; out (VdpOut_Control), a
		; ld a,128+26				;Hscroll
		; out (VdpOut_Control), a
	; pop de	
	; inc de						;Scroll Horizontally
	
	jp ScrollAgain

	
	
	
TestSprite:			;1 bit per pixel smiley
	incbin "\ResALL\Sprites\RawMSX1.RAW"
TestSpriteEnd:

TestSpritePalette:
	ds 6*8,&60		;Line 1=DarkRed
	ds 6*8,&80		;Line 2=Red
	ds 6*8,&90		;Line 3=Pink
	ds 6*8,&90		;Line 4=Pink
	ds 6*8,&80		;Line 5=Red
	ds 6*8,&60		;Line 6=DarkRed
TestSpritePalette_End:	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VDPScreenInitData:
	db %00000010,128+0	;mode register #0
	db %01100000,128+1	;mode register #1
	db %00000110,128+2	;Pattern table name
	db %10011111,128+3	;colour table (LOW)
	db %00000000,128+4	;pattern generator table
	db %00110110,128+5	;sprite attribute table (LOW)
	db %00000111,128+6	;sprite pattern generator table
	db %11110000,128+7	;border colour/character colour at text mode
VDPScreenInitData_End:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OutiDE:
	outi		;Send a byte from HL to OUT (C)
	dec de
	ld a,d		;Repeat until DE=0
	or e
	jr nz,OutiDE
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetVDPScreenPos:	;Move the VDP write pointer to a memory location by XY location
		ld h,c		;B=Xpos (0-31), C=Ypos (0-23)
		xor a
		
		srl h	;32 bytes per line, so shift L left 5 times, and push any overflow into H
		rr a
		srl h
		rr a
		srl h
		rr a
		
		or b	;Or in the X co-ordinate
		ld l,a
		
		ld a,h
		or VdpBufferH ;18	;Tilemap starts at &1800
		ld h,a
		;call VDP_SetWriteAddress
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VDP_SetWriteAddress:					;Set VRAM address next write will occur
	ld a, l
    out (VdpOut_Control), a		;Send L byte
    ld a, h
    or %01000000				;Set WRITE (0=read)
    out (VdpOut_Control), a		;Send H  byte
	
	ld c,VdpOut_Data			;Set C to data Write Addr
	ret            
	
;Fill an area with consecutively numbered tiles, so we can simulate a bitmap area
;BC = X,Y	HL = W,H	E = Start Tile	
FillAreaWithTiles:	
	push hl
	pop ix
FillAreaWithTiles_Yagain:
	push bc
		push ix
			call GetVDPScreenPos	;Set Dest Ram pos
FillAreaWithTiles_Xagain:
			ld (hl),e		;Write Tile num
			inc e			;Inc tile
			inc hl
			dec ixh			;Are we at end of line?
			jr nz,FillAreaWithTiles_Xagain
		pop ix
	pop bc
	inc c					;Move down a line
	dec ixl					;Are we done?
	jr nz,FillAreaWithTiles_Yagain
	ret