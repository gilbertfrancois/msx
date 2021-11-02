; Constant definitions
INIT32  equ &006F
CHPUT   equ &00A2
LINLEN  equ &F3B0

RomSize equ &4000

; Compilation address
    org &4000

; ROM header
    db "AB"     ; magic number
    dw Main  ; program execution address
    dw 0, 0, 0, 0, 0, 0

; Program code entry point
Main:
    call INIT32        ; set screen 1
    ld a, 32
    call LINLEN        ; set width 32
    ld hl, helloWorld  ; load string
    call PrintStr      ; print string
    call NewLn         ; goto new line
    call Finished      ; end

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

; Halt program execution. Change to "ret" to return to MSX-BASIC.
Finished:
    ; ret
    di
    halt

; Data
helloWorld:
    db "Hello world!",0

End:
; Padding to make the file size a multiple of 16K
    ds &4000 + RomSize - End, 255
