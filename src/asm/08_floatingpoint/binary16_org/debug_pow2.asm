if not defined FPOW2

    INCLUDE "print_fp.asm"

; HL = HL * HL
DEBUG@FPOW2
FPOW2:
        CALL    @FPOW2                  ;  3:17
        PUSH    HL                      ;  1:11
        LD      HL, $325E               ;  3:10     "↑2"
        LD      A, COL_BLUE             ;  2:7
        JP      PRINT_XFP               ;  3:10
else
    if not defined DEBUG@FPOW2
        .WARNING You must include the file: debug_fpow2.asm before.
    endif
endif
