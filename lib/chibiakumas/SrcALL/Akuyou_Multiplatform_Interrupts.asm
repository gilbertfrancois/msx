
Interrupts_Install:
nop
di
	ifdef BuildCPC
		exx
			ld (Interrupt_CpcBcRestore_Plus2-2),bc
		exx
	endif

ifndef Interrupts_UseIM2

	ld hl,&0038
	ld a,(hl)
	ld (InterruptRestore1_Plus1-1),a


;	ld sp,&8181	;this area is free as a stack pointer!

	ld a,&C3	;JP
	ld (hl),a

	ld de,InterruptHandler

	inc hl
	ld c,(hl)
	ld (hl),e

	inc hl
	ld b,(hl)
	ld (hl),d
	ld (InterruptRestore2_Plus2-2),bc
 
else
	ld hl,InterruptHandler

	ld (&8182),hl
	ld a,&C3
	ld (&8181),a

	ld hl,&8000
	ld de,&8001
	ld a,&81
	ld (hl),a
	ld bc,&0101
	ldir
	dec a
	ld i,a
	im 2
endif

	xor a
;	jp Interrupts_SafetyLock

Interrupts_SafetyLock:
	ld (Interrupts_Uninstall),a
	xor &C9
	ld (Interrupts_Install),a
	ei
ret

Interrupts_Uninstall:
ret
di
ifndef Interrupts_UseIM2
	ld a,&00	:InterruptRestore1_Plus1
	ld hl,&0038
	ld (hl),a				; Patch in our firmware handler

	ld de,&0000	:InterruptRestore2_Plus2
	inc hl
	ld (hl),e
	inc hl
	ld (hl),d
	ld a,&C9
else
	im 1
endif

ifdef BuildCPC
	exx
		ld bc,&000	:Interrupt_CpcBcRestore_Plus2
	exx
endif

	jr Interrupts_SafetyLock