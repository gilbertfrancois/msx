
;VdpIn_Data equ &98
;VdpIn_Status equ &99

;VdpOut_Data equ &98
;VdpOut_Control equ &99
;VdpOut_Palette equ &9A
;VdpOut_Indirect equ &9B

Vdp_SendByteData equ &62


Vdp9k_Data equ &60	;VRAM data port
Vdp9k_Palette equ &61	;Palette data port
Vdp9k_Command equ &62	;Command data port
Vdp9k_RegData equ &63	;Register data port
Vdp9k_RegSel equ &64	;Register select port (write only)
Vdp9k_Status equ &65	;Status port (read only)
Vdp9k_Interrupt equ &66	;Interrupt flag port
Vdp9k_System equ &67	;System control port (write only)
Vdp9k_Superimpose equ &6F


;#68-#69	Primary standard Kanji ROM address port (write only) (not used in Gfx9000)
;#69	Primary standard Kanji ROM data port (read only) (not used in Gfx9000)
;#6A-#6B	Secondary standard Kanji ROM address port (write only) (not used in Gfx9000)
;#6B	Secondary standard Kanji ROM data port (read only) (not used in Gfx9000)
;#6C-#6E	Reserved
;#6F	v7040 superimpose chip (write only) (both Gfx9000 and Video9000)





VDP_SetScreenMode4:
;B1 0 2 0 0-3 0-3  /  0 0/1 0/1 0/1 0/1 0/1 0  
	ld a,0
	out (Vdp9k_Superimpose),a

	ld a,0
	out (Vdp9k_System),a

	ld a,6			
	out (Vdp9k_RegSel),a
	ld c,Vdp9k_RegData
	ld a,%10000001
	out (c),a
	ld a,%00000000
	out (c),a

	ld a,8
	out (Vdp9k_RegSel),a
	ld a,&C2
	out (Vdp9k_RegData),a
	

	ld a,14
	out (Vdp9k_RegSel),a
	ld a,0
	out (Vdp9k_RegData),a
	ld a,0
	out (Vdp9k_Palette),a
	out (Vdp9k_Palette),a
	out (Vdp9k_Palette),a

	;Border --BBBBBB
	ld a,15
	out (Vdp9k_RegSel),a
	ld a,0
	out (Vdp9k_RegData),a


	;Screen offset VVVVHHHH
	ld a,16
	out (Vdp9k_RegSel),a
	ld a,%10000000
	out (Vdp9k_RegData),a




	;set default fill commands
	ld a,44
	out (Vdp9k_RegSel),a
	xor a
	out (Vdp9k_RegData),a


	ld a,%00001100		;logical op (reg 45)
	out (c),a

	ld a,255
	out (c),a		;Masks
	out (c),a		;Masks
	

	ret


VDP_Wait: 

	;Get The status register - Disable interrupts!
	ld a,2			;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	out (VdpOut_Control),a
	ld a,128+15		;R#15  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [S3 ] [S2 ] [S1 ] [S0 ] - Set Stat Reg to read
	out (VdpOut_Control),a

VDP_DoWait:
	in a,(Vdp9k_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	ret nc
	jr VDP_DoWait

VDP_FirmwareSafeWait:
;	di
	call VDP_Wait
	call VDP_GetStatusFirwareDefault
;	ei
	ret

VDP_GetStatusFirwareDefault:
	xor a
	jr VDP_GetStatusRegisterB
VDP_GetStatusRegister:
	;Get The status register - Disable interrupts!
	ld a,2			;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
VDP_GetStatusRegisterB:
	out (VdpOut_Control),a
	ld a,128+15		;R#15  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [S3 ] [S2 ] [S1 ] [S0 ] - Set Stat Reg to read
	out (VdpOut_Control),a
	ret

VDP_STOP:
	ld a,52
	out (Vdp9k_RegSel),a
	     ;CCCC----
	ld a,%00000000;4	LMMM	Rectangle area data is transferred from VRAM to VRAM. 
	out (Vdp9k_RegData),a
	ret


VDP_HMMM_BusyCheck:
	in a,(Vdp9k_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	jr c,VDP_HMMM_BusyCheck
VDP_HMMM:	;(High speed move VRAM to VRAM) (Blit Bytes)


	ld a,32			;Auto Inc from 36
	out (Vdp9k_RegSel),a
	ld c,Vdp9k_RegData

	;outi x 12
	defb &ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3
;&ED,&A3,&ED,&A3,&ED,&A3

	;set default fill commands
	ld a,45
	out (Vdp9k_RegSel),a
	ld a,%00001100		;logical op
	out (c),a


	ld a,52
	out (Vdp9k_RegSel),a
	     ;CCCC----
	ld a,%01000000;4	LMMM	Rectangle area data is transferred from VRAM to VRAM. 
	out (c),a
;	ld c,Vdp9k_Command

	ret


VDP_MyHMMM:
VDP_MyHMMM_SX:	defw &0000 ;SY 32,33
VDP_MyHMMM_SY:	defw &0000 ;SY 34,35
VDP_MyHMMM_DX:	defw &0060 ;DX 36,37
VDP_MyHMMM_DY:	defw &0060 ;DY 38,39
VDP_MyHMMM_NX:	defw &0040 ;NX 40,41 
VDP_MyHMMM_NY:	defw &0040 ;NY 42,43
		defb 0     ;Color 44 - unused
VDP_MyHMMM_MV:	defb 0     ;Move 45
		defb %11010000 ;Command 46	





VDP_LMMM_BusyCheck:
	in a,(Vdp9k_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	jr c,VDP_LMMM_BusyCheck
VDP_LMMM:	
	;Copy an area of Vram from one place to another - with Logical conditions (Transparency)

	;Set the autoinc for more data
;	ld a,32				;AutoInc From 36
;	out (VdpOut_Control),a		
;	ld a,128+17			;R#17  [AII] [ 0 ] [R5 ] [R4 ] [R3 ] [R2 ] [R1 ] [R0 ] 		Indirect Register 128=no inc
;	out (VdpOut_Control),a

	ld a,32			;Auto Inc from 36
	out (Vdp9k_RegSel),a
	ld c,Vdp9k_RegData

	;outi x 12
	defb &ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3
;&ED,&A3,&ED,&A3,&ED,&A3


	;set default fill commands
	ld a,45
	out (Vdp9k_RegSel),a
	ld a,%00011100		;logical op
	out (c),a



	ld a,52
	out (Vdp9k_RegSel),a
	     ;CCCC----
	ld a,%01000000;4	LMMM	Rectangle area data is transferred from VRAM to VRAM. 
	out (c),a
	;ld c,Vdp9k_Command
	ret
	
	
	
VDP_MyLMMM:
VDP_MyLMMM_SX:	defw &0000 ;SY 32,33
VDP_MyLMMM_SY:	defw &0000 ;SY 34,35
VDP_MyLMMM_DX:	defw &0060 ;DX 36,37
VDP_MyLMMM_DY:	defw &0060 ;DY 38,39
VDP_MyLMMM_NX:	defw &0040 ;NX 40,41 
VDP_MyLMMM_NY:	defw &0040 ;NY 42,43
		defb 0     ;Color 44 - unused
VDP_MyLMMM_MV:	defb 0     ;Move 45
VDP_MyLMMM_CM:	defb %10011000 ;Command 46	









VDP_HMMC_Generated_BusyCheck:
	in a,(Vdp9k_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	jr c,VDP_HMMC_Generated_BusyCheck
VDP_HMMC_Generated:			;Fill ram from calculated values (first in A)
;	ld hl,MyHMMC		 (High speed move CPU to VRAM) (Blit Bytes from OUTI)

	ld a,36			;Auto Inc from 36
	out (Vdp9k_RegSel),a
	ld c,Vdp9k_RegData


;	outi X 8
	defb &ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3

	ld a,(hl)
	push af
		inc hl

		outi


		;set default fill commands
		ld a,45
		out (Vdp9k_RegSel),a
		ld a,%00001100		;logical op
		out (c),a

		ld a,52
		out (Vdp9k_RegSel),a
			 ;CCCC----
		ld a,%00010000;1		LMMC		Data is transferred from CPU to VRAM rectangle area.
		out (c),a
		ld c,Vdp9k_Command
	;	ld a,(VDP_MyHMMCByte)
	pop af
		out (c),a

	ret




VDP_MyHMMC:
VDP_MyHMMC_DX:	defw &0000 ;DX 36,37
VDP_MyHMMC_DY:	defw &0000 ;DY 38,39
VDP_MyHMMC_NX:	defw &0032 ;NX 40,41
VDP_MyHMMC_NY:	defw &0032 ;NY 42,43
VDP_MyHMMCByte:	defb 255   ;Color 44
	defb 0     ;Move 45
	defb %11110000 ;Command 46	


VDP_HMMV_BusyCheck:
	in a,(Vdp9k_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	rra
	jr c,VDP_HMMV_BusyCheck
VDP_HMMV:	
;	ld hl,MyHMMV		;HMMV (High speed move VDP to VRAM) (Flood Fill Byte)
;	ld hl,MyHMMC		 (High speed move CPU to VRAM) (Blit Bytes from OUTI)

	ld a,36			;Auto Inc from 36
	out (Vdp9k_RegSel),a
	ld c,Vdp9k_RegData


;	outi X 8
	defb &ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3,&ED,&A3

;	ld a,(hl)
;push af


	;set default fill commands
	ld a,48	;Auto Inc from 48
	out (Vdp9k_RegSel),a
	outi		; paint the fill byte to 48,49
	dec hl
	outi

;pop af
;	out (c),a

	ld a,52
	out (Vdp9k_RegSel),a
	     ;CCCC----
	ld a,%00100000	;2 LMMV VRAM rectangle area is painted out.  
	out (c),a
	ld c,Vdp9k_Command

	ret


VDP_MyHMMV:	
VDP_MyHMMV_DX:	defw &0000 ;DX 36,37
VDP_MyHMMV_DY:	defw &0000 ;DY 38,39
VDP_MyHMMV_NX:	defw &0100 ;NX 40,41
VDP_MyHMMV_NY:	defw &00C0 ;NY 42,43
VDP_MyHMMV_Byte:defb 64   ;Color 44
		defb 0     ;Move 45
		defb %11000000 ;Command 46	

VDP_SetReadAddress:
	push af
		ld a,3
	jr VDP_SetAddress
VDP_SetWriteAddress:

;       A        H        L
;00000001 11111111 11111111
	push af

		ld a,0
VDP_SetAddress:
		out (Vdp9k_RegSel),a
		ld a,l
		out (Vdp9k_RegData),a
		ld a,h
		out (Vdp9k_RegData),a
	pop af	
	out (Vdp9k_RegData),a
	ld c,Vdp9k_Data

;	      rlc     h
;              rla
;              rlc     h
;              rla
;              srl     h
;              srl     h
;              di
;              out     (VdpOut_Control),a       ;set bits 15-17
;              ld      a,14+128
;              out     (VdpOut_Control),a
;              ld      a,l           ;set bits 0-7
;              nop
;              out     (VdpOut_Control),a
;              ld      a,h           ;set bits 8-14
;              or      C            ; 64= write access 0=read
;              ei
;              out     (VdpOut_Control),a 
;	      ld c,VdpIn_Data      
              ret


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
;
;Set VDP port #98 to start reading at address AHL (17-bit)
;;
;SetVdp_Read  rlc     h
;              rla
;              rlc     h
;              rla
;              srl     h
;              srl     h
;              di
;              out     (#99),a       ;set bits 15-17
;              ld      a,14+128
;              out     (#99),a
;              ld      a,l           ;set bits 0-7
;              nop
;              out     (#99),a
;              ld      a,h           ;set bits 8-14
;              ei                    ; + read access
;              out     (#99),a
;              ret





LastPalAddress: defw &0000
VDP_SetPalette:
	ld (LastPalAddress),hl

;;;;;;;;;;;;;;;;;;;;;;;;;;;
; palette setup

;	R#16  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [C3 ] [C2 ] [C1 ] [C0 ]  - Set AutoInc Palette reg	ister
;	Port #2 first byte  0  R2  R1  R0  0  B2  B1  B0 	Data 1   - Red data  Blue data 
;	Port #2 second byte 0  0   0   0   0  G2  G1  G0 	Data 2 	- Green data 	
;	
	ld b,16
VDP_SetPalettePartial:
	


	
;	ld a,0				;Set First Pallete to change
;	out (VdpOut_Control),a
;	ld a,128+16			;Copy Value to Register 16 (Palette)
;	out (VdpOut_Control),a
	ld a,14
	out (Vdp9k_RegSel),a
	xor a
	out (Vdp9k_RegData),a
;	ld a,16
;	sub b
;	rlca
;	rlca

VDP_morepal:
;	di
;	halt

	;need ---xxxxx
	ld a,(hl)
	and  %11110000
	rrca
	rrca
	rrca
	out (Vdp9k_Palette),a

	inc hl
	ld a,(hl)
	and  %00001111
	rlca
;	rlca
	out (Vdp9k_Palette),a
;	inc hl

	dec hl
	ld a,(hl)
	and  %00001111
	rlca
;	rlca
	out (Vdp9k_Palette),a
	inc hl
	inc hl
	djnz VDP_morepal
	

	ret


;ScreenBuffer_YY:
;defw &0000
;ScreenBuffer_Flip:
;	ld a,0	ScreenBuffer_Screen_Plus1
;	ld (ScreenBuffer_YY+1),a
;	xor 1	
;	ld (ScreenBuffer_Screen_Plus1-1),a
;
;	push af
;		ld a,18
;		out (Vdp9k_RegSel),a
;	pop af
;	out (Vdp9k_RegData),a
;
;
;ret



;ScreenBufferMSX_Reset
;ScreenBufferMSX_Init
ScreenBufferMSX_YY:
	defw &0000
ScreenBuffer_Init:
	xor a
	jr ScreenBuffer_Initb
ScreenBuffer_Flip:



	in a,(Vdp9k_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	bit 6,a
	jr nz,ScreenBuffer_Flip


	ld a,0	;<-- SM ***
ScreenBufferMSX_Screen_Plus1:
ScreenBuffer_Initb:
	call ScreenBuffer_Alt
	xor 1	
	ld (ScreenBufferMSX_Screen_Plus1-1),a
ScreenBuffer_Apply:
	push af
		ld a,18
		out (Vdp9k_RegSel),a
	pop af
	out (Vdp9k_RegData),a

	ei			; The V9900 is so fast we need to check it's actually flipped before drawing more!

	halt ;<-- SM ***
TwoHalts_Plus1:

	call RefreshWait1

	ld a,76  ;<-- SM ***
TwoHaltsReenable_Plus1:
	ld (TwoHalts_Plus1-1),a
	ret
ScreenBuffer_Reset:
	xor a
	ld (ScreenBufferMSX_Screen_Plus1-1),a
	call ScreenBuffer_Alt
	jr ScreenBuffer_Apply

ScreenBuffer_Alt:
	;CHIBIAKUMAS SPECIALS!
	;ld (VDP_Star_DY+1),a
	;ld (ScreenBufferMSX_YY+1),a
	;ld (SprShow_Y_Plus2-1),a	;Only need to frig with one byte!
	;ld (DrawTextYPosB_Plus1-1),a
	;ld (TileDestY_Plus2-1),a
	ret
	


RefreshWait1:
	in a,(Vdp9k_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
	bit 6,a
	jr z,RefreshWait1
RefreshWait2:

;	in a,(Vdp9k_Status)	;S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2
;	bit 6,a
;	jr nz,RefreshWait2
	ret


;CLSB
;CLS
;	xor a
;	ld (VDP_MyHMMV_Byte),a
;	ld h,a
;	ld l,a
;	ld (VDP_MyHMMV_DX),hl
;	ld hl,(ScreenBufferMSX_YY)
;	ld (VDP_MyHMMV_DY),hl	
;	ld hl,256
;	ld (VDP_MyHMMV_NX),hl
;	ld hl,192
;	ld (VDP_MyHMMV_NY),hl
;	ld hl,VDP_MyHMMV
;	jp VDP_HMMV_BusyCheck