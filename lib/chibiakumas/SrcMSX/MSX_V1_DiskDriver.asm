
DBASIC					EQU &F37D	;The address we call to do our disk ops.
;Possible disk commands below
FOPEN					EQU &0F
FCLOSE					EQU &10
CREATE					EQU &16
BLWRITE					EQU &26
BLREAD					EQU &27
SETDMA					EQU &1A ;Disk transfer address (Destination/source)
BDOS_INIT				EQU &1B
BDOS_RESET				EQU &00
BDOS_DiskRESET			EQU &0D
BDOS_DefaultDrive 		EQU &0E
BDOS_GetDefaultDrive 	EQU &19

;defw &0000 DiscDestRelocateCall_Plus2;not implemented yet!
defb 0 :DiskLoadBank_Plus1

DiskDriver_Save:

	ld (FileWriteSize_Plus2-2),bc
	ld (FileWriteDestination_Plus2-2),de
	call DiskDriver_InitCMD
	jr c,DiskDriver_Writeb	;Failed to get disk

	ld c,CREATE
	ld de,FCB
	call	DBASIC
	or a 
	jr nz,DiskDriver_Writeb

	call	resetfcb
	ld a,1
	ld (FCB_RecordSize),a

	ld a,&FE
	ld (signature),a
	ld hl,&0000
	ld (blstart),hl
	ld hl,&0020		:FileWriteSize_Plus2
	push hl
	ld (blend),hl

		ld	de,blheader
		ld	c,SETDMA
		call	DBASIC
		
		ld	hl,7
		ld	c,BLWRITE
		call	DBASICFCB

		ld	de,&0000:FileWriteDestination_Plus2
		ld	c,SETDMA; 		Set File destination
		call	DBASIC

	pop hl ;ld	hl,&0020
	ld	c,BLWRITE
	call	DBASICFCB

	ld 	c,FCLOSE
	call	DBASICFCB
DiskDriver_Writeb:
	call Bankswapper_FullRam
	ret

DBASICFCB:
	ld	de,FCB
	call	DBASIC
	ret
DiskDriver_InitCMD:

	ld de,FNAME
	ld bc,8+3
	ldir

	call Bankswapper_RestoreFirmware

		;Set our custom error handler
		ld a,&C3
		ld (&FFB1),a
		ld hl,DiskFailer
		ld (&FFB2),hl

		ld (DiskFailerSP_Plus2-2),sp	;Backup the current stackpointer so we can undo any mess!

		ld c,&64
		ld de,DiskFailer
		call	DBASIC			

		ld e,0
		ld c,BDOS_INIT
		call	DBASIC
		inc a;cp 255
		jr z,DiskDriver_InitCMD_Fail
	
		ld e,0 :DefaultDrive_Plus1
		ld c,BDOS_DefaultDrive
		call	DBASIC

;code_start:
; set the reading buffer addr
		ld	de,blheader
		ld	c,SETDMA
		call	DBASIC
	or a
	ret
DiskDriver_InitCMD_Fail:
	scf
	ret
	
DiskFailer:
	ld a,255
	ld sp,&0000	:DiskFailerSP_Plus2
	call Bankswapper_FullRam
	scf
	ret

DiskDriver_Init:
	ld c,BDOS_GetDefaultDrive
	call	DBASIC
	ld (DefaultDrive_Plus1-1),a
	ret

DiskDriver_LoadDirect:
	push hl
		ld hl,null
		ld (DiscDestRelocateCall_Plus2-2),hl
	pop hl
DiskDriver_Load:
	ld (FileDestination_Plus2-2),de
	call DiskDriver_InitCMD

; open file
	call	clearfcb
	ld	de,FCB
	ld	c,FOPEN
	call	DBASIC
	and	a
	jr	nz,diskerr	
; read the bload header
		call	resetfcb
		ld	hl,7
		ld	de,FCB
		ld	c,BLREAD
		call	DBASIC
		and	a
		jr	nz,diskerr
		
		ld	a,(signature)
		cp	&FE	; is it a bload file?
		jr	nz,diskerr

; starting address of the bl block
		ld	de,DiskBuffer
		ld	c,SETDMA;1A
		call	DBASIC

; calculate length in bytes
		ld	de,(blstart)
		ld	hl,(blend)
		or	a
		sbc	hl,de
		inc	hl		;2 extra bytes for safety
		inc	hl		;BC is used when decompressing files
		ld b,h
		ld c,l

		ld hl,(FileDestination_Plus2-2)
		call null :DiscDestRelocateCall_Plus2
		ld (FileDestination_Plus2-2),hl
		
; load the data block
LoadAgain:
		call Bankswapper_RestoreFirmware
		ld	de,FCB
		ld	c,BLREAD
		ld 	hl,DiskReader_Buffersize
		call	DBASIC

		di 
		ld a,l
		push af
			call Bankswapper_FullRam	;Function to page in ram
		pop af
		or a
		jr z,LoadDone
		push af
			ld b,0
			ld c,a
			ld hl,DiskBuffer	;BC=Buffersize
			call DiskReader_LoadProcessor :DiskReader_LoadProcessor_Plus2

		pop af
		cp DiskReader_Buffersize
		jp z,LoadAgain

;Function	27H
;Setup		DE register <-- starting address of opened FCB
;		FCB record size <-- record size to be read
;		FCB random record <-- record to start reading
;		HL register <-- number of records to be read
;Return value	00H is set in the A register when data is read successfully;
;		otherwise 01H is read. The number of records actually read
;		is set back in the HL register. When this number is almost
;		one, the data which has been read is set in the area
;		indicated by DMA.
;After readout, the random record field is automatically updated. After 
;executing this system call, the total number of records actually read is set 
;in the HL register. That is, if the end of file is reached before the 
;specified number of records have been read, the actual number of records read 
;will be returned in the HL register.	

LoadDone:
		scf ;(No Error, so set the carry flag
		ret
		
diskerr:
		call Bankswapper_FullRam
		or a	;Clear the carry flag on error
		ret

clearfcb:
		ld	bc,24
		ld	hl,FCBEND
		ld	de,FCBEND+1
		ld	(hl),0
		ldir
		ret

; Set record size, and reset the current record no
; This must be called after the OPEN!
resetfcb:
; record size 1 byte
		ld	hl,1
		ld	(FCB+14),hl
; reset current record
		ld	hl,0
		ld	(FCB+33),hl
		ld	(FCB+35),hl
		ret

blheader:
signature:	defb	0
blstart:	defw	0
blend:		defw	0
blrun:		defw	0
	
FCB:	defb	0
	;        12345678ABC
FNAME:	defb	"           "	
FCB_CurrentBlock: defw &0000
FCB_RecordSize: defw &0000
FCB_FileSize: 	defw &0000
		defw &0000
FCB_DATE:	defw &0000
FCB_Time:	defw &0000
FCB_DeviceID:	defb &00
FCB_DirectoryLoc:	defb &00
FCB_TopCluster:	defw &0000
FCB_LastCluster:defw &0000
FCB_RelCluster:defw &0000
FCB_CurrentRec:defb &00
FCB_RandomRecord:defw &0000
		 defw &0000
FCBEND:					;Need 24 bytes of space here for some reason!??

	;Disk buffer info
DiskReader_Buffersize equ &80
DiskBuffer:Defs 128
DiskBuffer_End:

	;Transfer data from the DiskBuffer to the actual location
DiskReader_LoadProcessor:
			ld de,&0000:FileDestination_Plus2
			ldir
			ld (FileDestination_Plus2-2),de
	ret

