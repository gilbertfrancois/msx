if not defined @SRL_DE

;  In: DE, A = 4*(SHIFT + 1) = 4..4*(MANT_BITS+1)
; Out: DE = (( DE & 11 1111 1111 ) | 100 0000 0000 ) >> ((A/4)-2)
@SRL_DE:
SRL_DE:
SRL_DE_POSUN    EQU     (SRLDEC_DE_SWITCH - SRL_DE_SWITCH - 4)

        ADD     A, SRL_DE_POSUN     ;
        LD      (SRL_DE_SWITCH), A  ;  3:13
        LD      A, D                ;  1:4
        OR      $04                 ;  2:7      pridam NEUKLADANY_BIT
      
SRL_DE_SWITCH   EQU     $+1
        JR      SRLDEC_DE_CASE_0    ;  2:12
        

;  In: DE, A = 4*(SHIFT + 1) = 4..4*(MANT_BITS+1)
; Out: DE = --(( DE & 11 1111 1111 ) | 100 0000 0000 ) >> ((A/4)-1)
@SRLDEC_DE:
SRLDEC_DE:
        LD     (SRLDEC_DE_SWITCH), A;  3:13        
        SET     2, D                ;  2:8      pridam NEUKLADANY_BIT
        DEC     DE                  ;  1:6      down(0 .. 0.5) => down(0 .. 0.4999), takze pri zaokrouhlovani resime jen prvni bit za desetinou carkou 
        LD      A, D                ;  1:4

SRLDEC_DE_SWITCH EQU     $+1
        JR      SRLDEC_DE_CASE_0    ;  2:12     first jump
        
        JP      SRLDEC_DE_CASEm1    ;  3:10     second jump
        NOP                         ;  1:4
        
SRLDEC_DE_CASE_0:
        AND     MANT_MASK_IMP_HI    ;  2:7
        LD      D, A                ;  1:4
        RET                         ;  1:10        

        RRA                         ;  1:4
        JP      SRLDEC_DE_CASE_1    ;  3:10     second jump
    
        RRA                         ;  1:4
        JP      SRLDEC_DE_CASE_2    ;  3:10     second jump

        XOR     E                   ;  1:4
        JP      SRLDEC_DE_CASE_3    ;  3:10     second jump

        XOR     E                   ;  1:4
        JP      SRLDEC_DE_CASE_4    ;  3:10     second jump

        XOR     E                   ;  1:4
        JP      SRLDEC_DE_CASE_5    ;  3:10     second jump

        XOR     E                   ;  1:4
        JP      SRLDEC_DE_CASE_6    ;  3:10     second jump
        
        JP      SRLDEC_DE_CASE_7    ;  3:10     second jump
        NOP                         ;  1:4
        
        JP      SRLDEC_DE_CASE_8    ;  3:10     second jump
        NOP                         ;  1:4

        RRA                         ;  1:4
        JP      SRLDEC_DE_CASE_9    ;  3:10     second jump
        
SRLDEC_DE_CASE_10:                  ;           1.. .... .... =>  000 0000 0001
        AND     $04                 ;  2:7      
        LD      DE, $0001           ;  3:10
        RET     nz                  ;  1:11/5   99%
        DEC     E                   ;  1:4
        RET                         ;  1:10

SRLDEC_DE_CASEm1:                   ;           1.. .... .... => 1... .... ...0
        AND     MANT_MASK_IMP_HI    ;  2:7
        SLA     E                   ;  2:8
        ADC     A, A                ;  1:4
        LD      D, A                ;  1:4
        RET                         ;  1:10
        
SRLDEC_DE_CASE_1:                   ;           1.. .... .... =>  01. .... ....
        RR      E                   ;  2:8
        AND     MANT_MASK_HI        ;  2:7
        LD      D, A                ;  1:4
        RET                         ;  1:10        

SRLDEC_DE_CASE_2:                   ;           1.. .... .... =>  001 .... ....
        RR      E                   ;  2:8
        AND     $03                 ;  2:7
        RRA                         ;  1:4
        RR      E                   ;  2:8
        LD      D, A                ;  1:4
        RET                         ;  1:10        
        
SRLDEC_DE_CASE_3:                   ;           1.. .... .... =>  000 1... ....
        AND     $07                 ;  2:7
        XOR     E                   ;  1:4      eeee eddd
        RRCA                        ;  1:4      deee eedd
        RRCA                        ;  1:4      ddee eeed
        RRCA                        ;  1:4      ddde eeee
        LD      E, A                ;  1:4
        LD      D, $00              ;  2:7
        RET                         ;  1:10        
                
SRLDEC_DE_CASE_4:                   ;           1.. .... .... =>  000 01.. ....
        AND     $07                 ;  2:7
        XOR     E                   ;  1:4      eeee eddd
        RRCA                        ;  1:4      deee eedd
        RRCA                        ;  1:4      ddee eeed
        RRCA                        ;  1:4      ddde eeee
        SRL     A                   ;  2:8      0ddd eeee
        LD      E, A                ;  1:4
        LD      D, $00              ;  2:7
        RET                         ;  1:10

SRLDEC_DE_CASE_5:                   ;           1.. .... .... =>  000 001. .... 
        AND     $07                 ;  2:7
        XOR     E                   ;  1:4      eeee eddd
        RLCA                        ;  1:4      eeee ddde
        RLCA                        ;  1:4      eeed ddee
        RLCA                        ;  1:4      eedd deee
        AND     $3F                 ;  2:7      00dd deee
        LD      E, A                ;  1:4
        LD      D, $00              ;  2:7
        RET                         ;  1:10    

SRLDEC_DE_CASE_6:                   ;           1.. .... .... =>  000 0001 ....
        AND     $07                 ;  2:7
        XOR     E                   ;  1:4      eeee eddd
        RLCA                        ;  1:4      eeee ddde
        RLCA                        ;  1:4      eeed ddee
        AND     $1F                 ;  2:7      000d ddee
        LD      E, A                ;  1:4
        LD      D, $00              ;  2:7
        RET                         ;  1:10

SRLDEC_DE_CASE_7:                   ;           1.. .... .... =>  000 0000 1... 
        AND     MANT_MASK_IMP_HI    ;  2:7
        RL      E                   ;  2:8
        ADC     A, A                ;  1:4
        LD      E, A                ;  1:4
        LD      D, $00              ;  2:7
        RET                         ;  1:10

SRLDEC_DE_CASE_8:                   ;           1.. .... .... =>  000 0000 01..
        AND     MANT_MASK_IMP_HI    ;  2:7
        LD      E, A                ;  1:4
        LD      D, $00              ;  2:7
        RET                         ;  1:10

SRLDEC_DE_CASE_9:                   ;           1.. .... .... =>  000 0000 001. 
        AND     MANT_MASK_HI        ;  2:7
        LD      E, A                ;  1:4
        LD      D, $00              ;  2:7
        RET                         ;  1:10

endif
