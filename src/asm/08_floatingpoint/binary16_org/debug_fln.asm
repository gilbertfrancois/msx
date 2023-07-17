if not defined FLN

    INCLUDE "print_fp.asm"

; HL = ln(abs(HL))
DEBUG@FLN:
FLN:
        CALL    @FLN                ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, 'L'+'N' * 256   ;  3:10     "LN"
        LD      A, COL_BLUE         ;  2:7
        JP      PRINT_XFP           ;  3:10
else
    if not defined DEBUG@FLN
        .WARNING You must include the file: debug_fln.asm before.
    endif
endif
