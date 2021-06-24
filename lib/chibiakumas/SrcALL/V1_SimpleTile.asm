	ifdef BuildCPC
TileWidth2 equ 1
	endif
	ifdef BuildENT
TileWidth2 equ 1
	endif
	ifdef BuildSAM
TileWidth4 equ 1
	endif
	ifdef BuildZXS
TileWidth1 equ 1
	endif
	ifdef BuildTI8
TileWidth1 equ 1
	endif
	
	ifdef BuildMSX
	ifdef BuildMSX_MSX1
TileWidth1 equ 1
	else
TileWidth4 equ 1
	endif
	endif
	ifdef BuildSxx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ShowTile:	;A=Tilenum, BC=XYpos	
		push af
			call GetVDPScreenPos
		pop af
		add 128
		out (vdpData),a
		ld a,0
		out (vdpData),a
		
		
		ret
	endif
	ifdef BuildGBx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ShowTile:	;A=Tilenum, BC=XYpos	
		push af
			ld d,0
			ld e,a
			ld hl,RawPalettes
			add hl,de
			ld d,(hl)
			push de
				call GetVDPScreenPos
			pop de
		pop af
		
		
		add 128
		ld (hl),a
		
		ifdef BuildGBC
			ld a,1			;Turn on GBC extras
			ld (&FF4F),a	
			ld (hl),d
			ld a,0			;Turn off GBC extras
			ld (&FF4F),a	
		endif
		ret
	endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ifndef BuildCONSOLE
	
ShowTile:	;A=Tilenum, BC=XYpos
	ifdef TileWidth2
		rlc b							;Convert Xpos to byte position
	endif
	ifdef TileWidth4
		rlc b
		rlc b
	endif

	rlc c								;Convert 8x8 tile Ypos to line
	rlc c
	rlc c
	
	push bc
	push af
		ld h,0
		ld l,a
		or a

		rl l						;Convert Tilenumber to memory location
		rl h
		rl l
		rl h
		rl l
		rl h
		ifdef TileWidth2
			rl l
			rl h
		endif

		ifdef TileWidth4
			rl l
			rl h
			rl l
			rl h
		endif

		
		;push hl	;&80
		;call Monitor_PushedRegister
		
		ld de,RawBitmap
		add hl,de
		ex de,hl
		call GetScreenPos				;Get Screen pos from BC
		ld c,8
	AgainY:
		ifdef TileWidth2				;No of bytes per tile
			ld b,8/4
		endif
		ifdef TileWidth1
			ld b,8/8
		endif
		ifdef TileWidth4
			ld b,8/2
		endif
		
	AgainX:
			ld a,(de)
			SetScrByte a
			inc de
			djnz AgainX
			
			call GetNextLine

		dec c
		jp nz,AgainY
	pop af	
	pop bc

	ifdef BuildZXS						;Apply the Spectrum palette
		ld hl,RawPalettes
		ld d,0
		ld e,a
		add hl,de
		ld a,(hl)
		push af
			call GetColMemPos
		pop af
		ld (hl),a						
	endif

	ifdef BuildMSX_MSX1
		ld hl,RawPalettes				;Apply the MSX1 palette
		ld d,0
		ld e,a
		or a 							;Clear Carry Flag
		rl d
		rl e
		rl d
		rl e
		rl d
		rl e
		
		add hl,de
		push hl
			call GetColMemPos
		pop hl
		ld b,8							;MSX1 palette uses 8 lines
MSXPalAgain:
		ld a,(hl)
		inc hl
		out (VdpOut_Data),a
		djnz MSXPalAgain
	endif

	ret
	else
	ifdef BuildMSX_MSX1VDP				;MSX1 hardware tilemap
ShowTile:	;A=Tilenum, BC=XYpos
		push af
			call GetVDPScreenPos
		pop af
		add 128
		out (VdpOut_Data),a
		ret
	endif
	ifdef  BuildMSX_MSXVDP
ShowTile:	
			push bc						;MSX2 VDP BLIT tilemap
			push de
			push hl
				ld d,b
				ld e,c
				ld h,0
				add 128
				ld l,a
				call CopyTileToScreen
			pop hl
			pop de
			pop bc
		ret
	endif
	ifdef  V9K
		ifdef BuildCPC
ShowTile:	
			push bc						;CPC V9K Blit tilemap *UNTESTED* 
			push de
			push hl
				ld d,b
				ld e,c
				ld h,0
				add 128
				ld l,a
				call CopyTileToScreen
			pop hl
			pop de
			pop bc
		ret
		endif
	endif
	endif
	
	
	