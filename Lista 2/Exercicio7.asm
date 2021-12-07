;Marcos Vinícius Firmino Pietrucci 10770072
; Lista 2
; Exercício 7

	ORG	0
	SJMP	PROG
;*****************************************
	ORG	003H
	SJMP	SUB_AD
;*****************************************
	ORG	00BH
	CPL	P3.1
	RETI
;*****************************************
PROG:	SETB	EA
	SETB	ET0
	SETB	EX0
	MOV	TH0, #0FFH
	MOV	TL0, #0FBH
	MOV	TMOD, #01
	SETB	TR0
	MOV	30H, #00
	ACALL	SEL_CANAL
LOOP:	MOV	A, 30H
	MOV	DPTR, #8000H
	MOVX	@DPTR, A
	SJMP	LOOP

;*****************************************
SUB_AD:	CLR	EA
	MOV	DPTR, #8000H
	MOVX	A, @DPTR
	MOV	30H, A
	SETB	EA
	ACALL	SEL_CANAL
	RETI
;*****************************************
SEL_CANAL:
	MOV	DPTR, #8007H ; SELECIONA O CANAL 7
	MOVX	@DPTR, A
	RET
	END
