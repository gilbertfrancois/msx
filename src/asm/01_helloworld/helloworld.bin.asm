ORGADR  equ $c000
CHPUT   equ $00A2
CHGMOD  equ $005f
 
    ; Place header before the binary.
    org ORGADR - 7
    ; Bin header, 7 bytes
    db $fe
    dw FileStart
    dw FileEnd - 1
    dw Main

    ; org statement after the header
    org ORGADR

FileStart:
Main:
    ld a, 0
    call CHGMOD

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
    ret

helloWorld:
    db "Hello world!", 0

FileEnd:
