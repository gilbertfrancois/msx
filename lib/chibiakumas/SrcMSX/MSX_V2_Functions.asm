; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		MSX Firmware Functions
;Version	V1.0b
;Date		2018/3/29
;Content	Provides basic text functions using Firware calls

;Changelog	Fixed Screen size to use full 32 char width
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




PrintChar 	equ BMP_PrintChar	
CLS 		equ BMP_CLS
Locate 		equ BMP_Locate
GetCursorPos 	equ BMP_GetCursorPos
NewLine 	equ BMP_NewLine
PrintString 	equ BMP_PrintString
WaitChar 	equ ScanKeys_WaitChar


SHUTDOWN:
	di		;Can't return to basic on a cartridge
	halt
DOINIT:


	jp ScreenINIT
