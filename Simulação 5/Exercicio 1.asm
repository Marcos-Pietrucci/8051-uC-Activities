;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 1 ***************


		ORG 0
		MOV	TMOD,#20H	;Configuração inicial
		MOV	SCON,#50H
		MOV	TL1,#253
		MOV	TH1,#253
		MOV	PCON,#80H
		SETB	TR1		;Inicia o contador

LIMPA:		MOV	P2,#0FFH
LOOP:		ACALL	REC_SERIAL

		CJNE	A,#47H,COMP	;Primeira comparação
		CLR	P2.0
		SJMP	LOOP
COMP:		CJNE	A,#59H,COMP1	;Comparação
		CLR	P2.4
		SJMP	LOOP
COMP1:		CJNE	A,#52H,COMP2	;Comparação
		CLR 	P2.7
		SJMP	LOOP
COMP2:		CJNE	A,#44H,LOOP	;Comparação
		SJMP	LIMPA

;*********************************
REC_SERIAL:	JNB	RI,$		;Loop
		MOV	A,SBUF
		CLR	RI
		RET
END
