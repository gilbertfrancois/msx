Gbz80Macros equ 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_neg
		neg
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	macro z_ex_sphl
		ex (SP),HL
	endm
	macro z_ex_dehl
		ex de,hl
	endm
	macro z_ldir
		ldir
	endm
	macro z_ldi
		ldi
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_or_ixl
		or ixl
	endm
	macro z_or_ixh
		or ixh
	endm
	macro z_or_iyl
		or iyl
	endm
	macro z_or_iyh
		or iyh
	endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ifdef vasm
		macro z_ld_iy_plusn_a,aoffset
			ld (iy + \aoffset),a
		endm
		
		macro z_ld_iy_plusn_n,aoffset,aval
			ld (iy + \aoffset),\aval
		endm
		
		macro z_ld_iy_plusn_h,aoffset
			ld (iy + \aoffset),h
		endm
		macro z_ld_iy_plusn_l,aoffset
			ld (iy + \aoffset),l
		endm		
	else
		macro z_ld_iy_plusn_a aoffset
			ld (iy + aoffset),a
		endm
		
		macro z_ld_iy_plusn_n aoffset,aval
			ld (iy + aoffset),\aval
		endm
		
		macro z_ld_iy_plusn_h aoffset
			ld (iy + aoffset),h
		endm
		macro z_ld_iy_plusn_l aoffset
			ld (iy + aoffset),l
		endm		
	endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	macro z_halt
		halt
	endm	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ifndef vasm
		macro z_djnz addr
			djnz addr
		endm
	else 
		macro z_djnz,addr
			djnz \addr
		endm	
	endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_ld_a_r
		LD a,r
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	macro z_ld_a_iyl
		ld a,iyl
	endm
	macro z_ld_a_iyh
		ld a,iyh
	endm
	
	macro z_ld_a_ixl
		ld a,ixl
	endm
	macro z_ld_a_ixh
		ld a,ixh
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	macro z_ld_b_ixl
		ld b,ixl
	endm
	macro z_ld_c_ixl
		ld c,ixl
	endm
	macro z_ld_d_ixl
		ld d,ixl
	endm
	macro z_ld_e_ixl
		ld e,ixl
	endm
	macro z_ld_h_ixl
		ld h,ixl
	endm
	macro z_ld_l_ixl
		ld l,ixl
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	macro z_ld_b_ixh
		ld b,ixh
	endm
	macro z_ld_c_ixh
		ld c,ixh
	endm
	macro z_ld_d_ixh
		ld d,ixh
	endm
	macro z_ld_e_ixh
		ld e,ixh
	endm
	macro z_ld_h_ixh
		ld h,ixh
	endm
	macro z_ld_l_ixh
		ld l,ixh
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	macro z_ld_ixl_b
		ld ixl,b
	endm
	macro z_ld_ixl_c
		ld ixl,c
	endm
	macro z_ld_ixl_d
		ld ixl,d
	endm
	macro z_ld_ixl_e
		ld ixl,e
	endm
	macro z_ld_ixl_h
		ld ixl,h
	endm
	macro z_ld_ixl_l
		ld ixl,l
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	macro z_ld_ixh_b
		ld ixh,b
	endm
	macro z_ld_ixh_c
		ld ixh,c
	endm
	macro z_ld_ixh_d
		ld ixh,d
	endm
	macro z_ld_ixh_e
		ld ixh,e
	endm
	macro z_ld_ixh_h
		ld ixh,h
	endm
	macro z_ld_ixh_l
		ld ixh,l
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_ld_iyl_a
		ld iyl,a
	endm
	macro z_ld_iyh_a
		ld iyh,a
	endm
	
	macro z_ld_ixl_a
		ld ixl,a
	endm
	macro z_ld_ixh_a
		ld ixh,a
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_cp_iyl
		cp iyl
	endm
	macro z_cp_iyh
		cp iyh
	endm
	
	macro z_cp_ixl
		cp ixl
	endm
	macro z_cp_ixh
		cp ixh
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_dec_ixl
		dec ixl
	endm
	macro z_dec_ixh
		dec ixh
	endm
	macro z_dec_iyl
		dec iyl
	endm
	macro z_dec_iyh
		dec iyh
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_inc_ixl
		inc ixl
	endm
	macro z_inc_ixh
		inc ixh
	endm
	macro z_inc_iyl
		inc iyl
	endm
	macro z_inc_iyh
		inc iyh
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_inc_iy
		inc iy
	endm	
	macro z_dec_iy
		dec iy
	endm	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_inc_ix
		inc ix
	endm	
	macro z_dec_ix
		dec ix
	endm	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_sbc_hl_de
		sbc hl,de
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_sbc_hl_bc
		sbc hl,bc
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ifdef vasm
		macro z_ld_bc_from,addr
			ld bc,(\addr)
		endm
		macro z_ld_de_from,addr
			ld de,(\addr)
		endm
		macro z_ld_hl_from,addr
			ld hl,(\addr)
		endm
		macro z_ld_ix_from,addr
			ld ix,(\addr)
		endm
		macro z_ld_iy_from,addr
			ld iy,(\addr)
		endm
		
		macro z_ld_bc_to,addr
			ld (\addr),bc
		endm
		macro z_ld_de_to,addr
			ld (\addr),de
		endm
		macro z_ld_hl_to,addr
			ld (\addr),hl
		endm
		macro z_ld_ix_to,addr
			ld (\addr),ix
		endm
		macro z_ld_iy_to,addr
			ld (\addr),iy
		endm
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		macro z_ld_ix,valu
			ld ix,\valu
		endm
		macro z_ld_iy,valu
			ld iy,\valu
		endm
		macro z_ld_ixl,valu
			ld ixl,\valu
		endm
		macro z_ld_ixh,valu
			ld ixh,\valu
		endm
		macro z_ld_iyl,valu
			ld iyl,\valu
		endm
		macro z_ld_iyh,valu
			ld iyh,\valu
		endm
	else

		macro z_ld_bc_from addr
			ld bc,(\addr)
		endm
		macro z_ld_de_from addr
			ld de,(\addr)
		endm
		macro z_ld_hl_from addr
			ld hl,(\addr)
		endm
		macro z_ld_ix_from addr
			ld ix,(\addr)
		endm
		macro z_ld_iy_from addr
			ld iy,(\addr)
		endm
		macro z_ld_bc_to addr
			ld (\addr),bc
		endm
		macro z_ld_de_to addr
			ld (\addr),de
		endm
		macro z_ld_hl_to addr
			ld (\addr),hl
		endm
		macro z_ld_ix_to addr
			ld (\addr),ix
		endm
		macro z_ld_iy_to addr
			ld (\addr),iy
		endm
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		macro z_ld_ix valu
			ld ix,\valu
		endm
		macro z_ld_iy valu
			ld iy,\valu
		endm
		macro z_ld_ixl valu
			ld ixl,\valu
		endm
		macro z_ld_ixh valu
			ld ixh,\valu
		endm
		macro z_ld_iyl valu
			ld iyl,\valu
		endm
		macro z_ld_iyh valu
			ld iyh,\valu
		endm
	endif
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro gb_swap_a	
		rrca		;Z80 Equivalent of GBZ80 Swap command 
		rrca
		rrca
		rrca
	endm
	macro gb_swap_b
		rrc b
		rrc b
		rrc b
		rrc b
	endm
	macro gb_swap_c
		rrc c
		rrc c
		rrc c
		rrc c
	endm
	macro gb_swap_d
		rrc d
		rrc d
		rrc d
		rrc d
	endm
	macro gb_swap_e
		rrc e
		rrc e
		rrc e
		rrc e
	endm
	macro gb_swap_f
		rrc f
		rrc f
		rrc f
		rrc f
	endm
	macro gb_swap_h
		rrc h
		rrc h
		rrc h
		rrc h
	endm
	macro gb_swap_l
		rrc l
		rrc l
		rrc l
		rrc l
	endm
	macro gb_swap_hl
		rrc (hl)
		rrc (hl)
		rrc (hl)
		rrc (hl)
	endm
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_ex_af_afs
		ex af,af'
	endm
	macro z_exx
		exx
	endm
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; there seems to be a bug in VASM - it thinks the GBZ80 doesn't support SRL, but it does!
	macro z_srl_a
		srl a
	endm
	macro z_srl_h
		srl h
	endm
	
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_add_iy_de	; add iy,de
		add iy,de
	endm		
	macro z_add_ix_de	; add ix,de
		add ix,de
	endm	
	macro z_add_iy_bc	; add iy,bc
		add iy,bc
	endm		
	macro z_add_ix_bc	; add ix,bc
		add ix,bc
	endm	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	macro z_ld_iy_plusn_a,aoffset	;  LD (Iy+n),a
		ld (iy+\aoffset),a
	endm
	macro z_ld_ix_plusn_a,aoffset	; Fake LD (Ix+n),a
		ld (ix+\aoffset),a
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


		macro z_push_ix		;Push IX
			push ix
		endm
		
		macro z_pop_ix		;pop IX
			pop ix
		endm

		macro z_push_iy		;Push Iy
			push iy
		endm
		
		macro z_pop_iy		;pop Iy
			pop iy
		endm
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_ld_a_ix_plusn,aoffset	; ld a,(ix+n)
			ld a,(ix+\aoffset)
	endm		
	macro z_ld_b_ix_plusn,aoffset	; ld b,(ix+n)
			ld b,(ix+\aoffset)
	endm		
	macro z_ld_c_ix_plusn,aoffset	; ld b,(ix+n)
			ld c,(ix+\aoffset)
	endm		
	macro z_ld_d_ix_plusn,aoffset	; ld b,(ix+n)
			ld d,(ix+\aoffset)
	endm		
	macro z_ld_e_ix_plusn,aoffset	; ld b,(ix+n)
			ld e,(ix+\aoffset)
	endm		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	macro z_ld_ix_plusn_a,aoffset	;ld (ix+n),a
			ld (ix+\aoffset),a
	endm
	macro z_ld_ix_plusn_b,aoffset	;ld (ix+n),a
			ld (ix+\aoffset),b
	endm
	macro z_ld_ix_plusn_c,aoffset	;ld (ix+n),a
			ld (ix+\aoffset),c
	endm
	macro z_ld_ix_plusn_d,aoffset	;ld (ix+n),a
			ld (ix+\aoffset),d
	endm
	macro z_ld_ix_plusn_e,aoffset	;ld (ix+n),a
			ld (ix+\aoffset),e
	endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	macro z_ld_c_iyl	;ld c,iyl
		ld c,iyl
	endm
	macro z_ld_c_iyh	;ld c,iyh
		ld c,iyh
	endm
	macro z_ld_c_ixl	;ld c,ixl
		ld c,ixl
	endm
	macro z_ld_c_ixh	;ld c,ixh
		ld c,ixh
	endm
	macro z_ld_iyl_c	;ld iyl,c
		ld iyl,c
	endm
	macro z_ld_iyh_c	;ld iyh,c
		ld iyh,c
	endm
	macro z_ld_ixl_c	;ld ixl,c
		ld ixl,c
	endm
	macro z_ld_ixh_c	;ld ixh,c
		ld ixh,c
	endm
	
	
	macro z_ld_b_iyl	;ld c,iyl
		ld b,iyl
	endm
	macro z_ld_b_iyh	;ld c,iyh
		ld b,iyh
	endm
	macro z_ld_b_ixl	;ld c,ixl
		ld b,ixl
	endm
	macro z_ld_b_ixh	;ld c,ixh
		ld b,ixh
	endm
	macro z_ld_iyl_b	;ld iyl,c
		ld iyl,b
	endm
	macro z_ld_iyh_b	;ld iyh,c
		ld iyh,b
	endm
	macro z_ld_ixl_b	;ld ixl,c
		ld ixl,b
	endm
	macro z_ld_ixh_b	;ld ixh,c
		ld ixh,b
	endm
	
	
	macro z_ld_e_iyl	;ld e,iyl
		ld e,iyl
	endm
	macro z_ld_e_iyh	;ld e,iyh
		ld e,iyh
	endm
	macro z_ld_e_ixl	;ld e,ixl
		ld e,ixl
	endm
	macro z_ld_e_ixh	;ld e,ixh
		ld e,ixh
	endm
	macro z_ld_iyl_e	;ld iyl,e
		ld iyl,e
	endm
	macro z_ld_iyh_e	;ld iyh,e
		ld iyh,e
	endm
	macro z_ld_ixl_e	;ld ixl,e
		ld ixl,e
	endm
	macro z_ld_ixh_e	;ld ixh,e
		ld ixh,e
	endm
	
	
	macro z_ld_d_iyl	;ld e,iyl
		ld d,iyl
	endm
	macro z_ld_d_iyh	;ld e,iyh
		ld d,iyh
	endm
	macro z_ld_d_ixl	;ld e,ixl
		ld d,ixl
	endm
	macro z_ld_d_ixh	;ld e,ixh
		ld d,ixh
	endm
	macro z_ld_iyl_d	;ld iyl,e
		ld iyl,d
	endm
	macro z_ld_iyh_d	;ld iyh,e
		ld iyh,d
	endm
	macro z_ld_ixl_d	;ld ixl,e
		ld ixl,d
	endm
	macro z_ld_ixh_d	;ld ixh,e
		ld ixh,d
	endm
	
	
	macro z_bit0_iy_plusn,aoffset	; bit n,(iy+n)
		bit 0,(iy+\aoffset)
	endm		
	macro z_bit0_ix_plusn,aoffset	; bit n,(ix+n)
		bit 0,(ix+\aoffset)
	endm		
	
	