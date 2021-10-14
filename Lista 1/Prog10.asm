		ORG  0000H
		SJMP SETUP

		ORG  0003H
		SJMP EXT_0

SETUP:		;Configurar as interrupções
		SETB 	EA
		SETB 	EX0
		SETB 	IT0

		;Maquina comeca zerada
RESET:		SETB	P1.0
		SETB	P1.1
		SETB	P1.2
		CLR	P2.0
		CLR	P2.1
		CLR	P2.2

		;Armazena valor total inserido
		MOV	R0,#0H
		MOV	A, R0
LOOP:
		CJNE	A, #20D, TEST	;Compara valor total inserido com 20
TEST:		JNC	Resposta

		SJMP	LOOP

Resposta:	;Calcular se deve haver troco
		CJNE	A, #20D, TEST2
TEST2:		JC	LOOP
		MOV	A, R0
		CLR	C
		SUBB	A, #20D

		JNZ	tem_troco

		;Se veio aqui não tem troco
		SJMP	FIM_result

		;Verificar se a diferenca é 5
tem_troco:	CJNE	A, #5D, troco_nao_eh_5

		;Se veio aqui o troco é 5
		SETB	P2.1
		SJMP	FIM_result

troco_nao_eh_5:	;Verificar se a diferenca é 10
		CJNE	A, #10D, troco_nao_eh_10

		;Se veio aqui o troco é 10
		SETB	P2.2
		SJMP	FIM_result

troco_nao_eh_10:
		;Se o troco não é 5 nem 10 só pode ser 15
		SETB	P2.1
		SETB	P2.2
		SJMP	FIM_result

FIM_result:	SETB	P2.0	;Dá o doce
		MOV	R0,#0H
		SJMP	RESET

;*********************************************************
EXT_0:		CLR	EA	;Desabilita interrupt
		;Detectar qual moeda foi inserida
		JB	P1.2, NaoEh20

		;Se veio aqui eh 20
		MOV	R1, #20D
		SJMP	FIM_moeda

NaoEh20:	JB	P1.1, NaoEh10

		;Se veio aqui eh 10
		MOV	R1, #10D
		SJMP	FIM_moeda

NaoEh10:	JB	P1.0, FIM_moeda

		;Se veio aqui eh 5
		MOV	R1, #5D
		SJMP	FIM_moeda

		;Se veio aqui eh nada
FIM_moeda:	SETB	EA
		MOV	A,  R0
		ADD	A,  R1
		MOV	R0, A
		RETI

END

