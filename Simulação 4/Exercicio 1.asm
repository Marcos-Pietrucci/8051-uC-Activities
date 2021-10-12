;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 1 ***************
ORG 0
		SJMP SETUP
;*************************************
ORG 0003h ;Local da intrrupcao externa 0
		SJMP EXT_0
;*************************************
ORG 000BH ; Local da interrupcao por overflow do timer 0
		SJMP TIMER_0
;*************************************

SETUP:		SETB EA		;Habilita interrupcoes
		SETB EX0	;Habilita a interr. ext0
		SETB IT0	;Configura a ext0 como descida de borda
		SETB ET0	;Habilita a interr. do timer 0
		MOV TMOD, #1h   ;#0000001b Deixar disparo por software no modo de temporizador do modo 1

		SETB 20H.0	;Configura o bit de flag

		MOV TL0, #0E7H	;Insere os valores iniciais no T0
		MOV TH0, #0FFH	;Frequencia de 20kHz == 100 microsegundos de período == 50 micros ligados e 50 micros desligados

		SETB TR0	;Começa a largada do timer 0

LOOP:		JB   20H.0, $	;Fica no loop de 20KHz
		JNB  20H.0, $	;Fica no loop de 10KHz
		SJMP LOOP

;***************** INTERRUPCAO TIMER 0 ********************
TIMER_0:	CPL P2.0	;Pisca o LED

VERIFICA:	JNB 20H.0, MODO10	;Verifica o estado do bit flag e seta valores correspondentes
		MOV TL0, #0E7H		;Frequencia de 10kHz == 50 microsegundos de período == 25 micros ligados e 25 micros desligados
		MOV TH0, #0FFH
		RETI

MODO10:		MOV TL0, #0CEH		;Frequencia de 20kHz == 100 microsegundos de período == 50 micros ligados e 50 micros desligados
		MOV TH0, #0FFH
		RETI

;**************** INTERRUPCAO EXTERNA 0 ********************
EXT_0:		CPL 20H.0
		SJMP	VERIFICA       ;Chama a função que verifica. Ela própria (verifica) dá o RETI

END
