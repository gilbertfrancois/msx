    ; GLOBAL _f16_add
    ; GLOBAL _f16_sub
    ; GLOBAL _f16_mul
    ; GLOBAL _f16_div
    ; GLOBAL _f16_int
    ; GLOBAL _f16_neg
    ; GLOBAL _f16_from_int

    ; GLOBAL _f16_add_hl_de
    ; GLOBAL _f16_sub_hl_de
    ; GLOBAL _f16_mul_hl_de
    ; GLOBAL _f16_div_hl_de
    ; GLOBAL _f16_int_hl
    ; GLOBAL _f16_neg_hl
    ; GLOBAL _f16_from_int_dehl

    ; GLOBAL _f16_gt_hl_de
    ; GLOBAL _f16_gte_hl_de
    ; GLOBAL _f16_lt_hl_de
    ; GLOBAL _f16_lte_hl_de
    ; GLOBAL _f16_eq_hl_de
    ; GLOBAL _f16_neq_hl_de

    ; GLOBAL _f16_gt
    ; GLOBAL _f16_gte
    ; GLOBAL _f16_lt
    ; GLOBAL _f16_lte
    ; GLOBAL _f16_eq
    ; GLOBAL _f16_neq




    ; SECTION code_compiler

_f16_add:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_add_hl_de:
    ld a, h
    xor d
    and $80
    jr z, fast_add_do_add
    xor d
    ld d, a
    jp _f16_sub_hl_de
fast_add_do_add:
    ld a, $80
    and h
    ex af, af'  ; push af; save sign in AF'
    res 7, d
    res 7, h
    ld a, l
    sub e
    ld a, h
    ; sbc d
    sbc a,  d
    jr nc, fast_add_noswap
    ex de, hl
fast_add_noswap:
    ld c, $7C
    ld a, c
    and d
    cp c
    jp z, add_handle_nan_or_inf
    ld b, a ; bx in b
    ld a, h
    and c
    cp c
    jp z, add_handle_nan_or_inf
    sub b
    jr z, fast_add_diff_0
    rra  ; carry is reset due to 
    rra  ; low bits are zero so no problem
    ld c, a ; c=shift
    ld a, b ; 
    or a 
    jr z,  fast_add_bx_is_zero
    ld a, d
    and 3
    or 4
    ld d, a
    ld b, c
fast_add_shift_a:
    sra d
    rr e
    djnz fast_add_shift_a
    jr fast_add_actual_add
fast_add_bx_is_zero:
    dec c
    jr z, fast_add_actual_add
    ld b, c
fast_add_shift_b:
    sra d
    rr e
    djnz fast_add_shift_b
    jr fast_add_actual_add
fast_add_diff_0:
    ld a, b
    or a
    jr nz, fast_add_bx_not_zero_diff_zero
    add hl, de
    ex af, af'
    ; or a, h
    or h
    ld h, a
    ret
fast_add_bx_not_zero_diff_zero:
    ld a, d
    and 3
    or 4
    ld d, a
fast_add_actual_add: 
    ld b, h  ; save hl
    ld c, l
    add hl, de  ; compare (hl+de) & $7c00 == $7c00 & hl stored in bc
    ld a, b
    xor h
    and $7C
    jr nz, fast_add_update_exp 
    ex af, af'
    ; or a, h
    or h
    ld h, a
    ret
fast_add_update_exp:
    ld a, b
    and 3
    or 4
    ld h, a
    ld l, c
    add hl, de
    sra h
    rr l
    res 2, h
    ld a, b
    and $7C
    add a, 4
    ld b, a
    and $7C
    cp $7C
    jp z, handle_inf
    ex af, af'
    or b
    or h
    ld h, a
    ret
add_handle_nan_or_inf:
    ld c, $7c
    ld a, h
    cp c
    jr c, add_a_not_inv
    xor c
    or l
    jp nz, handle_nan
add_a_not_inv:
    ld a, d
    cp c
    jr c, add_b_not_inv
    xor c
    or e
    jp nz, handle_nan
add_b_not_inv:
    jp handle_inf


    

_f16_sub:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_sub_hl_de:
    ld a, h
    xor d
    and $80
    jr z, fast_sub_do_sub
    xor d
    ld d, a
    jp _f16_add_hl_de
fast_sub_do_sub:
    ld a, $80
    and h
    ex af, af' ; save sign in AF'
    res 7, d
    and a
    rl e
    rl d
    res 7, h
    and a
    rl l
    rl h  ; shift both by 1 bit
    ld a, l
    sub e
    ld a, h
    ; sbc d
    sbc a,  d
    jr nc, fast_sub_noswap
    ex de, hl
    ex af, af'
    xor $80
    ex af, af'
fast_sub_noswap:
    ld c, $F8
    ld a, c
    and d
    cp c
    jp z, sub_handle_nan_or_inf
    ld b, a ; bx in b
    ld a, h
    and c
    cp c
    jr z, sub_handle_nan_or_inf
    sub b
    jr z, fast_sub_diff_0

    rra  ; carry is reset due to 
    rra  ; low bits are zero so no problem
    rra 

    ld c, a ; c=shift
    ld a, b ; 
    or a 
    jr z,  fast_sub_bx_is_zero
    ld a, d
    and 7
    or 8
    ld d, a
    ld b, c
fast_sub_shift_a:
    sra d
    rr e
    djnz fast_sub_shift_a
    jr fast_sub_actual_sub
fast_sub_bx_is_zero:
    dec c
    jr z, fast_sub_actual_sub
    ld b, c
fast_sub_shift_b:
    sra d
    rr e
    djnz fast_sub_shift_b
    jr fast_sub_actual_sub
fast_sub_diff_0:        
    ld a, b
    or a
    jr nz, fast_sub_bx_not_zero_diff_zero
    sbc hl, de
    jr fast_sub_shift_add_sign_and_ret
fast_sub_bx_not_zero_diff_zero:
    ld a, d
    and 7
    or 8
    ld d, a
fast_sub_actual_sub: 
    ld b, h  ; save hl
    ld c, l
    and a ; reset carry
    sbc hl, de
    ; compare (hl-de) & $f800 == $f800 & hl stored in bc
    ld a, b
    xor h
    and $f8
    jr z, fast_sub_shift_add_sign_and_ret
    
    ld a, b
    and 7
    or 8
    ld h, a
    ld l, c
    sbc hl, de
    jr z, fast_sub_shift_add_sign_and_ret
    ld a, $F8
    and b
    jr z, fast_sub_break_shift_loop
fast_sub_shift_loop:
    bit 3, h
    jr nz, fast_sub_break_shift_loop
    ; sub a, 8
    sub 8
    jr z, fast_sub_break_shift_loop
    add hl, hl
    jr fast_sub_shift_loop
fast_sub_break_shift_loop:
    res 3, h
    or h
    ld h, a
fast_sub_shift_add_sign_and_ret:
    and a ; reset C
    rr h
    rr l 
    ld a, h ; check for 0 - make sure not to return -0
    or l
    ret z
    ex af, af'
    ; or a, h
    or h
    ld h, a
    ret
sub_handle_nan_or_inf:
    ld c, $F8
    ld a, h
    cp c
    jr c, sub_a_not_inv
    xor c
    or l
    jr nz, handle_nan
sub_a_not_inv:
    ld a, d
    cp c
    jr c, handle_inf
    xor c
    or e
    jr nz, handle_nan ;
    sbc hl, de ; check if both are inf
    jr z, handle_nan 
    and a
    add hl, de
    ld a, h
    xor c
    or l
    jr z, handle_inf
    ex af, af'
    xor $80
    ex af, af'
    jr handle_inf


handle_nan:
    ld hl, $7FFF
    ret
handle_inf:
    ld hl, $7C00
    ex af, af'
    or h
    ld h, a
    ret



_f16_mul:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_mul_hl_de:
    call calc_ax_bx_mantissa_and_sign
    jr z, mul_handle_nan_inf
    ; add b   ; new_exp = ax + bx - 15
    add a, b   ; new_exp = ax + bx - 15
    sub 15
    exx 
    ld c, a ; save exp in bc'
    exx
    ld a, h
    or l
    ret z
    ex de, hl
    ld a, h
    or l
    ret z
    call mpl_11_bit  ; de/hl = m1*m2
    exx
    ld a, c
    exx 
    bit 5, e                      ; if v >=2048: m>>11,  exp++
    jr nz, fmul_exp_inc_shift_11
    bit 4, e
    jr nz, fmul_shift_10         ; if v>=1024: m>>10
    jr fmul_handle_denormals    ; check denormals
fmul_exp_inc_shift_11:
    inc a
    sra e
    rr h
    rr l
fmul_shift_10:
    sra e
    rr h
    rr l
    sra e
    rr h
    rr l
    ld l, h ; ehl >> 8
    ld h, e
    ld e, 0
    jr fmul_check_exponent
fmul_handle_denormals:
    sub 10
    ld c, a
    ld b, $f8
fmul_next_shift:    ; while ehl >= 2048
    ld a, h
    and b
    or e
    jr z, fmul_shift_loop_end
    sra e           ; ehl >> = 1,  exp++
    rr h
    rr l
    inc c
    jr fmul_next_shift
fmul_shift_loop_end:
    ld a, c      ; restre exp
fmul_check_exponent:
    ld b, 1
    and a
    jr z, fmul_denorm_shift
    bit 7, a
    jp z, final_combine
    neg 
    add a, b
    ld b, a
    xor a
fmul_denorm_shift:
    sra e
    rr h
    rr l
    djnz fmul_denorm_shift
final_combine:              
    cp 31
    jr nc,  handle_inf
    add a
    add a 
    res 2, h ; remove hidden bit
    or h
    ld h, a
    or $7F         ; reset -0 to normal 0
    or l
    ret z
    ex af, af' ; restore sign
    or h
    ld h, a
    ret
mul_handle_nan_inf:
    cp 31
    jr nz, mul_a_is_valid
    ld a, 4
    xor h
    or l
    jp nz, handle_nan ; exp=31 and mant!=0
mul_a_is_valid:
    ld a, b
    cp 31
    jr nz, mul_b_is_valid
    ld a, 4
    xor d
    or e
    jp nz, handle_nan ; exp=31 and mant!=0
mul_b_is_valid:
    ld a, h
    or l
    jp z, handle_nan
    ld a, d
    or e
    jp z, handle_nan
    jp handle_inf 
    

    ; input hl, de
    ; output 
    ;   a=ax = max(exp(hl), 1)
    ;   b=bx = max(exp(de), 1)
    ;   hl = mantissa(hl)
    ;   de = mantissa(de)
    ;   z flag one of the numbers is inf/nan
    ;   no calcs done
    ;   a' sign = sign(hl)^sign(de)

calc_ax_bx_mantissa_and_sign:
    ld a, h
    xor d
    and $80
    ex af, af'
calc_ax_bx_mantissa:
    res 7, h
    res 7, d
    ld c, $7c
    ld a, d
    and c
    jr z, bx_is_zero
    rrca  
    rra 
    ld b, a ; b=bx
    ld a, 3
    and d      ; keep bits 0, 1,  set 2
    or 4      
    ld d, a     ; de = mantissa
    jr bx_not_zero 
bx_is_zero:
    ld b, 1 ; de is already ok since exp=0,  bit 7 reset
bx_not_zero:
    ; b is bx,  de=mantissa(de)
    ld a, h
    and c
    jr z, ax_is_zero 
    rrca
    rra 
    ld c, a  ; c=exp
    ld a, 3
    and h
    or 4
    ld h, a
    ld a, c ; exp=ax
exp_check_nan:
    ld c, a
    ld a, 31
    cp c
    ret z
    cp b
    ld a, c ; restore exp(hl)
    ret
ax_is_zero:
    ld a, 1 ; hl is already ok a=ax
    jr exp_check_nan


mpl_11_bit:
    ld b, d
    ld c, e
    ld d, h
    ld e, l
    xor a, a
    bit 2, b
	jr	nz, unroll_a
	ld	h, a  
	ld	l, a
unroll_a:
    add hl, hl
    rla
    bit 1, b
    jr  z, unroll_b
	add hl, de
    adc 0
unroll_b:
    add hl, hl
    rla
    bit 0, b
    jr z, unroll_c
    add hl, de
    adc 0
unroll_c:

    ld b, 8

mpl_loop2:

	add	hl, hl  ; 
    rla
	rl c	   ; carry goes to de low bit
	jr	nc, mpl_end2
	add	hl, de
	adc 0
mpl_end2:

    djnz mpl_loop2
    ld e, a
    ld d, 0
    ret



_f16_div:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_div_hl_de:
    call calc_ax_bx_mantissa_and_sign
    jp z, div_handle_inf_or_nan
    sub b   ; new_exp = ax + bx - 15
    add 15
    ld b, a
    ld a, d
    or e
    jp z, div_handle_div_by_zero
    ld a, h
    or l
    ret z
    ld a, b
    push af
    ld b, d ;  save divider to bc
    ld c, e
    
    add hl, hl ; ehl = hl<10
    add hl, hl
    ld e, h  
    ld h, l
    ld l, 0

    pop af ; a exp,  ehl m1 bc m2
    call _div_24_by_15_ehl_by_bc
    ld b, a ; save new exp to b

    ld a, e
    or h
    or l
    ret z
div_loop_big:
    ld a, $F8
    and h
    or e
    jr z, div_check_neg_or_zero_exp
    inc b
    sra e
    rr h
    rr l
    jr div_loop_big
div_check_neg_or_zero_exp:
    ld a, b
    dec a
    bit 7, a
    jr z, div_exp_positive
    ld a, 1
    sub b
    ld b, 0
    jr z, div_exp_positive
    ld b, a
div_denorm_shift:
    sra h
    rr l
    djnz div_denorm_shift
div_exp_positive:
    ld a, 30
    cp b
    jp c, handle_inf
    res 2, h
    ld a, b
    add a, a
    add a, a
    or h
    ld h, a
    ex af, af'
    or h
    ld h, a
    ret
div_handle_div_by_zero:
    ld a, h
    or l
    jp z, handle_nan
    jp handle_inf 
div_handle_inf_or_nan:
    ld c, a
    add b
    cp 62
    jp z, handle_nan
    ld a, c
    cp 31
    jr nz, div_a_valid
    ld a, 4
    xor h
    or l
    jp nz, handle_nan
    ld a, d
    or e
    jp z, handle_inf
div_a_valid:
    ld a, b
    cp 31
    jr nz, div_b_valid
    ld a, 4
    xor d
    or e
    jp nz, handle_nan
    ld hl, 0 ; div by inf is 0
    ret
div_b_valid:
    ld a, h
    or l
    ret z
    jp handle_inf






_div_24_by_15_ehl_by_bc:
    push ix
    ld ix, 0
    add ix, sp
    push af ; set the exp at (ix-2)
    push hl
    ld a, e
    exx 
    ld c, a
    ex (sp), hl  ; chl = N ; save hl' on stack
    ld de, 0
    ld b, d      ; bde = Q = 0
    exx
    ld hl, 0
    ld e, c
    ld d, b
    ld b, 24
div_int_next:
    
    exx 
    sla e ; Q <<= 1
    rl d
    rl b
    
    sla l  ; N<<=1
    rl h 
    rl c
    exx
    
    adc hl, hl ; R=R*2 + msb(N)
    sbc hl, de ; since hl <= 65536 don't need to clear carry
    jr nc, div_int_update_after_substr
    add hl, de ; fix sub
    djnz div_int_next
    jr div_int_done
div_int_update_after_substr:
    exx    ; Q++
    inc e  
    exx
    djnz div_int_next
div_int_done:
    exx
    ld a, $FC       ; if ehl < 1024 && exp>0
    and d
    or b
    exx
    jr nz, div_final
    ld a, (ix-1)
    and a
    jr z, div_final
    inc b   ; set b to one sycle
    dec (ix-1)
    jr div_int_next
div_final:
    ex (sp), hl ; restore hl' (speccy thing) and put reminder to the stack
    exx
    ex de, hl
    ld e, b
    ld d, 0
    pop bc ; get  reminder
    pop af ; restore exp 
    pop ix
    ret 

_f16_neg:
    pop bc
    pop hl
    push hl
    push bc
_f16_neg_hl:
    ld a, $80
    xor h
    ld h, a
    ret

_f16_int:
    pop bc
    pop hl
    push hl
    push bc
_f16_int_hl:
    ld de, 0
    call calc_ax_bx_mantissa_and_sign
    jr z, f16_int_nan
    sub 25
    jr z, f16_int_combine_sign
    jr c, f16_int_shift_right
    ld b, a
f16_int_shift_left_next:
    add hl, hl
    djnz f16_int_shift_left_next
    jr f16_int_combine_sign
f16_int_shift_right:
    neg
    ld b, a
f16_int_shift_right_next:
    sra h
    rr l
    djnz f16_int_shift_right_next
f16_int_combine_sign:
    ld de, 0
    ex af, af'
    and a
    ret z
    ex de, hl
    sbc hl, de
    and a ; reset carry
    ld de, $FFFF
    ret
f16_int_nan:
    ld hl, 0
    ld de, 0
    scf
    ret

_f16_from_int:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_from_int_dehl:
    ld a, 0
    ex af, af'
    ld a, e
    or d
    jr z, from_int_pos
    ld a, $80
    ex af, af'
    inc de
    ld a, d
    or e
    jp nz, handle_inf
    ex de, hl
    and a
    sbc hl, de
from_int_pos:
    ld a, h
    or l
    ret z
    ld b, 25
from_int_sr:
    ld a, $f8
    and h
    jr z, from_int_less_then_800
    rr h
    rr l
    inc b
    jr from_int_sr
from_int_less_then_800:
    ld a, h
    or l
    ret z
from_int_shift_left:
    bit 2, h
    jr nz, from_int_range_ok
    add hl, hl
    dec b
    jr from_int_shift_left
from_int_range_ok:
    ld a, b
    jp final_combine

    
; input hl as A he as B
; return bit 0, a = A > B;
; return bit 1, a = A == B
; return bit 2, a = A < B;
_f16_cmp_he_de_to_a:
cmp_normalize_substract:
    ld bc, $7C7F
    ld a, h
    and c
    cp b
    jr c, cmp_norm_hl_ok
    jr nz, cmp_norm_nan
    ld a, l
    and a
    jr nz, cmp_norm_nan
cmp_norm_hl_ok:
    ld a, d
    and c
    cp b
    jr c, cmp_norm_de_ok
    jr nz, cmp_norm_nan
    ld a, e
    and a
    jr nz, cmp_norm_nan
cmp_norm_de_ok:
    ld b, $80
    ld a, h
    xor b
    ld h, a
    and b               
    jr nz, cmp_hl_fixed
    xor a   
    sub l
    ld l, a
    ld a, b
    sbc h
    ld h, a
cmp_hl_fixed:
    ld a, d
    xor b
    ld d, a
    and b
    jr nz, cmp_de_fixed
    xor a
    sub e
    ld e, a
    ld a, b
    ; sbc d
    sbc a, d
    ld d, a
cmp_de_fixed:
    and a ; make sure carry reset
    ret
cmp_norm_nan:
    pop hl
    ld hl, 0
    ret
   
_f16_gt:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc

_f16_gt_hl_de:
    call cmp_normalize_substract
    ex de, hl
    sbc hl, de
    ld hl, 0
    rl l
    ret

_f16_lt:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_lt_hl_de:
    call cmp_normalize_substract
    sbc hl, de
    ld hl, 0
    rl l
    ret
_f16_eq:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_eq_hl_de:
    call cmp_normalize_substract
    sbc hl, de
    ld hl, 1
    ret z
    ld l, 0
    ret

_f16_neq:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_neq_hl_de:
    call _f16_eq_hl_de
    ld a, 1
    xor l
    ld l, a
    ret

_f16_lte:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_lte_hl_de:
    call cmp_normalize_substract
    ex de, hl
    sbc hl, de
    ld hl, 0
    ccf
    rl l
    ret

_f16_gte:
    pop bc
    pop hl
    pop de
    push de
    push hl
    push bc
_f16_gte_hl_de:
    call cmp_normalize_substract
    sbc hl, de
    ld hl, 0
    ccf
    rl l
    ret


