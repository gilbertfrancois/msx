if not defined FRAC

    INCLUDE "print_fp.asm"

; HL = HL % 1
DEBUG@FRAC:
FRAC:
        CALL    @FRAC               ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, '%'+'1' * 256   ;  3:10     "%1"
        LD      A, COL_BLUE         ;  2:7
        JP      PRINT_XFP           ;  3:10
else
    if not defined DEBUG@FRAC
        .WARNING You must include the file: debug_frac.asm before.
    endif
endif
