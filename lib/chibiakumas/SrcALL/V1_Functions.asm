	ifdef BuildCPC
		read "..\SrcCPC\CPC_V1_Functions.asm" 
	endif
	ifdef BuildMSX
		read "..\SrcMSX\MSX_V1_Functions.asm" 
	endif
	ifdef BuildTI8
		read "..\SrcTI\TI_V1_Functions.asm" 
	endif
	ifdef BuildZX8 ;ZX81
		read "..\SrcZX8\ZX8_V1_Functions.asm" 
	endif
	ifdef BuildZXS
		read "..\SrcZX\ZX_V1_Functions.asm" 
	endif
	ifdef BuildENT
		read "..\SrcENT\ENT_V1_Functions.asm" 
	endif
	ifdef BuildSAM
		read "..\SrcSAM\SAM_V1_Functions.asm" 
	endif

	ifdef BuildSMS
		read "..\SrcSMS\SMS_V1_Functions.asm" 
	endif
	ifdef BuildSGG
		read "..\SrcSMS\SMS_V1_Functions.asm" 
	endif

	ifdef BuildGMB
		include "..\SrcGB\GB_V1_Functions.asm" 
	endif
	ifdef BuildGBC
		include "..\SrcGB\GB_V1_Functions.asm" 
	endif
	ifdef BuildCLX
		include "..\SrcCLX\CLX_V1_Functions.asm" 
	endif