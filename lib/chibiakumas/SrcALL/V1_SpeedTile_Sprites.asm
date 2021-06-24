;Virtual co-ords are in 2 pixel units
;first visible co-ord is 64,80
;Screen size is 128x96 (256 pixels x 192 pixels)
;Last visible co-ord is 192,176

;Least significant bit is unused on CPC (allows for 2 pixel accurate co-ordinates) 
;Co-ord format: %TTTTTTHQ T=Tile (ZXS) H=Half Tile (CPC) Q=Quarter (SAM)
;Cpc works in 4 pixel blocks... Sam in 2 pixel... Speccy in whole blocks

VscreenMinX equ 64		;Top left of visible screen in logical co-ordinates
VscreenMinY equ 80

VscreenWid equ 128		;Screen Size in logical units
VscreenHei equ 96

	ifdef BuildCPC
VscreenWidClip equ 2
VscreenHeiClip equ 2	;Don't try to draw on last strip of screen
	endif

	ifdef BuildSAM
VscreenWidClip equ 3
VscreenHeiClip equ 3
	endif

	ifdef BuildZXS
VscreenWidClip equ 0	;No half tile draws, so no clip needed
VscreenHeiClip equ 0
	endif
	
	ifdef BuildSxx
VscreenWidClip equ 0	;No half tile draws, so no clip needed
VscreenHeiClip equ 0
	endif
	
DrawSprite:
	exx
		ld d,0			;Marker for if any cropping occured
	exx

	ld ix,0
	ld iy,0

;Crop Left hand side
	ld a,b
	sub VscreenMinX 	;64 = Leftmost visible tile
	jr nc,NoLCrop
	and %11111100		;Tiles used for Cop
	neg

	srl a
	srl a
	cp h				;No pixels onscreen?
	ret nc				;Offscreen
	exx
	inc d				;CroppedMarker
	exx
	ld ixl,a
	ld a,b
	and %00000011		;Keep Half Tile Bit
NoLCrop:

;Crop Right hand side
	ld b,a
	add h				;4 logical units per tile
	add h		
	add h				;4 logical units per tile
	add h		
	sub VscreenWid-VscreenWidClip	;Logical Width of screen
	jr c,NoRCrop
	srl a
	srl a
	cp h				;No pixels onscreen?
	ret nc				;Offscreen
	ld ixh,a
	exx
	inc d				;CroppedMarker
	exx
NoRCrop:
	
;Crop Top of screen
	ld a,c
	sub VscreenMinY	;Topmost visible tile		;Add 4 to fix SMS top line
	jr nc,NoTCrop
	and %11111100
	neg
	srl a
	srl a
	cp l			;No pixels onscreen?
	ret nc			;Offscreen
	exx
	inc d			;CroppedMarker
	exx
	ld iyl,a
	ld a,c
	and %00000011	;Keep Half Tile Bit
NoTCrop:

;Crop Bottom of screen
	ld c,a
	add l			;4 logical units per tile
	add l
	add l			;4 logical units per tile
	add l
	sub VscreenHei-VscreenHeiClip	;Logical Height of screen
	jr c,NoBCrop
	srl a
	srl a
	cp l			;No pixels onscreen?
	ret nc			;Offscreen
	exx
	inc d			;CroppedMarker
	exx
	ld iyh,a
NoBCrop:	

	exx
	ld a,d			;Check Crop Marker

;Jump here for uncropped sprite! (no logical co-ords

	ld hl,0
	ld (TileYUnused_Plus2-2),hl	;Set Yskip tiles

	exx
	or a
	call nz,CropSprite	;Crop Sprite
	
	ifdef HSpriteLimit
		push bc
			ld a,(HSpriteNum)
			ld b,l						;Columns
AddHspritesAgain:		
			add h						;Sprites per row
			djnz AddHspritesAgain
		pop bc
		
		cp HSpriteLimit				;Are there enough hardware sprites left?
		jp c,UseHTileSprites		;If so use them!
	endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; We're using software/tiles
	
	push de
		push hl
		;Calculate VRAM pos into DE from XY in BC

		ifdef BuildSAM	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			ld a,C	
			and %01111111 	; -YYYYY-- --------
			ld h,a
			xor a
			ld l,a
		
			ld a,(ActiveBank)	;Add the screen Base 
			ld d,a

			ld e,B		;Add the X pos 
			add hl,de
			ex de,hl
		endif 			
			
		ifdef BuildSxx	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			ld a,C	
			and %01111100 	; -YYYYY-- --------
			ld h,a
			xor a
			srl h		; --YYYYY- --------
			rra
			srl h		; ---YYYYY --------
			rra
			srl h		; ----YYYY Y-------
			rra
			srl h		; -----YYY YY------
			rra
			ld l,a
		
			ld a,(ActiveBank)	;Add the screen Base 
			ld d,a

			ld a,B		;Add the X pos 
			and %11111100
			rra			;don't want Unused Bottom Bit
			ld e,a
			add hl,de
			ex de,hl
		endif 			
			
		ifdef BuildCPC	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			ld a,C	
			and %01111100 	; -YYYYY-- --------
			ld h,a
			xor a
			srl h		; --YYYYY- --------
			rra
			srl h		; ---YYYYY --------
			rra
			srl h		; ----YYYY Y-------
			rra
			srl h		; -----YYY YY------
			rra
			ld l,a
		
			ld a,(ActiveBank)	;Add the screen Base 
			ld d,a

			ld e,B		;Add the X pos 
			srl e		;Unused Bottom Bit
			add hl,de
			ex de,hl
		endif 	
			
		ifdef BuildZXS
			;	-0 -1 -0 Y7 Y6 Y2 Y1 Y0   Y5 Y4 Y3 X4 X3 X2 X1 X0
			
			ld a,c
			sll a
			;	 76543210
			and %00111000	;Main 3 Bits of Xpos
			rlca
			rlca
			srl b			;Ditch Two bits of Xpos 
			srl b
			or b
			ld e,a

			ld a,(ActiveBank)	;Screen Base ($C000)
			ld d,a
			ld a,c
			sll a
			
			;	 76543210
			and %11000000		;Top 2 bits of Ypos
			rrca
			rrca
			rrca
			or d
			ld d,a
		
		endif 
			
		pop hl	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		ld ixl,e	;Screen mem L 
		ld ixh,d	;Screen mem H 

		push hl		
		pop iy		;IXH=Width in Tiles ;IYL=Height in tiles 
		

	ifndef DisableShifts	
		bit 1,c
		jr nz,DrawSpriteAlt	;Vshift 4 lines
	endif

	pop de
		jp DrawTiles		;User sprite routine to draw sprite

	ifndef DisableShifts	
DrawSpriteAlt:			;Shifted 4 lines down
		ld a,d
		add 32		;Screen mem H + 4 lines
		ld ixh,a

	pop de
	ld hl,(TileYUnused_Plus2-2)	;Set Spacer for ALT code
	ld (TileYUnusedB_Plus2-2),hl

	jp DrawTilesAlt
	endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We're using hardware sprites - woo!	
	ifdef HSpriteLimit
		
UseHTileSprites:
		push de
			push hl
			;Calculate Sprite XY pos

			ifdef BuildSxx	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
				ld a,C	
				rlca
				;sub 6		;Sub 6 to fix SMS top line
				ld d,a	;Y position  (in pixels)
							
				ld e,B	;X position (in 2 pixel pairs)
			endif 		
			pop hl	

			ld ixl,e	;Ypos of first sprite
			ld ixh,d	;Xpos of first sprite
			
			push hl		
			pop iy		;IXH=Width in sprites ;IYL=Height in sprites
		pop de
		jp DrawTilesSprite		;Use Hardware sprite routine.
	endif
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Sprite Clipping routine

	;ld ixl,0	;Remove from Left
	;ld iyl,0	;Remove From Top	
	;ld ixh,0	;Remove From Right
	;ld iyh,0	;Remove from Bottom

CropSprite:

;Check Left hand side
	ld a,ixl
	or a 
	jr z,NoXCrop
	push hl
		ld h,0
		sla l		;2 bytes per Title
		ex de,hl
CropXAgain:
		add hl,de	;Remove 1 strip of tiles from left
		dec a
		jr nz,CropXAgain
		ex de,hl
	pop hl
NoXCrop:	

;Check top side
	ld a,iyl
	or a 
	jr z,NoYCrop
	push hl
		ld h,0
		sla a		;Two bytes per tile
		ld l,a
		add hl,de	;Update Start address of tilemap
		ex de,hl
		ld h,0
	pop hl
NoYCrop:

;Check Bottom side
	;Update vertical skip for removed bottom lines
	push hl
		ld h,0
		ld a,iyh		
		add iyl
		ld l,a
		sla l
		ld (TileYUnused_Plus2-2),hl
	pop hl

	;Reduce Height
	ld a,l
	sub iyl		;StartY
	sub iyh		;RemoveY
	ld l,a		;New Height of sprite in tiles

;Check Right hand side - Reduce width as required
	ld a,h
	sub ixl		;StartY
	sub ixh		;RemoveY
	
	ld h,a		;New Width of sprite in tiles

	ret
