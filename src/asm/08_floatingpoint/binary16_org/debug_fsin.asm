if not defined FSIN

    INCLUDE "print_fp.asm"

; HL = ln(abs(HL))
DEBUG@FSIN:
FSIN:
        CALL    @FSIN               ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, 'S'+'N' * 256   ;  3:10     "SN"
        LD      A, COL_BLUE         ;  2:7
        JP      PRINT_XFP           ;  3:10
else
    if not defined DEBUG@FSIN
        .WARNING You must include the file: debug_fsin.asm before.
    endif
endif
