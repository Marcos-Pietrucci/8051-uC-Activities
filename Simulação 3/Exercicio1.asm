;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 1 ***************
ORG 0

LOOP:	ACALL 	TEMPO
	CPL	P2.0
	CPL	P2.1
	ACALL 	TEMPO
	SJMP	LOOP

; START: Wait loop, time: 50 us
; Clock: 12000.0 kHz (12 / MC)
; Used registers: R0
TEMPO:	MOV	R0, #018h
	NOP
	DJNZ	R0, $
	RET
; Rest: 0
; END: Wait loop

END