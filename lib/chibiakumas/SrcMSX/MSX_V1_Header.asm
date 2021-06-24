; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		MSX Header
;Version	V1.1b
;Date		2018/3/10
;Content	Works from ROM or DSK - copies program to common address &8000

;Changes	Fixed to support files bigger than &1000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	write "..\BldMSX\boot.bin"
	org &800A

BuildCPCv equ 0
BuildMSXv equ 1
BuildTI8v equ 0
BuildZXSv equ 0
BuildENTv equ 0
BuildSAMv equ 0



KeyChar_Enter equ 13
KeyChar_Backspace equ 8

ScreenWidth equ 32
ScreenHeight equ 24

ScreenWidth32 equ 1
ScreenHeight24 equ 1

INITTXT equ &006c	; switch to screen 0 (text mode 40x24)

CHPUT equ &00A2

	print "*** MSX Build ***"
	print "*** Saved to RelMSX\cart.rom ***"
	print "*** Saved to RelMSX\Disk ***"
	print "*** Start with MSX_Go.bat ***"

	;EXPLAINATION:
	;This is a tricky header - it can load to &C00A from disk or &4000 from ROM
	;Either way it will copy to RAM at &800A and run!
	;We do this so that we have a common memory range for all our 
	;main systems - this makes using things like 'aroks songs' that need a 
	;fixed address easier


	;we create a little program that does the following
	; POP HL
	; PUSH HL
	; RET
	
	;This stores PC into HL so we know where our program is running in memory.



	ld hl,&8000
	ld a,&E1	;POP HL
	ld (hl),a
	inc hl
	ld a,&E5	;PUSH HL
	ld (hl),a
	inc hl
	ld a,&c9	;RET
	ld (hl),a
	call &8000	;Get the current mempos
	ld a,h
	push hl
		ld hl,MSX_Copier
		ld h,a
		ld de,&D000
		ld bc,MSX_StartInMem-MSX_Copier
		ldir
	pop hl

	jp &D000

MSX_Copier:
	ld l,0		;reset the lower byte of the address.
	ld de,&8000
	ld bc,FileEnd-&8000
	ldir
	jp MSX_StartInMem
MSX_StartInMem: