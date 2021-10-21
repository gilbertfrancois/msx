; ROM header
    org $4000
    db "AB"     ; magic number
    dw Execute  ; program execution address
    dw 0, 0, 0, 0, 0, 0

VDPOutData    equ $98
VDPOutControl equ $99

RomSize equ $4000

Execute:
    ; ld a, 2
    ; call CHGMOD
    ld c, VDPOutControl
    ld b, VDPScreenInitDataEnd - VDPScreenInitData
    ld hl, VDPScreenInitData
    otir

    di
    halt

VDPScreenInitData:
	;	Value   ,Register
	db $00000010,128+0	;mode register #0
	db $01100000,128+1	;mode register #1
	db $10011111,128+3	;colour table (LOW)
	db $00000000,128+4	;pattern generator table
    db $00110110,128+5	;sprite attribute table (LOW)
	db $00000111,128+6	;sprite pattern generator table
	db $11110000,128+7	;border colour/character colour at text mode
VDPScreenInitDataEnd:

;VDPScreenInitData:
;	;	Value   ,Register
;	db $00000010,128+0	;mode register #0
;	db $11100000,128+1	;mode register #1
;    db $00001110,128+2
;	db $11111111,128+3	;colour table (LOW)
;	db $00000011,128+4	;pattern generator table
;	db $01110110,128+5	;sprite attribute table (LOW)
;	db $00000011,128+6	;sprite pattern generator table
;	db $00001111,128+7	;border colour/character colour at text mode
;VDPScreenInitDataEnd:

ProgEnd:
; Padding with 255 to make the file of 16K size (can be 4K, 8K, 16k, etc) but
; some MSX emulators or Rom loaders can not load 4K/8K Roms.
; (Alternatively, include macros.asm and use ALIGN 4000H)
	ds $4000 + RomSize - ProgEnd, 255	; 8000h+RomSize-End if org 8000h 


