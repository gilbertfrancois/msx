if not defined @FSQDIF

    include "fsubp.asm"
    include "faddp.asm"

; Find the difference of two squares
; Input: HL=hypothenuse, DE=leg
; Output: HL = HL * HL - DE * DE computed as (HL - DE) * (HL + DE)
@FSQDIF:
if not defined FSQDIF
; *****************************************
                  FSQDIF                ; *
; *****************************************
endif
        PUSH    HL
        PUSH    DE
        CALL    FSUBP               ;           HL = HL - DE
        POP     DE
        EX      (SP), HL
        CALL    FADDP               ;           HL = HL + DE
        EX      DE, HL
        POP     BC
        ; continue with FMUL
    if not defined @FMUL
        include "fmul.asm"
    else
        JP      @FMUL
    endif

endif
