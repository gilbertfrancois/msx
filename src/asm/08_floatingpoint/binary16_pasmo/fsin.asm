if not defined @FSIN

; Trigonometric function sine
; Input: HL -π/2..π/2
; Output: HL = sin(HL)
; Pollutes: AF, DE
; $29c5..$2bff HL--
; $2c00..$33ff 16 bytes 1x256 bytes table
; $3400..$37ff  8 bytes 1x256 bytes table
; $3800..$39ff  4 bytes 1x256 bytes table
; $3a00..$3eff  1 bytes 5x256 bytes table
; $3a $ff..
; $3c $fe..
; $3e $fd
; $3b $3a..
; $3d $3b..
@FSIN:
if not defined FSIN
; *****************************************
                    FSIN                ; *
; *****************************************
endif

        LD      A, H                ;  1:4
        AND     $FF - SIGN_MASK     ;  2:7          abs(HL)
        SUB     $3A                 ;  2:7
        JR      nc, FSIN_3A3E       ;  2:12/7
        ADD     A, $02              ;  2:7
        JR      c, FSIN_3839        ;  2:12/7
        ADD     A, $04              ;  2:7
        JR      c, FSIN_3437        ;  2:12/7
        ADD     A, $08              ;  2:7
        JR      c, FSIN_2C33        ;  2:12/7
        ADD     A, $03              ;  2:7
        RET     nc                  ;  1:5/11
        JR      nz, FSIN_2A2B       ;  2:12/7
        LD      A, $C4              ;  2:7
        SUB     L                   ;  1:4
        RET     nc                  ;  1:5/11
FSIN_2A2B:
    if carry_flow_warning
        OR      A                   ;  1:4          reset carry
    endif
        DEC     HL                  ;  1:6
        RET                         ;  1:10
FSIN_2C33:
        XOR     L                   ;  1:4
        AND     $0F                 ;  2:7
        XOR     L                   ;  1:4
        RRCA                        ;  1:4
        RRCA                        ;  1:4
        RRCA                        ;  1:4          ehhl lll0
        LD      D, SIN_TAB_2C33/256 ;  2:7
FSIN_READ:
        LD      E, A                ;  1:4
        EX      DE, HL              ;  1:4
        LD      A, (HL)             ;  1:7
        CP      E                   ;  1:4        
        INC     L                   ;  1:4
        JR      nc, $+4             ;  2:11/7
        INC     HL                  ;  1:6
        INC     L                   ;  1:4
        LD      L, (HL)             ;  1:7
        LD      H, $FF              ;  2:7
        ADD     HL, DE              ;  1:11
    if carry_flow_warning
        OR      A                   ;  1:4          reset carry
    endif
        RET                         ;  1:10
FSIN_3437:
        XOR     L                   ;  1:4
        AND     $07                 ;  2:7
        XOR     L                   ;  1:4
        RRCA                        ;  1:4
        RRCA                        ;  1:4          hhll lll0
        LD      D, SIN_TAB_3437/256 ;  2:7
        JP      FSIN_READ           ;  3:10
FSIN_3839:
        XOR     L                   ;  1:4
        AND     $03                 ;  2:7
        XOR     L                   ;  1:4
        RRCA                        ;  1:4          hlll lll0
        LD      D, SIN_TAB_3839/256 ;  2:7
        JP      FSIN_READ           ;  3:10
FSIN_3A3E:

        RR      A                   ;  2:8          need set zero flag
        JR      c, FSIN_3B3D        ;  2:7/12
                                    ;               0 $3a $ff..
                                    ;               2 $3c $fe..
                                    ;               4 $3e $fd
        EX      DE, HL              ;  1:4
        LD      L, E                ;  1:4
        JR      z, FSIN_3A          ;  2:7/12
        DEC     A                   ;  1:4
        JR      z, FSIN_3C          ;  2:7/12
; 3E
        LD      H, high SIN_TAB_3E  ;  2:7
        LD      L, (HL)             ;  1:7
        LD      H, $FD              ;  2:7
        ADD     HL, DE              ;  1:11
    if carry_flow_warning
        OR      A                   ;  1:4          reset carry
    endif
        RET                         ;  1:10
FSIN_3C:
        LD      H, high SIN_TAB_3C  ;  2:7
        LD      L, (HL)             ;  1:7
        LD      H, $FE              ;  2:7
        ADD     HL, DE              ;  1:11
    if carry_flow_warning
        OR      A                   ;  1:4          reset carry
    endif
        RET                         ;  1:10
FSIN_3A:
        LD      H, high SIN_TAB_3A  ;  2:7
        LD      L, (HL)             ;  1:7
        LD      H, $FF              ;  2:7
        ADD     HL, DE              ;  1:11
    if carry_flow_warning
        OR      A                   ;  1:4          reset carry
    endif
        RET                         ;  1:10

FSIN_3B3D:
                                    ;               1 $3b $3a..
                                    ;               3 $3d $3b..
        JR      z, FSIN_3B          ;  2:7/12
; 3D
        LD      A, H                ;  1:4
        SUB     $02                 ;  2:7          reset carry
        LD      H, high SIN_TAB_3D  ;  2:7
        LD      L, (HL)             ;  1:7
        LD      H, A                ;  1:4
        RET                         ;  1:10
FSIN_3B:
        LD      A, H                ;  1:4
        SUB     $01                 ;  2:7          reset carry
        LD      H, high SIN_TAB_3B  ;  2:7
        LD      L, (HL)             ;  1:7
        LD      H, A                ;  1:4
        RET                         ;  1:10

endif
