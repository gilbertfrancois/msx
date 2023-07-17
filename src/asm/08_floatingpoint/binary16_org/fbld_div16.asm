if not defined @FBLD_DIV16

include "fbld.asm"

; Load Byte and divide it by 16. Convert unsigned 8-bit integer into floating-point number and divide it by 16
;  In:  A = Byte to convert
; Out: DE = floating point representation, zero flag if DE = 0
; Pollutes: AF
@FBLD_DIV16:
if not defined FBLD_DIV16
; *****************************************
                  FBLD_DIV16              ; *
; *****************************************
endif
        LD      D, FBLD_D-4
        JR      FBLD_X        

endif
