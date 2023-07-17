if not defined @FBLD_DIV4

include "fbld.asm"

; Load Byte and divide it by 4. Convert unsigned 8-bit integer into floating-point number and divide it by 4
;  In:  A = Byte to convert
; Out: DE = floating point representation, zero flag if DE = 0
; Pollutes: AF
@FBLD_DIV4:
if not defined FBLD_DIV4
; *****************************************
                  FBLD_DIV4               ; *
; *****************************************
endif
        LD      D, FBLD_D-2
        JR      FBLD_X        

endif
