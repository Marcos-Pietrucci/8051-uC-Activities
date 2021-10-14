		ORG 0000H
		SJMP SETUP

		ORG 0003H
		SJMP EXT_0

SETUP:		;Configurar as interrupções
		SETB 	EA
		SETB 	EX0
		SETB 	IT0

		;O robô começa andando para frente
		SETB	P1.0
		SETB	P1.1
		SETB	P1.2
		SETB	P1.3

		;Bit de direção a virar
		CLR	20H.0

		SJMP	$

;*********************************************************
EXT_0:		CLR	EX0	;Desabilita interrupt

		;Marcha ré
		CLR	P1.1
		CLR	P1.3
		CALL	DELAY_2S

		JB	20H.0,Esq

Dir:		;Virar a direita por 2s
		SETB	P1.1
		CLR	P1.3
		CALL	DELAY_2S
		SJMP	retorno

Esq:		;Virar a esquerda por 2s
		CLR	P1.1
		SETB	P1.3
		CALL	DELAY_2S

retorno:	;Voltar o robô para frente
		SETB	P1.1
		SETB	P1.3
		CPL	20H.0	;Inverte direção de virar
		SETB	EX0
		RETI
;*********************************************************
DELAY_2S:
; START: Wait loop, time: 2 s
; Clock: 12000.0 kHz (12 / MC)
; Used registers: R0, R1, R2, R3
		MOV	R3, #003h
		MOV	R2, #0D2h
		MOV	R1, #00Ch
		MOV	R0, #082h
		NOP
		DJNZ	R0, $
		DJNZ	R1, $-5
		DJNZ	R2, $-9
		DJNZ	R3, $-13
		MOV	R1, #006h
		MOV	R0, #0BAh
		NOP
		DJNZ	R0, $
		DJNZ	R1, $-5
		NOP
		NOP
		NOP
		RET
; Rest: 0
; END: Wait loop


END
