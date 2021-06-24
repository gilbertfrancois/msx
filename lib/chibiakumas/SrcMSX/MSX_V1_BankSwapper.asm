
BankSwapper_INIT:
	call BackupSlotRegisters	
	ld (FirmwareSlotRestoreB),a
	ld e,a
	ld (FirmwareSlotRestoreA),a
	
	
	
	
	ld de,SlotExpansion		;Backup slot expansion (we need it in our current ram bank for scan)
	ld hl,&FCC1
	ldi
	ldi
	ldi
	ldi
	ret
	
Bankswapper_RestoreFirmware:
		ld a,(FirmwareSlotRestoreA)
		out (&A8),a
		ld a,(FirmwareSlotRestoreB)
		ld (&FFFF),a
	ret

Bankswapper_FullRam:		
		ld a,(FullRamA)
		out (&A8),a
		ld a,(FullRamB)
		ld (&FFFF),a

	ret
	
BankSwapper_FindRAM:
	call GetCurrentBank	;Effectively push PC onto the stack
GetCurrentBank:
	pop af
	rlca
	rlca
	and %00000011

	ld (CurrentRunningBank_Plus1-1),a

		ld h,0		;Bank
BankTesth
		ld l,0		;Slot
BankTestl
		ld d,0		;Subslot
BankTestD:
		push hl
			call SetBank			;E=1 if expanded slot
			call BankTestRAM	;A=2 if RAM , 0 if ROM
		pop hl
		cp 2
		jr z,FoundRam
		inc d
		bit 2,d	;D=4?
		jr z,BankTestD
		
		inc l
		bit 2,l	;L=4?
		jr z,BankTestL
		jr NoRamFound
FoundRam:
		call BackupSlotRegisters
NoRamFound:
		inc h
		ld a,h
		cp 0	;<-- SM ***		;We can't bank switch the CURRENT bank - unless we like crashes!
CurrentRunningBank_Plus1:
		jr nz,DontskipHbank
		inc h
DontskipHbank:			
		cp 4
		jr nz,BankTestH
		
		ld a,(SlotRestoreA)
		ld (FullRamA),a
		ld a,(SlotRestoreB)
		ld (FullRamB),a
	ret
	
BackupSlotRegisters:
	in a,(&A8)
	ld (SlotRestoreA),a
	ld e,a
	ld a,(&FFFF)	
	cpl
	ld (SlotRestoreB),a
	ret
		
BankTestRAM:
		 push hl
		 push de
	 		ld a,h
			rrca
			rrca
			and %11000000	;Work out what memory address to 
			ld h,a			;  test from current banks number
			
			ld d,0
			ld l,d
			ld a,(hl)		;Read in from bank
			cpl				;Flip bits
			ld (hl),a		;Write back
			cp (hl)			;Did it write back
			jr nz,BankTestRAMReadOnly ;If it didn't change then it's rom
			cpl
			ld (hl),a		;it's ram, so Put correct value back
			ld d,2
BankTestRAMReadOnly:
			 ld a,d
		 pop de
		 pop hl
	ret

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
RAMAD0 equ	#F341	;Slot address of RAM in page 0
RAMAD1 equ	#F342	;Slot address of RAM in page 1
RAMAD2 equ	#F343	;Slot address of RAM in page 2
RAMAD3 equ	#F344	;Slot address of RAM in page 3

FindDiskRam:	;Read in 4 variables and convert them
	 ld a,(RAMAD3)
	 call ProcessSlotData
	 ld a,(RAMAD2)
	 call ProcessSlotData
	 ld a,(RAMAD1)
	 call ProcessSlotData
	 ld a,(RAMAD0)
	 call ProcessSlotData
	
	 ld a,b		;Slots
	 ld (FullRamA),a
	 ld a,c		;Subslots
	 ld (FullRamB),a
	 ret
	 
ProcessSlotData:	;Convert DISK ram definitions for registers
	push af			;Input     A  - ExxxSSPP
		and %00000011
		rlc b		;Shift Slot value
		rlc b
		or b
		ld b,a
	pop af 
	and %00001100	;Subslot value
	rrca
	rrca
	rlc c
	rlc c
	or c
	ld c,a
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
	align4
SlotExpansion: db 0,0,0,0

FirmwareSlotRestoreA: db 0
FirmwareSlotRestoreB: db 0

SlotRestoreA: db 0
SlotRestoreB: db 0
FullRamA: defb &00
FullRamB: defb &00

BankSwapper_SetCartBank:	;Bank 3 is the first of our program's banks (0-2 are ROM)

;	Bank 1 &4000h - &5FFF set by writing to &5000
;	Bank 2 &6000h - &7FFF set by writing to &7000
;	Bank 3 &8000h - &9FFF set by writing to &9000
;	Bank 4 &A000h - &BFFF set by writing to &B000
	ld (&5000),a
	inc a
	ld (&7000),a
	ret

	
BankSwapper_SetCartBank2:	;Bank 3 is the first of our program's banks (0-2 are ROM)
	ld (&9000),a
	inc a
	ld (&B000),a
	ret

	

	
	


SetBank:	; H=Bank  L=Slot  D=subslot .... 	
	di		;returns E=1 if slot has subslots
	ld e,0
	;Check the slot expansion vars FCC1H-FCC4H 
	ld bc,SlotExpansion 
	ld a,l		
	add c
	ld c,a
	ld a,(bc)
	bit 7,a				;bit 7 is set if expanded
	jr z,SlotNotExpanded

	;Page in the subslot selection register &FFFF 
	ld b,L			;B=Bank
	ld c,3			;C=Slot
	call GetSlotMask;Convert to aMmask & Value

	ld a,(SlotRestoreA)
	and B			;Apply Mask
	or c			;Set new value
	out (&A8),a

	;Set the subslot selection register &FFFF 
	ld b,H			;B=Bank
	ld c,D			;C=Subslot
	call GetSlotMask
	ld a,(&FFFF)
	cpl
	and B			;Apply Mask
	or c			;Set new value
	ld (&FFFF),a	;Set Subslot
	
	inc e			;Mark slot as expanded
SlotNotExpanded:	;Page in the bank we want	
	ld b,H			;Bank
	ld c,L			;Slot
	call GetSlotMask
	ld a,(SlotRestoreA)
	and B		;Apply Mask
	or c		;Set new value
	out (&A8),a
	ret

GetSlotMask: ;	B=Bank C=Slot  ... Returns B=Mask C=Slot
	ld a,%11111100	;Mask
	GetSlotMaskB:
	rlc c		;Shift the mask and slot into the 
	rlc c		;right position according to Bank (B)
	rlca
	rlca
	djnz GetSlotMaskB
	ld b,a
	ret

	

		