; Simple interrupt test
; Credits and references: 
;    https://msx.org/forum/msx-talk/development/question-about-htimi-hook-fd9fh 
;    https://msx.org/forum/msx-talk/hardware/way-detect-vblank-time
;    https://www.youtube.com/watch?v=aUkHk_mjtOU

ORGADR      equ $c000
BEEP        equ $00c0
HTIMI       equ $fd9f
MaxCount    equ 50

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
    ; Install hook, run once
    di
    ; Preserve old hook instructions
    ld de, OldHook
    ld hl, HTIMI
    ld bc, 5
    ldir
    ; Copy new hook instructions
    ld hl, NewHook
    ld de, HTIMI
    ld bc, 5
    ldir

    ei

    ; Return to Basic
    ret

NewHook:
    jp BeepFn
    ret
    nop

OldHook:
    ; Reserve 5 bytes to store the old hook
    db 0, 0, 0, 0, 0

BeepFn:
    ; Run at every interrupt
    ld hl, Counter
    dec (hl)
    ld a, (hl)
    jp nz, OldHook
    ; Reset counter and call BEEP
    ld (hl), MaxCount
    call BEEP

Counter:
    db MaxCount

FileEnd:

