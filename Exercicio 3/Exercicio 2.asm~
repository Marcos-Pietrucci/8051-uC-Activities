;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 1 ***************
ORG		0

core_loop:		JNB P3.5, acende_0
			JNB P3.6, acende_1
			JNB P3.7, pisca_alternado

			SJMP core_loop

;Procedimentos para acender o LED 0
acende_0:		SETB	P1.1
			SETB	P1.2
			CPL	C
			MOV	P1.0, C
			ACALL Atraso
			SJMP core_Loop

;Procedimentos para acender o LED 1
acende_1:		SETB 	P1.0
			SETB	P1.2
			CPL	C
			MOV	P1.1, C
			ACALL Atraso
			SJMP core_loop

;Procedimentos para acender os LEDs alternadamente
pisca_alternado:	SETB	P1.1
			MOV	P1.0, C
			CPL	C
			MOV	P1.2, C
			ACALL	Atraso
			SJMP	core_loop


Atraso:			MOV 	R1, #12		; Não é exatamente 1 segundo em ciclos de máquina, mas na simulação é aproximado
Loop:			MOV	R0, #12
			DJNZ	R0, $
			DJNZ	R1, Loop
			ret

END
