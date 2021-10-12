;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 2 ***************
		ORG	0
		SJMP	PROG
;**************** Interrupcao serial *****************
		ORG	0023H
		CLR 	EA
		CLR	TI
		CLR	RI
		MOV 	A, SBUF

		CJNE	A,#47H,COMP	;Comparacao
		CLR	P2.0
		SJMP	FIM_INT

COMP:		CJNE	A,#59H,COMP1	;Comparacao
		CLR	P2.4
		SJMP	FIM_INT

COMP1:		CJNE	A,#52H,COMP2	;Comparacao
		CLR 	P2.7
		SJMP	FIM_INT

COMP2:		CJNE	A,#44H, FIM_INT	;Comparacao
		MOV	P2,#0FFH

FIM_INT:	SETB	EA
		RETI

;**************************************************
PROG:		SETB 	EA		;Configurações iniciais
		SETB	ES
		MOV	TMOD,#20H
		MOV	SCON,#50H
		MOV	TL1,#253
		MOV	TH1,#253
		MOV	PCON,#80H
		SETB	TR1		;Inicia o contador

;***************************************************
REC_SERIAL:	SJMP	$

END

