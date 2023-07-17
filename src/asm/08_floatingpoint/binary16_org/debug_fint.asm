if not defined FINT

    INCLUDE "print_fp.asm"

; HL = int(HL)
DEBUG@FINT:
FINT:
        CALL    @FINT               ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, 'i'+' ' * 256   ;  3:10     "- "
        LD      A, COL_BLUE         ;  2:7
        JP      PRINT_XFP           ;  3:10
else
    if not defined DEBUG@FINT
        .WARNING You must include the file: debug_fint.asm before.
    endif
endif
