;Include this after your interrupt routine

Interrupts_Done:

ifdef Interrupts_ProtectShadowRegisters
	pop hl				;Restore the shadow registers if needed
	pop de
	pop bc
	pop af
endif
	exx
	ex af,af'

ifdef Interrupts_NeedAllRegisters	;restore the normal registers if needed
	pop iy
	pop ix
	pop hl
	pop de
	pop bc
	pop af

endif


ifdef Interrupts_AllowStackMisuse
	ld sp,&0000	:InterruptPlusSPRestore_Plus2
	ei
	jp &0000	:InterruptReturn_Plus2
else
	ei
	ret
endif

