	ifdef BuildCPC
		read "\SrcCPC\CPC_V1_ChibiWave.asm"
	endif
	ifdef BuildMSX
		read "\SrcCPC\CPC_V1_ChibiWave.asm"
	endif
	ifdef BuildZXS
		ifdef ZXSAYWave
			read "\SrcCPC\CPC_V1_ChibiWave.asm"
		else
			read "\SrcZX\ZX48_V1_ChibiWave.asm"
		endif
	endif
	ifdef BuildCLX
		read "\SrcCLX\CLX_V1_ChibiWave.asm"
	endif
	ifdef BuildENT
		read "\SrcENT\ENT_V1_ChibiWave.asm"
	endif
	
	ifdef BuildSAM
		read "\SrcSAM\SAM_V1_ChibiWave.asm"
	endif
	ifdef BuildSMS
		read "\SrcSMS\SMS_V1_ChibiWave.asm"
	endif
	ifdef BuildSGG
		read "\SrcSMS\SMS_V1_ChibiWave.asm"
	endif
	ifdef BuildGMB
		read "\SrcGB\GB_V1_ChibiWave.asm"
	endif
	ifdef BuildGBC
		read "\SrcGB\GB_V1_ChibiWave.asm"
	endif
	