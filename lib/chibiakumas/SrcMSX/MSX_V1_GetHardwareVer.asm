

GetHardwareVer:	
	call BankSwapper_INIT
	;D= 0=msx  1=MSX2  2=MSX2+  3=TurboR	4=WSX
	;E= 0= No memory Mapper / 1=has memory mapper with 128k+
	di
	ld a,(&002D)	
	ld d,a
	ld e,0
	cp 2
	jr nz,GetHardwareVerSwappertest
	ld a,8
	out (64),a		;Get current device id
	in a,(64)
	cp 247			;247=CPL of 8
	jr nz,GetHardwareVerSwappertest
	ld d,4
	
	
GetHardwareVerSwappertest:		
	;FCH to FFH	memory mapper for banks 1-4

	ld a,&69
	ld (&C000),a
	ld a,4
	out (&FF),a	;Switch to bank 4 in top bank
	ld a,(&C000)
	cp &69		;Did it work?
	ret z

	ld a,&69
	ld (&C000),a
	ld a,(&C000)
	cp &69		;is the current bank writable 
	ret nz		;if no then we don't have extra ram
	xor a
	out (&FF),a	;Yes we have a 128k memory mapper!
	inc e
	ret
	
	
	
CHGCPU	equ	&0180 ;Turbo R ON

EnableFastCPU:
	;Kick in the turbo-R 
	ld	A,(CHGCPU)
	cp	&C3			;See if this is a Turbo-R
	ld	a,&82        
	jp	z,CHGCPU	;Call the 'Turbo' Firmware function
	
	;Panasonic FS-A1WX turbo mode
	ld a,(&002D)		
	cp 2			;See if we're on a MSX2+
	ret nz			;No? then give up
	ld a,8
	out (64),a		;See if this is a WSX
	in a,(64)
	cp 247			;CPL of the 8 we sent
	ret nz			;No? then return
	xor a
	out (65),a		;Turn on 6mhz
	ret

	