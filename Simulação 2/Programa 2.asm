;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 2 ***************
ORG 0

	MOV	R2,#0FFH
	MOV	R1,#7FH
;VALOR0	EQU	0FFH
;VALOR1	EQU	7FH
	MOV	DPTR, #1200H

LOOP:	MOV	C, P1.0	;Chave aberta é 1, fechada é 0
	JC	OP1
	SJMP	OP0
OP1:	;MOV	A, #VALOR1
	MOV	A, R1
	MOVX	@DPTR, A
	SJMP	LED

OP0:	;MOV	A, #VALOR0
	MOV	A, R2
	MOVX	@DPTR, A

LED:	MOV	P3.1, C
	CPL	C
	MOV	P3.0,C

	SJMP	LOOP
END
