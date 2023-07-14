ORGADR  equ $0100
CHPUT   equ $00a2
CHGMOD  equ $005f
CALSLT	equ $001c
EXPTBL  equ $fcc0

    ; Place header before the binary.
    org ORGADR

FileStart:
Main:
    ; Set the screen mode to 1, using inter-slot call.
    ; http://map.grauw.nl/sources/callbios.php
    ld a, 0
    ld iy, (EXPTBL - 1)
    ld ix, CHGMOD
    call CALSLT 

    ld hl, helloWorld
    call PrintStr
    call NewLn
    ret

PrintStr:
    ld a, (hl)
    cp 0
    ret z
    inc hl
    call CallInterSlotChPut
    jr PrintStr

NewLn:
    push af
    ld a, 13
    call CallInterSlotChPut
    ld a, 10
    call CallInterSlotChPut
    pop af
    ret

CallInterSlotChPut:
    ld iy, (EXPTBL - 1)
    ld ix, CHPUT
    call CALSLT
    ret

helloWorld:
    db "Hello world!", 0

FileEnd:
