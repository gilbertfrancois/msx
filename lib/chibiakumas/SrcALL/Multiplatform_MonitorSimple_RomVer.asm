; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		Simple Monitor
;Version	V1.0
;Date		2018/3/29
;Content	Provides simple ability to show the Program Counter, and to show register values without altering z80 state

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Monitor_PushedRegister:
;show a register that was PUSHED before calling ... the pushed register is consumed!
;Usage
;	push af					;pushed value to show
;	call Monitor_PushedRegister
	push af
		ld a,l
		ld (Monitor_TMP1),a		;BACK UP HL
		ld a,h
		ld (Monitor_TMP1+1),a		;BACK UP HL
	pop af
	pop hl						;Get the return point
	z_ex_sphl	;ex (SP),HL
	call Monitor_BreakPoint_Show			;Send the pushed value to display routine
	push af	
		ld a,(Monitor_TMP1)		;BACK UP HL
		ld l,a
		ld a,(Monitor_TMP1+1)	;BACK UP HL
		ld h,a
	pop af
	ret
;Usage
;	call Monitor_BreakPoint

Monitor_BreakPoint:					;Show the Breakpoint and carry on!
	z_ex_sphl	;ex (SP),HL
	call Monitor_BreakPoint_Show			
	z_ex_sphl	;ex (SP),HL
	ret

;Usage
;	call Monitor_BreakPointOnce

Monitor_BreakPointOnce:					;Show the Breakpoint and carry on!
	z_ex_sphl	;ex (SP),HL
	call Monitor_BreakPoint_Show
	push af
	push hl
		xor a
		dec hl					;Erase the preceeding 3 bytes before the CALL 
		ld (hl),a				;This SelfModifies the program so the call only occurs once!
		dec hl					
		ld (hl),a
		dec hl
		ld (hl),a
	pop hl
	pop af
	z_ex_sphl	;ex (SP),HL
	ret


;This isn't intended to be called directly
Monitor_BreakPoint_Show:		;show *HL* where HL is in HEX - used by the functions above
	push af
	ld a,'*'
	call PrintChar
	ld a,h
	call ShowHex			;Show H in HEX
	ld a,l
	call ShowHex			;Show L in HEX
	ld a,'*'
	call PrintChar
	ifdef Monitor_Pause 		
			call WaitChar		;Do a pause
	endif
	pop af
	ret
