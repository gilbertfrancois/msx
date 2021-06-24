	ifdef BuildSMS
		read "..\SrcSMS\SMS_V1_VDPMemory.asm"
	endif
	ifdef BuildSGG
		read "..\SrcSMS\SMS_V1_VDPMemory.asm"
	endif
	ifdef BuildGMB
		read "..\SrcGB\GB_V1_VDPMemory.asm"
	endif
		
	ifdef BuildGBC
		read "..\SrcGB\GB_V1_VDPMemory.asm"
	endif
	
	ifdef BuildCPC
		ifdef V9K
			read "..\SrcCPC\CPC_V1_VDPMemory_9K.asm"
		endif
	endif
	ifdef BuildMSX
		ifdef V9K
			read "..\SrcMSX\MSX_V1_VDPMemory_9K.asm"
		else
			ifdef BuildMSX_MSX1
				read "..\SrcMSX\MSX1_V1_VDPMemory.asm"
			else
				read "..\SrcMSX\MSX_V1_VDPMemory.asm"
			endif
		endif
	endif
	
	