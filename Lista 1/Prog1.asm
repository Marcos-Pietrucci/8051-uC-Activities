		ORG 0000H
		SJMP SETUP

		ORG 000BH ;Interrupção do timer 0
		SJMP TC0_subrotina

SETUP:		SETB 	EA
		SETB	ET0
		MOV  	TMOD, #1H ;Software, temporizador modo 1
		MOV  	TH0, #0FFH 	; TC0 = 0.05s
		MOV  	TL0, #006H

		MOV  	R0, #100D	; Serão 100 interrupcoes do TC0
		SETB	20H.0		; Bit de controle

		SETB TR0


;***********Programa de 5s*******

LOOP:		JB	20H.0, $ 	; Aguarda imterrupcao do TC0

		DEC	R0
		setb 	P2.0
		SETB 	20H.0
		CJNE	R0,#0H, LOOP

		SJMP	$		; Fim lógico do programa


;*****************************
TC0_subrotina:	CLR 20H.0
		CLR P2.0
		MOV  	TH0, #0FFH 	; TC0 = 0.05s
		MOV  	TL0, #006H
		RETI