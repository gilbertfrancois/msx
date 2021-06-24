	ifdef BuildCPC
		read "..\SrcCPC\CPC_V1_GetHardwareVer.asm"
	endif
	ifdef BuildZXS
		read "..\SrcZX\ZX_V1_GetHardwareVer.asm"
	endif
	ifdef BuildENT
		read "..\SrcENT\ENT_V1_GetHardwareVer.asm"
	endif
	ifdef BuildSAM
		read "..\SrcSAM\SAM_V1_GetHardwareVer.asm"
	endif
	ifdef BuildGMB
		read "..\SrcGB\GB_V1_GetHardwareVer.asm"
	endif
	ifdef BuildGBC
		read "..\SrcGB\GB_V1_GetHardwareVer.asm"
	endif
	ifdef BuildSMS
		read "..\SrcSMS\SMS_V1_GetHardwareVer.asm"
	endif
	ifdef BuildMSX
		read "..\SrcMSX\MSX_V1_GetHardwareVer.asm"
	endif