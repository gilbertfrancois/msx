	ifdef BuildGMB	
		include "..\SrcGB\GB_V1_HardwareTileArray.asm"
	endif
	ifdef BuildGBC
		include "..\SrcGB\GB_V1_HardwareTileArray.asm"
	endif
	ifdef BuildSMS
		include "..\SrcSMS\SMS_V1_HardwareTileArray.asm"
	endif
	ifdef BuildSGG
		include "..\SrcSMS\SMS_V1_HardwareTileArray.asm"
	endif
	ifdef BuildMSX
		ifdef BuildMSX_MSX1VDP
			include "..\SrcMSX\MSX1VDP_V1_HardwareTileArray.asm"
		else
			include "..\SrcMSX\MSXVDP_V1_HardwareTileArray.asm"
		endif
	endif
	ifdef BuildCPC
		include "..\SrcMSX\MSXVDP_V1_HardwareTileArray.asm"
	endif