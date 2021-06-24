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
	ifdef BuildCLX
TileWidth3 equ 1
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
	ifdef BuildZXS
	push bc
	push af
	endif
		ld de,RawBitmap
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
		
		ifdef TileWidth3
			ex de,hl
			add hl,de
			rl e
			rl d
			add hl,de
			ex de,hl
		else 
			add hl,de
			ex de,hl
		endif
		
		;push hl	;&80
		;call Monitor_PushedRegister
		
		
		
		
		
		call GetScreenPos				;Get Screen pos from BC
	
	
	
		ifdef TileWidth2				;No of bytes per tile
			ex de,hl
			ldi
			ldi		
			call GetNextLineFast
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			call GetNextLineFast
		endif
		ifdef TileWidth1
			ex de,hl
			ldi
			call GetNextLineFast
			ldi
			call GetNextLineFast
			ldi
			call GetNextLineFast
			ldi
			call GetNextLineFast
			ldi
			call GetNextLineFast
			ldi
			call GetNextLineFast
			ldi
			call GetNextLineFast
			ldi
			call GetNextLineFast
		endif
		ifdef TileWidth4
			ex de,hl
			ldi
			ldi
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			ldi
			ldi
			call GetNextLineFast
			ldi
			ldi
			ldi
			ldi
			call GetNextLineFast
		endif
	ifdef BuildCLX
		;ld ixh,1
	;	ld ixl,8
	;	ex de,hl
		;ld iyl,e
		;ld iyh,d
		;ld b,0
		ex de,hl
		ld c,&20
		ld b,%11100000
		
ShowBitmapAgain:
		 exx
			ld a,&28
			ld bc,&0080
			out (c),a
			ld a,03
			ld bc,&FFFF
			out (c),a
		 exx
CamBmpTileA:		 
		 ld a,(de)
		 ld (hl),a
		 inc de
		 ld a,c
		 add l
		 ld l,a
		 and b
		 jr nz,CamBmpTileA
		  set 6,h
CamBmpTileB:		 
		 ld a,(de)
		 ld (hl),a
		 inc de
		 ld a,c
		 add l
		 ld l,a
		 and b
		 jr nz,CamBmpTileB
		 exx
			ld a,05
		;	ld bc,&FFFF
			out (c),a
			ld a,&24
			ld bc,&0080
			out (c),a
		 exx
		 
CamBmpTileC:	
		 ld a,(de)
		 ld (hl),a
		 inc de
		 ld a,c
		 add l
		 ld l,a
		 and b
		 jr nz,CamBmpTileC
		 exx
			xor a
	;		ld bc,&0080
			out (c),a
			ld bc,&FFFF
			out (c),a
		 exx
		ret
	endif

	ifdef BuildZXS
	pop af	
	pop bc
	endif
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

	ifdef BuildMSX_MSX1	;**** Deprecated - re-enable PUSHPOPS if you want this!
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	ifdef BuildMSX_MSX1VDP				;MSX1 hardware tilemap
ShowTile:	;A=Tilenum, BC=XYpos
		push af
			call GetVDPScreenPos
		pop af
		add 128
		out (VdpOut_Data),a
		ret
	endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
	
	
	