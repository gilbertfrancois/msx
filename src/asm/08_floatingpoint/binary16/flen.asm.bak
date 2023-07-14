if not defined @FLEN

include "fpow2.asm"
include "faddp.asm"

; Square norm of a vector
; Input: B = dimensions, HL = pointer to vector
; Output: HL = square norm
; B = 1: HL =                                                     [HL]*[HL]
; B = 2: HL =                                    [HL+2]*[HL+2] + ([HL]*[HL])
; B = 3: HL =                   [HL+4]*[HL+4] + ([HL+2]*[HL+2] + ([HL]*[HL]))
; B = 4: HL = [HL+6]*[HL+6] + (([HL+4]*[HL+4] + ([HL+2]*[HL+2] + ([HL]*[HL])))
; Pollutes: AF, B, DE
@FLEN:
if not defined FLEN
; *****************************************
                    FLEN                ; *
; *****************************************
endif

        LD      E, (HL)
        INC     HL
        LD      D, (HL)
        EX      DE, HL
        CALL    FPOW2               ; HL = HL * HL
        DJNZ    FLEN1
        RET
FLEN1:	
        PUSH    HL
        EX      DE, HL
        INC     HL
        CALL    FLEN
        EX      DE, HL
        POP     HL
        JP      FADDP               ; HL = HL + DE

endif
