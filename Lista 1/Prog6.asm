		ORG 	0000H
		SJMP 	SETUP

		ORG 	0003H
		SJMP 	EXT_0

		ORG 	000BH
		SJMP 	TC0

		ORG 	0013H
		SJMP 	EXT_1

		ORG 	001BH
		SJMP 	TC1

SETUP:		;Configurar as interrupções
		SETB 	EA
		SETB 	EX0
		SETB 	EX1
		SETB	ET0
		SETB	ET1
		SETB 	IT0
		SETB 	IT1
		MOV  	TMOD, #22H	;Modo dos contadores

		;Prioridades
		SETB	PX0
		CLR	PX1
		SETB	PT0
		CLR	PT1

		;Valores dos contadores
		MOV  	TH0, #0D8H
		MOV  	TL0, #0F0H
		MOV  	TH1, #015H
		MOV  	TL1, #0A0H

		SETB 	TR0
		SETB 	TR1

		SJMP	$

;*********************************************************
EXT_0:		MOV	DPTR, #5000H
		MOV	R0, P1
		MOVX	A, @DPTR
		MOV	P1, A
		MOV	A, R0
		MOVX	@DPTR, A
		RET

;*********************************************************
EXT_1:		MOV	DPTR, #5000H
		MOVX	A, @DPTR
		MOV	7FH, A
		RET

;**********************************************************
TC0:		MOV	A, 7FH
		MOV	DPTR, #5200H
		MOVX	@DPTR, A
		RET

;**********************************************************
TC1:		MOV	DPTR, #5200H
		MOVX	A,@DPTR
		MOV	DPTR, #5000H
		MOVX	@DPTR, A
END


