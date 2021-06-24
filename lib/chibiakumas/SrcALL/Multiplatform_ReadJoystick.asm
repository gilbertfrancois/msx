	ifdef BuildGMB
HardwareJoystick equ 1
		read "..\SrcGB\GB_V1_ReadJoystick.asm"
	endif
	ifdef BuildGBC
HardwareJoystick equ 1
		read "..\SrcGB\GB_V1_ReadJoystick.asm"
	endif
	
	
	ifdef BuildSMS
HardwareJoystick equ 1
		read "..\SrcSMS\SMS_V1_ReadJoystick.asm"
	endif
	ifdef BuildSGG
HardwareJoystick equ 1
		read "..\SrcSMS\SMS_V1_ReadJoystick.asm"
	endif

	
	
	ifndef HardwareJoystick
		;no hardware joystick, we're using a keymatrix system
		;ifdef BuildTI8
		ifdef UseHardwareKeyMap
			read "..\SrcALL\Multiplatform_ScanKeys.asm"
		endif
		read "..\SrcALL\Multiplatform_KeyboardDriver.asm"
		read "..\SrcALL\Multiplatform_ReadJoystickKeypressHandler.asm"
	else
		ifdef BuildMSX
			read "\SrcMSX\MSX_V1_ReadJoystick.asm"
		endif
		ifdef BuildENT
			read "\SrcENT\ENT_V1_ReadJoystick.asm"
		endif
		ifdef BuildZXS
			read "..\SrcZX\ZX_V1_ReadJoystick.asm"
		endif
		ifdef BuildCPC
		read "..\SrcCPC\CPC_V1_ReadJoystick.asm"
		endif 
		ifdef BuildSAM
		read "..\SrcSAM\SAM_V1_ReadJoystick.asm"
		endif 
	endif
	
	
	
	
	
	