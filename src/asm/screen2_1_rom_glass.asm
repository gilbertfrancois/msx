; ROM header
    org $4000
    db "AB"     ; magic number
    dw Execute  ; program execution address
    dw 0, 0, 0, 0, 0, 0

VDPOutData    equ $98
VDPOutControl equ $99

RomSize equ $4000
CHGMOD  equ $005f

Execute:
    ld a, 2
    call CHGMOD

    ld bc, 0e201h  ; write 1110 0010 = 0xe2 to VDP(1) 
    call WRTVDP
    ; ld c, VDPOutControl
    ; ld b, VDPScreenInitDataEnd - VDPScreenInitData
    ; ld hl, VDPScreenInitData
    ; otir

	ld hl, $0000 + 128 * 8		;Define Tiles 128+ (8 Bytes per tile)
	call VDPSetWriteAddress
	
	ld hl, TestSprite		;Copy Tile pixel Data
	ld b, 8 				;Bytes
	otir					;C=VdpOut_Data
	
	ld hl, $2000 + 128 * 8		;Define Tile Palette 128+ (8 Bytes per tile)
	call VDPSetWriteAddress
	
	ld hl, TestSpritePalette ;Copy Tile Palette Data
	ld b, 8 					;Bytes
	otir					;C=VdpOut_Data
		
	ld bc, $0808				;X,Y pos
	call GetVDPScreenPos
	
	ld a, 128				;Tile 128
	out (c), a

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
	
VDPSetWriteAddress:
    ld a, l
    out (VDPOutControl), a
    ld a, h
    or $01000000
    out (VDPOutControl), a
    ld c, VDPOutData
    ret

GetVDPScreenPos:
    ld h, c ; B=xpos (0, 31), C=ypos (0, 23)
    xor a
    
    srl h	;32 bytes per line, so shift L left 5 times, and push any overflow into H
    rr a
    srl h
    rr a
    srl h
    rr a
    
    or b	;Or in the X co-ordinate
    ld l, a
    
    ld a, h
    or $18	;Tilemap starts at &1800
    ld h, a
    call VDPSetWriteAddress
	ret


;VDPScreenInitData:
;	;	Value   ,Register
;	db $00000010,128+0	;mode register #0
;	db $01100000,128+1	;mode register #1
;	db $10011111,128+3	;colour table (LOW)
;	db $00000000,128+4	;pattern generator table
;	db $00110110,128+5	;sprite attribute table (LOW)
;	db $00000111,128+6	;sprite pattern generator table
;	db $11110000,128+7	;border colour/character colour at text mode
;VDPScreenInitDataEnd:

VDPScreenInitData:
	;	Value   ,Register
	db %00000010, 128 + 0	;mode register #0
	db %11100000, 128 + 1	;mode register #1
    db %00001110, 128 + 2
	db %11111111, 128 + 3	;colour table (LOW)
	db %00000011, 128 + 4	;pattern generator table
	db %01110110, 128 + 5	;sprite attribute table (LOW)
	db %00000011, 128 + 6	;sprite pattern generator table
	db %00001111, 128 + 7	;border colour/character colour at text mode
VDPScreenInitDataEnd:

ProgEnd:
; Padding with 255 to make the file of 16K size (can be 4K, 8K, 16k, etc) but
; some MSX emulators or Rom loaders can not load 4K/8K Roms.
; (Alternatively, include macros.asm and use ALIGN 4000H)
	ds $4000 + RomSize - ProgEnd, 255	; 8000h+RomSize-End if org 8000h 


