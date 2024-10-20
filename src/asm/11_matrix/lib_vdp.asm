; lib VDP 9918. 
VDPData     equ $98
VDPControl  equ $99

_setwrt_hl:
    ; Enable VDP to write. Replaces bios call SETWRT
    ; in       : hl = destination vram address
    ; registers: af, de
    ld a, l
    di
    out (VDPControl), a
    ld a, h
    and %00111111               ; Don't touch the 2 MSB
    or %01000000                ; set 1 = write mode (0 = read)
    out (VDPControl), a
    ei
    ret

_setwrt_de:
    ; Enable VDP to write. Replaces bios call SETWRT
    ; in       : de = destination vram address
    ; registers: af, de
    ld a, e
    di
    out (VDPControl), a
    ld a, d
    and %00111111               ; Don't touch the 2 MSB
    or %01000000                ; set 1 = write mode (0 = read)
    out (VDPControl), a
    ei
    ret

_ldirvm8:
    ; Possible replacement for LDIRVM. Copy data to vram. The write block must
    ; be smaller than 256 bytes, since it uses only register b as counter.
    ; in: hl = source ram address
    ;     de = destination vram address
    ;     b = number of bytes
    ; registers: af, bc, de, hl
    call _setwrt_de
    ld c, VDPData
_ldirvm8_loop:
    outi
    jp nz, _ldirvm_loop
    ret

_ldirvm:
    ; Possible replacement for LDIRVM. Copy data to vram, 16 bit version.
    ; in: hl = source ram address
    ;     de = destination vram address
    ;     bc = number of bytes
    ; registers: af, bc, de, hl
    ex de, hl
    call _setwrt_hl
_ldirvm_loop:
    ld a, (de)
    out (VDPData), a
    inc de
    dec bc
    ld a, c
    or b
    jr nz, _ldirvm_loop
    ret

_fillvrm:
    ; Fill vram with a value
    ; in:  a = Data byte
    ;     de = Destination vram address
    ;     bc = Number of bytes to be written
    ;     
    push af
    call _setwrt_de
_fillvrm_loop:
    pop af
    out (VDPData), a
    push af
    dec bc
    ld a, c
    or b
    jr nz, _fillvrm_loop
    pop af
    ret
