;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ****************** PROGRAMA ******************

;Lê caracteres do teclado matricial e exibe em display LDC 2x16

	;Pinos de controle de dados e de informações do LCD
	RS	EQU	P3.4
	RW	EQU	P3.3
	ENAB	EQU	P3.2
	DAT	EQU	P2

;************************************************

		ORG	0
		MOV	R2, #0H
		MOV	R4, #0H
		MOV	R5, #0H
		MOV	R6, #0H
SETUP:		ACALL	INIT_LCD
		ACALL	CLR_LCD
		MOV	A, #00	; O simlador não posiciona o cursos na posição 0
		ACALL	POS_LCD

;***** Loop principal ***********
INIC:		MOV	P1, #0FFH
		MOV	R0, #7FH
LOOP:		ACALL	VARRE
		MOV	A, P1
		ORL	A, #0F0H
		CJNE	A, #0FFH, TECLA
		SJMP	LOOP
TECLA:		MOV	A, P1
		ACALL	ASCII_TECLA
		MOV	R2, A		;Preserva o valor do ACC
		MOV	A, R7
		MOV	R3, A		;Transfere de R7 para R3
		MOV	A, R2		;Retorna o valor do ACC
		ACALL	WRITE_TEXT

ESPERA:		MOV	A, P1		;Trava o programa aqui até que a chave seja aberta
		ORL	A, #0F0H
		CJNE	A, #0FFH, ESPERA
		INC	R4

		CJNE	R4, #1H, TESTA_DOIS
		;Armazena o primeiro numero lido
		MOV	A, R3
		MOV	R5, A
		;Escreve o sinal de +
		MOV	A, #'+'
		ACALL	WRITE_TEXT

TESTA_DOIS:	CJNE	R4, #2H, INIC
		;Amazena o segundo numero lido
		MOV	A, R3
		MOV	R6, A

		;Escreve o sinal de =
		MOV	A, #'='
		ACALL	WRITE_TEXT

		;Faz a soma
		MOV	A, R6
		ADD	A, R5

		;Transforma o numero em ASCII
		ADD	A, #30H
		ACALL	WRITE_TEXT
		ACALL	CLR_LCD
		MOV		A, #0H
		ACALL	POS_LCD		;Reinicia LCD e a contagem
		SJMP	INIC

;**************************************************
VARRE:		MOV	A, R0
		MOV	P1, A
		RR	A
		JNB	ACC.3, FIM
		MOV	R0,A
		RET
FIM:		MOV	R0, #7FH
		RET
;**************************************************
;Subrotina que codifica a tecla do teclado matricial para ASCII
ASCII_TECLA:	MOV	DPTR,#TECLADO
		MOV	40H, A
		CLR	A
CONT1:		MOV	R7, A
		MOVC	A, @A+DPTR
		CJNE	A, 40H, OUTRO
		MOV	A, R7
		SJMP	CONV_ASCII
OUTRO:		MOV	A,R7
		INC	A
		SJMP	CONT1
CONV_ASCII:	CJNE	A, #0AH, TEST
TEST:		JC	NUMERO
		ADD	A, #7
NUMERO:		CLR	C
		ADD	A, #30H
		RET

TECLADO:	DB	0D7H, 0EEH, 0DEH, 0BEH, 0EDH, 0DDH, 0BDH, 0EBH, 0DBH, 0BBH, 7EH, 7DH, 7BH, 77H, 0E7H, 0B7H

;**************************************************
;Subrotina que mostra um caractere ASCII no LCD
WRITE_TEXT:	CLR	RW	;Modo de escrtia
		SETB	RS	;Dado a ser enviado
		SETB	ENAB
		MOV	DAT, A
		CLR	ENAB	;Pulso no enable
		RET
;*************************************************
;Subrotina que liga e configura o LCD
INIT_LCD:	CLR	RW
		CLR	RS
		SETB	ENAB
		MOV	DAT, #38H	;2x16 e matriz 5x7
		CLR	ENAB
		SETB	ENAB
		MOV	DAT, #0EH	;Display on/off
		CLR	ENAB
		SETB	ENAB
		MOV	DAT, #06H	;Modo de entrada
		CLR	ENAB
		RET

;**************************************************
CLR_LCD:	CLR	RW
		CLR	RS
		SETB	ENAB
		MOV	DAT, #01H
		CLR	ENAB
		RET
;**************************************************
POS_LCD:	CLR	RW
		CLR	RS
		SETB	ENAB
		ADD	A, #80H
		MOV	DAT, A
		CLR	ENAB
		RET

	END

