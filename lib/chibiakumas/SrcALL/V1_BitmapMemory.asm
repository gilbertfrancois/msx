	ifdef BuildCPC
		read "\SrcCPC\CPC_V1_BitmapMemory.asm"
	endif
	ifdef BuildZXS
		read "\SrcZX\ZX_V1_BitmapMemory.asm"
	endif
	ifndef BuildMSX_MSX1
		ifdef BuildMSX
			read "\SrcMSX\MSX_V1_BitmapMemory.asm"
		endif
	else
		ifdef BuildMSX
			read "\SrcMSX\MSX1_V1_BitmapMemory.asm"
		endif
	endif
	ifdef BuildTI8
		read "\SrcTI\TI_V1_BitmapMemory.asm"
	endif 
	ifdef BuildENT
		read "\SrcENT\ENT_V1_BitmapMemory.asm"
	endif 
	ifdef BuildSAM
		read "\SrcSAM\SAM_V1_BitmapMemory.asm"
	endif 
	ifdef BuildCLX
		read "\SrcCLX\CLX_V1_BitmapMemory.asm"
	endif 