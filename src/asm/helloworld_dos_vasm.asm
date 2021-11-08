; Constant definitions
INIT32  equ &006F
CHPUT   equ &00A2
LINLEN  equ &F3B0

; Compilation address
    org &100

; Program code entry point
Start:
    ; call INIT32         ; set screen 1
    ; ld a, 32
    ; call LINLEN         ; set width 32
    ld hl, helloWorld   ; load string
    call PrintStr       ; print string
    call NewLn          ; goto new line
    call Finished       ; end

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
    ret
    ; di
    ; halt

; Data
helloWorld:
    db "Hello world!",0

ProgEnd:
    ; end

