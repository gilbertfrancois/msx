if not defined FSQRT

    INCLUDE "print_fp.asm"

; HL = HL^0.5
DEBUG@FSQRT:
FSQRT:
        CALL    @FSQRT
        PUSH    HL                      ;  1:11
        LD      HL, 'S'+'Q' * 256       ;  3:10     "SQ"
        LD      A, COL_BLUE             ;  2:7
        JP      PRINT_XFP               ;  3:10
else
    if not defined DEBUG@FSQRT
        .WARNING You must include the file: debug_fsqrt.asm before.
    endif
endif
