		ORG 	0000H
		SJMP 	SETUP

		ORG 	0003H
		SJMP 	EXT_0

		ORG 	000BH
		SJMP 	TC0


SETUP:		;Configurar as interrupções
		SETB 	EA
		SETB 	EX0		;Conta os pulsos
		SETB	ET0		;Conta tempo para frequencia
		SETB 	IT0

		;Zera o registrador de 16bits, que contará os pulsos
		MOV	DPL, #0H
		MOV	DPH, #0H

		;Timer 0 conta 10ms => Serão 100 vezes
		MOV	TH0, #0D8H
		MOV	TL0, #0F0H
		MOV	R0,  #0H	;Contador de vezes -> Chegar em 1s
		;Freq = 1/s = numero_pulsos em 1s

		;Configura o contador 0
		MOV 	TMOD, #1H	;TC0 Modo 1

		SETB 	TR0
		SJMP	$

;*********************************************************
ENVIA_SERIAL:	;Desabilita as interrupcoes indesejadas
		CLR	EX0
		CLR	ET0

		;Configura transmissao seriala
		;Timer 1 usado na transmissão serial
		MOV 	TMOD, #00100000b	;TC1 modo 2
		;Calcular a taxa de comunicação
		;Pelos valores dados:
		MOV 	TL1, #250D	;TH1 = 256 −(11,0592∗10ˆ6)/(384∗4800) = 250
		MOV	TH1, #250D
		SETB	TR1

		MOV	SCON, #40H 	; Modo 1 do canal serial

		;MOV 	SBUF, DPTR  Canal nao permite transmissao de 16bits
		MOV	SBUF, DPH	; Enviar byte HIGH
		JNB	TI,$		;Espera transmissao
		CLR	TI

		MOV	SBUF, DPL	; Enviar byte LOW
		JNB	TI,$		;Espera transmissao
		CLR	TI

		SJMP	$		;Fim logico

;*********************************************************
EXT_0:		INC 	DPTR
			RETI
;**********************************************************
TC0:		INC	R0
		CJNE	R0,#64H,VOLTA	;Contar 100 vezes interrupt de 10ms
		SJMP	ENVIA_SERIAL
VOLTA:		MOV	TH0, #0D8H
		MOV	TL0, #0F0H
		RETI
;**********************************************************

END



