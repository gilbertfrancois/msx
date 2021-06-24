; Learn Multi platform Z80 Assembly Programming... With Vampires!

;Please see my website at	www.chibiakumas.com/z80/
;for the 'textbook', useful resources and video tutorials

;File		Arkos tracker lite
;Version	V1.0
;Date		2018/4/9

;Content	This is a stripped down and altered version of Arkostracker by me (Keith Sear)
;		It supports Enterprise 128 and Sam Coupe and uses less memory, but much functionality has been removed!

;		if you wish to have all funtionality, Please download the proper version from:
; 		http;//www.julien-nevo.com/arkos/

; 		This version has had functioality removed
; 		Special tracks cannot be used
; 		SFX can only play on track 2
; 		Basic and system friendly will not work

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	macro cexx
		ifdef gbz80
			call Call_exx
		else
			exx
		endif
	endm
	
	ifdef gbz80
Call_exx:
	z_exx
	ret
	endif

	ifdef BuildENT
		read "..\SrcENT\ENT_AY_Emulator.asm"
	endif
	ifdef BuildSAM
		read "..\SrcSAM\SAM_AY_Emulator.asm"
	endif


;The below options probably won't work any more - do not mess with them!
PLY_UseSoundEffectsDisabled equ 0
PLY_AllowSpecialTrack equ 0
PLY_UseSoundEffects equ 1	
PLY_UseFades equ 0	
PLY_SystemFriendly equ 0
PLY_UseFirmwareInterruptions equ 0 
PLY_UseBasicSoundEffectInterface equ 0




PLY_RetrigValue	equ #fe		;Value used to trigger the Retrig of Register 13. #FE corresponds to CP xx. Do not change it !


	


PLY_Play:

	ifdef BuildSAM
		call AYEmulation_Play
	endif
	ifdef BuildENT
		call AYEmulation_Play
	endif
;	xor a				
;	ld (PLY_Digidrum),a		;Reset the Digidrum flag.


;Manage Speed. If Speed counter is over, we have to read the Pattern further.
	ld a,(PLY_SpeedCpt)
	dec a
	jp nz,PLY_SpeedEnd

	;Moving forward in the Pattern. Test if it is not over.
	ld a,(PLY_HeightCpt)
	dec a
	jp nz,PLY_HeightEnd

;Pattern Over. We have to read the Linker.


	;Get the Transpositions, if they have changed, or detect the Song Ending !
	z_ld_hl_from PLY_Linker_PT
	ld a,(hl)
	inc hl
	rra
	jr nc,PLY_SongNotOver
	;Song over ! We read the address of the Loop point.
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)			;We know the Song won't restart now, so we can skip the first bit.
	inc hl
	rra
PLY_SongNotOver
	rra
	jr nc,PLY_NoNewTransposition1
	ld de,PLY_Transposition1
	z_ldi
PLY_NoNewTransposition1
	rra
	jr nc,PLY_NoNewTransposition2
	ld de,PLY_Transposition2
	z_ldi
PLY_NoNewTransposition2
	rra
	jr nc,PLY_NoNewTransposition3
	ld de,PLY_Transposition3
	z_ldi
PLY_NoNewTransposition3

	;Get the Tracks addresses.
	ld de,PLY_Track1_PT
	z_ldi
	z_ldi
	ld de,PLY_Track2_PT
	z_ldi
	z_ldi
	ld de,PLY_Track3_PT 
	z_ldi
	z_ldi

	;Get the Special Track address, if it has changed.
	rra
	jr nc,PLY_NoNewHeight
	ld de,PLY_Height
	z_ldi
PLY_NoNewHeight

	rra

	z_ld_hl_to PLY_Linker_PT 	;ld (PLY_Linker_PT + 1),hl


;	PLY_SaveSpecialTrack 
;ld hl,0		

	;Reset the SpecialTrack/Tracks line counter.
	;We can't rely on the song data, because the Pattern Height is not related to the Tracks Height.
	ld a,1


	ld (PLY_Track1_WaitCounter),a
	ld (PLY_Track2_WaitCounter),a
	ld (PLY_Track3_WaitCounter),a



	ld a,(PLY_Height)
PLY_HeightEnd
	ld (PLY_HeightCpt),a







;Read the Track 1.
;-----------------

;Store the parameters, because the player below is called every frame, but the Read Track isn't.
	ld a,(PLY_Track1_WaitCounter)
	dec a
	jp nz,PLY_Track1_NewInstrument_SetWait

	z_ld_hl_from PLY_Track1_PT
	call PLY_ReadTrack
	z_ld_hl_to PLY_Track1_PT ;ld (PLY_Track1_PT + 1),hl
	jp c,PLY_Track1_NewInstrument_SetWait


	;No Wait command. Can be a Note and/or Effects.
	ld a,d			;Make a copy of the flags+Volume in A, not to temper with the original.

	rra			;Volume ? If bit 4 was 1, then volume exists on b3-b0
	jr nc,PLY_Track1_SameVolume
	and %1111
	ld (PLY_Track1_Volume),a
PLY_Track1_SameVolume

	rl d				;New Pitch ?
	jr nc,PLY_Track1_NoNewPitch
	z_ld_ix_to PLY_Track1_PitchAdd ;ld (PLY_Track1_PitchAdd + 1),ix
PLY_Track1_NoNewPitch

	rl d				;Note ? If no Note, we don't have to test if a new Instrument is here.
	jr nc,PLY_Track1_NoNoteGiven
	
	;ld a,e
	;add a,(PLY_Transposition1)		;Transpose Note according to the Transposition in the Linker.
	ld a,(PLY_Transposition1)		;Transpose Note according to the Transposition in the Linker.
	add e
	
	ld (PLY_Track1_Note),a

	ld hl,0				;Reset the TrackPitch.
	z_ld_hl_to PLY_Track1_Pitch ;ld (PLY_Track1_Pitch + 1),hl

	rl d				;New Instrument ?
	jr c,PLY_Track1_NewInstrument
	z_ld_hl_from PLY_Track1_SavePTInstrument	;Same Instrument. We recover its address to restart it.
	ld a,(PLY_Track1_InstrumentSpeed)		;Reset the Instrument Speed Counter. Never seemed useful...
	ld (PLY_Track1_InstrumentSpeedCpt),a
	jr PLY_Track1_InstrumentResetPT

PLY_Track1_NewInstrument		;New Instrument. We have to get its new address, and Speed.
	ld l,b				;H is already set to 0 before.
	add hl,hl
	z_ld_bc_from PLY_Track1_InstrumentsTablePT
	add hl,bc
	ld a,(hl)			;Get Instrument address.
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)			;Get Instrument speed.
	inc hl
	ld (PLY_Track1_InstrumentSpeed),a
	ld (PLY_Track1_InstrumentSpeedCpt),a
	ld a,(hl)
	or a				;Get IsRetrig?. Code it only if different to 0, else next Instruments are going to overwrite it.
	jr z,$+5
	ld (PLY_PSGReg13_Retrig),a

	inc hl

	z_ld_hl_to PLY_Track1_SavePTInstrument;ld (PLY_Track1_SavePTInstrument + 1),hl		;When using the Instrument again, no need to give the Speed, it is skipped.

PLY_Track1_InstrumentResetPT
	z_ld_hl_to PLY_Track1_Instrument ;ld (PLY_Track1_Instrument + 1),hl

PLY_Track1_NoNoteGiven
	ld a,1
PLY_Track1_NewInstrument_SetWait
	ld (PLY_Track1_WaitCounter),a









;Read the Track 2.
;-----------------

;Store the parameters, because the player below is called every frame, but the Read Track isn't.
	ld a,(PLY_Track2_WaitCounter)
	dec a
	jp nz,PLY_Track2_NewInstrument_SetWait

	z_ld_hl_from PLY_Track2_PT
	call PLY_ReadTrack
	z_ld_hl_to PLY_Track2_PT ;ld (PLY_Track2_PT + 1),hl
	jp c,PLY_Track2_NewInstrument_SetWait


	;No Wait command. Can be a Note and/or Effects.
	ld a,d			;Make a copy of the flags+Volume in A, not to temper with the original.

	rra			;Volume ? If bit 4 was 1, then volume exists on b3-b0
	jr nc,PLY_Track2_SameVolume
	and %1111
	ld (PLY_Track2_Volume),a
PLY_Track2_SameVolume

	rl d				;New Pitch ?
	jr nc,PLY_Track2_NoNewPitch
	z_ld_ix_to PLY_Track2_PitchAdd ;ld (PLY_Track2_PitchAdd + 1),ix
PLY_Track2_NoNewPitch

	rl d				;Note ? If no Note, we don't have to test if a new Instrument is here.
	jr nc,PLY_Track2_NoNoteGiven
	ld a,(PLY_Transposition2)
	add e
	;ld a,e
	;add a,0		;Transpose Note according to the Transposition in the Linker.
	ld (PLY_Track2_Note),a

	ld hl,0				;Reset the TrackPitch.
	z_ld_hl_to PLY_Track2_Pitch ;ld (PLY_Track2_Pitch + 1),hl

	rl d				;New Instrument ?
	jr c,PLY_Track2_NewInstrument
	z_ld_hl_from PLY_Track2_SavePTInstrument	;Same Instrument. We recover its address to restart it.
	ld a,(PLY_Track2_InstrumentSpeed)		;Reset the Instrument Speed Counter. Never seemed useful...
	ld (PLY_Track2_InstrumentSpeedCpt),a
	jr PLY_Track2_InstrumentResetPT

PLY_Track2_NewInstrument		;New Instrument. We have to get its new address, and Speed.
	ld l,b				;H is already set to 0 before.
	add hl,hl
	z_ld_bc_from PLY_Track2_InstrumentsTablePT
	add hl,bc
	ld a,(hl)			;Get Instrument address.
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)			;Get Instrument speed.
	inc hl
	ld (PLY_Track2_InstrumentSpeed),a
	ld (PLY_Track2_InstrumentSpeedCpt),a
	ld a,(hl)
	or a				;Get IsRetrig?. Code it only if different to 0, else next Instruments are going to overwrite it.
	jr z,$+5
	ld (PLY_PSGReg13_Retrig),a
	inc hl


	z_ld_hl_to PLY_Track2_SavePTInstrument;ld (PLY_Track2_SavePTInstrument + 1),hl		;When using the Instrument again, no need to give the Speed, it is skipped.

PLY_Track2_InstrumentResetPT
	z_ld_hl_to PLY_Track2_Instrument ;ld (PLY_Track2_Instrument + 1),hl





PLY_Track2_NoNoteGiven

	ld a,1
PLY_Track2_NewInstrument_SetWait
	ld (PLY_Track2_WaitCounter),a







;Read the Track 3.
;-----------------

;Store the parameters, because the player below is called every frame, but the Read Track isn't.
	ld a,(PLY_Track3_WaitCounter)
	dec a
	jp nz,PLY_Track3_NewInstrument_SetWait

	z_ld_hl_from PLY_Track3_PT
	call PLY_ReadTrack
	z_ld_hl_to PLY_Track3_PT;ld (PLY_Track3_PT + 1),hl
	jp c,PLY_Track3_NewInstrument_SetWait


	;No Wait command. Can be a Note and/or Effects.
	ld a,d			;Make a copy of the flags+Volume in A, not to temper with the original.

	rra			;Volume ? If bit 4 was 1, then volume exists on b3-b0
	jr nc,PLY_Track3_SameVolume
	and %1111
	ld (PLY_Track3_Volume),a
PLY_Track3_SameVolume



	rl d				;New Pitch ?
	jr nc,PLY_Track3_NoNewPitch
	z_ld_ix_to PLY_Track3_PitchAdd ;ld (PLY_Track3_PitchAdd + 1),ix
PLY_Track3_NoNewPitch

	rl d				;Note ? If no Note, we don't have to test if a new Instrument is here.
	jr nc,PLY_Track3_NoNoteGiven
	;ld a,e
	;add a,0		;Transpose Note according to the Transposition in the Linker.
	ld a,(PLY_Transposition3)
	add e
	ld (PLY_Track3_Note),a

	ld hl,0				;Reset the TrackPitch.
	z_ld_hl_to PLY_Track3_Pitch ;ld (PLY_Track3_Pitch + 1),hl

	rl d				;New Instrument ?
	jr c,PLY_Track3_NewInstrument
	z_ld_hl_from PLY_Track3_SavePTInstrument	;Same Instrument. We recover its address to restart it.
	ld a,(PLY_Track3_InstrumentSpeed)		;Reset the Instrument Speed Counter. Never seemed useful...
	ld (PLY_Track3_InstrumentSpeedCpt),a
	jr PLY_Track3_InstrumentResetPT

PLY_Track3_NewInstrument		;New Instrument. We have to get its new address, and Speed.
	ld l,b				;H is already set to 0 before.
	add hl,hl
	z_ld_bc_from PLY_Track3_InstrumentsTablePT
	add hl,bc
	ld a,(hl)			;Get Instrument address.
	inc hl
	ld h,(hl)
	ld l,a
	ld a,(hl)			;Get Instrument speed.
	inc hl
	ld (PLY_Track3_InstrumentSpeed),a
	ld (PLY_Track3_InstrumentSpeedCpt),a
	ld a,(hl)
	or a				;Get IsRetrig?. Code it only if different to 0, else next Instruments are going to overwrite it.
	jr z,$+5
	ld (PLY_PSGReg13_Retrig),a
	inc hl


	z_ld_hl_to PLY_Track3_SavePTInstrument ;ld (PLY_Track3_SavePTInstrument + 1),hl		;When using the Instrument again, no need to give the Speed, it is skipped.

PLY_Track3_InstrumentResetPT
	z_ld_hl_to PLY_Track3_Instrument ;ld (PLY_Track3_Instrument + 1),hl





PLY_Track3_NoNoteGiven

	ld a,1
PLY_Track3_NewInstrument_SetWait
	ld (PLY_Track3_WaitCounter),a










	ld a,(PLY_Speed)
PLY_SpeedEnd
	ld (PLY_SpeedCpt),a










;Play the Sound on Track 3
;-------------------------
;Plays the sound on each frame, but only save the forwarded Instrument pointer when Instrument Speed is reached.
;This is needed because TrackPitch is involved in the Software Frequency/Hardware Frequency calculation, and is calculated every frame.

	z_ld_iy PLY_PSGRegistersArray + 4; ld iy,PLY_PSGRegistersArray + 4
	z_ld_hl_from PLY_Track3_Pitch
	z_ld_de_from PLY_Track3_PitchAdd
	add hl,de
	z_ld_hl_to PLY_Track3_Pitch ;ld (PLY_Track3_Pitch + 1),hl
	sra h				;Shift the Pitch to slow its speed.
	rr l
	sra h
	rr l
	z_ex_dehl ;ex de,hl
	cexx ;exx

;PLY_Track3_Volume equ $+2
;PLY_Track3_Note equ $+1
	z_ld_de_from PLY_Track3_Note				;D=Inverted Volume E=Note
	z_ld_hl_from PLY_Track3_Instrument
	call PLY_PlaySound

	ld a,(PLY_Track3_InstrumentSpeedCpt)
	dec a
	jr nz,PLY_Track3_PlayNoForward
	z_ld_hl_to PLY_Track3_Instrument ;ld (PLY_Track3_Instrument + 1),hl
	ld a,(PLY_Track3_InstrumentSpeed)
PLY_Track3_PlayNoForward
	ld (PLY_Track3_InstrumentSpeedCpt),a





	z_ld_a_ixl ; ld a,ixl			;Save the Register 7 of the Track 3.
	z_ex_af_afs ;ex af,af'
	



;Play the Sound on Track 2
;-------------------------
	z_ld_iy PLY_PSGRegistersArray + 2 ;ld iy,PLY_PSGRegistersArray + 2
	z_ld_hl_from PLY_Track2_Pitch
	z_ld_de_from PLY_Track2_PitchAdd
	add hl,de
	z_ld_hl_to PLY_Track2_Pitch ;ld (PLY_Track2_Pitch + 1),hl
	sra h				;Shift the Pitch to slow its speed.
	rr l
	sra h
	rr l
	z_ex_dehl ;ex de,hl
	cexx ;exx

;PLY_Track2_Volume equ $+2
;PLY_Track2_Note equ $+1
	z_ld_de_from PLY_Track2_Note				;D=Inverted Volume E=Note
	z_ld_hl_from PLY_Track2_Instrument
	call PLY_PlaySound

	ld a,(PLY_Track2_InstrumentSpeedCpt)
	dec a
	jr nz,PLY_Track2_PlayNoForward
	z_ld_hl_to PLY_Track2_Instrument;ld (PLY_Track2_Instrument + 1),hl
	ld a,(PLY_Track2_InstrumentSpeed)
PLY_Track2_PlayNoForward
	ld (PLY_Track2_InstrumentSpeedCpt),a



;***************************************
;Play Sound Effects on Track 2 (only assembled used if PLY_UseSoundEffects is set to one)
;***************************************
	if PLY_UseSoundEffects

	z_ld_de_from PLY_SFX_Track2_Pitch
	cexx ;exx
;PLY_SFX_Track2_Volume equ $+2
;PLY_SFX_Track2_Note equ $+1
	z_ld_de_from PLY_SFX_Track2_Note				;D=Inverted Volume E=Note
	z_ld_hl_from PLY_SFX_Track2_Instrument	;If 0, no sound effect.
	ld a,l
	or h
	jr z,PLY_SFX_Track2_End
	ld a,1
	ld (PLY_PS_EndSound_SFX),a
	call PLY_PlaySound
	xor a
	ld (PLY_PS_EndSound_SFX),a
	ld a,l				;If the new address is 0, the instrument is over. Speed is set in the process, we don't care.
	or h
	jr z,PLY_SFX_Track2_Instrument_SetAddress

	ld a,(PLY_SFX_Track2_InstrumentSpeedCpt)
	dec a
	jr nz,PLY_SFX_Track2_PlayNoForward
PLY_SFX_Track2_Instrument_SetAddress
	z_ld_hl_to PLY_SFX_Track2_Instrument ;ld (PLY_SFX_Track2_Instrument + 1),hl
	ld a,(PLY_SFX_Track2_InstrumentSpeed)
PLY_SFX_Track2_PlayNoForward
	ld (PLY_SFX_Track2_InstrumentSpeedCpt ),a

PLY_SFX_Track2_End
	endif
;******************************************


	z_ex_af_afs ;ex af,af'
	add a,a			;Mix Reg7 from Track2 with Track3, making room first.
	z_or_ixl ;or ixl
	rla
	z_ex_af_afs ;ex af,af'



;Play the Sound on Track 1
;-------------------------

	z_ld_iy PLY_PSGRegistersArray ;ld iy,PLY_PSGRegistersArray
	z_ld_hl_from PLY_Track1_Pitch
	z_ld_de_from PLY_Track1_PitchAdd
	add hl,de
	z_ld_hl_to PLY_Track1_Pitch ;ld (PLY_Track1_Pitch + 1),hl
	sra h				;Shift the Pitch to slow its speed.
	rr l
	sra h
	rr l
	z_ex_dehl ;ex de,hl
	cexx ;exx

;PLY_Track1_Volume equ $+2
;PLY_Track1_Note equ $+1
	z_ld_de_from PLY_Track1_Note				;D=Inverted Volume E=Note
	z_ld_hl_from PLY_Track1_Instrument
	call PLY_PlaySound

	ld a,(PLY_Track1_InstrumentSpeedCpt)
	dec a
	jr nz,PLY_Track1_PlayNoForward
	z_ld_hl_to PLY_Track1_Instrument ;ld (PLY_Track1_Instrument + 1),hl
	ld a,(PLY_Track1_InstrumentSpeed)
PLY_Track1_PlayNoForward
	ld (PLY_Track1_InstrumentSpeedCpt),a





	z_ex_af_afs ;ex af,af'
	z_or_ixl ;or ixl			;Mix Reg7 from Track3 with Track2+1.



;Send the registers to PSG. Various codes according to the machine used.
PLY_SendRegisters
;A=Register 7


	ifdef buildMSX

	ld b,a
	ld hl,PLY_PSGRegistersArray

;Register 0
	xor a
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 1
	ld a,1
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 2
	ld a,2
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 3
	ld a,3
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 4
	ld a,4
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 5
	ld a,5
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 6
	ld a,6
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 7
	ld a,7
	out (#a0),a
	ld a,b				;Use the stored Register 7.
	out (#a1),a

;Register 8
	ld a,8
	out (#a0),a
	ld a,(hl)
	if PLY_UseFades
PLY_Channel1_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif

	out (#a1),a
	inc hl
	inc hl				;Skip unused byte.

;Register 9
	ld a,9
	out (#a0),a
	ld a,(hl)

	if PLY_UseFades
PLY_Channel2_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif

	out (#a1),a
	inc hl
	inc hl				;Skip unused byte.
	
;Register 10
	ld a,10
	out (#a0),a
	ld a,(hl)

	if PLY_UseFades
PLY_Channel3_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif

	out (#a1),a
	inc hl

;Register 11
	ld a,11
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 12
	ld a,12
	out (#a0),a
	ld a,(hl)
	out (#a1),a
	inc hl

;Register 13
	if PLY_SystemFriendly
	call PLY_PSGReg13_Code
PLY_PSGREG13_RecoverSystemRegisters
	pop iy
	pop ix
	pop bc
	pop af
	exx
	ex af,af'
	;Restore Interrupt status
PLY_RestoreInterruption nop				;Will be automodified to an DI/EI.
	ret

	endif


PLY_PSGReg13_Code
	ld a,13
	out (#a0),a
	ld a,(hl)
PLY_PSGReg13_Retrig: cp 255				;If IsRetrig?, force the R13 to be triggered.
	ret z

	out (#a1),a
	ld (PLY_PSGReg13_Retrig + 1),a

ayReset:
AYEmulation_Play:
	ret



	endif



	ifdef BuildSAM
	ld hl,PLY_PSGRegistersArray
	ld b,a

;Register 0

	ld a,(hl)
	ld (ayfine1),a
	inc hl

;Register 1
	ld a,(hl)
	ld (aycoarse1),a
	inc hl

;Register 2
	ld a,(hl)
	ld (ayfine2),a
	inc hl

;Register 3
	ld a,(hl)
	ld (aycoarse2),a
	inc hl

;Register 4
	ld a,(hl)
	ld (ayfine3),a
	inc hl

;Register 5
	ld a,(hl)
	ld (aycoarse3),a
	inc hl
;Register 6
	ld a,(hl)
	ld (aynoisepitch),a
	inc hl

;Register 7
	ld a,b
	ld (aymixer),a

;Register 8
	ld a,(hl)

	if PLY_UseFades
PLY_Channel1_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif

	ld (ayvol1),a
	inc hl
	inc hl				;Skip unused byte.

;Register 9
	ld a,(hl)

	if PLY_UseFades
PLY_Channel2_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif
	ld (ayvol2),a
	inc hl
	inc hl				;Skip unused byte.
	
;Register 10

	ld a,(hl)

	if PLY_UseFades
PLY_Channel3_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif

	ld (ayvol3),a
;	call ayRegisterWrite
;	out (#a1),a
	inc hl

;Register 11
	ld a,(hl)
	ld (ayenvlen),a
	inc hl


;Register 12
	ld a,(hl)
	ld (ayenvlen2),a
	inc hl

;Register 13
	if PLY_SystemFriendly
	call PLY_PSGReg13_Code
PLY_PSGREG13_RecoverSystemRegisters
	pop iy
	pop ix
	pop bc
	pop af
	exx
	ex af,af'
	;Restore Interrupt status
PLY_RestoreInterruption nop				;Will be automodified to an DI/EI.
	ret

	endif


PLY_PSGReg13_Code
	ld a,(hl)


PLY_PSGReg13_Retrig: cp 255				;If IsRetrig?, force the R13 to be triggered.
	ret z

;	call ayRegisterWrite
	ld (ayenvshape),a
	ld (PLY_PSGReg13_Retrig + 1),a
	ret

	endif ; end of SAM code


	ifdef BuildENT
BuildENTType equ 1
	endif
	ifdef BuildSGG
BuildENTType equ 1
	endif
	ifdef BuildSMS
BuildENTType equ 1
	endif
	ifdef BuildGBC
BuildENTType equ 1
	endif
	ifdef BuildGMB
BuildENTType equ 1
	endif
	
	
	ifdef BuildENTType

	ld c,a
	push bc
	ld hl,PLY_PSGRegistersArray

;Register 0
	xor a
	ld c,(hl)
	call ayRegisterWrite
	inc hl

;Register 1
	ld a,1
	ld c,(hl)
	call ayRegisterWrite
	inc hl

;Register 2
	ld a,2
	ld c,(hl)
	call ayRegisterWrite
	inc hl

;Register 3
	ld a,3
	ld c,(hl)
	call ayRegisterWrite
	inc hl

;Register 4
	ld a,4
	ld c,(hl)
	call ayRegisterWrite
	inc hl

;Register 5
	ld a,5
	ld c,(hl)
	call ayRegisterWrite
	inc hl

;Register 6
	ld a,6
	ld c,(hl)
	call ayRegisterWrite
	inc hl

;Register 7
	ld a,7
;	ld c,(hl)
	pop bc
	call ayRegisterWrite
;	inc hl

;Register 8

;	out (#a0),a
	ld a,(hl)
	if PLY_UseFades
PLY_Channel1_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif
	ld c,a
	ld a,8
	call ayRegisterWrite
	inc hl
	inc hl				;Skip unused byte.

;Register 9


	ld a,(hl)


	if PLY_UseFades
PLY_Channel2_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif
	ld c,a
	ld a,9
	call ayRegisterWrite
;	out (#a1),a
	inc hl
	inc hl				;Skip unused byte.
	
;Register 10

;	out (#a0),a
;	ld a,(hl)
	ld a,(hl)
	
	if PLY_UseFades
PLY_Channel3_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+3
	xor a
	endif
	ld c,a
	ld a,10
	call ayRegisterWrite
;	out (#a1),a
	inc hl

;Register 11
	ld a,11
	ld c,(hl)
	call ayRegisterWrite
	inc hl


;Register 12
	ld a,12
	ld c,(hl)
	call ayRegisterWrite
	inc hl

;Register 13
	if PLY_SystemFriendly
	call PLY_PSGReg13_Code
PLY_PSGREG13_RecoverSystemRegisters
	pop iy
	pop ix
	pop bc
	pop af
	cexx ;exx
	z_ex_af_afs;ex af,af'
	;Restore Interrupt status
PLY_RestoreInterruption nop				;Will be automodified to an DI/EI.
	ret

	endif


PLY_PSGReg13_Code
	ld a,13
	ld c,(hl)

	push hl
		ld hl,PLY_PSGReg13_Retrig
		cp (hl)				;If IsRetrig?, force the R13 to be triggered.
	pop hl
	ret z

	call ayRegisterWrite
	ld a,c
	ld (PLY_PSGReg13_Retrig),a
	ret

	endif ; end of ENT code

















	ifdef buildCPC

	ld de,#c080
	ld b,#f6
	out (c),d	;#f6c0
	exx
	ld hl,PLY_PSGRegistersArray
	ld e,#f6
	ld bc,#f401

;Register 0
	defb #ed,#71	;#f400+Register
	ld b,e
	defb #ed,#71	;#f600
	dec b
	outi		;#f400+value
	exx
	out (c),e	;#f680 00000000
	out (c),d	;#f6c0 11000000
	exx

;Register 1
	out (c),c
	ld b,e
	defb #ed,#71	;OUT (C),0
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 2
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 3
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 4
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 5
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 6
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 7
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	dec b
	out (c),a			;Read A register instead of the list.
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 8
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	if PLY_UseFades
	dec b
	ld a,(hl)
PLY_Channel1_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+6
	defb #ed,#71
	jr $+4
	out (c),a
	inc hl

	else
	
	outi
	endif
	exx
	out (c),e
	out (c),d
	exx
	inc c
	inc hl				;Skip unused byte.

;Register 9
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	if PLY_UseFades			;If PLY_UseFades is set to 1, we manage the volume fade.
	dec b
	ld a,(hl)
PLY_Channel2_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+6
	defb #ed,#71
	jr $+4
	out (c),a
	inc hl

	else
	
	outi
	endif
	exx
	out (c),e
	out (c),d
	exx
	inc c
	inc hl				;Skip unused byte.

;Register 10
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	if PLY_UseFades
	dec b
	ld a,(hl)
PLY_Channel3_FadeValue sub 0		;Set a value from 0 (full volume) to 16 or more (volume to 0).
	jr nc,$+6
	defb #ed,#71
	jr $+4
	out (c),a
	inc hl

	else
	
	outi
	endif
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 11
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 12
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d
	exx
	inc c

;Register 13


PLY_PSGReg13_Code
	ld a,(hl)
PLY_PSGReg13_Retrig: cp 255				;If IsRetrig?, force the R13 to be triggered.
	ret z
	ld (PLY_PSGReg13_Retrig + 1),a
	out (c),c
	ld b,e
	defb #ed,#71
	dec b
	outi
	exx
	out (c),e
	out (c),d

ayReset:
AYEmulation_Play:
	ret

	endif ; end of CPC code











	ifdef BuildZXS
				ex af,af'	; save R7
				
				ld hl,PLY_PSGRegistersArray
				ld de,#BFFF
				ld bc,#FFFD
				
				xor a		; R0
				out (c),a
				ld b,d
				outi
				ld b,e
				
				inc a		; R1
				out (c),a
				ld b,d
				outi
				ld b,e
				
				inc a		; R2
				out (c),a
				ld b,d
				outi
				ld b,e
				
				inc a		; R3
				out (c),a
				ld b,d
				outi
				ld b,e
				
				inc a		; R4
				out (c),a
				ld b,d
				outi
				ld b,e
				
				inc a		; R5
				out (c),a
				ld b,d
				outi
				ld b,e
				
				inc a		; R6
				out (c),a
				ld b,d
				outi
				ld b,e
				
				inc a		; R7
				out (c),a
				ld b,d
				ex af,af'
				out (c),a	; R7 value is held in AF'
				ex af,af'	; not in the registers buffer
				ld b,e
				
				inc a		; R8
				out (c),a
				ld b,d
					if PLY_UseFades
					ex af,af'
					dec b
					ld a,(hl)
					inc hl
_azVAR_FadeChA				equ $+1
					sub 0
					jr nc,$+3
					xor a
					out (c),a
					ex af,af'
				else
					outi
				endif
				inc hl		; skip digidrum id byte
				ld b,e
				
				inc a		; R9
				out (c),a
				ld b,d
					if PLY_UseFades
					ex af,af'
					dec b
					ld a,(hl)
					inc hl
_azVAR_FadeChB				equ $+1
					sub 0
					jr nc,$+3
					xor a
					out (c),a
					ex af,af'
				else
					outi
				endif
				inc hl		; skip wasted byte
				ld b,e
				
				inc a		; R10
				out (c),a
				ld b,d
					if PLY_UseFades
					ex af,af'
					dec b
					ld a,(hl)
					inc hl
_azVAR_FadeChC				equ $+1
					sub 0
					jr nc,$+3
					xor a
					out (c),a
					ex af,af'
				else
					outi
				endif
				ld b,e
				
				inc a		; R11
				out (c),a
				ld b,d
				outi
				ld b,e
				
				inc a		; R12
				out (c),a
				ld b,d
				outi
				ld b,e
		
				inc a		; R13
				out (c),a
				ld a,(hl)
PLY_PSGReg13_Retrig:			cp 255
				ret z
				
				ld b,d
				out (c),a
				ld (PLY_PSGReg13_Retrig + 1),a
ayReset:
AYEmulation_Play:
				ret
	endif ; end of speccy code







;moved to the CORE
;There are two holes in the list, because the Volume registers are set relatively to the Frequency of the same Channel (+7, always).
;Also, the Reg7 is passed as a register, so is not kept in the memory.
;PLY_PSGRegistersArray
;PLY_PSGReg0 db 0
;PLY_PSGReg1 db 0
;PLY_PSGReg2 db 0
;PLY_PSGReg3 db 0
;PLY_PSGReg4 db 0
;PLY_PSGReg5 db 0
;PLY_PSGReg6 db 0
;PLY_PSGReg8 db 0		;+7
;	    db 0
;PLY_PSGReg9 db 0		;+9
;	    db 0
;PLY_PSGReg10 db 0		;+11
;PLY_PSGReg11 db 0
;PLY_PSGReg12 db 0
;PLY_PSGReg13 db 0
;PLY_PSGRegistersArray_End










;Plays a sound stream.
;HL=Pointer on Instrument Data
;IY=Pointer on Register code (volume, frequency).
;E=Note
;D=Inverted Volume
;DE'=TrackPitch

;RET=
;HL=New Instrument pointer.
;IXL=Reg7 mask (x00x)

;Also used inside =
;B,C=read byte/second byte.
;IXH=Save original Note (only used for Independant mode).
  

PLY_PlaySound
	ld b,(hl)
	inc hl
	rr b
	jp c,PLY_PS_Hard

;**************
;Software Sound
;**************
	;Second Byte needed ?
	rr b
	jp c,PLY_PS_S_SecondByteNeeded

	;No second byte needed. We need to check if Volume is null or not.
	ld a,b
	and %1111
	jr nz,PLY_PS_S_SoundOn

	;Null Volume. It means no Sound. We stop the Sound, the Noise, and it's over.
	z_ld_iy_plusn_a 7 ;ld (iy + 7),a			;We have to make the volume to 0, because if a bass Hard was activated before, we have to stop it.
	z_ld_ixl %1001;ld ixl,%1001

	ret

PLY_PS_S_SoundOn
	;Volume is here, no Second Byte needed. It means we have a simple Software sound (Sound = On, Noise = Off)
	;We have to test Arpeggio and Pitch, however.
	z_ld_ixl %1000;ld ixl,%1000

	sub d						;Code Volume.
	jr nc,$+3
	xor a
	z_ld_iy_plusn_a 7 ;ld (iy + 7),a

	rr b						;Needed for the subroutine to get the good flags.
	call PLY_PS_CalculateFrequency
	z_ld_iy_plusn_l 0 ;ld (iy + 0),l					;Code Frequency.
	z_ld_iy_plusn_h 1 ;ld (iy + 1),h
	cexx

	ret
	


PLY_PS_S_SecondByteNeeded
	z_ld_ixl %1000;ld ixl,%1000	;By defaut, No Noise, Sound.

	;Second Byte needed.
	ld c,(hl)
	inc hl

	;Noise ?
	ld a,c
	and %11111
	jr z,PLY_PS_S_SBN_NoNoise
	ld (PLY_PSGReg6),a
	z_ld_ixl %0000;ld ixl,%0000					;Open Noise Channel.
PLY_PS_S_SBN_NoNoise:

	;Here we have either Volume and/or Sound. So first we need to read the Volume.
	ld a,b
	and %1111
	sub d						;Code Volume.
	jr nc,$+3
	xor a
	z_ld_iy_plusn_a 7 ;ld (iy + 7),a

	;Sound ?
	bit 5,c
	jr nz,PLY_PS_S_SBN_Sound
	;No Sound. Stop here.
	z_inc_ixl ;inc ixl						;Set Sound bit to stop the Sound.
	ret

PLY_PS_S_SBN_Sound
	;Manual Frequency ?
	rr b						;Needed for the subroutine to get the good flags.
	bit 6,c
	call PLY_PS_CalculateFrequency_TestManualFrequency
	z_ld_iy_plusn_l 0 ;ld (iy + 0),l					;Code Frequency.
	z_ld_iy_plusn_h 1 ;ld (iy + 1),h
	cexx

	ret




;**********
;Hard Sound
;**********
PLY_PS_Hard
	;We don't set the Volume to 16 now because we may have reached the end of the sound !

	rr b						;Test Retrig here, it is common to every Hard sounds.
	jr nc,PLY_PS_Hard_NoRetrig
	ld a,(PLY_Track1_InstrumentSpeedCpt)	;Retrig only if it is the first step in this line of Instrument !
	ld c,a
	ld a,(PLY_Track1_InstrumentSpeed)
	cp c
	jr nz,PLY_PS_Hard_NoRetrig
	ld a,PLY_RetrigValue
	ld (PLY_PSGReg13_Retrig),a
PLY_PS_Hard_NoRetrig

	;Independant/Loop or Software/Hardware Dependent ?
	bit 1,b				;We don't shift the bits, so that we can use the same code (Frequency calculation) several times.
	jp nz,PLY_PS_Hard_LoopOrIndependent

	;Hardware Sound.
	z_ld_iy_plusn_n 7,16;ld (iy + 7),16					;Set Volume
	z_ld_ixl %1000 ;ld ixl,%1000					;Sound is always On here (only Independence mode can switch it off).

	;This code is common to both Software and Hardware Dependent.
	ld c,(hl)			;Get Second Byte.
	inc hl
	ld a,c				;Get the Hardware Envelope waveform.
	and %1111			;We don't care about the bit 7-4, but we have to clear them, else the waveform might be reset.
	ld (PLY_PSGReg13),a

	bit 0,b
	jp z,PLY_PS_HardwareDependent


;******************
;Software Dependent
;******************

	;Calculate the Software frequency
	bit 4-2,b		;Manual Frequency ? -2 Because the byte has been shifted previously.
	call PLY_PS_CalculateFrequency_TestManualFrequency
	z_ld_iy_plusn_l 0 ;ld (iy + 0),l		;Code Software Frequency.
	z_ld_iy_plusn_h 1 ;ld (iy + 1),h
	cexx

	;Shift the Frequency.
	ld a,c
	rra
	rra			;Shift=Shift*4. The shift is inverted in memory (7 - Editor Shift).
	and %11100
	ld (FakeJR_Ram),a ;ld (PLY_PS_SD_Shift + 1),a
	ld a,b			;Used to get the HardwarePitch flag within the second registers set.
	cexx

	call FakeJR ;PLY_PS_SD_Shift jr $+2
	srl h ; srl h
	rr l
	srl h ; srl h
	rr l
	srl h ; srl h
	rr l
	srl h ; srl h
	rr l
	srl h ; srl h
	rr l
	srl h ; srl h
	rr l
	srl h ; srl h
	rr l
	jr nc,$+3
	inc hl

	;Hardware Pitch ?
	bit 7-2,a
	jp z,PLY_PS_SD_NoHardwarePitch
	cexx						;Get Pitch and add it to the just calculated Hardware Frequency.
	ld a,(hl)
	inc hl
	cexx
	add a,l						;Slow. Can be optimised ? Probably never used anyway.....
	ld l,a
	cexx
	ld a,(hl)
	inc hl
	cexx
	adc a,h
	ld h,a
PLY_PS_SD_NoHardwarePitch
	z_ld_hl_to PLY_PSGReg11;ld (PLY_PSGReg11),hl
	cexx


	;This code is also used by Hardware Dependent.
PLY_PS_SD_Noise
	;Noise ?
	bit 7,c
	ret z
	ld a,(hl)
	inc hl
	ld (PLY_PSGReg6),a
	z_ld_ixl %0000 ;ld ixl,%0000
	ret




;******************
;Hardware Dependent
;******************
PLY_PS_HardwareDependent
	;Calculate the Hardware frequency
	bit 4-2,b			;Manual Hardware Frequency ? -2 Because the byte has been shifted previously.
	call PLY_PS_CalculateFrequency_TestManualFrequency
	z_ld_hl_to PLY_PSGReg11;ld (PLY_PSGReg11),hl		;Code Hardware Frequency.
	cexx

	;Shift the Hardware Frequency.
	ld a,c
	rra
	rra			;Shift=Shift*4. The shift is inverted in memory (7 - Editor Shift).
	and %11100
	ld (FakeJR_Ram),a ;ld (PLY_PS_HD_Shift + 1),a
	ld a,b			;Used to get the Software flag within the second registers set.
	cexx


	call FakeJR ;PLY_PS_HD_Shift jr $+2
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h
	sla l
	rl h

	;Software Pitch ?
	bit 7-2,a
	jp z,PLY_PS_HD_NoSoftwarePitch
	cexx						;Get Pitch and add it to the just calculated Software Frequency.
	ld a,(hl)
	inc hl
	cexx
	add a,l
	ld l,a						;Slow. Can be optimised ? Probably never used anyway.....
	cexx
	ld a,(hl)
	inc hl
	cexx
	adc a,h
	ld h,a
PLY_PS_HD_NoSoftwarePitch
	z_ld_iy_plusn_l 0 ;ld (iy + 0),l					;Code Frequency.
	z_ld_iy_plusn_h 1 ;ld (iy + 1),h
	cexx

	;Go to manage Noise, common to Software Dependent.
	jp PLY_PS_SD_Noise





PLY_PS_Hard_LoopOrIndependent
	bit 0,b					;We mustn't shift it to get the result in the Carry, as it would be mess the structure
	jr z,PLY_PS_Independent			;of the flags, making it uncompatible with the common code.

	;The sound has ended.
	;If Sound Effects activated, we mark the "end of sound" by returning a 0 as an address.
	if PLY_UseSoundEffects
	ld a,(PLY_PS_EndSound_SFX)			;Is the sound played is a SFX (1) or a normal sound (0) ?
	or a
	jr z,PLY_PS_EndSound_NotASFX
	ld hl,0
	ret
PLY_PS_EndSound_NotASFX
	endif

	;The sound has ended. Read the new pointer and restart instrument.

	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	jp PLY_PlaySound






;***********
;Independent
;***********
PLY_PS_Independent
	z_ld_iy_plusn_n 7,16 ;ld (iy + 7),16			;Set Volume

	;Sound ?
	bit 7-2,b			;-2 Because the byte has been shifted previously.
	jr nz,PLY_PS_I_SoundOn
	;No Sound ! It means we don't care about the software frequency (manual frequency, arpeggio, pitch).
	z_ld_ixl %1001 ;ld ixl,%1001
	jp PLY_PS_I_SkipSoftwareFrequencyCalculation
PLY_PS_I_SoundOn
	z_ld_ixl %1000 ;ld ixl,%1000			;Sound is on.
	z_ld_ixh_e ;ld ixh,e			;Save the original note for the Hardware frequency, because a Software Arpeggio will modify it.

	;Calculate the Software frequency
	bit 4-2,b			;Manual Frequency ? -2 Because the byte has been shifted previously.
	call PLY_PS_CalculateFrequency_TestManualFrequency
	z_ld_iy_plusn_l 0 ;ld (iy + 0),l			;Code Software Frequency.
	z_ld_iy_plusn_h 1 ;ld (iy + 1),h
	cexx

	z_ld_e_ixh ;ld e,ixh
PLY_PS_I_SkipSoftwareFrequencyCalculation

	ld b,(hl)			;Get Second Byte.
	inc hl
	ld a,b				;Get the Hardware Envelope waveform.
	and %1111			;We don't care about the bit 7-4, but we have to clear them, else the waveform might be reset.
	ld (PLY_PSGReg13),a


	;Calculate the Hardware frequency
	rr b				;Must shift it to match the expected data of the subroutine.
	rr b
	bit 4-2,b			;Manual Hardware Frequency ? -2 Because the byte has been shifted previously.
	call PLY_PS_CalculateFrequency_TestManualFrequency
	z_ld_hl_to PLY_PSGReg11;ld (PLY_PSGReg11),hl		;Code Hardware Frequency.
	cexx



	;Noise ? We can't use the previous common code, because the setting of the Noise is different, since Independent can have no Sound.
	bit 7-2,b
	ret z
	ld a,(hl)
	inc hl
	ld (PLY_PSGReg6),a
	z_ld_a_ixl ;ld a,ixl	;Set the Noise bit.
	res 3,a
	z_ld_ixl_a ;ld ixl,a
	ret

















;Subroutine that =
;If Manual Frequency? (Flag Z off), read frequency (Word) and adds the TrackPitch (DE').
;Else, Auto Frequency.
;	if Arpeggio? = 1 (bit 3 from B), read it (Byte).
;	if Pitch? = 1 (bit 4 from B), read it (Word).
;	Calculate the frequency according to the Note (E) + Arpeggio + TrackPitch (DE').

;HL = Pointer on Instrument data.
;DE'= TrackPitch.

;RET=
;HL = Pointer on Instrument moved forward.
;HL'= Frequency
;	RETURN IN AUXILIARY REGISTERS
PLY_PS_CalculateFrequency_TestManualFrequency
	jp z,PLY_PS_CalculateFrequency
	;Manual Frequency. We read it, no need to read Pitch and Arpeggio.
	;However, we add TrackPitch to the read Frequency, and that's all.
	ld a,(hl)
	inc hl
	cexx ;exx
	add a,e						;Add TrackPitch LSB.
	ld l,a
	cexx ;exx
	ld a,(hl)
	inc hl
	cexx ;exx
	adc a,d						;Add TrackPitch HSB.
	ld h,a
	ret




PLY_PS_CalculateFrequency
	;Pitch ?
	bit 5-1,b
	jp z,PLY_PS_S_SoundOn_NoPitch
	ld a,(hl)
	inc hl
	cexx ;exx
	add a,e						;If Pitch found, add it directly to the TrackPitch.
	ld e,a
	cexx ;exx
	ld a,(hl)
	inc hl
	cexx ;exx
	adc a,d
	ld d,a
	cexx ;exx
PLY_PS_S_SoundOn_NoPitch:

	;Arpeggio ?
	ld a,e
	bit 4-1,b
	jp z,PLY_PS_S_SoundOn_ArpeggioEnd
	add a,(hl)					;Add Arpeggio to Note.
	inc hl
	cp 144
	jr c,$+4
	ld a,143
PLY_PS_S_SoundOn_ArpeggioEnd:

	;Frequency calculation.
	cexx ;exx
	ld l,a
	ld h,0
	add hl,hl
	
	ld bc,PLY_FrequencyTable
	add hl,bc

	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	add hl,de					;Add TrackPitch + InstrumentPitch (if any).

	ret
















;Read one Track.
;HL=Track Pointer.

;Ret =
;HL=New Track Pointer.
;Carry = 1 = Wait A lines. Carry=0=Line not empty.
;A=Wait (0(=256)-127), if Carry.
;D=Parameters + Volume.
;E=Note
;B=Instrument. 0=RST
;IX=PitchAdd. Only used if Pitch? = 1.
PLY_ReadTrack
	ld a,(hl)
	inc hl
	srl a ; srl a			;Full Optimisation ? If yes = Note only, no Pitch, no Volume, Same Instrument.
	jr c,PLY_ReadTrack_FullOptimisation
	sub 32			;0-31 = Wait.
	jr c,PLY_ReadTrack_Wait
	jr z,PLY_ReadTrack_NoOptimisation_EscapeCode
	dec a			;0 (32-32) = Escape Code for more Notes (parameters will be read)
	
	;Note. Parameters are present. But the note is only present if Note? flag is 1.
	ld e,a			;Save Note.

	;Read Parameters
PLY_ReadTrack_ReadParameters
	ld a,(hl)
	ld d,a			;Save Parameters.
	inc hl

	rla			;Pitch ?
	jr nc,PLY_ReadTrack_Pitch_End
	ld b,(hl)		;Get PitchAdd
	z_ld_ixl_b ;ld ixl,b
	inc hl
	ld b,(hl)
	z_ld_ixh_b ;ld ixh,b
	inc hl
PLY_ReadTrack_Pitch_End

	rla			;Skip IsNote? flag.
	rla			;New Instrument ?
	ret nc
	ld b,(hl)
	inc hl
	or a			;Remove Carry, as the player interpret it as a Wait command.
	ret

;Escape code, read the Note and returns to read the Parameters.
PLY_ReadTrack_NoOptimisation_EscapeCode
	ld e,(hl)
	inc hl
	jr PLY_ReadTrack_ReadParameters
	




PLY_ReadTrack_FullOptimisation
	;Note only, no Pitch, no Volume, Same Instrument.
	ld d,%01000000			;Note only.
	sub 1
	ld e,a
	ret nc
	ld e,(hl)			;Escape Code found (0). Read Note.
	inc hl
	or a
	ret





PLY_ReadTrack_Wait
	add a,32
	ret


Music_Restart:
	ifdef BuildSAM
		call ayReset 
	endif
	ifdef BuildENT
		call ayReset 
	endif
PLY_Init:
	ld a,1
	ld (PLY_SpeedCpt),a
	ld (PLY_HeightCpt),a
	ld (PLY_Height),a
	ld (PLY_Track1_WaitCounter),a
	ld (PLY_Track1_InstrumentSpeedCpt),a
	ld (PLY_Track2_WaitCounter),a
	ld (PLY_Track2_InstrumentSpeedCpt),a
	ld (PLY_Track3_WaitCounter),a
	ld (PLY_Track3_InstrumentSpeedCpt),a
	ld (PLY_Speed),a
	ld (PLY_SFX_Track2_InstrumentSpeedCpt),a
	
	
	ld a,6
	ld (PLY_Track1_InstrumentSpeed),a
	ld (PLY_Track2_InstrumentSpeed),a
	ld (PLY_Track3_InstrumentSpeed),a
	ld (PLY_SFX_Track2_InstrumentSpeed),a
	
	ld a,255
	ld (PLY_PSGReg13_Retrig),a
	
	ld hl,Akuyou_MusicPos+9				;Skip Header, SampleChannel, YM Clock (DB*3), and Replay Frequency.
;	add hl,de
	ld de,PLY_Speed
	z_ldi				;Copy Speed.
	ld c,(hl)			;Get Instruments chunk size.
	inc hl
	ld b,(hl)
	inc hl
	z_ld_hl_to PLY_Track1_InstrumentsTablePT ;ld (PLY_Track1_InstrumentsTablePT + 1),hl
	z_ld_hl_to PLY_Track2_InstrumentsTablePT ;ld (PLY_Track2_InstrumentsTablePT + 1),hl
	z_ld_hl_to PLY_Track3_InstrumentsTablePT ;ld (PLY_Track3_InstrumentsTablePT + 1),hl

	add hl,bc			;Skip Instruments to go to the Linker address.
	;Get the pre-Linker information of the first pattern.
	ld de,PLY_Height
	z_ldi
	ld de,PLY_Transposition1
	z_ldi
	ld de,PLY_Transposition2
	z_ldi
	ld de,PLY_Transposition3
	z_ldi
	;ld de,PLY_SaveSpecialTrack + 1
	;z_ldi
	;z_ldi
	inc hl
	inc hl
	z_ld_hl_to PLY_Linker_PT;ld (PLY_Linker_PT + 1),hl	;Get the Linker address.

	ld a,1
	ld (PLY_SpeedCpt),a
	ld (PLY_HeightCpt),a

	ld a,#ff
	ld (PLY_PSGReg13),a
	
	;Set the Instruments pointers to Instrument 0 data (Header has to be skipped).
	z_ld_hl_from PLY_Track1_InstrumentsTablePT ;ld hl,(PLY_Track1_InstrumentsTablePT + 1)
	ld e,(hl)
	inc hl
	ld d,(hl)
	z_ex_dehl ; ex de,hl
	inc hl					;Skip Instrument 0 Header.
	inc hl
	z_ld_hl_to PLY_Track1_Instrument ;ld (PLY_Track1_Instrument + 1),hl
	z_ld_hl_to PLY_Track2_Instrument ;ld (PLY_Track2_Instrument + 1),hl
	z_ld_hl_to PLY_Track3_Instrument ;ld (PLY_Track3_Instrument + 1),hl




	ret



;Stop the music, cut the channels.
Music_Stop:
PLY_Stop
	

;	ld hl,PLY_PSGRegistersArray+8;PLY_PSGReg8
;	ld bc,#0300
	ld hl,PLY_PSGRegistersArray
	ld bc,#0F00
PLyLoop:
	ld (hl),c
	inc hl
	z_djnz PLyLoop
;	ld a,%00111111
	xor a
	jp PLY_SendRegisters








	if PLY_UseSoundEffects

;Initialize the Sound Effects.
;DE = SFX Music.
PLY_SFX_Init
	;Find the Instrument Table.
	ld hl,Akuyou_SfxPos+12
	;add hl,de
	z_ld_hl_to PLY_SFX_Play_InstrumentTable;ld (PLY_SFX_Play_InstrumentTable + 1),hl
	
;Clear the three channels of any sound effect.
PLY_SFX_Stop
PLY_SFX_StopAll
	ld hl,0
	;ld (PLY_SFX_Track1_Instrument + 1),hl
	z_ld_hl_to PLY_SFX_Track2_Instrument ;ld (PLY_SFX_Track2_Instrument + 1),hl
	;ld (PLY_SFX_Track3_Instrument + 1),hl
	ret


PLY_SFX_OffsetPitch equ 0
PLY_SFX_OffsetVolume equ PLY_SFX_Track2_Volume - PLY_SFX_Track2_Pitch
PLY_SFX_OffsetNote equ PLY_SFX_Track2_Note - PLY_SFX_Track2_Pitch
PLY_SFX_OffsetInstrument equ PLY_SFX_Track2_Instrument - PLY_SFX_Track2_Pitch
PLY_SFX_OffsetSpeed equ PLY_SFX_Track2_InstrumentSpeed - PLY_SFX_Track2_Pitch
PLY_SFX_OffsetSpeedCpt equ PLY_SFX_Track2_InstrumentSpeedCpt - PLY_SFX_Track2_Pitch

;Plays a Sound Effects along with the music.
;A = No Channel (0,1,2)
;L = SFX Number (>0)
;H = Volume (0...F)
;E = Note (0...143)
;D = Speed (0 = As original, 1...255 = new Speed (1 is fastest))
;BC = Inverted Pitch (-#FFFF -> FFFF). 0 is no pitch. The higher the pitch, the lower the sound.
PLY_SFX_Play
	;ld ix,PLY_SFX_Track1_Pitch
	;or a
	;jr z,PLY_SFX_Play_Selected
;	ld ix,PLY_SFX_Track2_Pitch
	;dec a
	;jr z,PLY_SFX_Play_Selected
	;ld ix,PLY_SFX_Track3_Pitch
	
PLY_SFX_Play_Selected
;	ld a,e					;Set Note
	ld (PLY_SFX_Track2_Pitch + PLY_SFX_OffsetNote),a
	xor a
	ld b,a
	ld c,a
	;ld d,a
	z_ld_bc_to PLY_SFX_Track2_Pitch + PLY_SFX_OffsetPitch    ;ld (PLY_SFX_Track2_Pitch + PLY_SFX_OffsetPitch + 1),bc	;Set Pitch
;	ld (ix + PLY_SFX_OffsetPitch + 2),b

	;ld a,15					;Set Volume
	;sub h
	ld (PLY_SFX_Track2_Pitch + PLY_SFX_OffsetVolume),a
	ld h,a					;Set Instrument Address
	add hl,hl
	z_ld_bc_from PLY_SFX_Play_InstrumentTable
	add hl,bc
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	;ld a,d					;Read Speed or use the user's one ?
	;or a
	;jr nz,PLY_SFX_Play_UserSpeed
	ld a,(hl)				;Get Speed
PLY_SFX_Play_UserSpeed
	ld (PLY_SFX_Track2_Pitch + PLY_SFX_OffsetSpeed ),a
	ld (PLY_SFX_Track2_Pitch + PLY_SFX_OffsetSpeedCpt ),a
	inc hl					;Skip Retrig
	inc hl
	z_ld_hl_to PLY_SFX_Track2_Pitch + PLY_SFX_OffsetInstrument ;ld (PLY_SFX_Track2_Pitch + PLY_SFX_OffsetInstrument + 1),hl


	ret
	endif
;Stops a sound effect on the selected channel
;E = No Channel (0,1,2)
;I used the E register instead of A so that Basic users can call this code in a straightforward way (call player+15, value).





PLY_FrequencyTable
	ifdef buildSAM

		dw 4095,4095,4095,4095,4095,4095,4095,4095,4095,3977,3754,3543
		dw 3344,3157,2980,2812,2655,2506,2365,2232,2107,1989,1877,1772
		dw 1672,1578,1490,1406,1327,1253,1182,1116,1053,994,939,886
		dw 836,789,745,703,664,626,591,558,527,497,469,443
		dw 418,395,372,352,332,313,296,279,263,249,235,221
		dw 209,197,186,176,166,157,148,140,132,124,117,111
		dw 105,99,93,88,83,78,74,70,66,62,59,55
		dw 52,49,47,44,41,39,37,35,33,31,29,28
		dw 26,25,23,22,21,20,18,17,16,16,15,14
		dw 13,12,12,11,10,10,9,9,8,8,7,7
		dw 7,6,6,5,5,5,5,4,4,4,4,3
		dw 3,3,3,3,3,2,2,2,2,2,2,2
	endif
	ifdef buildENT

		dw 4095,4095,4095,4095,4095,3822,3608,3214,2863,2551,2273,2025
	;	dw 3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025
		dw 1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012
		dw 956,902,851,804,758,716,676,638,602,568,536,506
		dw 478,451,426,402,379,358,338,319,301,284,268,253
		dw 239,225,213,201,190,179,169,159,150,142,134,127
		dw 119,113,106,100,95,89,84,80,75,71,67,63
		dw 60,56,53,50,47,45,42,40,38,36,34,32
		dw 30,28,27,25,24,22,21,20,19,18,17,16
		dw 15,14,13,13,12,11,11,10,9,9,8,8
		dw 7,7,7,6,6,6,5,5,5,4,4,4
		dw 4,4,3,3,3,3,3,2,2,2,2,2
		dw 2,2,2,2,1,1,1,1,1,1,1,1
	endif
	ifdef BuildSMS

		dw 4095,4095,4095,4095,4095,3822,3608,3214,2863,2551,2273,2025
	;	dw 3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025
		dw 1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012
		dw 956,902,851,804,758,716,676,638,602,568,536,506
		dw 478,451,426,402,379,358,338,319,301,284,268,253
		dw 239,225,213,201,190,179,169,159,150,142,134,127
		dw 119,113,106,100,95,89,84,80,75,71,67,63
		dw 60,56,53,50,47,45,42,40,38,36,34,32
		dw 30,28,27,25,24,22,21,20,19,18,17,16
		dw 15,14,13,13,12,11,11,10,9,9,8,8
		dw 7,7,7,6,6,6,5,5,5,4,4,4
		dw 4,4,3,3,3,3,3,2,2,2,2,2
		dw 2,2,2,2,1,1,1,1,1,1,1,1
	endif
		ifdef BuildGBC

		dw 4095,4095,4095,4095,4095,3822,3608,3214,2863,2551,2273,2025
	;	dw 3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025
		dw 1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012
		dw 956,902,851,804,758,716,676,638,602,568,536,506
		dw 478,451,426,402,379,358,338,319,301,284,268,253
		dw 239,225,213,201,190,179,169,159,150,142,134,127
		dw 119,113,106,100,95,89,84,80,75,71,67,63
		dw 60,56,53,50,47,45,42,40,38,36,34,32
		dw 30,28,27,25,24,22,21,20,19,18,17,16
		dw 15,14,13,13,12,11,11,10,9,9,8,8
		dw 7,7,7,6,6,6,5,5,5,4,4,4
		dw 4,4,3,3,3,3,3,2,2,2,2,2
		dw 2,2,2,2,1,1,1,1,1,1,1,1
	endif
	ifdef buildCPC

		dw 3822,3608,3405,3214,3034,2863,2703,2551,2408,2273,2145,2025
		dw 1911,1804,1703,1607,1517,1432,1351,1276,1204,1136,1073,1012
		dw 956,902,851,804,758,716,676,638,602,568,536,506
		dw 478,451,426,402,379,358,338,319,301,284,268,253
		dw 239,225,213,201,190,179,169,159,150,142,134,127
		dw 119,113,106,100,95,89,84,80,75,71,67,63
		dw 60,56,53,50,47,45,42,40,38,36,34,32
		dw 30,28,27,25,24,22,21,20,19,18,17,16
		dw 15,14,13,13,12,11,11,10,9,9,8,8
		dw 7,7,7,6,6,6,5,5,5,4,4,4
		dw 4,4,3,3,3,3,3,2,2,2,2,2
		dw 2,2,2,2,1,1,1,1,1,1,1,1
	endif
	ifdef buildMSX
		dw 4095,4095,4095,4095,4095,4095,4095,4095,4095,4030,3804,3591
		dw 3389,3199,3019,2850,2690,2539,2397,2262,2135,2015,1902,1795
		dw 1695,1599,1510,1425,1345,1270,1198,1131,1068,1008,951,898
		dw 847,800,755,712,673,635,599,566,534,504,476,449
		dw 424,400,377,356,336,317,300,283,267,252,238,224
		dw 212,200,189,178,168,159,150,141,133,126,119,112
		dw 106,100,94,89,84,79,75,71,67,63,59,56
		dw 53,50,47,45,42,40,37,35,33,31,30,28
		dw 26,25,24,22,21,20,19,18,17,16,15,14
		dw 13,12,12,11,11,10,9,9,8,8,7,7
		dw 7,6,6,6,5,5,5,4,4,4,4,4
		dw 3,3,3,3,3,2,2,2,2,2,2,2
	endif

	ifdef BuildZXS
		ifndef BuildZXS_Pentagon
			dw 4095,4095,4095,4095,4095,4095,4095,4095,4095,4030,3804,3591
			dw 3389,3199,3019,2850,2690,2539,2397,2262,2135,2015,1902,1795
			dw 1695,1599,1510,1425,1345,1270,1198,1131,1068,1008,951,898
			dw 847,800,755,712,673,635,599,566,534,504,476,449
			dw 424,400,377,356,336,317,300,283,267,252,238,224
			dw 212,200,189,178,168,159,150,141,133,126,119,112
			dw 106,100,94,89,84,79,75,71,67,63,59,56
			dw 53,50,47,45,42,40,37,35,33,31,30,28
			dw 26,25,24,22,21,20,19,18,17,16,15,14
			dw 13,12,12,11,11,10,9,9,8,8,7,7
			dw 7,6,6,6,5,5,5,4,4,4,4,4
			dw 3,3,3,3,3,2,2,2,2,2,2,2
		else
			dw 4095,4095,4095,4095,4095,4095,4095,4095,4095,3977,3754,3543
			dw 3344,3157,2980,2812,2655,2506,2365,2232,2107,1989,1877,1772
			dw 1672,1578,1490,1406,1327,1253,1182,1116,1053,994,939,886
			dw 836,789,745,703,664,626,591,558,527,497,469,443
			dw 418,395,372,352,332,313,296,279,263,249,235,221
			dw 209,197,186,176,166,157,148,140,132,124,117,111
			dw 105,99,93,88,83,78,74,70,66,62,59,55
			dw 52,49,47,44,41,39,37,35,33,31,29,28
			dw 26,25,23,22,21,20,18,17,16,16,15,14
			dw 13,12,12,11,10,10,9,9,8,8,7,7
			dw 7,6,6,5,5,5,5,4,4,4,4,3
			dw 3,3,3,3,3,2,2,2,2,2,2,2
		endif
	endif

	
	
	
ArkosRam equ &DE00	

FakeJR_Ram    equ ArkosRam
PLY_SpeedCpt  equ ArkosRam+1
PLY_HeightCpt equ ArkosRam+2
PLY_Linker_PT equ ArkosRam+3	;DW
PLY_Height    equ ArkosRam+5	
	
PLY_Track1_WaitCounter 	equ PLY_Height+1
PLY_Track1_PT 			equ PLY_Height+2
PLY_Transposition1		equ PLY_Height+4
PLY_Track1_SavePTInstrument equ PLY_Height+5
PLY_Track1_InstrumentsTablePT equ PLY_Height+7
PLY_Track1_InstrumentSpeed  equ PLY_Height+9
PLY_Track1_InstrumentSpeedCpt equ PLY_Height+10

PLY_Track2_WaitCounter 	equ PLY_Track1_InstrumentSpeedCpt+1
PLY_Track2_PT 			equ PLY_Track1_InstrumentSpeedCpt+2
PLY_Transposition2		equ PLY_Track1_InstrumentSpeedCpt+4
PLY_Track2_SavePTInstrument equ PLY_Track1_InstrumentSpeedCpt+5
PLY_Track2_InstrumentsTablePT equ PLY_Track1_InstrumentSpeedCpt+7
PLY_Track2_InstrumentSpeed  equ PLY_Track1_InstrumentSpeedCpt+9
PLY_Track2_InstrumentSpeedCpt equ PLY_Track1_InstrumentSpeedCpt+10

PLY_Track3_WaitCounter 	equ PLY_Track2_InstrumentSpeedCpt+1
PLY_Track3_PT 			equ PLY_Track2_InstrumentSpeedCpt+2
PLY_Transposition3		equ PLY_Track2_InstrumentSpeedCpt+4
PLY_Track3_SavePTInstrument equ PLY_Track2_InstrumentSpeedCpt+5
PLY_Track3_InstrumentsTablePT equ PLY_Track2_InstrumentSpeedCpt+7
PLY_Track3_InstrumentSpeed  equ PLY_Track2_InstrumentSpeedCpt+9
PLY_Track3_InstrumentSpeedCpt equ PLY_Track2_InstrumentSpeedCpt+10

PLY_Speed equ PLY_Track3_InstrumentSpeedCpt+1
PLY_PSGReg13_Retrig equ  PLY_Track3_InstrumentSpeedCpt+2


PLY_Track3_Pitch	equ PLY_PSGReg13_Retrig+1
PLY_Track3_PitchAdd	equ PLY_PSGReg13_Retrig+3
PLY_Track3_Note		equ PLY_PSGReg13_Retrig+5
PLY_Track3_Volume	equ PLY_PSGReg13_Retrig+6
PLY_Track3_Instrument equ PLY_PSGReg13_Retrig+7 ;2

PLY_Track2_Pitch	equ PLY_Track3_Instrument+1+1
PLY_Track2_PitchAdd	equ PLY_Track3_Instrument+3+1
PLY_Track2_Note		equ PLY_Track3_Instrument+5+1
PLY_Track2_Volume	equ PLY_Track3_Instrument+6+1
PLY_Track2_Instrument equ PLY_Track3_Instrument+7+1 ;2

PLY_Track1_Pitch	equ PLY_Track2_Instrument+1+1
PLY_Track1_PitchAdd	equ PLY_Track2_Instrument+3+1
PLY_Track1_Note		equ PLY_Track2_Instrument+5+1
PLY_Track1_Volume	equ PLY_Track2_Instrument+6+1
PLY_Track1_Instrument equ PLY_Track2_Instrument+7+1 ;2


PLY_SFX_Track2_Pitch equ PLY_Track1_Instrument+2
PLY_SFX_Track2_Note  equ PLY_Track1_Instrument+4
PLY_SFX_Track2_Volume equ PLY_Track1_Instrument+5
PLY_SFX_Track2_Instrument	equ PLY_Track1_Instrument+6
PLY_SFX_Track2_InstrumentSpeedCpt equ PLY_Track1_Instrument+8
PLY_SFX_Track2_InstrumentSpeed	equ PLY_Track1_Instrument+9


PLY_PS_EndSound_SFX equ PLY_SFX_Track2_InstrumentSpeed+1
PLY_SFX_Play_InstrumentTable equ PLY_SFX_Track2_InstrumentSpeed+2 ;2




	
PLY_PSGRegistersArray equ PLY_SFX_Track2_InstrumentSpeed+2 
;PLY_PSGReg0b db 0		;0
;PLY_PSGReg1b db 0		;1
;PLY_PSGReg2b db 0		;2
;PLY_PSGReg3b db 0		;3
;PLY_PSGReg4b db 0		;4
;PLY_PSGReg5b db 0		;5
PLY_PSGReg6 equ PLY_PSGRegistersArray+6; db 0		;6
;PLY_PSGReg8b db 0		;7
		;db 0			;8
;PLY_PSGReg9b db 0		;9
;		db 0			;10
;PLY_PSGReg10b db 0		;11
PLY_PSGReg11  equ PLY_PSGRegistersArray+12 ;db 0		;12
;PLY_PSGReg12b db 0		;13
PLY_PSGReg13  equ PLY_PSGRegistersArray+14 ;db 0		;14






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
FakeJR:
	
	push hl
	push de
	inc sp
	inc sp
	inc sp
	inc sp
	pop hl
	push af
	ld d,0
	ld a,(FakeJR_Ram)
	dec a
	dec a		;JR includes the 2 bytes of the JR n command - we do not!
	ld e,a
	add hl,de
	pop af
	push hl
	dec sp
	dec sp
	dec sp
	dec sp
	pop de
	pop hl
	ret