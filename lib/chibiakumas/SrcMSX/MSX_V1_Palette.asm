;VdpOut_Data equ &98
;VdpOut_Control equ &99
;VdpOut_Palette equ &9A


;Vdp9k_Palette equ &61	;Palette data port
;Vdp9k_RegData equ &63	;Register data port
;Vdp9k_RegSel equ &64	;Register select port (write only)


SetPalette:
	cp 16		;Ignore palette entries over 16
	ret nc	
	ifdef V9K
		push af
			ld a,14
			out (Vdp9k_RegSel),a
		pop af
		rlca					
		rlca
		out (Vdp9k_RegData),a ; NNNNNNCC
		;N= Palette number, C=Channel C=0 means Red... channels autoinc on write
		
		ld a,l
		and  %11110000
		rrca
		rrca
		rrca
		out (Vdp9k_Palette),a		;---RRRRR
		ld a,h
		and  %00001111
		rlca
		out (Vdp9k_Palette),a		;---GGGGG
		ld a,l
		and  %00001111
		rlca
		out (Vdp9k_Palette),a		;---BBBBB
		
	else
		ifndef BuildMSX_MSX1
		
			out (VdpOut_Control),a		;Send palette number to the VDP
			ld a,128+16					;Copy Value to Register 16 (Palette)
			out (VdpOut_Control),a

			ld a,l
			and %11101110				;We only want 3 bits for the MSX2 (V9k takes all 4)
			rrca
			out (VdpOut_Palette),a		;-RRR-BBB	

			ld a,h
			and %11101110
			rrca
			out (VdpOut_Palette),a		;-----GGG
		endif
	endif
	ret
;EndIF
