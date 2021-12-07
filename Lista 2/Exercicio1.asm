;Marcos Vinícius Firmino Pietrucci 10770072
; Lista 2
; Exercício 1

;Voltímetro. Lê sinal analógico e transforma em digital
;D7S no PORT 2, multiplexado pelo pino P3.7
; Buffer: 30H LSB e 31H MSB

		ORG 	0
		SJMP	PROG

;*********************************************
		ORG	03H
		SJMP	SUB_AD	;Ativado pelo timer. Lê o valor
;********************************************
		ORG	0BH	;Clock do A/D DE 100us
		CLR	EA
		MOV	TH0, #0FFH
		MOV	TL0, #09CH
		CPL	P3.6
		SETB	EA
		RETI
;*********************************************

PROG:		;Configuração de interrupções
		SETB	EA
		SETB	ET0
		SETB	EX0
		SETB	IT0
		MOV	TH0, #0FFH	;Clock de 100us
		MOV	TL0, #09CH
		MOV	TMOD, #01H	;Modo do timer
		SETB	TR0

		;Configurações do programa
		MOV	30H,#00H	;Zerar o buffer
		MOV	31H, #00H
		MOV	R0, #0H
		ACALL	SEL_CANAL

		;Loop principal do programa
LOOP:
		;Lê o Buffer e escreve no display
		ACALL	CONV2BCD_R0	;Converte o que está em R0 para BCD. Já armazena no buffer
		ACALL 	D7S
		SJMP	LOOP

;**********************************
;Função que converte o número no registrador R0 em BCD
CONV2BCD_R0:	MOV	A, R0
		MOV	B, #0AH
		DIV	AB
		;MOV	31H, A	; 31H = MSB
		MOV	A, B	; B armazena o LSB. Como vai de 0 até 9, usa só um
		MOV	30H, A
		RET
;**********************************************

;**********************************
;Função envia ao D7S os valores armazenados no buffer
D7S:		MOV	DPTR,#TABELA
		MOV	R3, #0H		;Será usado para indicar qual bit mostrar

		MOV	A, 30H		;Mostra o LSB primeiro

MOSTRA:		MOVC	A, @A+DPTR
		MOV	P2, A
		ACALL	ATIVA_D7S

		CJNE	R3, #0H, RETURN	;Caso já tenha mostrado o segundo, R3 será diferente e o prog retornará para o loop

		MOV	A, 31H		;Mostra o MSB depois
		INC	R3
		SJMP	MOSTRA

RETURN:		RET
TABELA:		DB	3FH, 06H, 05BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH

;************************************
;Função que ativa o respectivo Display, de acordo com o valor de R2
ATIVA_D7S:	CJNE	R3,#0H, ATIVA_MSB
		CLR	P3.7		;Ativa o LSB e retorna
		RET

ATIVA_MSB:	SETB	P3.7
		RET

;**********************************************
;Subrotina ativada pelo timer 0. Lê o A/D
SUB_AD:		CLR	EA
		JB	P1.7, SETA_MSB
			MOV	31H, #0H	;Não está ativado, então eh 0
		SJMP	continua
SETA_MSB:	MOV	31H, #1H		;Armazena o valor do segundo bit
continua:	CLR	P1.7
		MOV	R0, P1			;Armazena o valor do primeiro bit
		SETB	EA
		RETI
;**********************************************
;Subrotina que seleciona canal
SEL_CANAL:	MOV	DPTR, #8001H
		MOVX	@DPTR, A
		RET
		END