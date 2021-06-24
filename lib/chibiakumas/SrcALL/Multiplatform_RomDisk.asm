DiskDriver_Save:
ret




DiskDriver_LoadDirect:
	push hl
		ld hl,null
		ld (DiscDestRelocateCall_Plus2-2),hl
	pop hl

DiskDriver_Load:

	ld a,&C0:DiskLoadBank_Plus1
	push bc
		call BankSwitch_C0	; switch to bank A

	pop bc

	ld hl,DiskMap
WrongRomFileAgain:
	ld a,(hl)
	cp 00 :RomFileL_Plus1
	inc hl
	jr nz,WrongRomFile


	ld a,(hl)
	cp 00 :RomFileH_Plus1
	jr z,FoundRomFile


WrongRomFile:
	or (hl)
	jr z,DiskError		;0000=end of file list

	inc hl
	inc hl
	inc hl

	inc hl
	inc hl
	inc hl
	inc hl
	jr WrongRomFileAgain
FoundRomFile:
	inc hl
	
	inc hl	;bank
	inc hl

	inc hl	;memaddr
	inc hl

	ld c,(hl)
	inc hl
	ld b,(hl)
	dec hl

	dec hl
	ld a,(hl)
	dec hl
	ld l,(hl)
	ld h,a

	ex hl,de
	call null :DiscDestRelocateCall_Plus2
	ex hl,de

	ldir


	call BankSwitch_C0_Reset ; Restore the previous bank
	scf
	ret


DiskError:
	di 
	halt
	or a	

ret

DiskMap:
dw	&0001
dw	&0001
dw	&0001
dw	&0001

dw	&01C1		;File (&0000 last file
dw	&0000		;Bank	
dw	File1		;Pos
dw	File1END-File1	;Length

dw	&0000

File1:
incbin "Z:\ResALL\MusicTest9000.bin.z"
File1END:
