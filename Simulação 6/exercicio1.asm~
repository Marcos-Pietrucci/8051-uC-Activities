;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 1 ***************

		ORG	0
		SJMP	SETUP
;***************** EXT 0 ********************;
		ORG	003H
		CLR	20H.0	;Limpa o bit que retorna o programa
		RETI

;***************** EXT 1 ********************;
		ORG	013H
		SETB  	20H.0	;Seta o bit que para o programa
		RETI

;***************** Programa *****************;
SETUP:
		SETB EA		;Habilita interrupcoes
		SETB EX0	;Habilita a interr. externa 0
		SETB IT0	;Configura a ext0 como descida de borda
		SETB EX1	;Habilita a interr. externa 1
		SETB IT1	;Configura a ext1 como descida de borda

		CLR  	20H.0	;Bit de controle do estado


INICIO:		MOV	A, #00
LOOP:		MOV	R0, A
		ACALL	CONVBCD
		JB	20H.0, $	;Para o programa
		ACALL	MOSTRA_LED
		ACALL	DELAY
		MOV	A, R0
		INC	A
		CJNE	A, #064H,LOOP
		SJMP	INICIO

;****************** Método de contador BCD do slide *******************;

CONVBCD:	MOV	B, #0AH
		DIV	AB
		MOV	R2,A
		MOV	R1,B
		SWAP	A
		ORL	A,R1
		RET

;***************** Mostra o resultado nos LEDs P2 *****************;
MOSTRA_LED:	MOV	A,R2
		SWAP	A
		ORL	A,R1
		CPL	A
		MOV	P2,A
		RET

;**************** Função de Delay ******************************;
DELAY:		; START: Wait loop, time: 400 us
		; Clock: 12000.0 kHz (12 / MC)
		; Used registers: R0
		MOV	R3, #00C7h
		NOP
		DJNZ	R3, $
		RET
		; Rest: 0
		; END: Wait loop

END
