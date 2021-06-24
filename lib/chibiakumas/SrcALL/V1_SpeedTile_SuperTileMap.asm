
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;update Logical Tilemap from Supertilemap and draw to screen

CalculateAndDrawTilemap:
	push de

		ld a,(IY+2)	;(VtileOffsetX)
		and %11110000
		cp (IY+4)	;(LastLTilemapX) - Get current Logical tilemap
		jr nz,SuperTileRefresh	;See if we need to alter logical tilemap contents

		ld a,(IY+0)	;(VtileOffsetY)
		and %11110000
		cp (IY+6)	;(LastLTilemapY)
		jr nz,SuperTileRefresh	

		jp NoSuperTileRefresh	;Current Logical Tilemap is OK
	
	;Copy a new area of the SuperTilemap to the Logical
	SuperTileRefresh:		
		ld (sprestoreB_Plus2-2),sp		;Back up SP

	;Calculate Y-offset in SuperTilemap
		ld a,(IY+0);(VtileOffsetY)
		and %11110000
		ld (IY+6),a;(LastLTilemapY)
		ld c,a
		ld b,0		;Stilemap is 16 tiles wide (Ypos*Wid)
		add ix,bc

	;Calculate X-offset in SuperTilemap
		ld a,(IY+2);(VtileOffsetX)
		and %11110000
		ld (IY+4),a;(LastLTilemapX)	
		
		ld b,0		;You'll need this for a larger supertilemap
		srl b		;One Byte per X tile
		rra
		srl b
		rra
		srl b
		rra
		srl b
		rra
		ld c,a
		add ix,bc
	
	pop de			;Get back Logical Tilemap Address
	push de
		exx
			ld c,LTilemapHeight/4	;Height of Logical tilemap
	TileTransferAgainD:
		exx
		ld (DeRestore_plus2-2),de	;Can't use stack later
		exx
			ld b,LTilemapWidth/4	;Width of Logical tilemap
	TileTransferAgainC:
		exx
			ld a,(ix)	;Get SuperTile Num
			inc ix

	;TileTransfer - Transfer Supertile A to TileMap address DE
			ld b,a		;Calc address of Supertile
			xor a
			srl b		;4x4 2 byte tiles per supertile	
			rra
			srl b
			rra
			srl b
			rra
			ld c,a
			ld hl,SuperTileDefs
			add hl,bc	;HL Contains Address of Supertile

			di
			ld sp,hl	;use SP to read from Supertile Def

			ex de,hl	;Get TileBuffer from DE into HL
			ld a,4
			ld bc,LTilemapHeight*2 -8+1	;Bytes to skip to move across 1 tile
			
	;Transfer 1 Column from Supertile to Locical Tilemap
	TileTransferAgain:
		pop de	
				ld (hl),e	
				inc hl
				ld (hl),d
				inc hl
				pop de
				ld (hl),e
				inc hl
				ld (hl),d
				inc hl
				pop de
				ld (hl),e
				inc hl
				ld (hl),d
				inc hl
				pop de
				ld (hl),e
				inc hl
				ld (hl),d
				add hl,bc	;Move right to next column in supertile
	TileTransferAgainB:
				dec a
				jp nz,TileTransferAgain

			ex de,hl 		;TileBuffer Pos into DE
		exx
		dec b				;Width of tilebuffer
		jr nz,TileTransferAgainC
		
		exx	
			;Restore DE (Logical Tilemap pos)
			ifdef DeRestore_plus2
				ld de,(DeRestore_plus2-2)		
			else
				ld de,0
	DeRestore_plus2:
			endif

			ld hl,8			;Bytes per supertile block
			add hl,de		;Move down Logical tilemap
			ex de,hl

			;Unused H supertiles
			ifdef vasm
				ld bc,((STilemapWidth*4) - LTilemapWidth) /4 
			else
				ld bc,STilemapWidth*4 - LTilemapWidth /4 
			endif
			add ix,bc		;Move to the next row of the Supertilemap
		exx
		dec c				;Height of tilebuffer
		jr nz,TileTransferAgainD	
		exx
		
	;Restore the stack		
		ifdef sprestoreB_Plus2
			ld sp,(sprestoreB_Plus2-2)
		else
			ld sp,0			
	sprestoreB_Plus2:
		endif


NoSuperTileRefresh:

;Caclulate Y offset in Logical tilemap for first visible tile
		ld a,(IY+0);(VtileOffsetY)
		and %00001100		;Bits for tilemap Y offset
		rra
		ld b,0
		ld c,a				;2 Bytes per Y Tile offset
		
	pop hl					;Get back logical tilemap Address
	
	add hl,bc				;Move Ypos

;Caclulate X offset in Logical tilemap for first visible tile
	
	ld b,0
	ld a,(IY+2);(VtileOffsetX)
	and %00001100			;Bits for tilemap X offset
	rlca	;%00011000
	rlca	;%00110000
	rlca	;%01100000
	rlca	;%11000000
	ld c,a					;64 bytes per X tile offset (32 tiles)
	add hl,bc				;Move Xpos
	
	ex de,hl		;DE Now contains top left corner of logical tilemap


	ld a,(IY+2);(VtileOffsetX)
	cpl	
	and %00000011			;Half/Quaeter X shift
	
	ld c,(IY+0);(VtileOffsetY) - Get Y shift
	
;This is only used by the CPC, 
;it deals with the annoying CPC screen layout		
	ifndef DisableShifts
		bit 1,c
		jp z,DrawTileMapAlt	;Alt version for half Y shift 
	endif 	
	jp DrawTileMap			;A=Xoffset / C=Yoffset

	