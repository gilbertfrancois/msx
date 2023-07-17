if color_flow_warning && not defined UNDER_COL_WARNING

    BORDER      EQU     $229B         ; ROM border change permanent

if 0
  $229B  OUT    ($FE), A            ; The '#S/OUT/' instruction is then used to set the border colour.
  $229D  RLCA                       ; {The parameter is then multiplied by eight.
  $229E  RLCA                       ;
  $229F  RLCA                       ; }
  $22A0  BIT    5, A                ; Is the border colour a 'light' colour?
  $22A2  JR     nz, $22A6           ; Jump if so (the INK colour will be black).
  $22A4  XOR    $07                 ; Change the INK colour to white.
@label=BORDER_1
 *$22A6  LD     ($5C48), A          ; {Set the system variable (#SYSVAR(BORDCR)) as required
  $22A9  RET                        ; and return.}
endif

CBLU     EQU    1
CMNG     EQU    3
CRED     EQU    2
CYEL     EQU    6


UNDER_COL_WARNING:
        PUSH    AF                  ;  1:11
        LD      A, CBLU + CMNG      ;  2:7      A = 4
FMUL_SELF_U:
        SUB     CBLU                ;  2:7      A = 3 or 1 
        LD      ($-1), A            ;  3:13
        CALL    BORDER              ;  3:17     change border colour
        POP     AF                  ;  1:10
        RET                         ;  1:10

        
OVER_COL_WARNING:
        PUSH    AF                  ;  1:11
        LD      A, CRED + CYEL      ;  2:7      A = 8
FMUL_SELF_O:
        SUB     CRED                ;  2:7      A = 6 or 2 
        LD      ($-1), A            ;  3:13
        CALL    BORDER              ;  3:17     change border colour
        POP     AF                  ;  1:10
        RET                         ;  1:10

endif
