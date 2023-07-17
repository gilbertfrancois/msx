if not defined FMUL

    INCLUDE "print_fp.asm"
        
; HL = BC * DE
DEBUG@FMUL:
FMUL:
        CALL    @FMUL                   ;  3:17
        PUSH    HL                      ;  1:11
        LD      HL, '*'+' ' * 256       ;  3:10     "* "
        LD      A, COL_BLUE             ;  2:7
        JP      PRINT_XFP               ;  3:10
else
    if not defined DEBUG@FMUL
        .WARNING You must include the file: debug_fmul.asm before.
    endif
endif
