;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 1 ***************
		ORG 0000H
		SETB	EX1
		SETB	IT1
		SJMP	SETUP

		ORG 0013H
		JMP EXT_1

SETUP:		;Configuracoes iniciais
		CLR	EA
		CLR	20H.0	;Vai determinar o estado, se reiniciado ou nao
		MOV	R2, #0H
		MOV	R3, #0H
		MOV	R4, #0H
		MOV	R5, #0H
		MOV	R6, #0H

;**************** LEITURA DO PAINEL *************
INIC:		ACALL	DELAY	;Mais conforto ao ler
		MOV	P1,#0FFH
		MOV	R0, #7FH
LOOP:		ACALL	VARRE
		MOV	A,P1
		ORL	A,#0F0H
		CJNE	A,#0FFH,TECLA
		SJMP	LOOP

TECLA:		MOV	R1, P1
		MOV	A, P1
		CPL	A
		SJMP	amzna_tecla

VARRE:		MOV	A,R0
		MOV	P1,A
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

outro2:		CJNE	R5, #0H, outro3
		;Se chegou aqui, o R5 esta disponivel. Armazenar
		MOV	R5, A
		SJMP	INIC

outro3:		;Se chegou aqui, o R5 esta disponivel. Armazenar
		MOV	R6, A

		SETB	EA		;Libera o botao secreto
		SJMP	COMPARAR

;********************COMPARA OS VALORES LIDOS********************
COMPARAR:
		;Comparar a senha inserida
		;Caractere por caractere
		CJNE	R2, #0EBH, TRAVA

		CJNE	R3, #7EH, TRAVA

		CJNE	R4, #7DH, TRAVA

		CJNE	R5, #0BEH, TRAVA

		CJNE	R6, #0B7H, TRAVA

		;Se chegou aqui, a senha está certa!
		SJMP	LIBERAR

;*****************LIBERA ACESSO*******************
LIBERAR:	;Liberar acesso
		CLR	P2.0
		ACALL 	DELAY
		CLR	P2.1
		ACALL 	DELAY
		CLR	P2.2
		ACALL 	DELAY
		CLR	P2.3
		ACALL 	DELAY
		CLR	P2.4
		ACALL 	DELAY
		CLR	P2.5
		ACALL 	DELAY
		CLR	P2.6
		ACALL 	DELAY
		CLR	P2.7

		JNB	20H.0,$
		;Se chegou aqui, resetou
		JMP	SETUP

;*******************TRAVA ACESSO***********************
TRAVA:
		MOV	P2, #0H
		ACALL 	DELAY
		MOV	P2, #0FFH
		ACALL 	DELAY
		JNB	20H.0, TRAVA

		;Se chegou aqui, resetou
		JMP	SETUP

;**************************************************
DELAY:		MOV	R7, #20h
		NOP
		DJNZ	R7, $
		RET
;**************************************************
EXT_1:		;Reinicia o processo de insercao da senha
		SETB	20H.0
		MOV	P2, #0FFH
		RETI

END
