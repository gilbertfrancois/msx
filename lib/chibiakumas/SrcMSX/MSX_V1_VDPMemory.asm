;The MSX2 VDP needs a few control ports to work, in my source, they are defined in the header, but you can always unrem them here!

;VdpIn_Data equ &98
;VdpIn_Status equ &99

;VdpOut_Data equ &98
;VdpOut_Control equ &99
;VdpOut_Palette equ &9A
;VdpOut_Indirect equ &9B

;Vdp_SendByteData equ &9B

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VDP_SetScreenMode4:	
	ld a,%00000110		;6 - set graphics screen mode bits
	out (VdpOut_Control),a
	ld a,128+0		;[ 0 ] [DG ] [IE2] [IE1] [M5] [M4] [M3] [ 0 ]
	out (VdpOut_Control),a
	
	ld a,%01100000  	; Enable Screen - Enable Retrace Interrupt
	out (VdpOut_Control),a
	ld a,128+1		;R#1  [ 0 ] [BL ] [IE0] [M1 ] [ M2] [ 0 ] [SI ] [MAG] 
	out (VdpOut_Control),a
	
	ld a,31
	out (VdpOut_Control),a
	ld a,128+2		;Pattern layout table
	out (VdpOut_Control),a
	
	ld a,239
	out (VdpOut_Control),a
	ld a,128+5		; Sprite Attrib Table Low
	out (VdpOut_Control),a
	
	ld a,%11110000;1	;		Low nibble defines background color (0 or 1 ?)
	out (VdpOut_Control),a
	ld a,128+7		;Text and screen margin color
	out (VdpOut_Control),a
	
	ld a,128
	out (VdpOut_Control),a
	ld a,128+10		;Color Table High (Don't know what this does!)
	out (VdpOut_Control),a
	
	ld a,%00001010		;Set up Vram (Shrug!) [VR=1] [SPD=SpriteDisable] 
	out (VdpOut_Control),a
	ld a,128+8		;R#8  [MS ] [LP ] [TP ] [CB ] [VR ] [ 0 ] [SPD] [BW ] 
	out (VdpOut_Control),a

	ld a,%00000000 		;[LN ]=1 212 lines / [LN ]=0 = 192 lines
	out (VdpOut_Control),a
	ld a,128+9	        ;R#9  [LN ] [ 0 ] [S1 ] [S0 ] [IL ] [E0 ] [*NT] [DC ]
	out (VdpOut_Control),a
	ret


VDP_Wait: 			;Get The status register - Disable interrupts, as they require status register 0 to be selected!
	
	ld a,2			;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	out (VdpOut_Control),a
	ld a,128+15		;R#15  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [S3 ] [S2 ] [S1 ] [S0 ] - Set Stat Reg to read
	out (VdpOut_Control),a

VDP_DoWait:
	in a,(VdpIn_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	ret nc
	jp VDP_DoWait

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VDP_FirmwareSafeWait:
;	di
	call VDP_Wait						;Wait for the VDP to be available
	call VDP_GetStatusFirwareDefault	;Reset selected Status register to 0 for the firmware
;	ei
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VDP_GetStatusFirwareDefault:
	xor a
	jr VDP_GetStatusRegisterB
VDP_GetStatusRegister:		;Get The status register - Disable interrupts!
	ld a,2					;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
VDP_GetStatusRegisterB:
	out (VdpOut_Control),a
	ld a,128+15				;R#15  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [S3 ] [S2 ] [S1 ] [S0 ] - Set Stat Reg to read
	out (VdpOut_Control),a
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VDP_STOP:
	ld a,0
	out (VdpOut_Control),a		
	ld a,128+46
	out (VdpOut_Control),a
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;This function doubles up as HMMM and LMMM, they both use the same parameters, so the OUTI block is the same,
;The only difference is the command byte in register 46
;LMMM = Copy an area of Vram from one place to another - with Logical conditions (Transparency)
;HMMM = Copy an area of Vram from one place to another - Fast (Blit)
											
VDP_HMMM_BusyCheck:		;This function expects status register 2 to be selected - BY FIRMWARE DEFAULT IT IS NOT - so we can't use it in the tutorials
VDP_LMMM_BusyCheck:
	in a,(VdpIn_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	jr c,VDP_LMMM_BusyCheck
						;Need to point HL to a set of command parameters... EG:
VDP_HMMM:				;ld hl,MyHMMM		 (Fast Copy an area of Vram to Vram - BLIT).... or
VDP_LMMM:				;ld hl,MyHMMM		 (Slow Copy an area of Vram to Vram with logical options (Transparency).... or


						;Set the autoinc for more data
	ld a,32				;AutoInc From 32
	out (VdpOut_Control),a		
	ld a,128+17			;R#17  [AII] [ 0 ] [R5 ] [R4 ] [R3 ] [R2 ] [R1 ] [R0 ] 		Indirect Register 128=no inc
	out (VdpOut_Control),a

	ld c,VdpOut_Indirect
	defb &ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3	;outi x 15
	ret
	
VDP_MyLMMM:
VDP_MyLMMM_SX:	defw &0000 ;SX 32,33
VDP_MyLMMM_SY:	defw &0000 ;SY 34,35
VDP_MyLMMM_DX:	defw &0060 ;DX 36,37
VDP_MyLMMM_DY:	defw &0060 ;DY 38,39
VDP_MyLMMM_NX:	defw &0040 ;NX 40,41 
VDP_MyLMMM_NY:	defw &0040 ;NY 42,43
				defb 0     ;Color 44 - unused
VDP_MyLMMM_MV:	defb 0     ;Move 45
VDP_MyLMMM_CM:	defb %10011000 ;Command 46	

VDP_MyHMMM:
VDP_MyHMMM_SX:	defw &0000 ;SX 32,33
VDP_MyHMMM_SY:	defw &0000 ;SY 34,35
VDP_MyHMMM_DX:	defw &0060 ;DX 36,37
VDP_MyHMMM_DY:	defw &0060 ;DY 38,39
VDP_MyHMMM_NX:	defw &0040 ;NX 40,41 
VDP_MyHMMM_NY:	defw &0040 ;NY 42,43
				defb 0     ;Color 44 - unused
VDP_MyHMMM_MV:	defb 0     ;Move 45
				defb %11010000 ;Command 46	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;HMMC allows us to OUT data to the VDP, which will use it to fill an area of the screen,
;it's slow, but this is effectively how we define sprites in VRAM, or show generated content (Like the chibiakumas gradient)
;an alternative is to use direct memory address selection.

										;Need to point HL to a set of command parameters... EG:
										;ld hl,MyHMMC		 (High speed move CPU to VRAM) (Blit Bytes from OUTI)
VDP_HMMC_Generated_BusyCheck:			;This function expects status register 2 to be selected - BY FIRMWARE DEFAULT IT IS NOT - so we can't use it in the tutorials
	in a,(VdpIn_Status)					;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	jr c,VDP_HMMC_Generated_BusyCheck
VDP_HMMC_Generated:						;Fill ram from calculated values (first in A)

	;Set the autoinc for more data
	ld a,36				;AutoInc From 36
	out (VdpOut_Control),a		
	ld a,128+17			;R#17  [AII] [ 0 ] [R5 ] [R4 ] [R3 ] [R2 ] [R1 ] [R0 ] 		Indirect Register 128=no inc
	out (VdpOut_Control),a

	ld c,VdpOut_Indirect
	defb &ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3	;	outi X 11

	ld a,128+44			;128 = NO Increment ;R#44    Color byte
	out (VdpOut_Control),a		
	ld a,128+17			;R#17  [AII] [ 0 ] [R5 ] [R4 ] [R3 ] [R2 ] [R1 ] [R0 ] 		Indirect Register
	out (VdpOut_Control),a
	ret




VDP_MyHMMC:
VDP_MyHMMC_DX:	defw &0000 ;DX 36,37
VDP_MyHMMC_DY:	defw &0000 ;DY 38,39
VDP_MyHMMC_NX:	defw &0032 ;NX 40,41
VDP_MyHMMC_NY:	defw &0032 ;NY 42,43
VDP_MyHMMCByte:	defb 255   ;Color 44
				defb 0     ;Move 45
				defb %11110000 ;Command 46	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; HMMV will flood fill a square area with a single byte, it's far faster than copying areas even with HMMM
; This Hyper version is a 'FAST FILL' function...  it uses the Z80 to fill the screen while the VDP is busy,
; then gets the VDP to finish the job once it's ready to work!
	
	
;Ypos in C
;333x222222211111111
;sss-mrrrrrrrccccccc	=screen,row,col, M 1=write, 0=read
   ; 100000000000000  = half way down the screen!

VDP_HMMV_Hyper:			
	ld a,(VDP_MyHMMV_DY)
	ld b,a
	xor a
	ld c,a
	ld a,(VDP_MyHMMV_DY+1)
	rra
	rr b
	rr c
	rlc     b
	rla
	rlc     b
	rla
	srl     b
	srl     b
	
	out     (VdpOut_Control),a       ;set bits 15-17
	ld      a,14+128
	out     (VdpOut_Control),a
	ld      a,c           ;set bits 0-7
	out     (VdpOut_Control),a
	ld      a,b           ;set bits 8-14
	or      64            ; 64= write access 0=read
	out     (VdpOut_Control),a 
	
	ld a,(VDP_MyHMMV_NY)
	ld c,a
	ld h,a
	ex af,af'
	ld a,(VDP_MyHMMV_Byte)
;	ld a,128
	di
VDP_HMMV_HyperAgain:
	ld b,8
VDP_HMMV_Hyperb:
	
	out (VdpIn_Data),a		;16 out commands (32 pixels)
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	out (VdpIn_Data),a
	djnz VDP_HMMV_Hyperb	;carry on with the fill job
	
	ex af,af'
	in a,(VdpIn_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	jr nc,VDP_HMMV_HyperDone ;finished waiting
	ex af,af'
	dec c
	jp nz,VDP_HMMV_HyperAgain
	ret
VDP_HMMV_HyperDone:
	ld (VDP_MyHMMV_NY),bc
	ld a,h
	sub c
	ld c,a
;	ld b,0
	ld hl,(VDP_MyHMMV_DY)
	add hl,bc
	ld (VDP_MyHMMV_DY),hl

	ld hl,VDP_MyHMMV
	jp VDP_OutFrom36

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; HMMV will flood fill a square area with a single byte, it's far faster than copying areas even with HMMM


							;Need to point HL to a set of command parameters... EG:
							;ld hl,MyHMMV		;HMMV (High speed move VDP to VRAM) (Flood Fill Byte)
VDP_HMMV_BusyCheck:			;This function expects status register 2 to be selected - BY FIRMWARE DEFAULT IT IS NOT - so we can't use it in the tutorials
	in a,(VdpIn_Status)		;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	jr c,VDP_HMMV_BusyCheck
VDP_HMMV:	
VDP_OutFrom36:
	ld a,36				;AutoInc From 36
	out (VdpOut_Control),a		
	ld a,128+17			;R#17  [AII] [ 0 ] [R5 ] [R4 ] [R3 ] [R2 ] [R1 ] [R0 ] 		Indirect Register 128=no inc
	out (VdpOut_Control),a

	ld c,VdpOut_Indirect
	defb &ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3
	ret
	
VDP_MyHMMV:	
VDP_MyHMMV_DX:	defw &0000 ;DX 36,37
VDP_MyHMMV_DY:	defw &0000 ;DY 38,39
VDP_MyHMMV_NX:	defw &0100 ;NX 40,41
VDP_MyHMMV_NY:	defw &00C0 ;NY 42,43
VDP_MyHMMV_Byte:defb 64   ;Color 44
				defb 0     ;Move 45
				defb %11000000 ;Command 46	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		
; Move the Read/Write pointer to a new location we can then use IN/OUT with port &98 to read or write data
; TO/FROM the memory address we selected 

VDP_SetReadAddress:
	ld C,0									;Need to set bit 6 to 0 for READ
	jr VDP_SetAddress
VDP_SetWriteAddress:
	ld C,64									;Need to set bit 6 to 1 for WRITE
	
VDP_SetAddress:								;Memory address is defined using 17 bits
;       A        H        L					;As it's 128k
;00000001 11111111 11111111
	      rlc     h
              rla
              rlc     h
              rla
              srl     h
              srl     h
              di
              out     (VdpOut_Control),a	;set bits 15-17
              ld      a,14+128
              out     (VdpOut_Control),a
              ld      a,l           		;set bits 0-7
              nop
              out     (VdpOut_Control),a
              ld      a,h           		;set bits 8-14
              or      C            			;64= write access 0=read
              ei
              out     (VdpOut_Control),a 
	      ld c,VdpIn_Data      
              ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

VDP_LDIR_ToVDP:
	;HL - SRC in ram
	;ADE - Dest in Vram
	;BC  - Bytecount
	push bc
	push hl
		ld h,d
		ld l,e
		call VDP_SetWriteAddress
	pop hl
	pop de

	ld b,e
	ld e,0
VDP_LDIR_ToVDP_Repeater:
	otir
	dec d
	jr nz,VDP_LDIR_ToVDP_Repeater
	ret

VDP_LDIR_FromVDP:
	;AHL - SRC in vram
	;DE - Dest in ram
	;BC  - Bytecount
	push de
	push bc
		call VDP_SetReadAddress
	pop de
	pop hl
	ld b,e
	ld e,0
	VDP_LDIR_FromVDP_Repeater:
	inir
	dec d
	jr nz,VDP_LDIR_FromVDP_Repeater
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LastPalAddress: defw &0000
VDP_SetPalette:
	ld (LastPalAddress),hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; palette setup

;	R#16  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [C3 ] [C2 ] [C1 ] [C0 ]  - Set AutoInc Palette register
;	Port #2 first byte  0  R2  R1  R0  0  B2  B1  B0 	Data 1   - Red data  Blue data 
;	Port #2 second byte 0  0   0   0   0  G2  G1  G0 	Data 2 	- Green data 	
;	
	ld b,16
VDP_SetPalettePartial:
	
	ld a,0				;Set First Pallete to change
	out (VdpOut_Control),a
	ld a,128+16			;Copy Value to Register 16 (Palette)
	out (VdpOut_Control),a

VDP_morepal:
	ld a,(hl)
	and %11101110
	rrca
	inc hl
	out (VdpOut_Palette),a
	ld a,(hl)
	and %11101110
	rrca
	inc hl
	out (VdpOut_Palette),a
	djnz VDP_morepal
	ret
 