	ifdef BuildCPC
		read "\SrcCPC\CPC_V1_ChibiSound.asm"
	endif
	ifdef BuildMSX
		read "\SrcCPC\CPC_V1_ChibiSound.asm"
	endif
	ifdef BuildZXN	;AY 
		read "\SrcCPC\CPC_V1_ChibiSound.asm"
	else
		ifdef BuildZXS
			;read "..\SrcCPC\CPC_V1_ChibiSound.asm"
			read "\SrcZX\ZX48_V1_ChibiSound.asm"
		endif
	endif
	
	ifdef BuildSAM
		read "\SrcSAM\SAM_V1_ChibiSound.asm"
	endif
	ifdef BuildENT
		read "\SrcENT\ENT_V1_ChibiSound.asm"
	endif
	ifdef BuildSMS
		read "\SrcSMS\SMS_V1_ChibiSound.asm"
	endif
	ifdef BuildSGG
		read "\SrcSMS\SMS_V1_ChibiSound.asm"
	endif
	ifdef BuildGMB
		read "\SrcGB\GB_V1_ChibiSound.asm"
	endif
	ifdef BuildGBC
		read "\SrcGB\GB_V1_ChibiSound.asm"
	endif
	ifdef BuildCLX
		read "\SrcCLX\CLX_V1_ChibiSound.asm"
	endif
	ifdef BuildTI8
ChibiSound:
		ret
	endif