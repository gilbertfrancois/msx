ORGADR  equ $c000
CHPUT   equ $00A2
CHGMOD  equ $005f
 
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
	ld e, a
	ld d, 0
	pop bc
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


_current_ij:
	db &00,&00
_current_k:
	db &00
_current_val:
	db &00

_data:
	db &00,&01,&02,&03,&04,&05,&06,&07,&08
	db &10,&11,&12,&13,&14,&15,&16,&17,&18
	db &20,&21,&22,&00,&00,&00,&00,&00,&00
	db &30,&31,&32,&33,&34,&35,&36,&37,&38
	db &40,&41,&42,&43,&44,&45,&46,&47,&48
	db &50,&51,&52,&53,&54,&55,&56,&57,&57
	db &60,&61,&62,&63,&64,&65,&66,&67,&68
	db &70,&71,&72,&73,&74,&75,&76,&77,&78
	db &80,&81,&82,&83,&84,&85,&86,&87,&88


_file_end:
