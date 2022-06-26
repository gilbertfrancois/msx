; Build with:
; java -jar glass.jar helloworld_cas.asm -L listing.txt -o helloworld.cas
;
    ; CAS header with the filename
    db $1F, $A6, $DE, $BA, $CC, $13, $7D, $74
    db $D0, $D0, $D0, $D0, $D0, $D0, $D0, $D0, $D0, $D0
    db "hellow"
    db $1F, $A6, $DE, $BA, $CC, $13, $7D, $74
    dw FileStart
    dw FileEnd - 1
    dw Main

    ; org statement after the header
    org $C000

CHPUT   equ $00A2

CHGMOD  equ $005f

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
