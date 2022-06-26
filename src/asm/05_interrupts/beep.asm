; Simple interrupt test
; Credits: https://msx.org/forum/msx-talk/development/question-about-htimi-hook-fd9fh 

    ; BIN header
    db $FE
    dw FileStart
    dw FileEnd - 1
    dw Main

    ; org statement after the header
    org $C000

BEEP    equ $00c0
HTIMI   equ $fd9f
SPEED   equ 50

FileStart:
Main:
    di

    ; Preserve old hook
    ld de, OldHook
    ld hl, HTIMI
    ld bc, 5
    ldir

    ; Install new hook
    ld a, $c3              ; jp instruction opcode
    ld (HTIMI), a          ; Set jp instruction into the hook memory address
    ld hl, BeepFn          ; Load BeepFn addr
    ld (HTIMI+1), hl       ; Set BeepFn memory addr after jp instruction
    ei                     ; enable interrupts
    ret


BeepFn:
    ld hl, Counter
    dec (hl)
    ld a, (hl)
    jp nz, OldHook
    ld (hl), SPEED
    call BEEP


OldHook:
    db 0, 0, 0, 0, 0

Counter:
    db SPEED

FileEnd:

