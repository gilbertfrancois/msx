RomSize equ &4000

; Compilation address
    org &4000

; ROM header
    db "AB"             ; magic number
    dw Main             ; program execution address
    dw 0, 0, 0, 0, 0, 0

; Program code entry point
Main:
	ld hl, &C000
	ld de, &C000+1
	ld bc, &1000
	ld (hl), &aa
	ldir
	call Finish

Finish:
	di
	halt

FileEnd:
; Padding to make the file size a multiple of 16K
    ds &4000 + RomSize - FileEnd, 255
