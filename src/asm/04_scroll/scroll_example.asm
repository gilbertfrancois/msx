; ---------------------------------------------
; --- SCrolling wall v.1 	                ---
; --- By Paul Koning                        ---
; --- Displays a scrolling wall on screen 1 ---
; ---------------------------------------------

; --- BIOS CALLS ---
INIT32:			equ 0x006F		; bios call to init screen 1
ERAFNK:			equ	0x00CC		; bios call to hide function key display
LDIRVM:			equ 0x005C		; bios call to copy block from memory to VRAM
FILVRM:			equ 0x0056		; bios call to fill VRAM with value

; --- MEMORY ADDRESSES ---
HTIMI:      	equ 0xFD9F      ; memory adress of hook that's invoked after VBLANK	
NMTBL:			equ 0x1800		; memory adress of name table screen 1

; ---------------------
; --- START OF CODE ---
; ---------------------
				org 0xD000		; the address of our program

start:
; --- INITIALIZE SCREEN ---
			call INIT32		; to screen 1
			call ERAFNK		; hide function keys text

; --- COPY NEW PATTERNS FOR CHARACTERS A...H to VRAM
			ld hl,images 	; memory address of new patterns
            ld de, 0x208 	; startadres of pattern for character A in VRAM
            ld bc,64	 	; blocklenght: 8 patterns x 8 bytes = 64
			call LDIRVM		; write to memory
            
; --- SETUP TIMERHOOK ---
              di				; disable interrupts
              ld a,0xc3			; jp instruction opcode
              ld (HTIMI),a		; load into the hook memory adress
              ld hl, timerhook	; load the adress of the hook routine that's invokedl
              ld (HTIMI+1),HL 	; load adress into hook after the jp instruction
              ei              	; enable interrupts				

; --- ENDLESS LOOP ---
infinite:	
              jr infinite	            
            
; --------------------------------
; --- TIMERHOOK ROUTINE: START ---
; --------------------------------
            
timerhook:		
            ld a,(character) ; load character to write from memory
            ld bc,768		; length of name table is 32x24=768
            ld hl,NMTBL		; VRAM address of name table
            call FILVRM		; fill name table with character
			inc a           ; next character
            cp 73			; if a=73 then make a 65 again
			jr nz,proceed   ; a != 73 > continue
            ld a,65			; a=65
proceed:    
			ld(character),a ; store character to write in memory
			ret				; end of timerhook

; --- timerhook end ---

; --- DATA FOR NEW CHARACTERS ---
 
images:		db 0xFE,0xFE,0xFE,0x00,0xEF,0xEF,0xEF,0x00 ; new pattern for character A (65)
			db 0xFD,0xFD,0xFD,0x00,0xDF,0xDF,0xDF,0x00 ; new pattern for character B (66)
			db 0xFB,0xFB,0xFB,0x00,0xBF,0xBF,0xBF,0x00 ; new pattern for character C (67)
			db 0xF7,0xF7,0xF7,0x00,0x7F,0x7F,0x7F,0x00 ; new pattern for character D (68)
			db 0xEF,0xEF,0xEF,0x00,0xFE,0xFE,0xFE,0x00 ; new pattern for character E (69)
			db 0xDF,0xDF,0xDF,0x00,0xFD,0xFD,0xFD,0x00 ; new pattern for character F (70)
			db 0xBF,0xBF,0xBF,0x00,0xFB,0xFB,0xFB,0x00 ; new pattern for character G (71)
			db 0x7F,0x7F,0x7F,0x00,0xF7,0xF7,0xF7,0x00 ; new pattern for character H (72)

;--- VARIABLES ---

character: 	db 65			; character to display, first is 65 (A)

; -------------------
; --- END OF CODE ---
; -------------------
            ; use the label "start" as the entry point
            end start
