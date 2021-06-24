; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		MSX Bitmapheader
;Version	V1.2
;Date		2018/7/5

;Changes	Bitshifts have been altered on b/w printing, they now print in color 15 on all systems, or color 3 on 4 color systems

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BmpByteWidth equ 4
CharByteWidth equ 4

VdpIn_Data equ &98
VdpIn_Status equ &99

VdpOut_Data equ &98
VdpOut_Control equ &99


VdpOut_Palette equ &9A
VdpOut_Indirect equ &9B

Vdp_SendByteData equ &9B


;V9990 functions
	ifdef V9K
Vdp9k_Data equ &60	;VRAM data port
Vdp9k_Palette equ &61	;Palette data port
Vdp9k_Command equ &62	;Command data port
Vdp9k_RegData equ &63	;Register data port
Vdp9k_RegSel equ &64	;Register select port (write only)
Vdp9k_Status equ &65	;Status port (read only)
Vdp9k_Interrupt equ &66	;Interrupt flag port
Vdp9k_System equ &67	;System control port (write only)
Vdp9k_Superimpose equ &6F
	endif






	macro NextScrByte				;MSX autoincrements, so we do nothing here!
	endm
	ifndef vasm
		macro SetScrByte newbyte
			ld a,newbyte
			out (VdpOut_Data),a			;We have to send data to the VDP with OUT commands
		endm
	else
		macro SetScrByte,newbyte
			ld a,\newbyte
			out (VdpOut_Data),a			;We have to send data to the VDP with OUT commands
		endm
	endif
	macro ScreenStopDrawing
	endm
	macro ScreenStartDrawing
	endm
	macro SetScrByteBW
		push af
		push bc
			ld b,a				;2 pixels per byte - so lots of shifting!
			xor a
			rl b
			rla
			rlca
			rlca
			rlca
			rl b
			rl a
			ld c,a
			rlca
			or c
			rlca
			or c
			rlca
			or c
			out (VdpOut_Data),a
			xor a
			rl b
			rla
			rlca
			rlca
			rlca
			rl b
			rl a
			ld c,a
			rlca
			or c
			rlca
			or c
			rlca
			or c
			out (VdpOut_Data),a
			xor a
			rl b
			rla
			rlca
			rlca
			rlca
			rl b
			rl a
			ld c,a
			rlca
			or c
			rlca
			or c
			rlca
			or c
			out (VdpOut_Data),a
			xor a
			rl b
			rla
			rlca
			rlca
			rlca
			rl b
			rl a
			ld c,a
			rlca
			or c
			rlca
			or c
			rlca
			or c
			out (VdpOut_Data),a
		pop bc
		pop af
		NextScrByte				;Send the byte to screen
	endm
