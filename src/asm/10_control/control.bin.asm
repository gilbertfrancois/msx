ORGADR      equ $c000
ERAFNK      equ $00cc
CHPUT       equ $00a2
CHGET	    equ $009f
CHSNS       equ $009c
CHGMOD      equ $005f
CHGCLR      equ $0062
LDIRVM      equ $005c
SETWRT      equ $0053
POSIT       equ $00c6
GTSTCK      equ $00d5
VDPData     equ $98
VDPControl  equ $99

KEYCLK      equ $f3db	;Key Press Click Switch 0:Off 1:On (1B/RW)
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

; =[ CODE ]=====================================================================

_main:
    ; set screen mode to 1
    ld a, 1
    call CHGMOD
    ; set screen colors
    ld a, 1
    ld (BDRCLR), a
    ld (BAKCLR), a
    ld a, 10
    ld (FORCLR), a
    call CHGCLR
    ; disable function keys
    call ERAFNK
    ; disable key click
    ld a, 0
    ld (KEYCLK), a
    ; init player position
    ld hl, $0f0c
    ld (_player_yx), hl
    ; draw first frame and start event loop
    call _draw_player
    call _event_loop
_exit:
    ret

_event_loop:
    ; read cursor keys
    ld a, 0
    call GTSTCK
    or a
    jr nz, _start_draw
    ; check for keypress
    call CHSNS
    jp z, _event_loop
    call CHGET
    cp $1b
    jp z, _exit
    jp _event_loop

_start_draw:
    push af
    ld bc, (_player_yx)
    ld (_player_yx_prev), bc
    push bc
    call _blank_player
    pop bc
    pop af
_if_joy_up:
    ld d, a
    cp 1
    jr nz, _if_joy_down
    dec c
_if_joy_down:
    ld a, d
    cp 5
    jr nz, _if_joy_left
    inc c
_if_joy_left:
    ld a, d
    cp 7
    jr nz, _if_joy_right
    dec b
_if_joy_right:
    ld a, d
    cp 3
    jr nz, _update_player_pos
    inc b
_update_player_pos:
    ld (_player_yx), bc
    ; boundary check
    ld a, b
    cp 32
    jr c, _player_x_ok
    jr _player_reset
_player_x_ok:
    ld a, c
    cp 24
    jr c, _player_yx_ok
    jr _player_reset
_player_reset:
    ld bc, (_player_yx_prev)
    ld (_player_yx), bc
_player_yx_ok:
    call _draw_player
    ld bc, 5000
    call _pause
    jp _event_loop

_draw_player:
    ld bc, (_player_yx)
    call _get_vdp_pos
    call SETWRT
    ld a, (_player_sprite)
    out (VDPData), a
    ret

_blank_player:
    ld bc, (_player_yx_prev)
    call _get_vdp_pos
    call SETWRT
    ld a, $20
    out (VDPData), a
    ret

_get_vdp_pos:
    ; compute y * 32 + x (naive implementation)
    ; in:   bc = (x, y)
    ;       x = 0..31, y = 0..23
    ; out:  hl = VDP write address
    ; 
    ; load y coordinate in low byte
    ld l, c
    xor a
    ; multiply y by 32, shift L left 5 times, push overflow in H
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
    ; tilemap starts at $1800
    ld a, h
    or $18
    ld h, a
    ret


_pause:
    ; in:   bc = pause time
	dec bc
	ld a,b
	or c
	jr nz, _pause
	ret

; =[ DATA ]=====================================================================

_player_yx:
    db $0c, $0f
_player_yx_prev:
    db $0c, $0f
_player_sprite:
    db $02
_vdp_offset:
    dw $00
_vdp_offset2:
    dw $00

_file_end:
