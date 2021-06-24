BmpByteWidth equ 1
CharByteWidth equ 1

VdpIn_Data equ &98
VdpIn_Status equ &99

VdpOut_Data equ &98
VdpOut_Control equ &99


VdpOut_Palette equ &9A
VdpOut_Indirect equ &9B

Vdp_SendByteData equ &9B


;V9990 functions
;Vdp9k_Data equ &60	;VRAM data port
;Vdp9k_Palette equ &61	;Palette data port
;Vdp9k_Command equ &62	;Command data port
;Vdp9k_RegData equ &63	;Register data port
;Vdp9k_RegSel equ &64	;Register select port (write only)
;Vdp9k_Status equ &65	;Status port (read only)
;Vdp9k_Interrupt equ &66	;Interrupt flag port
;Vdp9k_System equ &67	;System control port (write only)
;Vdp9k_Superimpose equ &6F







	macro NextScrByte				;MSX autoincrements, so we do nothing here!
		Call MoveAlong
	endm
	macro ScreenStopDrawing
	endm
	macro ScreenStartDrawing
	endm
	macro SetScrByteBW
		out (VdpOut_Data),a
		NextScrByte				;Send the byte to screen
	endm
	ifdef vasm
		macro SetScrByte,sentbyte
			ld a,\sentbyte
			out (VdpOut_Data),a
			NextScrByte
		endm
	else
		macro SetScrByte sentbyte
			out (VdpOut_Data),sentbyte
			NextScrByte
		endm
	endif
