if not defined MTST

; Warning: must be included before first use!

; Test floating-point (compare with 0.0)
;    Input: reg_hi, reg_lo
;   Output: zero  - If the number is positive or negative zero
;           carry - If the number is less than or equal to -MIN (-0)
; Pollutes: AF
;      Use: MTST H,L
MTST MACRO reg_hi, reg_lo
    if SIGN_BIT > 7
        LD      A, reg_lo           ;  1:4
        ADD     A, A                ;  1:4
        OR      reg_lo              ;  1:4      reset carry
        RRA                         ;  1:4      0xxx xxxx
        OR      reg_hi              ;  1:4      sxxx xxxx
        ADD     A, A                ;  1:4
    else
        LD      A, reg_hi           ;  1:4
        ADD     A, A                ;  1:4
        OR      reg_hi              ;  1:4      reset carry
        RRA                         ;  1:4      0xxx xxxx
        OR      reg_lo              ;  1:4      sxxx xxxx
        ADD     A, A                ;  1:4
    endif
ENDM

endif
