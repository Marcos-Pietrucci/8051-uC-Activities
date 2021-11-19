;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 1 ***************		
		
		ORG	0
		SJMP	SETUP

		ORG	013H
		ACALL	EXT_1
		RETI

SETUP:		SETB	EA		;Prepara A interrupção
		SETB	EX1
		SETB	IT1
		CLR	20H.0		;Bit de parada da contagem

INIC:		MOV	A, #00
LOOP:		MOV	R0, A
		ACALL	VERIFICA
		ACALL	D7S
		MOV	A, R0
		INC	A
PARADA:		JB	20H.0, $	;Caso o bit de parada estiver ativo, congelar o programa aqui
		CJNE	A, #0C8H,TESTE_MENOR
TESTE_MENOR:	JC	LOOP
		JMP	INIC

;**********************************
;Função que verifica quanto está a contagem, altera o MSB e ativa a conversão para BCD
VERIFICA:	CJNE	A, #64H, TESTE
TESTE:		JC	MENOR
		SUBB	A, #64H		; Reseta a contagem no acumulador
		ACALL	CONV2BCD	; Ingorar que o número é maior do que 100 ao converter BCD
		MOV	R3, #1H		; o MSB é alterado "manualmente"
		RET
MENOR:		ACALL	CONV2BCD
		MOV	R3, #00H
		RET

;**********************************
;Função que converte o número no acumulador em BCD
CONV2BCD:	MOV	B, #0AH
		DIV	AB
		MOV	R2, A	; R2 = ISB
		MOV	R1, B	; R1 = LSB
		SWAP	A
		ORL	A,R1
		RET

;**********************************
;Função que ativa os três D7S, valores armazenados em memória
D7S:		JB	20H.0, PARADA
		MOV	DPTR,#TABELA
		MOV	A, R1
		MOVC	A, @A+DPTR
		MOV	P0, A
		MOV	A, R2
		MOVC	A, @A+DPTR
		MOV	P2, A
		MOV	A, R3
		MOVC	A, @A+DPTR
		MOV	P1, A
		RET

TABELA:		DB	3FH, 06H, 05BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH

;**********************************
EXT_1:		JNB	20H.0, ATIVA_BIT
		CLR	20H.0		;O bit estava ativado. Reativar a contagem
		MOV	A, #0C8H	;Faz a contagem recomeçar do zero
		RET
ATIVA_BIT:	SETB 	20H.0		;Seta a flag de parada do programa
		RET

		END
