if not defined @FBLD_DIV2

include "fbld.asm"

; Load Byte and divide it by 2. Convert unsigned 8-bit integer into floating-point number and divide it by 2
;  In:  A = Byte to convert
; Out: DE = floating point representation, zero flag if DE = 0
; Pollutes: AF
@FBLD_DIV2:
if not defined FBLD_DIV2
; *****************************************
                  FBLD_DIV2               ; *
; *****************************************
endif
        LD      D, FBLD_D-1
        JR      FBLD_X        

endif
