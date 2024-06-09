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


ORGADR      equ $100

HTIMI       equ $fd9f
EXPTBL      equ $FCC1
SCREENMODE  equ 2               ; 0 = text mode, 1 = bitmap mode
WIDTH       equ 32              ; Screen width
HEIGHT      equ 24              ; Screen height 
HHEIGHT     equ HEIGHT/2        ; Half screen height
WAIT_ANIMATION_CYCLES equ 3               ; N wait cycles before refresh. 1=50fps, 2=25fps, etc
WAIT_MUSIC_CYCLES equ 1               ; N wait cycles before refresh. 1=50fps, 2=25fps, etc

    org ORGADR

_main:
    call _setup
    ld hl, _NYANCAT_MUSIC_START
    xor a
    call PLY_AKG_INIT
_main_loop:
    ld a, (_request_animation_update)
    cp 1
    jp nz, _sync_music
    call _update
_sync_music:
    ld a, (_request_music_update)
    cp 1
    jp nz, _main_loop
    call PLY_AKG_PLAY
    ld a, 0
    ld (_request_music_update), a
    jr _main_loop
    ; It should never reach this point.
    di
    halt

_setup:
    call _setup_screen2
    call _setup_interrupt_hook
    call _setup_pattern_table
    call _setup_color_table
    call _setup_name_table
    ; Set initial variables
    ld hl, _frame_0_to_1_name_table_delta
    ld (_current_mem_block), hl
    ld a, 1
    ld (_current_frame), a
    ; Setup music
    ret

_setup_interrupt_hook:
    ; Install interrupt hook.
    ; Preserve old hook instructions
    ld hl, HTIMI
    ld de, _old_interrupt_hook
    ld bc, 5
    ldir
    ; Set new hook instructions
    ld a, $f7					; RST #30
	ld (HTIMI), a				; In HTIMI hook
	call _get_slot              ; Our Slot in A
	ld (HTIMI+1), a				; Next HTIMI hook byte
	ld	hl, _run_interrupt
	ld (HTIMI+2), hl	

    ; Copy new hook instructions
    ; ld hl, _new_interrupt_hook
    ; ld de, HTIMI
    ; ld bc, 5
    ; ldir
    ret

_setup_screen2:
    call _init_sc2
    ret

_setup_pattern_table:
    ; Use the same data for all 3 segments.
    ld hl, _pattern_table_data
    ld de, CGPTBL2
    ld bc, $800
    call _ldirvm
    ld hl, _pattern_table_data
    ld de, CGPTBL2 + $800
    ld bc, $800
    call _ldirvm
    ld hl, _pattern_table_data
    ld de, CGPTBL2 + $1000
    ld bc, $800
    call _ldirvm
    ret

_setup_color_table:
    ; Use the same data for all 3 segments.
    ld hl, _color_table_data
    ld de, COLTBL2
    ld bc, $800
    call _ldirvm
    ld hl, _color_table_data
    ld de, COLTBL2 + $800
    ld bc, $800
    call _ldirvm
    ld hl, _color_table_data
    ld de, COLTBL2 + $1000
    ld bc, $800
    call _ldirvm
    ret

_setup_name_table:
    ; Arrange the tiles for the first frame.
    ld hl, _frame_0_name_table
    ld de, NAMTBL2
    ld bc, $0300
    call _ldirvm
    ret

_update:
        ; Begin visual time measurement.
        ld a, $26
        call _debug_timing
    call _update_frame
    ld a, 0
    ld (_request_animation_update), a
        ; End visual time measurement.
        ld a, $21
        call _debug_timing
    ret


_update_frame:
    ld hl, (_current_mem_block)
_update_frame_loop:
    ; Fetch name table address
    ld a, (hl)
    ld e, a
    inc hl
    ld a, (hl)
    ld d, a
    ; Check if we reached the end of the table, ending with de=$ffff.
    cp a, $ff
    jp z, _update_frame_loop_next_frame
    push hl
    call _setwrt_de
    pop hl
    ; Fetch name table value
    inc hl
    ld a, (hl)
    out (VDPData), a
    ; Go to next entry
    inc hl
    jp _update_frame_loop
_update_frame_loop_next_frame:
    ; Store the start of the next frame in the current_mem_block
    inc hl
    ld (_current_mem_block), hl
    ; Increase and store the frame counter
    ld a, (_current_frame)
    inc a
    cp a, 12
    jp z, _update_frame_loop_to_frame_0
    ; Frame counter is < 12, store it and return
    ld (_current_frame), a
    ret
_update_frame_loop_to_frame_0:
    ; Frame counter is 12, reset it to 0 and return
    ld a, 0
    ld (_current_frame), a
    ld hl, _frame_0_to_1_name_table_delta
    ld (_current_mem_block), hl
    ret

_request_music_update:
    db 0
_request_animation_update:
    db 0
_interrupt_animation_counter:
    db 1
_interrupt_music_counter:
    db 1
_current_frame:
    db 0
_current_mem_block:
    db 0, 0

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

_get_slot:
	in	a,($A8)
	rrca
	rrca
	and %00000011
	ld	c,a          ;c=slot
	ld	b,0
	ld	hl,EXPTBL
	add	hl,bc
	ld	a,(hl)
	and	#80
	or	c
	ld	c,a
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld	a,(hl)
	and	$0c
	or	c
	bit	7,a
	ret	nz
	and	%11
	ret

_run_interrupt:
_run_interrupt_animation:
    ld hl, _interrupt_animation_counter
    dec (hl)
    ld a, (hl)
    jp nz, _run_interrupt_music
    ; Reset _interrupt counter and call _draw
    ld (hl), WAIT_ANIMATION_CYCLES
    ld a, 1
    ld (_request_animation_update), a
_run_interrupt_music:
    ld hl, _interrupt_music_counter
    dec (hl)
    ld a, (hl)
    jp nz, _old_interrupt_hook
    ; Reset _interrupt counter and call play music
    ld (hl), WAIT_MUSIC_CYCLES
    ld a, 1
    ld (_request_music_update), a
    jp _old_interrupt_hook
; Interrupt jump block.
_old_interrupt_hook:
    db 0, 0, 0, 0, 0 
_new_interrupt_hook:
    rst $30;
    db 
    jp _run_interrupt
    ret
    nop

; Add includes here, so they are out of the way at debugging.
    include "../lib/lib_vdp.asm"
    include "../lib/lib_screen2.asm"
    include "../lib/lib_char_eu.asm"
    include "nyancat_data.asm"
    include "nyancat_music_universal.asm"

_file_end:
