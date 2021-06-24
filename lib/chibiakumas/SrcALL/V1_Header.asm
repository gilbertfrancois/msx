	
	ifdef BuildCPC
		read "..\SrcCPC\CPC_V1_Header.asm" 
	endif
	ifdef BuildMSX
		read "..\SrcMSX\MSX_V1_Header.asm" 
	endif
	ifdef BuildTI8
		read "..\SrcTI\TI_V1_header.asm" 
	endif
	ifdef BuildZXS
		read "..\SrcZX\ZX_V1_header.asm" 
	endif
	ifdef BuildZX8	;ZX81
		read "..\SrcZX8\ZX8_V1_header.asm" 
	endif
	ifdef BuildENT
		read "..\SrcENT\ENT_V1_header.asm" 
	endif
	ifdef BuildSAM
		read "..\SrcSAM\SAM_V1_header.asm" 
	endif

	ifdef BuildSMS
		read "..\SrcSMS\SMS_V1_header.asm" 
	endif
	ifdef BuildSGG
		read "..\SrcSMS\SMS_V1_header.asm" 
	endif

	ifdef BuildGMB
		include "..\SrcGB\GB_V1_header.asm" 
	endif
	
	ifdef BuildGBC
		include "..\SrcGB\GB_V1_header.asm" 
	endif

	ifdef BuildCLX
		include "..\SrcCLX\CLX_V1_header.asm" 
	endif

	ifndef vasm
		ifdef BuildCPC
			if BuildMSXv+BuildZXSv+BuildENTv+BuildSAMv+BuildTI8v
				print "Bad Build - Multiple target platforms selected"
				stop
			endif
		endif
		ifdef BuildMSX
			if BuildCPCv+BuildZXSv+BuildENTv+BuildSAMv+BuildTI8v
				print "Bad Build - Multiple target platforms selected"
				stop
			endif
		endif
		ifdef BuildZXS
			if BuildCPCv+BuildMSXv+BuildENTv+BuildSAMv+BuildTI8v
				print "Bad Build - Multiple target platforms selected"
				stop
			endif
		endif
		ifdef BuildENT
			if BuildCPCv+BuildMSXv+BuildZXSv+BuildSAMv+BuildTI8v
				print "Bad Build - Multiple target platforms selected"
				stop
			endif
		endif
		ifdef BuildSAM
			if BuildCPCv+BuildMSXv+BuildENTv+BuildZXSv+BuildTI8v
			
				print "Bad Build - Multiple target platforms selected"
				stop
			endif
		endif
	endif