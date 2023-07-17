if not defined FEXP

    INCLUDE "print_fp.asm"

; HL = exp(HL)
DEBUG@FEXP:
FEXP:
        CALL    @FEXP               ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, 'e' + $5E * 256 ;  3:10     "e↑"
        LD      A, COL_BLUE         ;  2:7
        JP      PRINT_XFP           ;  3:10
else
    if not defined DEBUG@FEXP
        .WARNING You must include the file: debug_fexp.asm before.
    endif
endif
