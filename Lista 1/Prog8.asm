		ORG 	0000H

SETUP:		MOV 	R0, #0H			;Quantidade de nros lidos
		MOV	R2, #0H			;Quantidade de nros pares
		MOV	R3, #0H			;Quantidade de nros impares
		MOV 	DPTR, #Valor		;Ponteiro para vetor

		;Configuracao serial
		MOV	SCON, #40H 		; Modo 1 do canal serial
		MOV 	TMOD, #00100000b	;TC1 modo 2

LOOP:		MOV	A, R0
		INC	R0
		CJNE	R0, #0BH, continua
		SJMP 	FINALIZA

continua:	MOVC	A, @A+DPTR		;Comando para mover valor
		MOV	R1, A			;Armazena o valor lido
		MOV	B, #2H			;Divisor
		DIV	AB			;Resto vai para o registrador B
		MOV	A, B
		CJNE	A, #1H, Nro_Par
		SJMP	Nro_impar

		SJMP	Finaliza

;***********************************************************************************
Nro_Par:	MOV 	P1, R1
		MOV	A, R1
		;Enviar serial com 9600,N,8,1.
		;Configura transmissao serial
		;Calcular a taxa de comunicação
		;Pelos valores dados:
		MOV 	TL1, #253D	;TH1 = 256 −(11,0592∗10ˆ6)/(384∗9600) = 253
		MOV	TH1, #253D
		SETB	TR1

		MOV 	SBUF, A		;Transmite o numero

		JNB	TI,$		;Espera transmissao
		CLR	TI
		INC	R2		;Armazena quantidade de pares
		SJMP 	LOOP

Nro_impar:	MOV	P2, R1
		MOV	A, R1

		;Enviar serial com 4800,N,8,1
		;Configura transmissao serial
		;Calcular a taxa de comunicação
		;Pelos valores dados:
		MOV 	TL1, #250D	;TH1 = 256 −(11,0592∗10ˆ6)/(384∗4800) = 250
		MOV	TH1, #250D
		SETB	TR1

		MOV 	SBUF, A		;Transmite o numero

		JNB	TI,$		;Espera transmissao
		CLR	TI
		INC	R3	;Armazena quantidade de impares
		SJMP 	LOOP

Finaliza:	;Mover para a RAM externa
		MOV	DPTR, #2030H
		MOV	A, R2
		MOVX	@DPTR, A

		MOV	DPTR, #2031H
		MOV	A,R3
		MOVX	@DPTR, A

		SJMP	$

Valor: DB 	54, 23, 88, 215, 189, 98, 8, 11, 28, 100

END
