;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ****************** PROGRAMA ******************


ORG 0

;*****   EQUs
	RS 	EQU 	P3.4
	RW 	EQU 	P3.4
	ENAB 	EQU 	P3.2
	DAT	EQU	P2
	DQ	EQU	P3.0
	CLK	EQU	P3.1
	RST	EQU	P1.0

;**********************************

		;Configurações iniciais do LCD
		ACALL	INIT_LCD
		ACALL	CLR_LCD
		MOV	A,#00H
		ACALL	POS_LCD
		MOV	DPTR, #DADOS
CONT_PRINT2:	CLR	A
		MOVC	A,@A+DPTR
		CJNE	A,#00,CONT_PRINT
		SJMP	SAI
CONT_PRINT:	ACALL	WRITE_TEXT
		INC	DPTR
		SJMP	CONT_PRINT2

SAI:		ACALL	CONF		;Inicia a leitura de temperatura
L1:		ACALL	MEDE		;Mede o valor da temp.
		MOV	A, #40H
		ACALL	POS_LCD		;Preparar para printar no LCD
		MOV	A,R1
		CJNE	A,#00,NEGATIVO
		MOV	30H,#'+'
		MOV	A,R0
		JB	ACC.0,PRINT_MEIO
		MOV	35H,#30H
L2:		CLR	C
		RRC	A
L3:		ACALL	CONV2
		MOV	A,30H		;Escrever os textos
		ACALL	WRITE_TEXT
		MOV	A,31H
		ACALL	WRITE_TEXT
		MOV	A,32H
		ACALL	WRITE_TEXT
		MOV	A,33H
		ACALL	WRITE_TEXT
		MOV	A,#'.'
		ACALL	WRITE_TEXT
		MOV	A,35H
		ACALL	WRITE_TEXT
		MOV	A,#0DFH		;Simbolo de graus
		ACALL	WRITE_TEXT
		MOV	A,#'C'
		ACALL	WRITE_TEXT
		SJMP	L1
;*************************************************
;Subrotina que printa valores decimais, 0.5
PRINT_MEIO:	MOV	35H, #35H
		SJMP	L2
PRINT_MEIO2:	MOV	35H, #35H
		SJMP	L4
;*************************************************
;Subrotina que printa valores negativos
NEGATIVO:	MOV	30H,#'-'
		MOV	A,R0
		JB	ACC.0,PRINT_MEIO2
		MOV	35H, #30H
L4:		SETB	C
		RRC	A
		CPL	A
		ADD	A,#1
		SJMP	L3
;*************************************************
DADOS:		DB	'TEMPERATURA',00 ;String de texto para printar
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

;**************************************************
;Subrotina que mostra um caractere ASCII no LCD
WRITE_TEXT:	CLR	RW	;Modo de escrtia
		SETB	RS	;Dado a ser enviado
		SETB	ENAB
		MOV	DAT, A
		CLR	ENAB	;Pulso no enable
		RET

;**************************************************
;Subrotina que converte um valor Hexa no ACC em BCD de 3 digitos
CONV2:		CJNE	A,#64H,TESTE
TESTE:		JC	MENOR
		SUBB	A,#64H
		ACALL	CONVBCD
		MOV	R3, #1
		ACALL	ASCII_3
		RET
MENOR:		ACALL	CONVBCD
		MOV	R3, #00
		ACALL	ASCII_3
		RET
;**************************************************
;Função que converte o número no acumulador em BCD
CONVBCD:	MOV	B, #0AH
		DIV	AB
		MOV	R2, A	; R2 = ISB
		MOV	R1, B	; R1 = LSB
		SWAP	A
		ORL	A,R1
		RET
;**************************************************
;Subrotina que monta o buffer de dados de 3 digitos ASCII
;Converter em ASCII só somar 30h no numero BCD
ASCII_3:	MOV	A,R3
		ADD	A,#30H
		MOV	31H,A
		MOV	A,R2
		ADD	A,#30H
		MOV	32H,A
		MOV	A,R1
		ADD	A,#30H
		MOV	33H,A

;**************************************************
;		CONFIGURAÇÃO DO DS1620
;***************************************************
; CONF deve ser chamada uma vez e MEDE deve ser chamada toda vez que fizer uma leitura.
CONF:		MOV 	A,#0AH  ;Configuração = cpu & Continuo
		ACALL	OUT_CMD
		MOV	A,#0EEH ;Iniciar conversão.
		ACALL   OUT_CMD
		RET
;***************************************************
; OUT_CMD - Envia comando para o DS1620..
;***************************************************
OUT_CMD:  	CLR 	RST ; É necessário pulsar o Reset antes de enviar comando
		SETB 	RST
		MOV 	R7,#8
SERIAL: 	RRC 	A ;Desloca o ACC para enviar o cada bit (LSB) via Carry
		MOV 	DQ,C ; Envia bit a bit para DQ
		ACALL 	PULSE ; Pulsa o clock a cada bit enviado
		DJNZ 	R7,SERIAL

		RET
;***************************************************
PULSE:		SETB  	CLK
		CLR 	CLK
		SETB 	CLK
		RET
;*****************************************
; Rotina que lê a temperatura do sensor DS1620 e salva em 
; R0 = LSB e R1 = 00 se positivo ou R1 = 01 se negativo
;******************************************

MEDE: 		MOV 	A,#0AAH ; Comando de leitura de 
		ACALL   OUT_CMD ;temperatura (9 bits).
		ACALL   IN_DATA ; Ler o LSB (8 bits)da temperatura.
		MOV     R0,A ;Salvar o LSB em R0.
		MOV     20H.0,C ; Ler o Bit de sinal (nono bit) da temperatura
		MOV     R1,20H ; Salvar no bit 0 de R1 (1 = negativo  0 = positivo)
		MOV     A,#0EEH ; Iniciar outra conversão.
		ACALL	OUT_CMD
		RET
;***************************************************
; IN_DATA - Lê um dado do DS1620.

;*************************************************

IN_DATA:    	CLR 	A
		SETB 	DQ ; DQ será usado como 
		;entrada (leitura)
		SETB 	RST
		MOV 	R7,#9
SERIAL2: 	SETB  	CLK
		CLR 	CLK
		MOV 	C,DQ
		SETB 	CLK
		RRC 	A
		DJNZ 	R7,SERIAL2
		RLC 	A
		RET

		END