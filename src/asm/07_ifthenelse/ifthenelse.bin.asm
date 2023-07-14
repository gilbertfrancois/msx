ORGADR  equ $c000
CHPUT   equ $00A2
CHGMOD  equ $005f
 
    ; Place header before the binary.
    org ORGADR - 7
    ; Bin header, 7 bytes
    db $fe
    dw _filestart
    dw _fileend - 1
    dw _main

    ; org statement after the header
    org ORGADR

_filestart:

_main:
    ld ix, _vars

    ld hl,_msg_ge_true
    call _print
    call _endln
    ld a, (ix+1)
    ld b, (ix)
    call _if_ge


    ld hl, _msg_ge_false
    call _print
    call _endln
    ld a, (ix)
    ld b, (ix+1)
    call _if_ge

    ld hl,_msg_lt_true
    call _print
    call _endln
    ld a, (ix)
    ld b, (ix+1)
    call _if_lt


    ld hl, _msg_lt_false
    call _print
    call _endln
    ld a, (ix+1)
    ld b, (ix)
    call _if_lt

    ld hl,_msg_eq_true
    call _print
    call _endln
    ld a, (ix)
    ld b, (ix)
    call _if_eq


    ld hl, _msg_eq_false
    call _print
    call _endln
    ld a, (ix)
    ld b, (ix+1)
    call _if_eq

    ret
    
_if_ge:        
    sub b			;; (a >= b) or (a - b >= 0)
    jp c, _else     ;; when C is set, condition is false
    jp _then
_if_lt:
    sub b           ;; (a < b) or (a - b < 0)
    jp nc, _else    ;; when C is not set, condition is false
    jp _then
_if_eq:
    sub b           ;; (a == b) or (a - b == 0)
    jp nz, _else    ;; when non-zero, condition is false
    jp _then
_then:
    ld a, &31       ;; print 1 if true
    call ChPut
    call _endln
    ret				;; back to basic
_else:
    ld a, &30		;; print 0 if false
    call ChPut
    call _endln
    ret

_print:
    ld a, (hl)
    cp 0
    ret z
    inc hl
    call ChPut
    jr _print

_endln:
    push af
        ld a, 13
        call ChPut
        ld a, 10
        call ChPut
    pop af
    ret

_msg_ge_true:
    db "if (2 >= 1)",0
_msg_ge_false:
    db "if (1 >= 2)",0
_msg_lt_true:
    db "if (1 < 2)",0
_msg_lt_false:
    db "if (2 < 1)",0
_msg_eq_true:
    db "if (1 == 1)",0
_msg_eq_false:
    db "if (1 == 2)",0

_vars:
    db 1, 2

_fileend:
