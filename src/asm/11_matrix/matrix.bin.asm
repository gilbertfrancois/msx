ORGADR      equ $c000
CHGMOD      equ $005f
CHGCLR      equ $0062
LDIRVM      equ $005c
BREAKX      equ $00b7
VDPData     equ $98
VDPControl  equ $99

HTIMI       equ $fd9f
JIFFY       equ $fc9e           ; 50Hz Jiffy Counter (2B/RW)
FORCLR      equ $f3e9
BAKCLR      equ $f3ea
BDRCLR      equ $f3eb

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

_app_constants:
SCREENMODE  equ 1               ; 0 = text mode, 1 = bitmap mode
WIDTH       equ 32              ; Screen width
HEIGHT      equ 24              ; Screen height 
HHEIGHT     equ HEIGHT/2        ; Half screen height
NAME_TABLE  equ $1800           ; Address of the name table
N_PERM      equ 1               ; Number of permutations times 3 per screen update
P_RAIN      equ 8               ; Probability of rain: 1/p_rain
N_FADEOUTS  equ 3               ; Number of chars to darken at the end of the rain
SPEED_VAR   equ 8               ; Speed variation of the rain drops
WAIT_CYCLES equ 1		; N wait cycles before refresh. 1=50fps, 2=25fps, etc

_main:
    call _setup
_main_loop:
    ld a, (_request_render)
    cp 0
    jp nz, __breakx
    call _update
    ; draw is handled by interrupt hook, after _request_render is set to 1.
__breakx:
    call BREAKX
    jr nc, _main_loop
    call _cleanup
    ret

_setup:
    ; Install interrupt hook.
    di
    ; Preserve old hook instructions
    ld hl, HTIMI
    ld de, _old_interrupt_hook
    ld bc, 5
    ldir
    ; Copy new hook instructions
    ld hl, _new_interrupt_hook
    ld de, HTIMI
    ld bc, 5
    ldir
    ei
    ; Set screen mode and colors
    ld a, SCREENMODE
    call CHGMOD
    ld hl, FORCLR
    ld (hl), 2
    ld hl, BAKCLR
    ld (hl), 1
    ld hl, BDRCLR
    ld (hl), 1
    call CHGCLR
    ret

_cleanup:
    ld a, 0
    call CHGMOD
    ret

_update:
    call _update_rain_state
    call _update_rain_columns
    call _update_rnd_char
    ld hl, _request_render
    ld (hl), 1
    ret

_draw:
    ; Copy new state to VRAM
    ld hl, _name_table_buffer
    ld de, NAME_TABLE
    ld bc, WIDTH*HEIGHT
    call LDIRVM
    ret 

_run_interrupt:
    ld hl, _interrupt_counter
    dec (hl)
    ld a, (hl)
    jp nz, _old_interrupt_hook
    ; Run every WAIT_CYCLES times
    ; Reset _interrupt counter and call _draw
    ld (hl), WAIT_CYCLES
    ld a, (_request_render)
    cp 1
    jp nz, _set_is_slow
    ; Update was ready, render request was set. 
    ; reset _is_slow and _render_request, then call draw function.
    ld a, 0
    ld (_is_slow), a
    ld (_request_render), a
    call _draw
    jr _old_interrupt_hook
_set_is_slow:
    ld a, 1
    ld (_is_slow), a
    ld a, $21
    ld (_name_table_buffer), a
; Interrupt jump block.
_old_interrupt_hook:
    db 0, 0, 0, 0, 0 
    ret

_new_interrupt_hook:
    jp _run_interrupt
    ret
    nop

_update_rain_state:
    ; Update the rain state for a random column. The state can be 0 (no rain) or 1 (rain). 
    ; First, test if we activate a new rain drop with probability 1/p_rain.
    ld a, P_RAIN
    call _rnd8
    cp 1
    jp nz, __update_rain_state_ret
    ; get a random column
    ld a, WIDTH
    call _rnd8
    ; get the address of _drop_state for column i.
    dec a                       ; a = 0..WIDTH-1
    ld d, 0
    ld e, a
    ld hl, _drop_state
    add hl, de
    ; get current drop state for col i
    ld a, (hl)
    cp 0
    jp nz, __update_rain_state_ret ; if drop state is 1, skip
    ; set drop state to true for this column
    inc (hl)
    ; set a random drop speed
    ld hl, _drop_speed
    add hl, de                  ; hl = &drop_speed[i]
    ld a, SPEED_VAR
    push hl
    call _rnd8
    pop hl
    ld (hl), a
    ; set drop speed counter to 0
    ld hl, _drop_speed_counter
    add hl, de
    ld a, 0
    ld (hl), a
    ; set drop start to 0
    ld hl, _drop_start
    add hl, de
    ld a, 0
    ld (hl), a
    ; set drop length, range = [HEIGHT/2 .. HEIGHT]
    ld hl, _drop_length
    add hl, de
    push hl
    ld a, HHEIGHT
    call _rnd8
    pop hl
    add a, HHEIGHT
    ld (hl), a
__update_rain_state_ret:
    ret

_update_rain_columns:
    ld b, WIDTH
    ld h, 0
    ld l, b
    ld (_COL), hl
__update_rain_columns_loop:
    push bc
    ld de, (_COL)
    dec de
    ld (_COL), de
    ld hl, _drop_state 
    add hl, de                  ; hl = &drop_state[i]
    ld a, (hl)                  ; a = drop_state[i]
    cp 0                        ; if (drop_state[i] == 0)
    jp z, __update_rain_columns_continue ; skip, no rain here.
    ld hl, _drop_speed
    add hl, de                  ; hl = &drop_speed[i]
    ld a, (hl)
    ld c, a                     ; c = drop_speed[i]
    ld hl, _drop_speed_counter
    add hl, de                  ; hl = &drop_speed_counter[i]
    ld a, (hl)                  ; a = drop_speed_counter[i]
    sub c                       ; a = drop_speed_counter[i] - drop_speed[i]
    jr nc, __update_rain_column_i
    inc (hl)                    ; drop_speed_counter[i]++
    jp __update_rain_columns_continue
__update_rain_column_i:
    ld (hl), 0                  ; drop_speed_counter[i] = 0
    call _update_rain_column
__update_rain_columns_continue:
    pop bc
    djnz __update_rain_columns_loop
    ret

_update_rain_column:
    ; Advance the rain drop in column i
    ld de, (_col)               ; de = i
    ; start = _drop_start[i]
    ld hl, _drop_start
    add hl, de
    ld a, (hl)
    ld (_start), a
    ; length = _drop_length[i]
    ld hl, _drop_length
    add hl, de
    ld a, (hl)
    ld (_length), a
    ; end = start - length
    ld a, (_length)
    ld b, a
    ld a, (_start)
    sub b
    ; if (start - length < 0)
    jr c, __then_end_is_zero
__else_end_eq_start_min_length:
    ld (_end), a
    jr __update_rain_column_continue
__then_end_is_zero:
    ld a, 0
    ld (_end), a
__update_rain_column_continue:
    ; if (end > HEIGHT)
    ld a, (_end)
    sub HEIGHT + 1
    jr nc, __reset_all_states_for_column
    ; else update the drop state
    call _update_rain_column_chars
    ; drop_start[i]++
    ld hl, _drop_start
    ld de, (_col)
    add hl, de
    inc (hl)
    jp __update_rain_column_ret
__reset_all_states_for_column:
    ld de, (_col)
    ld hl, _drop_state
    add hl, de
    ld (hl), 0
    ld hl, _drop_speed
    add hl, de
    ld (hl), 0
    ld hl, _drop_speed_counter
    add hl, de
    ld (hl), 0
    ld hl, _drop_start
    add hl, de
    ld (hl), 0
    ld hl, _drop_length
    add hl, de
    ld (hl), 0
__update_rain_column_ret:
    ret

_update_rain_column_chars:
    ; Add a character at the start of the rain trail.
    ; if (start > height), skip add character.
    ld a, (_start)
    sub HEIGHT
    jr nc, __update_rain_column_chars_continue
    ld a, (_start)
    ld c, a                 ; c = row
    ld a, (_col)
    ld b, a                 ; b = col
    call _get_index         ; hl = k = y * WIDTH + x
    ex de, hl               ; de = k
    ; update the character at k in the name table buffer
    ld hl, _name_table_buffer
    add hl, de
    push hl
    call _get_char
    pop hl
    ld (hl), a
__update_rain_column_chars_continue:
    ; Remove a character at the end of the rain trail.
    ; if (end > 1), continue 
    ld a, (_end)
    sub 1
    jr c, __update_rain_column_chars_ret
    ld a, (_end)
    dec a
    ld c, a                 ; c = row
    ld a, (_col)
    ld b, a                 ; b = col
    call _get_index         ; hl = k = y * WIDTH + x
    ex de, hl               ; de = k
    ; update the character at k in the name table buffer
    ld hl, _name_table_buffer
    add hl, de
    ld a, $20
    ld (hl), a
__update_rain_column_chars_ret:
    ret

_update_rnd_char:
    ld b, N_PERM
    ld c, 3
__update_rnd_char_outer_loop:
    push bc
__update_rnd_char_inner_loop:
    ld a, $ff                   ; get a random offset in the 1/3 part of the screen
    push bc
    call _rnd8
    pop bc
    dec c
    ld d, c                     ; d = 0..2, offset to the 1/3 part of the screen 
    ld e, a                     ; e = 0..255, offset in the 1/3 part of the screen
    ld hl, _name_table_buffer
    add hl, de
    ld a, (hl)
    ; if (a == ' '), do nothing
    cp $20                      
    jp z, __update_rnd_char_inner_loop_next
    ; else replace the character with a random character
    push bc
    push hl
    call _get_char
    pop hl
    pop bc
    ld (hl), a
__update_rnd_char_inner_loop_next:
    ld a, c
    cp 0
    jp nz, __update_rnd_char_inner_loop
    pop bc
    ld c, 2
    djnz __update_rnd_char_outer_loop
    ret

_get_char:
    ; Get a random character from the printable character set.
    ; in:  none
    ; out: a = random character
    ; registers: af, bc, hl
    ld a, 159
    call _rnd8
    add 33
    ret

_rnd8:
    ; Get a random value in the range [1..a]
    ; in:  a = max value
    ; out: a = random value
    ; registers: bc, hl
    push af
    ld a, (_rnd8_idx)
    inc a                ; the lookup table is 256 bytes long, overflow is ok.
    ld c, a
    ld a, (JIFFY)        ; use the low byte of the jiffy counter as a seed
    add c                ; add the seed to the index
    ld (_rnd8_idx), a    
    ld hl, _rnd8_data    ; start address lookup table
    ld b, 0
    ld c, a              ; current offset
    add hl, bc           ; hl is now the address of the random value
    pop af
    ld b, a              ; b = max value
    ld a, (hl)           ; get the random value
_rnd8_rrange:
    sub b                ; we need 0-rval only
    jr nc, _rnd8_rrange  ; repeat unitl within range of value
    adc a, b             ; undo last subtraction, range 1-rval
    ret


_get_index:
    ; Get relative position in memory
    ; compute y * WIDTH + x (naive implementation)
    ; in:   bc = (x, y), b = col, c = row
    ;       x = 0..31, y = 0..23
    ; out:  hl = k = y * WIDTH + x
    ; registers: af, bc, hl
    ;
    ; load y coordinate in low byte
    ld l, c
    xor a
    ; multiply y by COLS, shift L left 5 times, push overflow in H
    sla l
    rla
    sla l
    rla
    sla l
    rla
    sla l
    rla
    sla l
    rla
    ld h, a
    ; Add the x coordinate in the low byte
    ld a, b
    or l
    ld l, a
    ret


_rnd8_idx:
    db $00
_rnd8_idx_max:
    db $ff
_rnd8_data:
    db $d8, $d1, $8a, $01, $b4, $7c, $9c, $ae
    db $45, $3e, $50, $96, $bb, $e3, $a2, $66
    db $b7, $18, $8f, $fb, $0d, $f5, $1f, $09
    db $2f, $1a, $a5, $dd, $9d, $75, $c8, $37
    db $f9, $e4, $e9, $bf, $90, $6c, $ec, $5c
    db $3b, $fe, $9f, $68, $15, $bc, $11, $e6
    db $b6, $f7, $ee, $86, $7e, $29, $d0, $54
    db $55, $a6, $44, $33, $56, $3c, $c3, $c7
    db $be, $b8, $25, $77, $93, $b2, $8b, $41
    db $6e, $3a, $64, $b9, $aa, $ab, $5d, $d2
    db $0a, $af, $eb, $0b, $6a, $c1, $f3, $7a
    db $ad, $b5, $bd, $c6, $7d, $0e, $98, $b1
    db $fa, $63, $9e, $c5, $21, $57, $79, $03
    db $fd, $71, $d5, $c9, $ff, $db, $2a, $08
    db $67, $8e, $fc, $07, $e7, $31, $a8, $de
    db $94, $6d, $91, $1e, $4b, $ce, $82, $0f
    db $83, $26, $1b, $b3, $5e, $81, $69, $da
    db $61, $9a, $e1, $4d, $32, $59, $38, $27
    db $46, $3d, $13, $a0, $cd, $ea, $39, $d3
    db $51, $34, $80, $6f, $a4, $7f, $49, $05
    db $5f, $5a, $74, $df, $5b, $2b, $48, $89
    db $17, $ba, $62, $8d, $dc, $78, $c2, $06
    db $c4, $16, $d4, $0c, $76, $f4, $65, $ef
    db $a1, $4a, $e2, $95, $f1, $b0, $9b, $19
    db $60, $7b, $2e, $f0, $1c, $72, $88, $30
    db $8c, $24, $99, $02, $d7, $84, $43, $ac
    db $c0, $97, $70, $12, $a9, $42, $cc, $4f
    db $1d, $4e, $cf, $87, $e0, $f2, $2d, $04
    db $e5, $23, $58, $10, $85, $a7, $47, $35
    db $28, $73, $53, $d6, $ed, $14, $52, $22
    db $2c, $40, $36, $3f, $92, $6b, $f6, $cb
    db $f8, $00, $ca, $d9, $e8, $4c, $20, $a3

; request render
_request_render:
    db 0
; flag that indicates if the system needs more time than the requested 
; refresh rate.
_is_slow:
    db 0
_interrupt_counter:
    db 0
; variables for updating a column. 
_start:
    db 0
_length:
    db 0
_end:
    db 0
; reserve 2 bytes for the column index, so that we can fetch it conveniently
; with an 8bit or 16bit register.
_col:
    dw 0                        

; State arrays for the rain drops, one state for each column.
_drop_state:
    ds WIDTH, 0
_drop_speed:
    ds WIDTH, 0
_drop_speed_counter:
    ds WIDTH, 0
_drop_start:
    ds WIDTH, 0
_drop_length:
    ds WIDTH, 0
_name_table_buffer:
    ds WIDTH*HEIGHT, $20
_color_table_buffer:
    ds WIDTH*HEIGHT, $21


_file_end:
