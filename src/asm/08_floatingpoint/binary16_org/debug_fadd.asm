if not defined FADD

    INCLUDE "print_fp.asm"

; HL = HL + DE
DEBUG@FADD:
FADD:
        CALL    @FADD               ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, '+'+' ' * 256   ;  3:10     "+ "
        LD      A, COL_BLUE         ;  2:7
        JP      PRINT_XFP           ;  3:10

else
    if not defined DEBUG@FADD
        .WARNING You must include the file: debug_fadd.asm before.
    endif
endif
