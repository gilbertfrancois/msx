	;ifdef BuildMSX_MSX1VDP
BmpByteWidth equ 1
CharByteWidth equ 1


VdpIn_Status equ &99
VdpIn_Data  equ &98

VdpOut_Data equ &98
VdpOut_Control equ &99

VdpOut_Palette equ &9A
VdpOut_Indirect equ &9B
	ifndef V9K
Vdp_SendByteData equ &9B
	endif