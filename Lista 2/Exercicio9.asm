;Marcos Vinícius Firmino Pietrucci 10770072
; Lista 2
; Exercício 9

;Teclado matricial conectados via mapeamento de memoria
; D7S via mapeamento de memoria

		ORG	0

		;Armazena os digitos inseridos
		MOV	R2, #0H
		MOV	R3, #0H
		MOV	R4, #0H
		MOV	R5, #0H
		SETB	P3.2	;Apaga leds
		SETB	P3.4

Volta:

;**************** LEITURA DO PAINEL *************
INIC:		ACALL	DELAY	;Mais conforto ao ler
		MOV	P1,#0FFH
		MOV	R0, #7FH
LOOP:		ACALL	VARRE
		MOV	DPTR, #6000H
		MOVX	A, @DPTR
		ORL	A,#0F0H
		CJNE	A,#0FFH,TECLA
		SJMP	LOOP

TECLA:		MOV	DPTR, #6000H
		MOVX	A, @DPTR
		MOV	R1, A
		MOV	DPTR, #8000H
		MOVX	A, @DPTR
		CPL	A
		SJMP	amzna_tecla

VARRE:		MOV	A,R0
		MOV	DPTR, #6000H
		MOVX	@DPTR, A
		RR	A
		JNB	ACC.3, fim_varre
		MOV	R0,A
		RET
fim_varre:	MOV	R0, #7FH
		RET

;**************** ARMAZENA AS TECLAS *******************
amzna_tecla:	MOV	A, R1
		CJNE	R2, #0H, outro
		;Se chegou aqui, o R2 esta disponivel. Armazenar
		MOV	R2, A
		SJMP	INIC

outro:		CJNE	R3, #0H, outro1
		;Se chegou aqui, o R3 esta disponivel. Armazenar
		MOV	R3, A
		SJMP	INIC

outro1:		CJNE	R4, #0H, outro2
		;Se chegou aqui, o R4 esta disponivel. Armazenar
		MOV	R4, A
		SJMP	INIC

outro2:		;Se chegou aqui, o R5 esta disponivel. Armazenar
		MOV	R5, A

		SJMP	COMPARAR

; 0   1   2  3 4  5  6  7  8 9   A  B  C D   E  F
; 77 EE ED EB E7 DE DD DB D7 BE BD BB B7 7E 7D 7B
;********************COMPARA OS VALORES LIDOS********************
COMPARAR:
		;Comparar a senha inserida
		;Caractere por caractere
		CJNE	R2, #0BDH, TESTA_SENHA2 ; A

		CJNE	R3, #0BBH, TESTA_SENHA2 ; B

		CJNE	R4, #0B7H, TESTA_SENHA2 ; C

		CJNE	R5, #07EH, TESTA_SENHA2 ; D

		;Se chegou aqui, a senha 1 está certa!
		SJMP	LIBERAR_1

TESTA_SENHA2:	CJNE	R2, #77H, ERRO ; 0

		CJNE	R3, #77H, ERRO ; 0

		CJNE	R4, #77H, ERRO ; 0

		CJNE	R5, #77H, ERRO ; 0

		;Se chegou aqui, a senha 2 está certa!
		SJMP	LIBERAR_2

;***************************************************************
;Executa as ações após liberar
LIBERAR_1:
		MOV	DPTR,#TABELA
		MOV	A, #1H
		MOVC	A, @A+DPTR

		;A agora contem o codigo D7S do numero 1
		MOV	DPTR, #800H	;Codigo do D7S
		MOVX	@DPTR, A

		JMP	INIC
TABELA:		DB	3FH, 06H, 05BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH
;***************************************************************
;Executa as ações após liberar
LIBERAR_2:
		MOV	DPTR,#TABELA
		MOV	A, #0H
		MOVC	A, @A+DPTR

		;A agora contem o codigo D7S do numero 0
		MOV	DPTR, #800H	;Codigo do D7S
		MOVX	@DPTR, A

		JMP	INIC
;****************************************************************
;Senha errada digitada
ERRO:

loop_erro:	;Piscar o dígito 8
		MOV	DPTR,#TABELA
		MOV	A, #8H
		MOVC	A, @A+DPTR

		;A agora contem o codigo D7S do numero 0
		MOV	DPTR, #800H	;Codigo do D7S
		MOVX	@DPTR, A
		ACALL	DELAY

		;Agora apagar o D7S, ou seja, carregar tudo com 0
		MOV	A, #0H
		MOV	DPTR, #800H	;Codigo do D7S
		MOVX	@DPTR, A
		ACALL	DELAY

		SJMP	loop_erro

;****************************************************************
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
	RET
; Rest: 0
; END: Wait loop

END

