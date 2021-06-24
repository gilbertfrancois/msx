; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		MSX Firmware Functions
;Version	V1.0b
;Date		2018/3/29
;Content	Provides basic text functions using Firware calls

;Changelog	Fixed Screen size to use full 32 char width
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PrintChar equ &00A2
WaitChar  equ &009F


CLS:
	xor a	
	jp &00C3	;CLS command requires A to be 0

Locate:		;Locate X=H Y=L
	push hl
		inc h
		inc l
		call &00C6 ;Firmware Call for Locate - on MSX top corner is 1,1
	pop hl
	ret

GetCursorPos:	;Return XY location in same format as Lcate
	push af
		ld hl,(&F3DC)	;Get the cursor pos from Firmware Var
		dec l	;CSRY   (F3DCH, 1)    initial value  1  contents	Y-coordinate of cursor
		dec h	;CSRX   (F3DDH, 1)    initial value  1  contents	X-coordinate of cursor
	pop af


	ret

NewLine:
	push af
		ld a,13		;Carriage return
		call PrintChar
		ld a,10		;Line Feed
		call PrintChar
	pop af
	ret

PrintString:
	ld a,(hl)	;Print a '255' terminated string 
	cp 255
	ret z
	inc hl
	call PrintChar
	jr PrintString

SHUTDOWN:
	di		;Can't return to basic on a cartridge
	halt
DOINIT:


;	call &006C	;INITXT - initialises the screen to TEXT1 mode (40 x 24).
	call &006F	;INIT32 - initialises the screen to GRAPHIC1 mode (32x24)
	
	ld a,32		;Set Screen width to 32 chars
	ld (&F3B0),a	;LINLEN 
	ret