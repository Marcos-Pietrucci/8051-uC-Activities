;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ****************** PROGRAMA 2 ***************

; Para o contador, usarei dois registradores 8 bits R0 e R1
; R1 para os 2 mais significativos, R2 para os 2 leds menos significativos
; Buffer: 30H == LSB e 33H == MSB
; O bit 20H.0 armazena o estado do programa
; Fade out de 100
		ORG	0H
		SJMP	SETUP

		ORG	013H
		JMP	EXT_1

SETUP:		SETB	EA		;Configura interrupções
		SETB	EX1
		SETB	IT1

		MOV	R0, #0H		;Contador menos significativo
		MOV	R1, #0H		;Contador mais significativo
		MOV	R2, #0H		;Armazena qual o bit ativo
		MOV	30H, #0H	;Limpa o buffer
		MOV	31H, #0H
		MOV	32H, #0H
		MOV	33H, #0H
		MOV	P2, #0FFH	;Limpa os ativadores
		MOV	P1, #0FFH
		CLR	20H.0		;Limpa o bit de parada


LOOP:		JB	20H.0, $
		MOV	P2, #00H	;Limpa os ativadores
		MOV	P1, #00H	;Limpa os leds
		ACALL	CONV2BCD_R0	;Converte para BCD e coloca no buffer
		ACALL	CONV2BCD_R1	;Converte para BCD e coloca no buffer
		ACALL	D7S		;Ativa todos os números
		INC	R0
		;Faz os testes
		CJNE	R1, #99H, TESTE ;Veja se o contador mais significativo está em 99
TESTE:		JNC	RESETA
		CJNE	R0, #99H, TESTE2 ;Veja se o contador menos significativo está em 99
TESTE2:		JNC	CARRY_CONT
		SJMP	LOOP

CARRY_CONT:	INC	R1
		MOV	R0, #00H
		SJMP	LOOP

RESETA:		;Reseta
		MOV	R0, #0H		;Limpa os contadores
		MOV	R1, #0H
		SJMP	LOOP
;**********************************
;Função que converte o número no registrador R0 em BCD
CONV2BCD_R0:	MOV	A, R0
		MOV	B, #0AH
		DIV	AB
		MOV	31H, A	; 31H = ISB1
		MOV	30H, B	; 30H = LSB
		RET

;**********************************
;Função que converte o número no registrador R1 em BCD
CONV2BCD_R1:	MOV	A, R1
		MOV	B, #0AH
		DIV	AB
		MOV	33H, A	; 33H = MSB
		MOV	32H, B	; 32H = ISB2
		RET

;**********************************
;Função envia ao D7S os valores armazenados no buffer
D7S:		MOV	DPTR,#TABELA
		MOV	R3, #0H

		;Executar 4 vezes, para mostrar os 4 dígitos
EXIBE:		CJNE	R2, #3H, TESTA_2
		MOV	A, 33H			;Mostra o MSB
		SJMP	MOSTRA

TESTA_2:	CJNE	R2, #2H, TESTA_1
		MOV	A, 32H			;Mostra o MSB-1
		SJMP	MOSTRA

TESTA_1:	CJNE	R2, #1H, TESTA_0
		MOV	A, 31H			;Mostra o LSB+1
		SJMP	MOSTRA

TESTA_0:	MOV	A, 30H			;Mostra o LSB
		SJMP	MOSTRA

MOSTRA:		MOVC	A, @A+DPTR
		MOV	P1, A

		ACALL	ATIVA_D7S
		MOV	P2, #00H
		INC	R3
		CJNE	R3, #4H, EXIBE		;Enquanto não exibir os 4 números, continuar
		RET
TABELA:		DB	3FH, 06H, 05BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH

;************************************
;Função que ativa o respectivo Display, de acordo com o valor de R2
ATIVA_D7S:	CJNE	R2, #3H, ATIVA_2
		SETB	P2.3
		MOV	R2, #0
		RET

ATIVA_2:	CJNE	R2, #2H, ATIVA_1
		SETB	P2.2
		INC	R2
		RET

ATIVA_1:	CJNE	R2, #1H, ATIVA_0
		SETB	P2.1
		INC	R2
		RET

ATIVA_0:	CJNE	R2, #0H, TESTA_2
		SETB	P2.0
		INC	R2
		RET

;**********************************
;Congela o programa e retoma a contagem
EXT_1:		JNB	20H.0, ATIVA_BIT
		CLR	20H.0		;O bit estava ativado. Reativar a contagem
		MOV	R0, #0H		;Faz a contagem recomeçar do zero
		MOV	R1, #0H
		RETI
ATIVA_BIT:	SETB 	20H.0		;Seta a flag de parada do programa
		RETI


		END
