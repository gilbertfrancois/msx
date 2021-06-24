; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		Interrupt handler template
;Version	V1.0
;Date		2018/5/20

;Content	This is an easy interrupt handler routine you can use, it works on MSX/ZX/ENT/SAM/CPC

;		It works in IM1 (at &0038) or IM2 (at &8000-&8183)

;		By default it assumes you're allocating shadow registers exclusively to the interrupt handler, 
;		... BUT It can protect shadow regsiters, or protect all registers if your interrupt handler needs everything!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Interrupt handler options
;	Interrupts_NeedAllRegisters equ 1		;If your interrupt handler needs more than shadow registers enable this
;	Interrupts_ProtectShadowRegisters equ 1	;If your program needs shadow registers enable this
;	Interrupts_UseIM2 equ 1			;Use interrupt mode 2 instead of IM1 (need free &200 byte block at &8000)
;	Interrupts_AllowStackMisuse equ 1		;Use shadow stack to allow interrupts during misusing the stack
;	Interrupt_ShadowStack equ &8200



;Interrupt handler Usage


;	call Interrupts_Install			;Turn on interrupts


;Template of interrupt handler

;	read "..\SrcALL\Multiplatform_Interrupt_Start.asm"

;	call PLY_Play							;Your Interrupt tasks go here

;	Interrupts_FastTick						;label needed for CPC (300hz interrupt)
;	read "..\SrcALL\Multiplatform_Interrupt_End.asm"



Interrupts_Install:
nop		;Used by safety lock
di
	ifdef BuildCPC	;Back up BC' on the CPC to keep the firmware happy
		exx
			ld (Interrupt_CpcBcRestore_Plus2-2),bc
		exx
	endif

ifndef Interrupts_UseIM2

	ld hl,&0038	;Back up current interrupt handler, and push our new one in
	ld a,(hl)
	ld (InterruptRestore1_Plus1-1),a


;	ld sp,&8181	;this area is free as a stack pointer!

	ld a,&C3	;JP
	ld (hl),a

	ld de,InterruptHandler

	inc hl
	ld c,(hl)	;Back up current interrupt handler, and push our new one in
	ld (hl),e

	inc hl
	ld b,(hl)
	ld (hl),d
	ld (InterruptRestore2_Plus2-2),bc
 
else
	ld hl,InterruptHandler

	ld (&8182),hl			;Our IM2 Interrupt handler has a jp at &8181
	ld a,&C3
	ld (&8181),a
	
	ld hl,&8000			;Fill the 257 IM2 jump block with 81's 
	ld de,&8001
	ld a,&81
	ld (hl),a
	ld bc,&0101-1
	ldir
	dec a	;a=&80
	ld i,a
	im 2	;Turn IM2 on 
endif

	xor a

Interrupts_SafetyLock:				;Stop the interrupt handler being installed twice - causing corruption of the backups
	ld (Interrupts_Uninstall),a
	xor &C9
	ld (Interrupts_Install),a
	ei
ret

	
;Uninstall the interrupt handler - for normal firmware functions
Interrupts_Uninstall:
ret			;Used by safety lock
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

else
	im 1
endif

ifdef BuildCPC		;restore up BC' on the CPC to keep the firmware happy
	exx
		ld bc,&0000	:Interrupt_CpcBcRestore_Plus2
	exx
endif
	ld a,&C9
	jr Interrupts_SafetyLock