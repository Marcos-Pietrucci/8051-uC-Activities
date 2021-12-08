;Marcos Vinícius Firmino Pietrucci 10770072
; Lista 2
; Exercício 10

	ORG	0H
	SJMP	MAIN

	ORG	03H
	SJMP	READ_AD
	;Recebe sinal de interrupcao

MAIN:	SETB	EA
	SETB	EX0
	SETB	INT0
	CLR	30H	;Buffer de memoria

	;Começa a conversão, seleciona canal 1
	MOV	DPTR, #0C001H
	MOVX	@DPTR, A

LOOP:	MOV	R1, 30H
	ACALL	Mostra_D7S
	SJMP	LOOP

;************************************************
Mostra_D7S:
	MOV	DPTR,#TABELA
	MOV	A, R1
	MOVC	A, @A+DPTR

	;A agora contem o codigo D7S do numero lido
	MOV	DPTR, #8000H	;Codigo do D7S
	MOVX	@DPTR, A

	JMP	MAIN
TABELA:	DB	3FH, 06H, 05BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH

;************************************************
READ_AD:
	MOV	DPTR, #0A000H
	MOVX	A, @DPTR
	MOV	R1, A
	RETI

	END
