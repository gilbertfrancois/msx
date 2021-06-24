;include this before your interrupt handler routine

InterruptHandler:
ifdef Interrupts_AllowStackMisuse

	;We need to read in the return address, and store it for later
	ifdef Interrupts_ProtectShadowRegisters
		ld (InterruptHandlerHLRestore_Plus2-2),hl 	;Don't break HL
	else
		exx 
	endif

	pop hl
	ld (InterruptPlusSPRestore_Plus2-2),sp		;Back up the current stack pointer
	ld (InterruptReturn_Plus2-2),hl			;Copy the return address


	;Fix HL
	ifdef Interrupts_ProtectShadowRegisters
		ld hl,&0000 :InterruptHandlerHLRestore_Plus2		;Get back HL
	else
		exx 
	endif

	push de		;Fix the stack (for if we're using SP for reading
	ld sp,Interrupt_ShadowStack	;Use our safe 'Shadow stack' - this means if the stack was being misused, then only 2 bytes will be affected
endif


ifdef Interrupts_NeedAllRegisters
	push af				;Back up the normal registers if needed
	push bc
	push de
	push hl
	push ix
	push iy
endif
	ex af,af'
	exx

ifdef Interrupts_ProtectShadowRegisters
	push af				;Back up the shadow registers if needed
	push bc
	push de
	push hl
endif

ifdef BuildENT
    ld   a,&30				;on the enterprise we need to tell the interrupt to stop firing
    out  (&b4),a
endif

ifdef BuildCPC
	ld      b,&f5
	in      a,(c)
	rra     
	jp nc,Interrupts_FastTick	;on the CPC the interrupt handler fires 6x faster than other systems, so jump
					;to 'FastTick' 5 out of 6 times
endif

ifdef BuildMSX
	in a,(&99)			;on the MSX we need to read the status register, or it'll keep firing
endif