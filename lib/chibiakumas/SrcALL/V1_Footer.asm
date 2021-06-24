	ifdef BuildMSX
		read "..\SrcMSX\MSX_V1_Footer.asm" 
	endif
	ifdef BuildCPC
		read "..\SrcCPC\CPC_V1_Footer.asm" 
	endif
	ifdef BuildENT
		read "..\SrcENT\ENT_V1_Footer.asm" 
	endif
	ifdef BuildSMS
		read "..\SrcSMS\Sms_V1_Footer.asm" 
	endif
	ifdef BuildSGG
		read "..\SrcSMS\Sms_V1_Footer.asm" 
	endif
	ifdef BuildZX8	;ZX81
		read "..\SrcZX8\ZX8_V1_Footer.asm" 
	endif