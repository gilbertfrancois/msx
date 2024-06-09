ORGADR  equ $c000
 
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
_backup_slot_registers:
    in a, ($a8)
    ld (_slot_restore_a), a
    ld e, a
    ld a, ($ffff)
    cpl
    ld (_slot_restore_b), a
    ret

_slot_restore_a: 
    db 0
_slot_restore_b: 
    db 0
_file_end:
