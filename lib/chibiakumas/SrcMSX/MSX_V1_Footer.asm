; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		MSX Footer
;Version	V1.0
;Date		2018/3/01
;Content	Generic Footer

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FileEnd:
	close


;Boot.BIN will work from a DISK, but we need to make somne changes if we want it to work as
;a Cartridge - so attatch our header here

;Note, MsxHeader.exe will create the DISK header from the batch file
;we only create the CART header here.
	ifndef vasm
		write "..\RelMSX\cart.rom"
		org &8000		;Change this to &4000 if you want to run from rom
		db "AB"
		dw FileStart-&4000 ;Change this to "dw FileStart" if you want to run from rom
	
		db 00,00,00,00,00,00
		FileStart:
		incbin "..\BldMSX\boot.bin"

		;Align to an 8k boundary - otherwise OpenMSX will get angry!
		Align 8192 
	endif