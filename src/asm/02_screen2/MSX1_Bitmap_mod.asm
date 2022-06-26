
;For Cartridge	
	org $4000				;Base Cart Address
	db "AB"					;Fixed Header
	dw ProgramStart 		;Pointer to start of program
	db 00,00,00,00,00,00	;Unused
	
	;Effectively Code starts at address $400A
	

VdpOut_Data equ $98			;For Data writes
VdpOut_Control equ $99		;For Reg settings /Selecting Dest addr in VRAM
RomSize        equ $4000    ;Used for padding to valid rom size
CHGMOD         equ $005f

ProgramStart:			;Program Code Starts Here

    ; Set up our screen to graphics mode 2
    ld a, 2
    call CHGMOD
	
	ld hl,$0000+128*8		;Define Tiles 128+ (8 Bytes per tile)
	call VDP_SetWriteAddress
	
	ld hl,TestSprite		;Copy Tile pixel Data
	ld b,8 					;Bytes
    call CopyToVRAM
	
	ld hl,$2000+128*8		;Define Tile Palette 128+ (8 Bytes per tile)
	call VDP_SetWriteAddress
	
	ld hl,TestSpritePalette ;Copy Tile Palette Data
	ld b,8 					;Bytes
    call CopyToVRAM

	ld bc,$0807				;X,Y pos
	call GetVDPScreenPos
	ld a,128				;Tile 128
	out (c),a
	
    di
	halt 	

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
CopyToVRAM:
    ; Don't use otir on MSX1 for VDP operations. Instead, use
    ; this slower loop.
    ; See http://map.grauw.nl/articles/vdp_tut.php#vramtiming
    outi;
    jp nz, CopyToVRAM
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
	
	
ProgEnd:
    ds $4000 + RomSize - ProgEnd, 255
