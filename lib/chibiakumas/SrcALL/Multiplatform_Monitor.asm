; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		Monitor
;Version	V1.0b
;Date		2018/4/1
;Content	Provides simple ability to show the Program Counter, and to show register values without altering z80 state
;Requires	ShowHex function

;Changelog	Code shown in youtube vid had a bug - it was showing more registers than exited, resulting in
;		non-existant reg pair DIxxxx showing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;include this somewhere
;read "..\SrcAll\Multiplatform_ShowHex.asm"

;Options
;Monitor_Full equ 1				;*** FULL monitor takes more ram, but shows all registers
;Monitor_Pause equ 1 				;*** Pause after showing debugging info

;Usage
;	call Monitor


;Magic trick to work out if Interrupts are enabled or disabled
	ifdef Monitor_Full

MonitorEICheck:
		ld bc,&44F3		;F3 is DI

		ifdef BuildENT
			call TestInterrupts
			ret c
		else
			ld a,i			;strange - but this sets PO flag inf ints were enabled
			ret po 			;this is tricky - it will return if Interrupts disabled
		endif

		ld c,&FB		;FB is EI
		inc b 			;convert D->E for the label
	ret

		ifdef BuildENT
		;Thanks to BruceTanner on the EnterpriseForever forums, who suggested using this... which works more reliably on the Enterprise (and maybe others that use a NMOS Z80)
TestInterrupts:
			XOR 	A			;Push a zero on stack and pop it
			PUSH 	AF			; back off so we can tell if it gets
			POP 	AF			; overwitten with IRQ return address.
			LD 	A,R			;Get IRQ state
			DI
			RET 	PE			;Return if interrupts enabled
			DEC 	SP			;If they appear disabled then check
			DEC 	SP			; whether the zero is still below stack
			POP 	AF
			OR 	A			;If not then interrupts must have been 
			RET 	NZ			; enabled so return with carry clear.
			SCF				;Return with carry set to indicate
			RET	
		endif
	endif ;Monitor_Full

Monitor:
	;This is a dirty trick to check if interrupts are enabled or not 
	ifdef Monitor_Full
		push bc
		push af
			call MonitorEICheck
			ld a,c
			ld (Monitor_EI_Reenable_Plus1-1),a	;DI /EI at end of monitor
			ld a,b
			ld (Monitor_Special),a			;letter D/E for visible string
		pop af
		pop bc
		di
	endif

	; Push all registers onto the stack - we'll pop them back and put them onscreen

	ifdef Monitor_Full		;Monitor FULL includes all registers
		exx			
		ex af,af'		;Backup all the registers.
		push HL
		PUSH DE
		PUSH BC
		Push AF

		ld a,I
		ld h,a
		ld a,R
		ld l,a
		push hl

		exx
		ex af,af'
		push IY
		push IX

	endif
		push HL
		PUSH DE
		PUSH BC
		Push AF

	;	ld (MonitorStackRestore_Plus2-2),sp	;We need to backup the true stack pointer, we're going to be messin' around!

		call NewLine
		

	ifdef Monitor_Full
		ld hl,12*2	;NO of bytes we pushed in FULL mode
	else
		ld hl,12-7 *2	;NO of bytes we pushed in NORMAL mode
	endif
		add hl,sp	;work out the original stack pointer address, and push that too!
		push hl
		ld (NextMonitorPos_Plus2-2),sp	;Store the current stack pointer, so we know where the legit data is.

	ifdef Monitor_Full
		ld b,13				;Set our loop counter to the number of regs
	else
		ld b,13-7
	endif 
		ld hl,Monitor_Text 
		ld de,&0000;<-- SM ***
NextMonitorPos_Plus2:	;Pointer to the pushed values - we use this to read them out the stack.

	MonitorAgain:

		;push bc
			ld a,(hl)
			call PrintChar		;Shiw the 2 char label
			inc hl
			ld a,(hl)
			call PrintChar
	;	push de
			inc de
			ld a,(de)		;Show the 1st Hex Byte
			call ShowHex
	;	pop de
		dec de
		ld a,(de)			;Load the 2nd HEX byte
		inc de
		inc de
			call ShowHex		;Show the 2nd Hex Byte
			ld a,32			;Show two spaces
			call PrintChar
			call PrintChar
	;	pop bc
	;	inc bc
		inc hl

		djnz MonitorAgain

	ifdef Monitor_Full
		ld b,2				;Print 'Special chars' (currently just DI/EI)
		ld de,Monitor_Special
	Monitor_MoreChars:
		ld a,(de)
		call PrintChar
		inc de
		djnz Monitor_MoreChars
	endif


	;	ld sp,&0000 MonitorStackRestore_Plus2

		pop hl				;this is the SP we pushed before.

	ifdef Monitor_Pause
		call WaitChar			;Do a WaitChar if we're supposed to pause
	endif
		Pop AF				;Restore all the registers.
		Pop BC
		pop DE
		pop HL
	ifdef Monitor_Full


		pop IX
		pop IY

		;I and R
		inc SP
		inc SP

		exx
		ex af,af'
		Pop AF
		Pop BC
		pop DE
		pop HL
		exx
		ex af,af'
	endif


	ifdef Monitor_Full				;SelfModifying code will change this to EI or DI depending if interrputs are needed
		nop ;<-- SM ***
Monitor_EI_Reenable_Plus1:
	endif
	ret

	Monitor_Text:			;Labels of the register - must be 2 char!
		db "S","p"
		db "A","f"
		db "B","c"
		db "D","e"
		db "H","l"
	ifdef Monitor_Full

		db "I","x"
		db "I","y"
		db "i","R"
		db "A","'"
		db "B","'"
		db "D","'"
		db "H","'"

	endif
		db "P","c"
	ifdef Monitor_Full
	Monitor_Special:db "DI"		;Special text shown straight to the screen.
	endif
