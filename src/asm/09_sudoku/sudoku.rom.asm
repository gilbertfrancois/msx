ORGADR  equ $4000
CHPUT   equ $00A2
CHGMOD  equ $005f
RomSize equ $4000

    ; org statement before the header
    org ORGADR
    ; ROM header
    db "AB"
    dw Main
    dw 0, 0, 0, 0, 0, 0

FileStart:
Main:

    

Finished:
    di
    halt

helloWorld:
    db "Hello world!", 0

FileEnd:
    ds $4000 + RomSize - FileEnd, 255
