    ; org statement before the header
    org $4000

    ; ROM header
    db "AB"
    dw Main
    dw 0, 0, 0, 0, 0, 0

RomSize equ $4000
CHPUT   equ $00A2

FileStart:
Main:
    ld hl, helloWorld
    call PrintStr
    call NewLn
    call Finished

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

helloWorld:
    db "Hello world!", 0

FileEnd:
    ds $4000 + RomSize - FileEnd, 255
