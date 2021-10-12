		ORG 0000H
		SJMP SETUP

		ORG 0003H
		SJMP EXT_0_S1

		ORG 0013H
		SJMP EXT_1_S2

SETUP:		;Configurar as interrupções
		SETB EA
		SETB EX0
		SETB EX1
		SETB IT0
		SETB IT1
		SETB PX0
		SETB PX1

		;O tanque começa vazio enchendo
		SETB	P1.1	;V2
		CLR	P1.0	;V1

		SJMP	$

;*********************************************************
EXT_0_S1:	; Passou por S1, encher o tanque
		SETB	P1.1	;V2
		CLR	P1.0	;V1
		RETI

;*********************************************************
EXT_1_S2:	; Passou por S1, esvaziar o tanque
		CLR	P1.1	;V2
		SETB	P1.0	;V1
		RETI

END
