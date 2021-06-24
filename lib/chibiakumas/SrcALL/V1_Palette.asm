	ifdef BuildCPC
		ifdef CpcPlus
			read "..\SrcCPC\CPCPLUS_V1_Palette.asm"
		else
			read "..\SrcCPC\CPC_V1_Palette.asm"
		endif

	endif

	ifdef BuildENT
		read "..\SrcENT\ENT_V1_Palette.asm"
	endif
	ifdef BuildSAM
		read "..\SrcSAM\SAM_V1_Palette.asm"
	endif
	ifdef BuildMSX
		read "..\SrcMSX\MSX_V1_Palette.asm"
	endif
	ifdef BuildGMB
		read "..\SrcGB\GB_V1_Palette.asm"
	endif
	ifdef BuildGBC
		read "..\SrcGB\GB_V1_Palette.asm"
	endif
	ifdef BuildSMS
		read "..\SrcSMS\SMS_V1_Palette.asm"
	endif
	ifdef BuildSGG
		read "..\SrcSMS\SMS_V1_Palette.asm"
	endif
	ifdef BuildZXS
		read "..\SrcZX\ZX_V1_Palette.asm"

	endif
	ifdef BuildCLX
		SetPalette:
		ret
	endif
	ifdef BuildTI8
		SetPalette:
		ret
	endif