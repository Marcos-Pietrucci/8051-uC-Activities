;Marcos Vinícius Firmino Pietrucci 10770072
; Lista 2
; Exercício 8

		ORG	0H
		MOV	A, #0H
		MOV	R1, #0H
		MOV	R2, #0H


LOOP:		CJNE	A, #9H, continua
		MOV	A, #0H
continua:	ACALL 	CONV2BCD
		ACALL	D7S
		INC	A
		ACALL	DELAY
		SJMP	LOOP

;******************************************
;Função que converte o número no acumulador em BCD
CONV2BCD:	MOV	R2, A
		MOV	B, #0AH
		DIV	AB
		MOV	R2, A	; R2 = ISB
		MOV	A, B	; B = LSB - O numero vai de 0 a 9
		MOV	R1, A
		MOV	A, R2
		RET

;*******************************************
;3FH, 06H, 05BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH
;Função que ativa os três D7S, valores armazenados em memória
D7S:
		MOV	DPTR, #TABELA

		;Vamos agora colocar o valor no ACC
		MOV	A, R1

		;Carrega no ACC o código D7S correspondente
		MOVC	A, @A+DPTR

		;Devo agora ativar o decodificador. Para o D7S, é Y4
		;O endereço do D7S é 8000H
		MOV	DPTR,#8000H

		MOVX	@DPTR, A
		RET

TABELA:		DB	3FH, 06H, 05BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH
;*******************************************
DELAY:
; START: Wait loop, time: 1 s
; Clock: 12000.0 kHz (12 / MC)
; Used registers: R4, R5, R6, R7
	MOV	R7, #003h
	MOV	R6, #0D2h
	MOV	R5, #024h
	MOV	R4, #014h
	NOP
	DJNZ	R4, $
	DJNZ	R5, $-5
	DJNZ	R6, $-9
	DJNZ	R7, $-13
	MOV	R4, #059h
	DJNZ	R4, $
	NOP
; Rest: 0
; END: Wait loop
	RET

END
