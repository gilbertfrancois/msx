

InterruptHandler:
ifdef Interrupts_AllowStackMisuse
	exx 
	pop hl
	ld (InterruptPlusSPRestore_Plus2-2),sp
	ld (InterruptReturn_Plus2-2),hl

	exx
	push de
	exx
	ld sp,Interrupt_ShadowStack
	ex af,af'

endif


ifdef Interrupts_NeedAllRegisters
	push af
	push bc
	push de
	push hl
	push ix
	push iy
else
	ex af,af'
	exx
endif


ifdef BuildENT
    ld   a,&30
    out  (&b4),a
endif

ifdef BuildCPC
	ld      b,&f5
	in      a,(c)
	rra     
	jp nc,Interrupts_FastTick
endif
ifdef BuildMSX
;	xor a
;	out (VdpOut_Control),a
;	ld a,128+15		;R#15  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [S3 ] [S2 ] [S1 ] [S0 ] - Set Stat Reg to read
;	out (VdpOut_Control),a

	in a,(&99)	;VdpIn_Status S#2  [TR ] [VR ] [HR ] [BD ] [ 1 ] [ 1 ] [EO ] [CE ] - Status register 2

;	ld a,2
;	out (VdpOut_Control),a
;	ld a,128+15		;R#15  [ 0 ] [ 0 ] [ 0 ] [ 0 ] [S3 ] [S2 ] [S1 ] [S0 ] - Set Stat Reg to read
;	out (VdpOut_Control),a
endif