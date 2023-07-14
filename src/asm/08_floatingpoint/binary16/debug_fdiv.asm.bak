if not defined FDIV

    INCLUDE "print_fp.asm"

; HL = BC / HL
DEBUG@FDIV:
FDIV:
        CALL    @FDIV                   ;  3:17
        PUSH    HL                      ;  1:11
        LD      HL, '/'+' ' * 256       ;  3:10     "/ "
        LD      A, COL_BLUE             ;  2:7
        JP      PRINT_XFP               ;  3:10

else
    if not defined DEBUG@FDIV
        .WARNING You must include the file: debug_fdiv.asm before.
    endif
endif
