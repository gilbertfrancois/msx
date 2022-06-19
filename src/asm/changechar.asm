; ROM header
    org $4000
    db "AB"     ; magic number
    dw Main     ; program execution address
    dw 0, 0, 0, 0, 0, 0

VDPOutData    equ $98
VDPOutControl equ $99

RomSize equ $4000
CHGMOD  equ $005f
CHPUT   equ $00a2
CHGET   equ $009f
LINL32  equ $f3af

FileStart:
Main:
	; Set screen width to 40
	ld hl, LINL32
	ld (hl), 32
	; Change to screen 0
	ld a, 1
	call CHGMOD
	; Show all characters on screen to see the effect of our bit operations.
	ld bc, $0020
	call PrintCharMapLoop
	call NewLn
	call NewLn

	; Show message on screen
	ld hl, Message
	call PrintStr
	call NewLn
	call CHGET

	; End and return to Basic
	call Finished

PrintCharMapLoop:
	ld a, c
	cp $FF
	ret z
	inc c
	call CHPUT
	jr PrintCharMapLoop

PrintStr:
    ld a, (hl)
    cp 0
    ret z
    inc hl
    call CHPUT
    jr PrintStr

NewLn:
    push af
    ld a, 13
    call CHPUT
    ld a, 10
    call CHPUT
    pop af
    ret

Finished:
	di
	halt

Message:
    db "Press a key to continue...",0

FileEnd:
