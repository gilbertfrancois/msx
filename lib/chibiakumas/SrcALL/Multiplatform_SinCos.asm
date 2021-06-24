Sin_A_Times_D:
	bit 7,d 
	jr z,Sin_A_Times_D_DNotNegative

	ld h,a
		ld a,d
		neg
		ld d,a
	ld a,h
	call Sin_A_Times_D_DNotNegative

	ld a,h
	neg
	ld h,a
	ret
Sin_A_Times_D_DNotNegative:
	ifdef UseSmallAngleApprox
		ld h,a
		and %11111110
		cp &0
		jr z,ResZero
		cp &80
		jr z,ResZero

		add 4
		and %11111000		;Small Angle Approximation

		cp &40
		jr z,Res127
		cp &C0
		jr z,Resminus127
		ld a,h
	endif
	call sin	;Y
	ld l,d
	call mul8ZeroH_Sgn
	sla l
	rl h	
	ret

Cos_A_Times_D:
	bit 7,d 
	jr z,Cos_A_Times_D_DNotNegative
	ld h,a
		ld a,d
		neg
		ld d,a
	ld a,h
	call Cos_A_Times_D_DNotNegative

	ld a,h
	neg
	ld h,a
	ret

Cos_A_Times_D_DNotNegative:
	ifdef UseSmallAngleApprox
		ld h,a
		and %11111110
		cp &40
		jr z,ResZero
		cp &C0
		jr z,ResZero

		add 4
		and %11111000		;Small Angle Approximation
	;	cp &0
		jr z,Res127

		cp &80
		jr z,Resminus127
		ld a,h
	endif
	call cos		;Y
	ld l,d
	call mul8ZeroH_Sgn
	sla l
	rl h	
	ret

ResZero:
	ld h,0			;Anything *0=0
	ret
Res127:				;Halve D
	ld l,0
	ld h,d
;	srl h
;	rr l
	ret
Resminus127:			;Halve and negate D
;	ld l,0
;	ld h,d
;	srl h
;	rr l
	ld a,d
	neg
	ld h,a
	ld l,255
;	neg
;	ld l,a
	ret

;64 byte quarter table ver
IfDef SmallSINTable
Cos:
	add 64
Sin:
	bit 7,a
	jr z,SineC
	call SineC
	neg
	ret
SineC:
;	and %01111111
;	cp &40
;	jr c,SineB

	bit 6,a
	jr z,SineB
	and %00111111
	ld l,a
	ld a,63
	sub l	
SineB:

	ld hl,SineTable
	ifdef SmallSINTable32
		and %00111110
		rrca	
	else 
		and %00111111
	endif
	ld l,a
	ld a,(hl)
	ret

	align 256
SineTable:
	ifdef SmallSINTable32
		db 0,6,12,19,25,31,37,43,49,54,60,65,71,76,81,85 
		db 90,94,98,102,106,109,112,115,117,120,122,123,125,126,126,127 
		;db 0,4,8,16,24,32,38,40,48,56,60,64,72,76,80,86
		;db 90,94,96,102,106,109,112,114,116,120,122,124,124,126,127,127 

	else:
		db 0,3,6,9,12,16,19,22,25,28,31,34,37,40,43,46,49,51,54,57,60,63,65,68,71,73,76,78,81,83,85,88 
		db 90,92,94,96,98,100,102,104,106,107,109,111,112,113,115,116,117,118,120,121,122,122,123,124,125,125,126,126,126,127,127,127 
		;db 0,2,6,7,12,16,18,22,24,28,32,34,36,40,42,46,48,52,54,56,60,62,64,68,70,72,76,78,80,82,84,88 
		;db 90,92,94,96,98,100,102,104,106,106,108,110,112,114,114,116,118,118,120,120,122,122,124,124,124,126,126,126,126,127,127,127 
	endif




else

;256 Byte Table version

Cos:
	add 64
Sin:
	ld hl,SineTable
	ld l,a
	ld a,(hl)
	ret

	align 256
SineTable:
	db 0 ,3 ,6 ,9 ,12 ,16 ,19 ,22 ,25 ,28 ,31 ,34 ,37 ,40 ,43 ,46 ,49 ,51 ,54 ,57 ,60 ,63 ,65 ,68 ,71 ,73 ,76 ,78 ,81 ,83 ,85 ,88 
	db 90 ,92 ,94 ,96 ,98 ,100 ,102 ,104 ,106 ,107 ,109 ,111 ,112 ,113 ,115 ,116 ,117 ,118 ,120 ,121 ,122 ,122 ,123 ,124 ,125 ,125 ,126 ,126 ,126 ,127 ,127 ,127 
	db 127 ,127 ,127 ,127 ,126 ,126 ,126 ,125 ,125 ,124 ,123 ,122 ,122 ,121 ,120 ,118 ,117 ,116 ,115 ,113 ,112 ,111 ,109 ,107 ,106 ,104 ,102 ,100 ,98 ,96 ,94 ,92 
	db 90 ,88 ,85 ,83 ,81 ,78 ,76 ,73 ,71 ,68 ,65 ,63 ,60 ,57 ,54 ,51 ,49 ,46 ,43 ,40 ,37 ,34 ,31 ,28 ,25 ,22 ,19 ,16 ,12 ,9 ,6 ,3 
	db 0 ,-3 ,-6 ,-9 ,-12 ,-16 ,-19 ,-22 ,-25 ,-28 ,-31 ,-34 ,-37 ,-40 ,-43 ,-46 ,-49 ,-51 ,-54 ,-57 ,-60 ,-63 ,-65 ,-68 ,-71 ,-73 ,-76 ,-78 ,-81 ,-83 ,-85 ,-88 
	db -90 ,-92 ,-94 ,-96 ,-98 ,-100 ,-102 ,-104 ,-106 ,-107 ,-109 ,-111 ,-112 ,-113 ,-115 ,-116 ,-117 ,-118 ,-120 ,-121 ,-122 ,-122 ,-123 ,-124 ,-125 ,-125 ,-126 ,-126 ,-126 ,-127 ,-127 ,-127 
	db -127 ,-127 ,-127 ,-127 ,-126 ,-126 ,-126 ,-125 ,-125 ,-124 ,-123 ,-122 ,-122 ,-121 ,-120 ,-118 ,-117 ,-116 ,-115 ,-113 ,-112 ,-111 ,-109 ,-107 ,-106 ,-104 ,-102 ,-100 ,-98 ,-96 ,-94 ,-92 
	db -90 ,-88 ,-85 ,-83 ,-81 ,-78 ,-76 ,-73 ,-71 ,-68 ,-65 ,-63 ,-60 ,-57 ,-54 ,-51 ,-49 ,-46 ,-43 ,-40 ,-37 ,-34 ,-31 ,-28 ,-25 ,-22 ,-19 ,-16 ,-12 ,-9 ,-6 ,-3 

endif