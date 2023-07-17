if not defined FMOD

    INCLUDE "print_fp.asm"

; HL = BC % HL
DEBUG@FMOD:
FMOD:
        CALL    @FMOD               ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, '%'+' ' * 256   ;  3:10     "% "
        LD      A, COL_BLUE         ;  2:7
        JP      PRINT_XFP           ;  3:10
else
    if not defined DEBUG@FMOD
        .WARNING You must include the file: debug_fmod.asm before.
    endif
endif
