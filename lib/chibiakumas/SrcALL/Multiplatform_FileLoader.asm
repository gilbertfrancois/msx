
;Support64k equ 1
;buildMSX equ 1
;buildCPC equ 1
;BuildZXS equ 1


; --------------------------------------------------------------------------------------------
;***************************************************************************************************

;			 Super simple Disk reader

;***************************************************************************************************
	read "..\SrcAll\LZ48_decrunch.asm"




	ifdef buildMSX
LoadFileName: 		db "-"
LoadFileNameTrack:	db "0000 "
		 	db "  "
LoadFileNameCompressed:	db "D0"
LoadFileNameDisk: 	db "0"
	endif


	ifdef buildENT
LoadFileName: 		db 9,"-"
LoadFileNameTrack:	db "0000"
			db "."
LoadFileNameCompressed:	db "D0"
LoadFileNameDisk: 	db "0"
	endif

	ifdef buildSAM
LoadFileName: 		db "-"
LoadFileNameTrack:	db "0000"
		 	db "."
LoadFileNameCompressed:	db "D"
LoadFileNameDisk: 	db "0      "
	endif

	ifdef buildCPC
	ifdef buildCPC_Tap
LoadFileName: 		db "-"
LoadFileNameTrack:	db "0000"
			db "."
LoadFileNameCompressed:	db "D0"
LoadFileNameDisk: 	db "0   "
	else
LoadFileName: 		db "-"
LoadFileNameTrack:	db "0000 "
			db "  ."
LoadFileNameCompressed:	db "D0"
LoadFileNameDisk: 	db "0"
	endif
	endif

SetDiskMessage:
	ifdef BuildZXS_TAP
		db "Set Tape "
	endif
	ifdef BuildZXS_TRD
		db "Set Disk "
	endif
	ifdef BuildZXS_DSK 
		db "Set Disk "
	endif
	ifdef buildCPC
		db "Set Disk "
	endif
	ifdef buildENT
		db "Set Disk "
	endif
	ifdef buildMSX
		ifdef BuildLangE
			db "Set Disk "
		else
			db "SET DISK "
		endif
	endif
	ifdef BuildLangE
SetDiskMessageDisk:	db  "1"+&80
	else
SetDiskMessageDisk:	db  "1",255
	endif
;BootStrapFile
;	db "BootStrp.Aku"

;align 8
;DiskRemap
;defb 0,1,2,3,4
;--------------------------------------------------------------------------------------------

	ifdef BuildZXS
;TestFileName
;     12345678
LoadFileName: 		db "X"	;1
LoadFileNameTrack:	db "0000" ;234
LoadFileNameCompressed:	db "D0"   ;7
LoadFileNameDisk: 	db "0"   ;8

	ifdef BuildZXS_TAP
		db "C",32
	endif
	ifdef BuildZXS_TRD
		db "C"
	endif
	ifdef BuildZXS_DSK
		db ".C",&ff
	endif

	endif




LoadDiscSectorZ: ;Load Compressed Disk sector
	;DE = Destination of decompressed file
	;IX = Temp location of Compressed data


;	ifdef buildCPC
;	push af
;		cp &C0
;		jr z,LoadDiscSectorZver_BankOk
;		ld a,(CPCVer)
;		and 128
;		jr nz,LoadDiscSectorZver_BankOk		; Told to load a file into 128k memory!
;		pop af
;		ret
;LoadDiscSectorZver_BankOk
;	pop af
;	endif

	push af



		push de
			call LoadDiscSectorZver
		pop de
		; hl  compressed data adres
		; de  output adress of dat	
		ld hl,0000;<-- SM ***
CompressedDataAddress_Plus2:






	pop af

	ifdef BuildZXS
	;	ld (SPRestoreB_Plus2-2),sp
	;	ld sp,StackPointerAlt
	endif

	di

	ifdef BuildZXS
		call Bankswapper_Set
	endif
	;cpc disabled call BankSwitch_C0	; switch to bank A



	call LZ48_decrunch
	;cpc disabled 	jp BankSwitch_C0_Reset	; switch to bank A
	ifdef BuildMSX
		ld (LZ48FileEnd_Plus2-2),de
	endif
	ifdef BuildZXS

		call Bankswapper_Reset
	endif

;	ld sp,&0000 SPRestoreB_Plus2
;LoadDiscSectorByEnd
;	push af
;	ld a,'D'
;	jr LoadDiscSectorZverB
	ret
LoadDiscSectorZver:

	push af
	ld a,'Z'
	push hl
		push ix		;Use our temp address as the destination
		pop hl
		ld (NewDestination_Plus2-2),hl

	ifdef buildMSX
		ld hl,DiskReader_LoadProcessor
		ld (DiskReader_LoadProcessor_Plus2-2),hl
	endif

		ld hl,DiscDestRelocate
	jr LoadDiscSectorB


	ifdef buildMSX
LoadDiscSectorSpecialMSX:
		push af
		ld a,'D'
		push hl

		push iy
		pop hl
		jr LoadDiscSector_SpecialMSX2
	endif



LoadDiscSector:				; This was all structured assuming amsdos would be replaced with 
	; H = Track  (41)		; a sector based disk reader however with the success of M4
	; L = Sector (C1)		; and C4CPC - and the fact KL_WALK_ROM seems to restore the
	; I = Disk   (00)		; A600-BF00 block so well, it was never needed
	; B = Size - size is not used at all , no need to pass it
	; C = disk
	;  A  = 128 k memory bank
	;; DE = load address 


	push af
	ld a,'D'

	push hl

	ifdef buildMSX
		ld hl,DiskReader_LoadProcessor
LoadDiscSector_SpecialMSX2:
		ld (DiskReader_LoadProcessor_Plus2-2),hl
	endif

		ld hl,null
LoadDiscSectorB:
		ld (DiscDestRelocateCall_Plus2-2),hl
	pop hl
	ld (LoadFileNameCompressed),a
	pop af

	ld (DiskLoadBank_Plus1-1),a	; if asked to load to a mem bank >0 on 64k do nothing
;ifdef buildCPC
;	cp &C0
;	jr z,LoadDiscSector_64kOk
;	ld a,(CPCVer)
;	and 128
;	ret z		; Told to load a file into 128k memory!
;endif

LoadDiscSector_64kOk:
;push af

	push hl


	ld a,c
	add 48
	ld (LoadFileNameDisk),a

	ld hl,DiskRemap
	ld a,c
	add l
	ld l,a
	ld c,(hl)


	ld a,(SetDiskMessageDisk)
	ifdef BuildLangE
		sub &80+48
	else
		sub 48
	endif
	cp c
	ifdef SingleDisk
		jr LoadDiscSector_NoDiskCheck	; The disk is still in
	endif 

	jr z,LoadDiscSector_NoDiskCheck	; Disk Zero means file is assumed to be on 
	;ALL Disks

		ld a,c
		or a

		
		jr z,DiskZero
	ifdef BuildLangE
		add 48+&80
	else
		add 48
	endif
		ld (SetDiskMessageDisk),a
		Call ShowDiskMessage
;		jr DiskZero
LoadDiscSector_NoDiskCheck:	;Skip the disk check, just assume the disk is in


DiskZero: ;file common to all disks
	pop hl





	ifdef RomDisk
		ld a,l
		ld (RomFileL_Plus1-1),a
		ld a,h
		ld (RomFileH_Plus1-1),a
	else






	;pop af
		; Patch the filename with Sector and track info
		push de
	;		push bc
				ld de,LoadFileNameTrack
				ld a,h
				call SetHex
				ld a,l
				call SetHex
	;		pop bc

		pop de
		ld hl,LoadFileName
	endif
;	jr LoadDiskFileFromHL
LoadDiskFileFromHL:	; Load a file from HL memory loc
	push hl	



;	push de
		;push hl
	
	;cpc disabled 	push hl
;cpc disabled 			ld hl,&0A0F		; Move cursor so errors dont wrap I don't hide them
	;cpc disabled 				call txt_set_cursor	; so we can see if a problem happened
;cpc disabled 		pop hl

;cpc disabled 				call txt_set_cursor	; so we can see if a problem happened		ld de,&C000	;; address of 2k buffer, this can be any value if the files have a header
;cpc disabled 				call txt_set_cursor	; so we can see if a problem happened		ld b,12		;12 chars

;CPC DISKLOAD WAS HERE	call DiskDriverLoad	; carry true if sucess
;	pop de

	call DiskDriver_Load	; carry true if sucess
	ld h,d
	ld l,e

	
	jr nc,DiskError1


	pop hl	; speccy only

	ret


DiskRetry2:	;not needed for speccy

;	ld a,&C0DiskLoadBank_Plus1
	;cpc disabled 	push bc
	;cpc disabled 		call BankSwitch_C0	; switch to bank A
	;cpc disabled 	pop bc
	;cpc disabled 	call cas_in_direct	; carry true if sucess

	jr nc,DiskError2
	pop hl
	;cpc disabled 	call BankSwitch_C0_Reset ; Restore the previous bank
	;cpc disabled 	jp cas_in_close
DiskError1:

	call 	ShowDiskMessage
	pop hl
	jr LoadDiskFileFromHL

DiskError2:
	call 	ShowDiskMessage
	pop hl
	jr LoadDiskFileFromHL

ShowDiskMessage:		;Show the error messages
		push bc
		push de

	ifdef BuildMSX	
		di
		ld hl,MSXGameoverPalette
		ld b,8
		call VDP_SetPalettePartial
	endif
	;cpc disabled 			call RasterColors_DefaultSafe

	ld a,CSprite_SetDisk
	call ShowCompiledSprite
	;cpc disabled			call BankSwitch_C0_Reset ; Restore the previous bank
			;push bc
	call SpriteBank_Font2


			;pop bc
			;ld hl,Font_RegularSizePos 			
;			call ShowSprite_SetBankAddr


			
	ifdef BuildZXS
		call Firmware_Kill	;Get the firmware font for speccy!
	endif
				ld hl,&160a ;<-- SM ***
SetDiskMessagePos_Plus2:
				ld bc,SetDiskMessage
				call DrawText_LocateAndPrintStringUnlimited



	ifdef BuildZXS
		call Firmware_Restore
	endif
				call KeyboardScanner_WaitForKey
			;call CLS

	ifdef BuildMSX	
		di
		call Akuyou_Music_Stop 
	endif

	ld a,CSprite_Loading
	call ShowCompiledSprite

		pop de
		pop bc
	ret



	




SetHex:	
	push af
		and %11110000
		rrca
		rrca
		rrca
		rrca
		call SetHexChar
	pop af
	and %00001111
SetHexChar:
	or a	;Clear Carry Clag
	daa
	add a,&F0
	adc a,&40
	ld (de),a
	inc de
	ret

DiscDestRelocate:
;	push hl
	ld hl,&0000 ;<-- SM ***
NewDestination_Plus2:
;	exx hl,de
	    or a   ;ccf
;	    SCF    ; Force carry = 1
;	    CCF    ; Flip carry so it is 0
	    SBC    HL, BC
	ld (CompressedDataAddress_Plus2-2),hl
;	ex hl,de
;	pop hl
	ret


