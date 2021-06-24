	ifdef BuildCPC
		ifdef V9K
			read "..\SrcCPC\CPCVDP_V1_Functions.asm" 
		else
			read "..\SrcCPC\CPC_V2_Functions.asm" 
		endif
	endif
	ifdef BuildMSX
		ifdef BuildMSX_MSX1VDP
			read "..\SrcMSX\MSX1VDP_V1_Functions.asm" 
		else
			ifdef BuildMSX_MSXVDP
				read "..\SrcMSX\MSXVDP_V1_Functions.asm" 
			else
				read "..\SrcMSX\MSX_V2_Functions.asm" 
			endif
		endif
	endif
	ifdef BuildTI8
		read "..\SrcTI\TI_V2_Functions.asm" 
	endif
	ifdef BuildZXS
		read "..\SrcZX\ZX_V2_Functions.asm" 
	endif
	ifdef BuildENT
		read "..\SrcENT\ENT_V2_Functions.asm" 
	endif
	ifdef BuildSAM
		read "..\SrcSAM\SAM_V2_Functions.asm" 
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
	