	macro print,lin	
	endm
	macro write,lin	
	endm
	macro read,lin	
	include \0
	endm
	
	macro align256
		align 8
	endm
	macro align128
		align 7
	endm
	macro align64
		align 6
	endm
	macro align32
		align 5
	endm
	macro align16
		align 4
	endm
	macro align8
		align 3
	endm
	macro align4
		align 2
	endm
	macro align2
		align 1
	endm

	macro NewOrg,val
		org \val
	endm
	macro save	
	endm
	macro close
	endm