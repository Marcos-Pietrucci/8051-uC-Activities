;Marcos Vinícius Firmino Pietrucci 10770072
; Lista 2
; Exercício 3

;Teclado matricial conectado no port1
;LED no P3.2 e P3.4

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

outro2:		;Se chegou aqui, o R5 esta disponivel. Armazenar
		MOV	R5, A

		SJMP	COMPARAR

; 0   1   2  3 4  5  6  7  8 9   A  B  C D   E  F
; 77 EE ED EB E7 DE DD DB D7 BE BD BB B7 7E 7D 7B
;********************COMPARA OS VALORES LIDOS********************
COMPARAR:
		;Comparar a senha inserida
		;Caractere por caractere
		CJNE	R2, #0E7H, TESTA_SENHA2 ; 4

		CJNE	R3, #0BDH, TESTA_SENHA2 ; A

		CJNE	R4, #07EH, TESTA_SENHA2 ; D

		CJNE	R5, #0EBH, TESTA_SENHA2 ; 3

		;Se chegou aqui, a senha 1 está certa!
		SJMP	LIBERAR_1

TESTA_SENHA2:	CJNE	R2, #0B7H, ERRO ; C

		CJNE	R3, #0BDH, ERRO ; A

		CJNE	R4, #0BBH, ERRO ; B

		CJNE	R5, #07DH, ERRO ; E

		;Se chegou aqui, a senha 2 está certa!
		SJMP	LIBERAR_2

;***************************************************************
;Executa as ações após liberar
LIBERAR_1:
		CLR	P3.2	;Acende o LED1

		;Preencher a memoria externa. Vai de 0000 até FFFF
		MOV	DPTR, #0000H
		MOV	R6, #00H	;MSB
		MOV	R5, #00H	;LSB


loop_memoria:	CJNE	R6, #0FFH, continua
		SJMP	Volta

		;Coloca o valor menos significativo
continua:	MOV	A, R5
		MOVX	@DPTR, A

		;Incrementos
		INC	DPTR
		INC	R5
		JNB	OV, loop_memoria	;Se deu overflow no LSB
		INC	R6
		SJMP	loop_memoria

;***************************************************************
;Executa as ações após liberar
LIBERAR_2:	CLR	P3.2	;Acende o LED2

		;Zerar a RAM externa
		MOV	A, #0H
		MOV	DPTR, #0000H
		MOV	R6, #00H	;MSB
		MOV	R5, #00H	;LSB


loop_memoria2:	CJNE	R6, #0FFH, continua2
		JMP	Volta

		;Coloca o valor menos significativo
continua2:	MOVX	@DPTR, A

		;Incrementos
		INC	DPTR
		INC	R5
		JNB	OV, loop_memoria2	;Se deu overflow no LSB
		INC	R6
		SJMP	loop_memoria2
;****************************************************************
;Senha errada digitada
ERRO:
		;Preencher a RAM externa com FF
		MOV	A, #0FFH
		MOV	DPTR, #0000H
		MOV	R5, #00H	;Armazena o mesmo valor que DPTR
		MOV	R6, #00H
		MOV	R4, #00H	;Armazena a parte menos significativa

loop_memoria3:	CJNE	R6, #0FFH, continua3
		SJMP	blink_LEDS

continua3:	MOVX	@DPTR, A

		INC	DPTR
		INC	R5

		CJNE	R5, #0FFH, loop_memoria3
		INC	R6
		SJMP	loop_memoria3

blink_LEDS:	;Piscar os leds conforme pedido
		CLR	P3.2
		SETB	P3.4
		ACALL	DELAY
		SETB	P3.2
		CLR	P3.4
		ACALL	DELAY
		SJMP	blink_LEDS

;****************************************************************
DELAY:
; Esperar 10Hz
; START: Wait loop, time: 100 ms
; Clock: 12000.0 kHz (12 / MC)
; Used registers: R4, R5, R6
		MOV	R6, #004h
		MOV	R5, #0A0h
		MOV	R4, #04Ch
		NOP
		DJNZ	R4, $
		DJNZ	R5, $-5
		DJNZ	R6, $-9
		MOV	R4, #049h
		DJNZ	R4, $
		RET
; Rest: 0
; END: Wait loop

END

