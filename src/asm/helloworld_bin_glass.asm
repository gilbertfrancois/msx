    db $FE
    dw FileStart
    dw FileEnd - 1
    dw Main

    org $C000

CHPUT   equ $00A2
POSIT	equ $00C6
BEEP    equ $00C0

FileStart:
Main:
	ld hl, $040B
	call Locate
    ld hl, helloWorld
    call PrintStr
    call NewLn
	ld hl, $0114
	call Locate
	call BEEP
    call Finished

Locate:
	; push hl
	call POSIT
	; pop hl 
	ret

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
    ret

helloWorld:
    db "Hello world!",0

FileEnd:
