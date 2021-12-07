;Marcos Vinícius Firmino Pietrucci 10770072
; Lista 2
; Exercício 2

; Uso de conversor ADC0808
; Será considerado seleção de canal com mapeamento de memória


;*****   EQUs
		RS 	EQU 	P3.4
		RW 	EQU 	P3.4
		ENAB 	EQU 	P3.2
		DAT	EQU	P2
		DQ	EQU	P3.0
		CLK	EQU	P3.1
		RST	EQU	P1.0

		ORG 	0
		SJMP	PROG

;*********************************************
		ORG	03H
		JMP	SUB_AD	;Ativado pelo timer. Lê o valor
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

		;Configurações iniciais do LCD
		ACALL	INIT_LCD
		ACALL	CLR_LCD
		MOV	A,#00H
		ACALL	POS_LCD

		;Configurações do programa
		MOV	30H,#00H	;Zerar o buffer
		MOV	31H, #00H
		MOV	R0, #0H
		MOV	R1, #0H		;Armazena o valor
		MOV	DPTR, #7FFFH

LOOP:		;Loop principal do programa
		ACALL	SEL_CANAL		;Seleciona o canal e corrige R1

		;Lê o Buffer e escreve no display
		ACALL	Conv2Digital	;Converte o que está em R0 para BCD. Já armazena no buffer
		ACALL	PRINT_APRES
		ACALL	PRINT_INFO

		;Limpar LCD
		ACALL	CLR_LCD
		MOV	A,#00H
		ACALL	POS_LCD
		INC 	R1
		SJMP	LOOP

;**********************************
;Função que converte o número no registrador R0 em BCD
Conv2Digital:	MOV	A, R0
		CJNE	A, #0H,Test1
		MOV	30H, #0H			;Tensão é 0
		SJMP	RETURN
Test1:		CJNE	A, #17H,Test2
		MOV	30H, #1H			;Tensão é 1v
		SJMP	RETURN
Test2:		CJNE	A, #2EH,Test3
		MOV	30H, #2H			;Tensão é 2v
		SJMP	RETURN
Test3:		CJNE	A, #45H,Test4
		MOV	30H, #3H			;Tensão é 3V
		SJMP	RETURN
Test4:		CJNE	A, #5CH,Test5
		MOV	30H, #4H			;Tensão é 4V
		SJMP	RETURN
Test5:		CJNE	A, #73H,Test6
		MOV	30H, #5H			;Tensão é 5V
		SJMP	RETURN
Test6:		CJNE	A, #8AH,Test7
		MOV	30H, #6H			;Tensão é 6V
		SJMP	RETURN
Test7:		CJNE	A, #0A1H,Test8
		MOV	30H, #7H			;Tensão é 7V
		SJMP	RETURN
Test8:		CJNE	A, #0B8H,Test9
		MOV	30H, #8H			;Tensão é 8V
		SJMP	RETURN
Test9:		CJNE	A, #0CFH,Test10
		MOV	30H, #9H			;Tensão é 9V
		SJMP	RETURN
Test10:		MOV	30H, #0AH			;Tensão é 10V

RETURN:		RET


;**********************************************
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
;VALOR ANALOGICO DA TENSAO NO SENSOR
PRINT_APRES:	MOV 	A, #'V'
		ACALL   WRITE_TEXT
		MOV 	A, #'A'
		ACALL   WRITE_TEXT
		MOV	 A, #'L'
		ACALL   WRITE_TEXT
		MOV 	A, #'O'
		ACALL   WRITE_TEXT
		MOV 	A, #'R'
		ACALL   WRITE_TEXT
		MOV 	A, #' '
		ACALL   WRITE_TEXT
		MOV	 A, #'A'
		ACALL   WRITE_TEXT
		MOV 	A, #'N'
		ACALL   WRITE_TEXT
		MOV 	A, #'A'
		ACALL   WRITE_TEXT
		MOV	 A, #'L'
		ACALL   WRITE_TEXT
		MOV 	A, #'O'
		ACALL   WRITE_TEXT
		MOV 	A, #'G'
		ACALL   WRITE_TEXT
		MOV 	A, #'I'
		ACALL   WRITE_TEXT
		MOV 	A, #'C'
		ACALL   WRITE_TEXT
		MOV 	A, #'O'
		ACALL   WRITE_TEXT
		MOV	 A, #' '
		ACALL   WRITE_TEXT
		MOV 	A, #'D'
		ACALL   WRITE_TEXT
		MOV	 A, #'A'
		ACALL   WRITE_TEXT
		MOV 	A, #' '
		ACALL   WRITE_TEXT
		MOV	 A, #'T'
		ACALL   WRITE_TEXT
		MOV	 A, #'E'
		ACALL   WRITE_TEXT
		MOV 	A, #'N'
		ACALL   WRITE_TEXT
		MOV	 A, #'S'
		ACALL   WRITE_TEXT
		MOV	 A, #'A'
		ACALL   WRITE_TEXT
		MOV 	A, #'O'
		ACALL   WRITE_TEXT
		MOV 	A, #' '
		ACALL   WRITE_TEXT
		MOV 	A, #'N'
		ACALL   WRITE_TEXT
		MOV	 A, #'O'
		ACALL   WRITE_TEXT
		MOV	 A, #' '
		ACALL   WRITE_TEXT
		MOV	 A, #'S'
		ACALL   WRITE_TEXT
		MOV 	A, #'E'
		ACALL   WRITE_TEXT
		MOV 	A, #'N'
		ACALL   WRITE_TEXT
		MOV 	A, #'S'
		ACALL   WRITE_TEXT
		MOV 	A, #'O'
		ACALL   WRITE_TEXT
		MOV 	A, #'R'
		ACALL   WRITE_TEXT
		MOV 	A, #' '
		ACALL   WRITE_TEXT

		RET
;**********************************************
PRINT_INFO:
		MOV	A, R1		;Indica o canal, o sensor
		ACALL   WRITE_TEXT
		MOV 	A, #'='
		ACALL   WRITE_TEXT
		MOV	A,R0		;Indica o valor lido
		ACALL   WRITE_TEXT
		RET
;**********************************************
;Subrotina ativada pelo timer 0. Lê o A/D
SUB_AD:		CLR	EA
		MOV	R0, P1			;Armazena o valor lido
		SETB	EA
		RETI
;**********************************************
;Subrotina que seleciona canal
SEL_CANAL:	CJNE	R1, #8H, CONT
		MOV	R1, #0H
		MOV	DPTR, #7FFFH

CONT:		INC	DPTR
		MOVX	@DPTR, A
		RET
		END

