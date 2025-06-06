;   Copyright 2024 Gilbert Francois Duivesteijn
;
;   Licensed under the Apache License, Version 2.0 (the "License");
;   you may not use this file except in compliance with the License.
;   You may obtain a copy of the License at
;
;       http://www.apache.org/licenses/LICENSE-2.0
;
;   Unless required by applicable law or agreed to in writing, software
;   distributed under the License is distributed on an "AS IS" BASIS,
;   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;   See the License for the specific language governing permissions and
;   limitations under the License.

;   Screen 2 version

ORGADR      equ $c000

HTIMI       equ $fd9f
JIFFY       equ $fc9e           ; 50Hz Jiffy Counter (2B/RW)

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
SCREENMODE  equ 2               ; 0 = text mode, 1 = bitmap mode
WIDTH       equ 32              ; Screen width
HEIGHT      equ 24              ; Screen height
HHEIGHT     equ HEIGHT/2        ; Half screen height
N_PERM      equ 6               ; Number of permutations times 3 per screen update
P_RAIN      equ 6               ; Probability of rain: 1/p_rain
N_FADEOUTS  equ 3               ; Number of chars to darken at the end of the rain
SPEED_VAR   equ 8               ; Speed variation of the rain drops
WAIT_CYCLES equ 2               ; N wait cycles before refresh. 1=50fps, 2=25fps, etc

_main:
    call _setup
_main_loop:
    ld a, (_request_update)
    cp 1
    jp nz, _main_loop
    call _update
    jr _main_loop
    ; It should never reach this point.
    di
    halt

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
    call _init_sc2
    ld a, $21
    call _init_color_table
    call _rnd8_set_seed
    ret

_update:
        ; Begin visual time measurement.
        ld a, $26
        call _debug_timing
    call _update_rain_state
    call _update_rain_columns
    call _update_rnd_char
    ld a, 0
    ld (_request_update), a
        ; End visual time measurement.
        ld a, $21
        call _debug_timing
    ret

_run_interrupt:
    ld hl, _interrupt_counter
    dec (hl)
    ld a, (hl)
    jp nz, _old_interrupt_hook
    ; Reset _interrupt counter and call _draw
    ld (hl), WAIT_CYCLES
__run_interrupt_on_request_update:
    ld a, 1
    ld (_request_update), a
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
    ld (_col), a
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
    ; set drop trail color
__update_rain_state_set_color:
    ld a, 3
    call _rnd8
    dec a
    call _times8
    ld a, l
    push af
    ld hl, _drop_color
    ld a, (_col)
    ld d, 0
    ld e, a
    add hl, de
    pop af
    ld (hl), a                  ; drop_color[i] = a
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
    ld (_col), hl
__update_rain_columns_loop:
    push bc
    ld de, (_col)
    dec de
    ld (_col), de
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
    ld de, (_col)
    ld hl, _drop_end
    add hl, de
    ld (hl), a
    jr __update_rain_column_continue
__then_end_is_zero:
    ld a, 0
    ld (_end), a
    ld de, (_col)
    ld hl, _drop_end
    add hl, de
    ld (hl), a
__update_rain_column_continue:
    ; if (end > HEIGHT)
    ld a, (_end)
    sub HEIGHT + 1
    jr nc, __reset_all_states_for_column
    ; else update the drop state
    call _update_rain_column_chars
    call _update_rain_column_colors
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
    ld hl, _drop_end
    add hl, de
    ld (hl), 0
__update_rain_column_ret:
    ret

_cp_rnd_char_at_k_in_vdp:
    ; Copy a character from RAM to pattern generator table.
    ; in: de = vram destination address
    ; registers: af, bc, de, hl
    ld hl, CGPTBL2
    add hl, de              ; de = vram destination
    ex de, hl
    push de
    call _get_char          ; hl = ram source
    pop de
    ld a, 8
    ld c, a                 ; bc = len bytes to copy
    ld a, 0
    ld b, a
    call _ldirvm            ; hl = char addr, de = k, 
    ret

_cp_spc_char_at_k_in_vdp:
    ; Copy an empty character from RAM to pattern generator table.
    ; in: de = vram destination address
    ; registers: af, bc, de, hl
    ld hl, CGPTBL2
    add hl, de              ; de = vram destination
    ex de, hl
    ld hl, _spc
    ld a, 8
    ld c, a                 ; bc = len bytes to copy
    ld a, 0
    ld b, a
    call _ldirvm            ; hl = char addr, de = k, 
    ret

_cp_color_at_k_in_vdp:
    ; Copy an empty character from RAM to pattern generator table.
    ; in: de = vram destination address
    ;     _color = color value
    ; registers: af, bc, de, hl
    ld hl, COLTBL2
    add hl, de              ; de = vram destination
    ex de, hl
    ld hl, (_color)
    ld a, 8
    ld c, a                 ; bc = len bytes to copy
    ld a, 0
    ld b, a
    call _ldirvm            ; hl = char addr, de = k, 
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
    call _times8_hl
    ex de, hl               ; de = k
    ; update the character at k in the pattern generator table
    call _cp_rnd_char_at_k_in_vdp
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
    call _times8_hl
    ex de, hl               ; de = k
    ; update the character at k in the pattern generator table
    call _cp_spc_char_at_k_in_vdp
__update_rain_column_chars_ret:
    ret


_update_rain_column_colors:
    ; Set color to white at start of the trail
    ; If (start > HEIGHT) then skip set color
    ld a, (_start)
    sub HEIGHT
    jp nc, __update_rain_column_colors_continue_1
    ld a, (_start)
    ld c, a                 ; c = row
    ld a, (_col)
    ld b, a                 ; b = col
    call _get_index         ; hl = k = y * WIDTH + x
    call _times8_hl
    ex de, hl               ; de = k
    ld hl, _color_head1
    ld (_color), hl
    call _cp_color_at_k_in_vdp:
__update_rain_column_colors_continue_1:
    ; Set color to green at start - 1 of the trail
    ; if (start - height-1) > 0 or (start - 1) < 0 then skip
    ld a, (_start)
    sub HEIGHT + 1
    jp nc, __update_rain_column_colors_continue_2
    ld a, (_start)
    sub 1
    jp c, __update_rain_column_colors_continue_2
    ld a, (_start)
    sub 1
    ld c, a
    ld a, (_col)
    ld b, a
    call _get_index
    call _times8_hl
    ex de, hl
    ld hl, _color_head2
    ld (_color), hl
    call _cp_color_at_k_in_vdp
__update_rain_column_colors_continue_2:
    ; Set color to green at start - 1 of the trail
    ; if (start - height-1) > 0 or (start - 1) < 0 then skip
    ld a, (_start)
    sub HEIGHT + 2
    jp nc, __update_rain_column_colors_continue_3
    ld a, (_start)
    sub 2
    jp c, __update_rain_column_colors_continue_3
    ld a, (_start)
    sub 2
    ld c, a
    ld a, (_col)
    ld b, a
    call _get_index
    call _times8_hl
    ex de, hl               ; de = vram destination
    ; get default color for this column
    ld a, (_col)
    ld c, a
    ld b, 0
    ld hl, _drop_color      ; start of color offset addresses
    add hl, bc              ; hl = *drop_color[i]
    ld a, (hl)              ; a = drop_color[i]
    ld b, 0
    ld c, a
    ld hl, _color_default1
    add hl, bc
    ld (_color), hl
    call _cp_color_at_k_in_vdp
__update_rain_column_colors_continue_3:
    ; Remove a character at the end of the rain trail.
    ; if (end > 1), continue 
    ld a, (_end)
    sub 1
    jp c, __update_rain_column_colors_continue_4
    ld a, (_end)
    ; dec a
    ld c, a                 ; c = row
    ld a, (_col)
    ld b, a                 ; b = col
    call _get_index         ; hl = k = y * WIDTH + x
    call _times8_hl
    ex de, hl               ; de = k
    ; get default color for this column
    ld a, (_col)
    ld c, a
    ld b, 0
    ld hl, _drop_color      ; start of color offset addresses
    add hl, bc              ; hl = *drop_color[i]
    ld a, (hl)              ; a = drop_color[i]
    ld b, 0
    ld c, a
    ld hl, _color_tail1
    add hl, bc
    ld (_color), hl
    call _cp_color_at_k_in_vdp
__update_rain_column_colors_continue_4:
    ret

_set_color_tile_in_vdp:
    ; Set color tile in vdp
    ; in: a = row
    ;     _color = address of the color tile
    ; registers: af, bc, hl
    ld c, a
    ld a, (_col)
    ld b, a
    call _get_index
    call _times8_hl
    ex de, hl
    ld hl, _color_default1
    ld (_color), hl
    call _cp_color_at_k_in_vdp

_update_rnd_char:
    ; This function makes random permutations in the matrix.
    ; It takes a random (row, col) pair and checks if the coord is inside a
    ; rain trail. If true, then permutate the character in the pattern generator
    ; table.
    ld b, N_PERM                        ; Use b as loop counter
    ld c, 0
__update_rnd_char_loop:
    push bc
    ld a, 0
    ld (_start), a
    ld (_end), a
    ld (_row), a
    ld (_col), a
    ; Pick a random col
    ld a, WIDTH
    call _rnd8
    ld (_col), a
    ; Check for rain in this column
    ld hl, _drop_state
    ld de, (_col)
    add hl, de
    ld a, (hl)
    cp 1                                ; Is there rain in this col?
    jp nz, __update_rnd_char_loop_next  ; if (drop_state[i] != 1) goto next
__update_rnd_char_loop_start:
    ; Pick a random row
    ld a, HEIGHT
    call _rnd8
    dec a                               ; a = 0..HEIGHT-1
    ld (_row), a
    ; if (row > drop_start[i]) goto next
    ld hl, _drop_start
    ld de, (_col)
    add hl, de
    ld e, (hl)                          ; value of drop_start[i]
    ld a, e
    ld a, (_row)                        ; row_i
    and a                               ; reset carry
    sub e                               ; row_i - drop_start[i]
    jp nc, __update_rnd_char_loop_next
    ; if (row < drop_end[i])
    ld hl, _drop_end
    ld de, (_col)
    add hl, de
    ld e, (hl)                          ; value of drop_end[i]
    ld a, e
    inc a                               ; value of drop_end[i] + 1, don't include the end
    ld a, (_row)                        ; row_i
    and a                               ; reset carry
    sub e                               ; row_i - drop_end[i]
    jp c, __update_rnd_char_loop_next
    ; The (row, col) is inside a drop trail. Permutate the char.
    ld a, (_row)
    ld c, a
    ld a, (_col)
    ld b, a
    call _get_index
    call _times8_hl
    ex de, hl
    call _cp_rnd_char_at_k_in_vdp
__update_rnd_char_loop_next:
    pop bc
    djnz __update_rnd_char_loop
    ret

_get_char:
    ; Get start address of random character in ram.
    ; in:  none
    ; out: hl = relative start of random char address in charset.
    ; registers: af, bc, hl
    ld a, 253
    call _rnd8
    call _times8        ; Multiply by 8, to get the start of the ram address of the charset
    ex de, hl
    ld hl, _charset
    add hl, de
    ret

_rnd8_set_seed:
    ; Set the pseudo seed for the random number generator to the jiffy counter.
    ; registers: af
    ld a, (JIFFY)
    ld (_rnd8_idx), a
    ret

_rnd8:
    ; Get a random value in the range [1..a]
    ; in:  a = max value
    ; out: a = random value
    ; registers: bc, hl
    push af
    ld a, (_rnd8_idx)
    inc a                ; the lookup table is 256 bytes long, overflow is ok.
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

_times8:
    ; Multiply a by 8
    ; in:  a = value
    ; out: hl = value * 8
    ; registers: af, hl
    ld h, 0
    ld l, a
_times8_hl:
    ; Multiply hl by 8
    ; in : hl = value
    ; out: hl = value * 8
    ; registers: hl
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    ret

_get_index:
    ; Get relative position in memory
    ; compute y * WIDTH + x (naive implementation)
    ; in:   bc = (x, y), b = col, c = row
    ;       x = 0..31, y = 0..23
    ; out:  hl = k = y * WIDTH + x
    ; registers: af, bc, hl
    ld l, c                 ; load y coordinate in low byte
    xor a                   ; clear carry
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
    db $f8, $01, $ca, $d9, $e8, $4c, $20, $a3

_spc:
    db $00, $00, $00, $00, $00, $00, $00, $00 
_color_default1:
    db $21, $21, $21, $21, $21, $21, $21, $21
_color_default2:
    db $31, $31, $31, $31, $31, $31, $31, $31
_color_default3:
    db $c1, $c1, $c1, $c1, $c1, $c1, $c1, $c1
_color_head1:
    db $f1, $f1, $f1, $f1, $f1, $f1, $f1, $f1
_color_head2:
    db $71, $71, $71, $71, $71, $71, $71, $71
_color_tail1:
    db $21, $11, $21, $11, $21, $11, $21, $11
_color_tail2:
    db $31, $11, $31, $11, $31, $11, $31, $11
_color_tail3:
    db $c1, $11, $c1, $11, $c1, $11, $c1, $11
_color:
    dw 0

_request_update:
    db 0
_interrupt_counter:
    db 1
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
_row:
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
_drop_end:
    ds WIDTH, 0
_drop_color:
    ds WIDTH, 0

; Add includes here, so they are out of the way at debugging.
    include "src/lib_vdp.asm"
    include "src/lib_screen2.asm"
    include "src/lib_chars.asm"

_debug_timing:
    ifdef DEBUG
    and %00001111
    or %00100000
    di
    out (VDPControl), a
    ld a, %10000111
    out (VDPControl), a
    ei
    endif
    ret 

_file_end:
