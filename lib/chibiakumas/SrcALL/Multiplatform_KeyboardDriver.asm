
	ifdef BuildTI8
		read "..\SrcTI\TI_V1_KeyboardDriver.asm"
	endif
	ifdef BuildENT
		read "..\SrcENT\ENT_V1_KeyboardDriver.asm"
	endif
	ifdef BuildMSX
		read "..\SrcMSX\MSX_V1_KeyboardDriver.asm"
	endif
	ifdef BuildCPC
		read "..\SrcCPC\CPC_V1_KeyboardDriver.asm"
	endif
	ifdef BuildZXS
		read "..\SrcZX\ZX_V1_KeyboardDriver.asm"
	endif
	ifdef BuildSAM
		read "..\SrcSAM\SAM_V1_KeyboardDriver.asm"
	endif
	ifdef BuildCLX
		read "..\SrcCLX\CLX_V1_KeyboardDriver.asm"
	endif
	
	
KeyboardScanner_Init:								;Init the screen buffer.
	ld hl,KeyboardScanner_KeyPresses
	ld d,h
	ld e,l
	inc de
	ld bc,15
	ld (hl),255
	z_ldir
	ret
