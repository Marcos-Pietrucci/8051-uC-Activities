;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 1 ***************
ORG	0

	CLR	A
	MOV	DPTR, #DADO
	MOVC	A,@A+DPTR	;Move conteúdo do DPTR+A para o Acc
	MOV	30H, A		;Move conteúdo do Acc para a posicao da memoria 30H
	INC	DPTR
	CLR	A
	MOVC	A,@A+DPTR

	CJNE	A,30H,Test 	;Desvie se A != (30H): C=1 <=> *(30H) > A | C=0 <=> *(30H) < A

Test:	MOV	DPTR,#1200H
	JC	LT
	MOV	A,30H
	MOVX	@DPTR,A
	SJMP	FIM

LT:	MOVX	@DPTR,A

FIM:	SJMP	$

;*********** Dados ***********;
DADO:	DB	3AH,0A3H
	END
