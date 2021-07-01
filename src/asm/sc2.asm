    include "VasmBuildCompat.asm"
    include "V1_Header.asm"
    ;include "MSX1_V1_VdpMemory.asm"

;
; Hello World .ROM for cartridge environment
;
; Constant definitions
WRTVDP  equ &0047
LDIRVM  equ &005c
CHGMOD  equ &005f
INIT32  equ &006F
;CHPUT   equ &00A2
LINLEN  equ &F3B0

; Compilation address
	org &4000

; ROM header
	db "AB"     ; magic number
	dw Execute  ; program execution address
	dw 0, 0, 0, 0, 0, 0

; Program code entry point
Execute:
    ld a, 2  ; Change screen mode (Screen 2)
    call CHGMOD
    ld bc, 0e201h  ; write 1110 0010 = 0xe2 to VDP(1) 
    call WRTVDP
    ; Color info
    ld hl, &2000
    call VDP_SetWriteAddress
    
    call Finished      ; end

; Halt program execution. Change to "ret" to return to MSX-BASIC.
Finished:
    ; ret
	di
	halt

Palette:
    ds 768*8, &3F
; Padding to make the file size a multiple of 16K
; (Alternatively, include macros.asm and use ALIGN 4000H)
	ds -$ & &3FFF



    include "V1_Footer.asm"
