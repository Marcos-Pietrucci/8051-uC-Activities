		ORG 0000H
		SJMP SETUP

		ORG 0003H
		SJMP EXT_0

		ORG 0013H
		SJMP EXT_1

SETUP:		;Configurar as interrupções
		SETB EA
		SETB EX0
		SETB EX1
		SETB IT0
		SETB IT1

		;Inicia o teste, baixar o recipiente
		SETB	P2.7
		SETB	P2.6
		CLR	P1.2	;Desliga aquecimento
		CLR	P1.0	;Desliga resfriamento

		;Contador de vezes
		MOV	R3, #0H

		;Garantir que o processo ocorra 3 vezes
		CJNE	R3, #3H, $

		SJMP	$

;*********************************************************
EXT_0:		;Presenca do recipiente para aquecer
		CLR	P2.6		;Parar o motor
		SETB	P1.2		;Liga aquecimento
		ACALL	Delay500
		CLR	P1.2		;Desliga aquecimento
		CLR	P2.7		;Inverte sentido do motor
		SETB	P2.6		;Liga motor
		RETI

;*********************************************************
EXT_1:		;Presença de recipiente para resfriar
		CLR	P2.6		;Parar o motor
		SETB	P1.0		;Liga resfriamento
		ACALL	Delay500
		CLR	P1.0		;Desliga resfriamento
		SETB	P2.7		;Inverte sentido do motor
		SETB	P2.6		;Liga motor

		INC	R3		;Incrementa o contador de vezes

;**********************************************************

Delay500:
; START: Wait loop, time: 500 ms
; Clock: 12000.0 kHz (12 / MC)
; Used registers: R0, R1, R2
		MOV	R2, #004h
		MOV	R1, #0FAh
		MOV	R0, #0F8h
		NOP
		DJNZ	R0, $
		DJNZ	R1, $-5
		DJNZ	R2, $-9
		RET
; Rest: -13.0 us
END

