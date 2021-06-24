; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		Read Controls
;Version	V1.0
;Date		2018/7/6

;Content	This function reads in input from the Key and Joystick input, and compares it to a defined 'keymap'

;----------------------------------------------------------------------------------------------
	ifdef UseSampleKeymap													;Sample keymap for all systems
align32	
KeyMap equ KeyMap2+16														;wsad bnm p
KeyMap2:																	;Default controls (joystick)
		ifdef BuildCPC
		db &F7,&03,&7f,&05,&ef,&09,&df,&09,&f7,&09,&fB,&09,&fd,&09,&fe,&09 ;p2-pause,f3,f2,f1,r,l,d,u
		db &f7,&03,&bf,&04,&bf,&05,&bf,&06,&df,&07,&df,&08,&ef,&07,&f7,&07 ;p1-pause,f3,f2,f1,r,l,d,u
		endif
		ifdef BuildENT
		db &ef,&09,&bf,&08,&df,&0a,&bf,&0a,&fe,&0a,&fd,&0a,&fb,&0a,&f7,&0a
		db &ef,&09,&fe,&08,&fe,&00,&fb,&00,&f7,&01,&bf,&01,&df,&01,&bf,&02
		endif
		ifdef BuildZXS
		db &fe,&05,&fe,&07,&fe,&06,&ef,&08,&fe,&08,&fd,&08,&fb,&08,&f7,&08
		db &fe,&0f,&fb,&07,&f7,&07,&ef,&07,&fb,&01,&fe,&01,&fd,&01,&fd,&02
		endif
		ifdef BuildMSX
		db &df,&04,&fe,&08,&ef,&0c,&df,&0c,&f7,&0c,&fb,&0c,&fd,&0c,&fe,&0c
		db &df,&04,&fb,&04,&f7,&04,&7f,&02,&fd,&03,&bf,&02,&fe,&05,&ef,&05
		endif
		ifdef BuildTI8
		db &f7,&05,&fb,&05,&fd,&05,&fe,&05,&fb,&04,&fb,&02,&fd,&03,&f7,&03
		db &bf,&05,&7f,&00,&bf,&00,&df,&00,&fb,&06,&fd,&06,&fe,&06,&f7,&06
		endif
		ifdef BuildSAM
		db &FE,&05,&Fe,&07,&FE,&06,&FE,&04,&F7,&04,&EF,&04,&FB,&04,&FD,&04
		db &FE,&05,&FB,&07,&F7,&07,&EF,&07,&FB,&01,&FE,&01,&FD,&01,&FD,&02
		endif
		ifdef BuildCLX
		db &Fd,&07,&F7,&02,&F7,&09,&F7,&04,&DF,&09,&FB,&09,&DF,&00,&EF,&00
		db &Fd,&07,&F7,&02,&F7,&09,&F7,&04,&DF,&09,&FB,&09,&DF,&00,&EF,&00
		endif
	endif

KeyboardScanner_WaitForKey:
		call KeyboardScanner_ScanForOne		;Call the keyscanner
		cp 255								;No keys pressed?
		jr z,KeyboardScanner_WaitForKey
	ret	
	
KeyboardScanner_ScanForOne:
	call KeyboardScanner_Read				;Read the keymap
	ld b,KeyboardScanner_LineCount			;Number of lines depends on system - systems like the speccy has 3 unused bis (567)
	ld c,0
	ld hl,KeyboardScanner_KeyPresses
KeyboardScanner_WaitForKey_Check:
	ld a,(hl)
	cp 255
	ret nz									;Return if we found a line that had a key pressed
	inc hl
	inc c
	djnz KeyboardScanner_WaitForKey_Check
	ret										;if we got here, none of the keys were pressed.							

Player_ReadControlsDual:			; Read Controls
	call KeyboardScanner_Read		;Read hardware keypresses
	call Player_ReadControls2
	ld l,c							;Player 2 controls
	push hl
		call Player_ReadControls
	pop hl
	ld h,c							;Player 1 controls
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Player_ReadControls2:
	ld hl,KeyMap2					;p2 keymap
	jr Player_ReadControlsB
Player_ReadControls:
	ld hl,KeyMap					;p1 keymap

Player_ReadControlsB:			; We compare the keypresses to the 8 key map, 
		ld b,&08				; and store the result as a single byte
								; when 2player support is done, we will do this twice one for
Player_Handler_ReadNext:		; each controller
		push bc
			ld d,(hl)				;Bitmap
			inc hl
			ld a,(hl)				;line num
			inc hl
			push hl
				ld hl,KeyboardScanner_KeyPresses
				add l
				ld l,a				;We're relying on this being byte aligned.
				ld a,(hl)
				or d
				inc a 				;see if A is 255!
				jr nz,Player_Handler_notPressed
				scf					;set C to 1 (the previous OR made it 0)
Player_Handler_notPressed:
			pop hl
		pop bc
		rl c						;Shift the new bit in
		djnz Player_Handler_ReadNext
		ld a,c
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ifdef JOY_NoReconfigureControls
ConfigureControls:
	ld b,8*2						;8 buttons, 2 players
ConfigureControls_Nextkey:
	ifdef BuildCPC
			ld a,30*6				;Delay is longer on CPC due to faster interrupts
	else
			ifdef BuildCLX
				ld a,100
			else
				ld a,30
			endif
	endif
	ifndef BuildCLX
		ei
	endif
ConfigureControls_Delay:
	ifndef BuildCLX	
		halt			;Cant halt on camputers lynx
	else
		ld h,255
CamputersDelay:		
		;push af
		;pop af
		dec h
		jr nz,CamputersDelay
		;di
	endif
	dec a
	jr nz,ConfigureControls_Delay

	push bc
		ld hl,KeyName
		ld a,b						;B=key number
		dec a
		add a						;2 bytes per key
		ld d,0
		ld e,a
		add hl,de					;get offset to key string address
		
		ld c,(hl)					;get the description of the key
		inc hl
		ld b,(hl)					;get the description of the key
		push de
			push bc
				ifdef BuildTI8
					call CLS
				endif
				ld hl,KeyMapString0				;Print 'Press key for'
				call PrintString
			pop hl								;Get the name of the key in HL
			call PrintString
			call KeyboardScanner_WaitForKey		;Wait for a keypress
		pop de
		ld hl,KeyMap2							;Read the keymap
		add hl,de								;add keynumber (x2) to keymap
		push de
			ld (hl),a							;Bitmask
			inc hl
			ld (hl),c							;Line number
		pop de
	pop bc
	call NewLine
	ifdef KeyboardScanner_OnePlayerOnly
		dec b
		ld a,8
		cp b
		jp nz,ConfigureControls_Nextkey
	else
		djnz ConfigureControls_Nextkey
	endif
	ret
 
 
KeyName: 					;Stringmap for keysnames - order is important!
	defw KeyMapString8b
	defw KeyMapString7b
	defw KeyMapString6b
	defw KeyMapString5b
	defw KeyMapString4b
	defw KeyMapString3b
	defw KeyMapString2b
	defw KeyMapString1b

	defw KeyMapString8
	defw KeyMapString7
	defw KeyMapString6
	defw KeyMapString5
	defw KeyMapString4
	defw KeyMapString3
	defw KeyMapString2
	defw KeyMapString1

	KeyMapString0: db  "PRESS KEY FOR:",255
	KeyMapString8: db  "P1-PAUSE",255
	KeyMapString7: db  "P1-SBOMB",255
	KeyMapString6: db  "P1-FIRER",255
	KeyMapString5: db  "P1-FIREL",255
	KeyMapString4: db  "P1-RIGHT",255
	KeyMapString3: db  "P1-LEFT",255
	KeyMapString2: db  "P1-DOWN",255
	KeyMapString1: db  "P1-UP",255

	KeyMapString8b: db  "P2-PAUSE",255
	KeyMapString7b: db  "P2-SBOMB",255
	KeyMapString6b: db  "P2-FIRER",255
	KeyMapString5b: db  "P2-FIREL",255
	KeyMapString4b: db  "P2-RIGHT",255
	KeyMapString3b: db  "P2-LEFT",255
	KeyMapString2b: db  "P2-DOWN",255
	KeyMapString1b: db  "P2-UP",255

	endif
