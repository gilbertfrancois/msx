; Simple interrupt test
; Credits and references: 
;    https://msx.org/forum/msx-talk/development/question-about-htimi-hook-fd9fh 
;    https://msx.org/forum/msx-talk/hardware/way-detect-vblank-time
;    https://www.youtube.com/watch?v=aUkHk_mjtOU

ORGADR      equ $c000
BEEP        equ $00c0
HTIMI       equ $fd9f
MAX_COUNT   equ 50

    ; Place header before the binary.
    org ORGADR - 7
    ; Bin header, 7 bytes
    db $fe
    dw _file_start
    dw _file_end - 1
    dw _main

    ; org statement after the header
    org ORGADR

_file_start:
_main:
    ; Install hook, run once
    di
    ; Preserve old hook instructions
    ld hl, HTIMI
    ld de, _old_hook
    ld bc, 5
    ldir
    ; Copy new hook instructions
    ld hl, _new_hook
    ld de, HTIMI
    ld bc, 5
    ldir
    ei
    ; Return to Basic
    ret

_new_hook:
    jp _on_interrupt
    ret
    nop

_on_interrupt:
    ; Run at every interrupt
    ld hl, _counter
    dec (hl)
    ld a, (hl)
    jp nz, _old_hook
    ; Run once every MAX_COUNT times
    ; Reset _counter and call BEEP
    ld (hl), MAX_COUNT
    call BEEP
_old_hook:
    ; Place old hook here, so it will be called directly after
    ; the new on_interrupt function.
    ; Reserve 5 bytes to store the old hook
    ds 5, 0
    ret

_counter:
    db MAX_COUNT

_file_end:

