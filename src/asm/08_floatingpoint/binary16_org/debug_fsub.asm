if not defined FSUB

    INCLUDE "print_fp.asm"

; HL = HL - DE
DEBUG@FSUB:
FSUB:
        CALL    @FSUB               ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, '-'+' ' * 256   ;  3:10     "- "
        LD      A, COL_BLUE         ;  2:7
        JP      PRINT_XFP           ;  3:10
else
    if not defined DEBUG@FSUB
        .WARNING You must include the file: debug_fsub.asm before.
    endif
endif
