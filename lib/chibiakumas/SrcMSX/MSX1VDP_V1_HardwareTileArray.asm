FillAreaWithTiles:		;Fill an area with consecutively numbered tiles, so we can simulate a bitmap area
						;BC = X,Y
						;HL = W,H
						;DE = Start Tile	
	ld a,h
	add b
	ld h,a
	
	ld a,l
	add c
	ld l,a
FillAreaWithTiles_Yagain:
	push bc
		push de
		push hl
			call GetVDPScreenPos
		pop hl
		pop de
			
FillAreaWithTiles_Xagain:
		ld a,e
		out (VdpOut_Data),a
		inc e
		inc b
		ld a,b
		cp h
		jr nz,FillAreaWithTiles_Xagain
	pop bc

	inc c
	ld a,c
	cp l
	jr nz,FillAreaWithTiles_Yagain

	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
					;Write Tile data to Vram
					;Tile patterns start at &0000 - each tile is 8 bytes... we have 256 available.
					;In theory, The tilemap supports 768 tiles, the first 1/3rd for the top part of the screen,
					;The 2nd for the middle, and 3rd for the bottom... we use it to fake a bitmap mode, but it's slow, so we're not using it here.
DefineTiles:		;BC=Bytecount, HL=source, DE=Destination
	push bc
		ex de,hl
		call prepareVram
		ex de,hl
	pop bc
DefineTiles2:
	ld a,(hl)
	out (VdpOut_Data),a
	inc hl
	dec bc
	ld a,b
	or c
	jp nz,DefineTiles2
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetVDPScreenPos:	;Move the VDP write pointer to a memory location by XY location
	push bc			;B=Xpos (0-31), C=Ypos (0-23)
		ld h,0
		ld l,c
		or a
		rl l		;32 bytes per line, so shift L left 5 times, and push any overflow into H
		rl h
		rl l
		rl h
		rl l
		rl h
		rl l
		rl h
		rl l
		rl h
		ld a,l
		or b	;Or in the X co-ordinate
		ld l,a
		ld a,h
		or &18	;Tilemap starts at &1800
		ld h,a
		call VDP_SetWriteAddress
	pop bc
	ret
	
	