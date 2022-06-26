
;For Cartridge	
	org $4000				;Base Cart Address
	db "AB"					;Fixed Header
	dw ProgramStart 		;Pointer to start of program
	db 00,00,00,00,00,00	;Unused
	
	;Effectively Code starts at address $400A
	

VdpOut_Data equ $98			;For Data writes
VdpOut_Control equ $99		;For Reg settings /Selecting Dest addr in VRAM

ProgramStart:			;Program Code Starts Here

	;Set up our screen
	ld c,VdpOut_Control
	ld b,VDPScreenInitData_End-VDPScreenInitData
	ld hl,VDPScreenInitData
	otir	
	
	
	
	ld hl,$0000+128*8		;Define Tiles 128+ (8 Bytes per tile)
	call VDP_SetWriteAddress
	
	ld hl,TestSprite		;Copy Tile pixel Data
	ld b,8 					;Bytes
	otir					;C=VdpOut_Data
	
	ld hl,$2000+128*8		;Define Tile Palette 128+ (8 Bytes per tile)
	call VDP_SetWriteAddress
	
	ld hl,TestSpritePalette ;Copy Tile Palette Data
	ld b,8 					;Bytes
	otir					;C=VdpOut_Data
		
	ld bc,$0808				;X,Y pos
	call GetVDPScreenPos
	
	ld a,128				;Tile 128
	out (c),a
	
	
	DI					;Can't RET on Cartridge
	Halt 	

TestSprite:				;1 bit per pixel smiley
	db %00111100	
	db %01111110	
	db %11011011	
	db %11111111	
	db %11111111	
	db %11011011	
	db %01100110	
	db %00111100

TestSpritePalette:
	;   FB 		=Fore		Back	
	db $A0		;DarkYellow	Black
	db $A0		;DarkYellow	Black
	db $BC		;Yellow		DarkGreen
	db $BC		;Yellow		DarkGreen
	db $BC		;Yellow		DarkGreen
	db $BC		;Yellow		DarkGreen
	db $AC		;DarkYellow	DarkGreen
	db $A0		;DarkYellow	Black
	
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VDPScreenInitData:
	;	Value   ,Register
	db %00000010,128+0	;mode register #0
	db %01100000,128+1	;mode register #1
	db %10011111,128+3	;colour table (LOW)
	db %00000000,128+4	;pattern generator table
	db %00110110,128+5	;sprite attribute table (LOW)
	db %00000111,128+6	;sprite pattern generator table
	db %11110000,128+7	;border colour/character colour at text mode
VDPScreenInitData_End:

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
		or $18	;Tilemap starts at $1800
		ld h,a
		call VDP_SetWriteAddress
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VDP_SetWriteAddress:		;Set VRAM address next write will occur
	ld a, l
    out (VdpOut_Control), a	;Send L byte
    ld a, h
    or %01000000			;Set WRITE (0=read)
    out (VdpOut_Control), a	;Send H  byte
	
	ld c,VdpOut_Data		;Set C to data Write Addr
	ret            
	
	
