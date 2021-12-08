;Marcos Vinícius Firmino Pietrucci 10770072
; Lista 2
; Exercício 11

		ORG	0H
		SJMP	SETUP

		ORG	03H
		JMP	READ_AD
		;Recebe sinal de interrupcao

SETUP:		SETB	EA
		SETB	EX0
		SETB	INT0
		CLR	30H	;Buffer de memoria
		MOV	R1, #0H ;Armazena o canal selecionado
		MOV	R2, #0H ;Armazena o valor lido do AD

MAIN:
		ACALL	LEITURA
		ACALL	SELECIONA_CANAL
		ACALL	Mostra_D7S


;**************** LEITURA DO PAINEL *************
LEITURA:	MOV	R0, #7FH
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

VARRE:		MOV	A,R0
		MOV	DPTR, #6000H
		MOVX	@DPTR, A
		RR	A
		JNB	ACC.3, fim_varre
		MOV	R0,A
		RET
fim_varre:	MOV	R0, #7FH
		RET

;**************** SELECIONA O CANAL *******************
seleciona_canal: ; A tecla está em R1

		MOV	A, R1
		MOV	DPTR, #0C000H

		;Agora, Acc possui o valor correto para o canal
		MOV	DPL, A
		MOVX	@DPTR, A	;Inicia conversão do canal
		RET
;************************************************
Mostra_D7S:
		MOV	DPTR,#TABELA
		MOV	A, R2		;R2 contém o valor lido
		MOVC	A, @A+DPTR
	
		;A agora contem o codigo D7S do numero lido
		MOV	DPTR, #8000H	;Codigo do D7S
		MOVX	@DPTR, A
		RET
TABELA:		DB	3FH, 06H, 05BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH

;************************************************
READ_AD:
		MOV	DPTR, #0A000H
		MOVX	A, @DPTR
		MOV	R2, A
		RETI

		END
