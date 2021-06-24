;The MSX 2 is NOT a tilemap based system, we have written functions using HMMC (write bytes) and HMMV (fast copy)
;to emulate a tile array.



DefineTiles:
CopyTilesToVdp:
	push de
	push bc
		ld a,(hl)
		push hl
			ld (Tile_MyHMMCByte),a		;Load in the first byte of the data to copy for writing to the VDP
			ld a,e
			and %00011111				;Get the Xpos, 32 tiles per 256 pixel line, so keep 5 bits
			rlca
			rlca
			rlca
			ld (Tile_MyHMMC_DX),a
			ld a,e
			and %11100000				;Get the Ypos, need to skip the first 5 bits,
			rr d						;Note we're only currently supporting MAX 256 tiles
			rr a
			rr d
			rr a
			ld (Tile_MyHMMC_DY),a		
			di							;Stop interrupts, and wait for the VDP to finish it's last job
			call VDP_FirmwareSafeWait	
			ld hl,Tile_MyHMMC			;Use the HMMC command to prep the writer for sending the data
			call VDP_HMMC_Generated
			ei
		pop hl
	pop bc
	pop de
	inc hl						;We wrote one byte already
	dec bc						;so alter HL and BC
CopyTilesToVdp_Again:		
	ld a,(hl)
	out (Vdp_SendByteData),a	;Copy all the other bytes to the area with OUTs
	inc hl
	dec bc
	ld a,b
	or c
	ret z
	ld a,c
	and %00011111
	jr nz,CopyTilesToVdp_Again					
	inc de				;We've finished a tile, so start the next one
	jp CopyTilesToVdp
	
Tile_MyHMMC:						;Tile definition command Vars 	
Tile_MyHMMC_DX:		defw &0000 		;DX 36,37		;Destination Xpos
Tile_MyHMMC_DY:		defw &0200 		;DY 38,39		;Tiles start 512 pixels down
Tile_MyHMMC_NX:		defw &0008 		;NX 40,41		;Width=8px
Tile_MyHMMC_NY:		defw &0008 		;NY 42,43		;Height=8px
Tile_MyHMMCByte:	defb 255   		;Color 44		;First byte to write goes here
					defb 0     		;Move 45		;Not used
					defb %11110000 	;Command 46	 	;HMMC command - Don't mess with this!

	
	
CopyBWTilesToVdp:		;HL=source,DE=XY dest (in 8x8 tiles),bc=bytes

	push de
	push bc
		ld b,(hl)		;Load in the first byte, and conver the first two pixels for the MSX screen
		xor a
		rl b
		rla
		rlca
		rlca
		rlca
		rl b
		rl a
		ld c,a
		rlca
		or c
		rlca
		or c
		rlca
		or c
		
		push hl
			ld (Tile_MyHMMCByte),a	;Store the first byte in the HMMC command
			
				ld a,e
				and %00011111				;Get the Xpos, 32 tiles per 256 pixel line, so keep 5 bits
				rlca
				rlca
				rlca
				ld (Tile_MyHMMC_DX),a
				ld a,e
				and %11100000				;Get the Ypos, need to skip the first 5 bits,
				rr d						;Note we're only currently supporting MAX 256 tiles
				rr a
				rr d
				rr a
				ld (Tile_MyHMMC_DY),a
			
			di							;Stop interrupts, and wait for the VDP to finish it's last job
			call VDP_FirmwareSafeWait	
			ld hl,Tile_MyHMMC			;Use the HMMC command to prep the writer for sending the data
			call VDP_HMMC_Generated
			ei

		pop hl
	pop bc
	
	push bc
			ld b,(hl)		
			rl b				;We've already processed the first 2 pixels 
			rl b				;with the HMMC command, so skip them here			
			jr CopyBWTilesToVdp_Again_MissOne
			
			
CopyBWTilesToVdp_Again:			
	push de
	push bc
			ld b,(hl)			;Convert the 2 pixel pairs to MSX format
			xor a
			rl b
			rla
			rlca
			rlca
			rlca
			rl b
			rl a
			ld c,a
			rlca
			or c
			rlca
			or c
			rlca
			or c
			out (Vdp_SendByteData),a	
CopyBWTilesToVdp_Again_MissOne:		
			xor a
			rl b
			rla
			rlca
			rlca
			rlca
			rl b
			rl a
			ld c,a
			rlca
			or c
			rlca
			or c
			rlca
			or c
			out (Vdp_SendByteData),a
			xor a
			rl b
			rla
			rlca
			rlca
			rlca
			rl b
			rl a
			ld c,a
			rlca
			or c
			rlca
			or c
			rlca
			or c
			out (Vdp_SendByteData),a
			xor a
			rl b
			rla
			rlca
			rlca
			rlca
			rl b
			rl a
			ld c,a
			rlca
			or c
			rlca
			or c
			rlca
			or c
			out (Vdp_SendByteData),a
	pop bc
	pop de
	inc hl
	dec bc
	ld a,b
	or c
	ret z
	
	
	ld a,c
	and %00000111
	jr z,CopyBWTilesToVdp_NextTile

	jp CopyBWTilesToVdp_Again
CopyBWTilesToVdp_NextTile:
	inc de
	jp CopyBWTilesToVdp


CopyTileToScreen:	;HL=Tilenum -> DE=XY
	ld a,L					;Workout tile memory position from tilenum
	and %00011111			;32 tiles per line
	rlca
	rlca
	rlca
	ld (Tile_MyHMMM_SX),a	;Source tile position X
	ld a,l
	and %11100000			;Tile line num
	rr h
	rr a
	rr h
	rr a
	ld (Tile_MyHMMM_SY),a	;Source tile position Y

	ld a,d					;Tiles are 8*8
	rlca					;multiply up to convert tile co-ord to pixel
	rlca
	rlca
	ld (Tile_MyHMMM_DX),a	;Store Xpos
	
	ld a,e					;Tiles are 8*8
	rlca					;multiply up to convert tile co-ord to pixel
	rlca
	rlca
	ld (Tile_MyHMMM_DY),a	;Store Ypos
	di
	call VDP_FirmwareSafeWait	
	ld hl,Tile_MyHMMM
	call VDP_HMMM			;Fastcopy an area of memory (Tile->screen)
	ei
	ret
	
Tile_MyHMMM:					;Tile Copy command Vars 	
Tile_MyHMMM_SX:	defw &0000 		;SY 32,33	;Destination Xpos
Tile_MyHMMM_SY:	defw &0200 		;SY 34,35	;Tiles start 512 pixels down
Tile_MyHMMM_DX:	defw &0000 		;DX 36,37	;Destination X
Tile_MyHMMM_DY:	defw &0000 		;DY 38,39	;Destination Y
Tile_MyHMMM_NX:	defw &0008 		;NX 40,41 	;Width=8px
Tile_MyHMMM_NY:	defw &0008 		;NY 42,43	;Height=8px
				defb 0     		;Color 44 	;unused
Tile_MyHMMM_MV:	defb 0     		;Move 45	;Unused
				defb %11010000 	;Command 46	;HMMM command - Don't mess with this 

	;BC = X,Y)
	;HL = W,H)
	;DE = Start Tile
FillAreaWithTiles:				;Used to get our bitmap onscreen
	ld a,h						;Offset HL with the start position
	add b
	ld h,a
	ld a,l
	add c
	ld l,a
FillAreaWithTiles_Yagain:
	push bc		
FillAreaWithTiles_Xagain:
		push bc
		push de
		push hl
			ld 	h,0
			ld  l,e							;Tilenum
			ld  d,b							;X
			ld  e,c							;Y
			call CopyTileToScreen			;Draw the tile to screen
		pop hl
		pop de
		pop bc
		inc de
		inc b
		ld a,b
		cp h
		jr nz,FillAreaWithTiles_Xagain
	pop bc
	inc c								;Start a new line
	ld a,c
	cp l
	jr nz,FillAreaWithTiles_Yagain
	ret
