ORGADR      equ $c000
ERAFNK      equ $00cc
CHPUT       equ $00a2
CHGET	    equ $009f
CHSNS       equ $009c
CHGMOD      equ $005f
LDIRVM      equ $005c
SETWRT      equ $0053
POSIT       equ $00c6
VDPData     equ $98
VDPControl  equ $99

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

    ; clear screen, goto screen 1
    ld a, 1
    call CHGMOD
    call ERAFNK
    ld hl, $0d0f
    ld (_current_ij), hl
    call _eventloop
    ret

_eventloop:
    call CHSNS
    jr z, _eventloop
    call CHGET
    cp $1c            ; right
    jr z, _right
    cp $1d            ; left
    jr z, _left
    cp $1e            ; up
    jr z, _up
    cp $1f            ; down
    jr z, _down
    jp _eventloop
_left:
    ld hl, (_current_ij)
    ld a, l
    sub 1
    ld l, a
    ld (_current_ij), hl
    call _get_k
    jp _move_cursor
_right:
    ld hl, (_current_ij)
    ld a, l
    add 2
    ld l, a
    ld (_current_ij), hl
    call _get_k
    jp _move_cursor
_up:
    ld hl, (_current_ij)
    ld a, h
    sub 2
    ld h, a
    ld (_current_ij), hl
    call _get_k
    jp _move_cursor
_down:
    ld hl, (_current_ij)
    ld a, h
    add 2
    ld h, a
    ld (_current_ij), hl
    call _get_k
    jp _move_cursor
_move_cursor:
    ld hl, (_current_ij)
    call _get_k
    ld a, (_current_k)
    ld hl, $1800
    ld l, a
    ld a, $30
    ld (_keyin), a
    call _print_char
    jp _eventloop



_print_char:
    call SETWRT
    ld a, (_keyin)
    out (VDPData), a
    call _eventloop
_end:
    ret

_test_has_val_in_rowcolblock:
    ; select i, j
    ld h, 5
    ld l, 7
    ld (_current_ij), hl
    call _get_k
    ld a, e
    ld (_current_k), a
    ld hl, _data
    add hl, de
    ld a, (hl)
    ld (_current_val), a
    
    call _has_val_in_block
    call _div8_3
    ld b, a
    ld hl, _data

    ret

_offset_nt:
    db $07, $00
_offset_data:
    db $00, $00

_grid_to_vram:
    ld b, 9
    ld c, 9
    ld d, 0
    ld e, 0
_grid_to_vram_loop:
    ld hl, $1800
    ld ix, (_grid_screen)
    add hl, de
    call SETWRT
    ld hl, _data
    ld de, (_offset_data)
    add hl, de
    ld a, (hl)
    add $30
    out (VDPData), a
    ; inc offset name table
    ld hl, (_offset_nt)
    inc hl
    inc hl
    ld (_offset_nt), hl 
    ; inc offset data
    ld de, (_offset_data)
    inc de
    ld (_offset_data), de
    djnz _grid_to_vram_loop
    ld hl, (_offset_nt)
    ld de, 46
    add hl, de
    ld (_offset_nt), hl
    ld b, 9
    dec c
    jr nz, _grid_to_vram_loop
    ret




_print_grid:
    ld hl, _data
    ld c, 9
_print_grid_outer_loop:
    ld b, 9
_print_grid_inner_loop:
    ld a, (hl)
    add $30
    call CHPUT
    inc hl
    djnz _print_grid_inner_loop
    ld a, 13
    call CHPUT
    ld a, 10
    call CHPUT
    dec c
    jr nz, _print_grid_outer_loop
    ret
; in     -
; out    a      true/false
_has_val_in_block:
    push bc
    push de
    push hl
    ld de, (_current_ij)
    ld a, (_current_val)
    ; get block row index
    ld h, 0
    ld l, d
    call _div8_3
    call _mult8_3
    ld d, a
    ; get block col index
    ld h, 0
    ld l, e
    call _div8_3
    call _mult8_3
    ld e, a
    ; get block k
    ex de, hl
    call _get_k
    ; hl has now the address to the start of the block.
    ; d = current_val, e = k0

    ; outer loop
    ld c, 3
_has_val_in_block_outer_loop:
    ; inner loop
    ld b, 3
_has_val_in_block_inner_loop:
     ; if (k == k0) break;       
    ld a, (_current_k)   
    sub e
    jr z, _has_val_in_block_continue
    ; get data[k]
    ld hl, _data
    add hl, de
    ld a, (hl)
    ; if (data[k] == _current_val)
    ld l, a
    ld h, 0
    ld a, (_current_val)
    sub l
    jr z, _has_val_in_block_ret_true
_has_val_in_block_continue:
    inc e
    djnz _has_val_in_block_inner_loop
    ld a, e
    add 6
    ld e, a
    dec c
    jr nz, _has_val_in_block_outer_loop
_has_val_in_block_ret_false:
    ld a, 0
    pop hl
    pop de
    pop bc
    ret
_has_val_in_block_ret_true:
    ld a, 1
    pop hl
    pop de
    pop bc
    ret

; in     -
; out    a      true/false
_has_val_in_row:
    ld hl, (_current_ij)
    ld l, 0         ; set col to 0
    ld a, (_current_val)
    ld b, 9
    ld c, a
    ; b = counter, c = current val
    call _get_k     ; D=0, E <- k
_has_val_in_row_while_do:
     ; if (k == k0) break;       
    ld a, (_current_k)   
    sub e
    jr z, _has_val_in_row_continue
    ; if (data[k] == _current_val)
    ld hl, _data    ; ptr_data
    add hl, de      ; ptr_data + k
    ld a, (hl)      ; A <- data[k]
    sub c           ; if (a-c) == 0
    jr z, _has_val_in_row_ret_true
_has_val_in_row_continue:
    inc e           ; next col
    djnz _has_val_in_row_while_do
_has_val_in_row_ret_false:
    ld a, 0
    ret
_has_val_in_row_ret_true:
    ld a, 1
    ret


_has_val_in_col:
    ld hl, (_current_ij)
    ld h, 0         ; set row to 0
    ld a, (_current_val)
    ld b, 9
    ld c, a
    ; b = counter, c = current val
    call _get_k     ; D=0, E <- k
_has_val_in_col_while_do:
     ; if (k == k0) break;       
    ld a, (_current_k)   
    sub e
    jr z, _has_val_in_col_continue
    ; if (data[k] == _current_val)
    ld hl, _data    ; ptr_data
    add hl, de      ; ptr_data + k
    ld a, (hl)      ; A <- data[k]
    sub c           ; if (a-c) == 0
    jr z, _has_val_in_col_ret_true
_has_val_in_col_continue:
    ld a, e
    add 9
    ld e, a         ; next col
    djnz _has_val_in_col_while_do
_has_val_in_col_ret_false:
    ld a, 0
    ret
_has_val_in_col_ret_true:
    ld a, 1
    ret
    
; in      hl    row,col
; out     de    k
_get_k:
    push bc
    ld b, h       ; b <- row 
    ld c, l       ; c <- col
        ; prepare for mult function
    ld h, 0
    ld l, b
    ld d, 0
    ld e, 9
    call _mult8   ; hl <- l * e
    ; calculate k
    ld a, 0
    add l         ; row*9
    add c         ; row*9+col
    ; prepare return of DE
    ld (_current_k), a
    ld e, a
    ld d, 0
    pop bc
    ret 
 
_k_to_screen_i:
    ld a, (_current_k)
    push af
    call _div8_9
    ld h, 0
    ld l, a
    ld d, 0
    ld e, 9
    call _mult8
    ld ix, (_grid_screen + 4)
    ld de, ix
    ld d, 0
    call _mult8
    ld ix, (_grid_screen + 2)
    ld de, ix
    ld d, 0
    add hl, de
    ld (_grid_screen), hl
    ret

; in    h=0, l=var1
;       d=0, e=var2
; out   hl
_mult8:
    ld h, l
    ld l, 0
    ld d, 0
    ld b, 8
_mult8_loop:
    add hl, hl
    jr nc, _mult8_noadd
    add hl, de
_mult8_noadd:
    djnz _mult8_loop
    ret

; in    h=0, l=var1
; ret   a
_div8_3:
    ld a, l
    ld h, 0
_div8_3_loop:
    sub 3
    jr c, _div8_3_ret
    inc h
    jr _div8_3_loop
_div8_3_ret:
    ld a, h
    ret

; in    h=0, l=var1
; ret   a
_div8_9:
    ld a, l
    ld h, 0
_div8_9_loop:
    sub 9
    jr c, _div8_9_ret
    inc h
    jr _div8_9_loop
_div8_9_ret:
    ld a, h
    ret

;in     a
;out    a * 3
_mult8_3:
    cp 0
    ret z
    ld b, a
    ld c, 3
    ld a, 0
_mult8_3_loop:
    add c
    djnz _mult8_3_loop
    ret

_grid_screen:
    db $00,$00 ; current index
    db $07,$02 ; offset x, offset y
    db $02,$02 ; stride x, stride y

_current_ij:
    db $00,$00
_current_k:
    db $00
_current_val:
    db $00

_data:
    db $01,$02,$03, $04,$05,$06, $07,$08,$09
    db $04,$05,$06, $07,$08,$09, $01,$02,$03
    db $07,$08,$09, $01,$02,$03, $04,$05,$06

    db $02,$03,$04, $05,$06,$07, $08,$09,$01
    db $05,$06,$07, $08,$09,$01, $02,$03,$04
    db $08,$09,$01, $02,$03,$04, $05,$06,$07

    db $03,$04,$05, $06,$07,$08, $09,$01,$02
    db $06,$07,$08, $09,$01,$02, $03,$04,$05
    db $09,$01,$02, $03,$04,$05, $06,$07,$08

_offset:
    db $01,$02

_keyin:
    db $00

_file_end:


