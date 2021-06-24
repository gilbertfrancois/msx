; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		Multiplatform Bitmap Fonts
;Version	V1.0
;Date		2018/6/13
;Content	Simulates firmware font functions using a 2 bit Bitmap font of 96 or 64 chars - this is platform independent

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


BMP_PrintChar:
	push hl					;Push like crazy!
	push bc					;For maximum register protection!
	push de			
	push af

	ScreenStartDrawing			;For Sam Coupe

	ifdef BMP_UppercaseOnlyFont		;We can use a smaller 64 char font with no uppercase letters to save ram
		cp 'a'
		jr c,BMP_PrintCharSkip		;Char is not a problem
		cp 'z'+1
		jr nc,BMP_PrintCharSkip		;Char is not a problem
		sub 32				;Convert Lower to uppercase
BMP_PrintCharSkip:
	endif
		sub ' '				;We don't have any chars below 32 (Space)

		ld h,0
		ld l,a
		add hl,hl			;8 bytes per char - so move to correct char
		add hl,hl
		add hl,hl

		ld de,BitmapFont		;Add Location of Bitmap font
		add hl,de
		ex de,hl

		ld bc,&0000;<--SM 
TextCursorBytePos_Plus2:

		call GetScreenPos		;Move text cursor to predefined location

		ld b,8

BitmapCharAgain:
		ld a,(de)
		SetScrByteBW 			;Use our 1 bit converter
		inc de
		call GetNextLine
		dec b
		jp nz,BitmapCharAgain		;repeat for 8 lines
	
		ld a,(TextCursorBytePos_Plus2-1)
		add CharByteWidth		;Move across no bytes for system
		cp ScreenWidth*CharByteWidth

		jr nz,BMP_PrintCharPosOK

		ld a,(TextCursorBytePos_Plus2-2)
		add 8				;Move down 8 lines
		ld (TextCursorBytePos_Plus2-2),a
		xor a
BMP_PrintCharPosOK:
		ld (TextCursorBytePos_Plus2-1),a

	ScreenStopDrawing		;For Sam Coupe

	pop af				;Restore all registers
	pop de
	pop bc			
	pop hl
	ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BMP_NewLine:	;Newline Command
	push hl
		call BMP_GetCursorPos		
		ld h,0			;Move X to 0	
		inc l			;Move down a line
		call BMP_Locate
	pop hl
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BMP_GetCursorPos:
	ld hl,(TextCursorBytePos_Plus2-2)
	rrc l				;Convert bytepos to char line
	rrc l
	rrc l

	if BuildCPCv+BuildENTv
		ifdef ScrColor16
			rrc h		;Convert bytepos to char column
		endif
		rrc h
	endif
	if BuildSAMv+BuildMSXv
		rrc h			
		rrc h
	endif
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BMP_Locate:	;Locate command, H=X, L=Y
	push af
		ld a,ScreenHeight
		cp l
		jp nc,BMP_LocateOK
		pop af
		jp BMP_CLS		;Off the screen, then CLS (no scroll, sorry!)
BMP_LocateOK:
	pop af
	push hl

	rlc l				;convert char to pixel line
	rlc l
	rlc l

	if BuildCPCv+BuildENTv
		ifdef ScrColor16
			rlc h
		endif
		rlc h
	endif
	if BuildSAMv+BuildMSXv
		rlc h			;Convert Xpos according to number of bytesperchar
		rlc h
	endif
	ld (TextCursorBytePos_Plus2-2),hl
	pop hl

	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BMP_CLS:
	ld bc,&0000			;Clear the screen with our 1 bit byte command - this isn't very fast, but it's compatible!
	call GetScreenPos

	ld c,ScreenHeight*8
BMP_CLSAgainY:
	ld b,ScreenWidth
	xor a				;0 byte
BMP_CLSAgainX:
	SetScrByteBW 			;Send it to screen
	djnz BMP_CLSAgainX
	call GetNextLine
	dec c
	jr nz,BMP_CLSAgainY

	ld hl,&0000	
	call BMP_Locate			;Move cursor to 0,0
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BMP_PrintString:
	ld a,(hl)			;Print a '255' terminated string 
	cp 255
	ret z
	inc hl
	call BMP_PrintChar
	jr BMP_PrintString


