

Interrupts_Done:
ifdef Interrupts_NeedAllRegisters
	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af
else
	exx
	ex af,af'
endif

ifdef Interrupts_AllowStackMisuse
	ld sp,&0000	:InterruptPlusSPRestore_Plus2
	ei
	jp &0000	:InterruptReturn_Plus2
else
	ei
	ret
endif

