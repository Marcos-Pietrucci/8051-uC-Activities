;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 2 ***************

ORG		0
		SJMP 	PROG

ORG		0003H
		SJMP 	EXT_0

PROG:		SETB 	EA
		SETB 	EX0
		SETB 	IT0
		SETB  	F0	; Flag 0 indica o estado do motor
				; F0 = 1 --> Horario
				; F0 = 1 --> Antihorario

horario:	SETB 	P2.1
		CLR 	P2.7
		JB 	F0, $	;Motores no horario aguardando interrupcao
				;Ao voltar da interrupcao, F0 sera 0. Sai do loop 'JB' e vai para 'antihorario'

antihorario:
		CLR	P2.1	;Antihorario
		JNB F0,$	;Aguarda nova interrupt
		SJMP horario	;Ao voltar da interrupcao, F0 sera 1. Sai do loop 'JB' e retorna ao 'horario'

;********************** INTERRUPCAO EXTERNA 0************************************;
EXT_0:
		JB F0, estado_horario ;Testa o estado do motor

				;Motor está no antihorario, parar por 10s e retornar
		SETB F0		;Altera o estado logico do programa
		SETB	P2.1	;Para o motor
		MOV R1, #8h 	;Move um valor para aguardar 10 segundos
		ACALL	aguarda
		RETI

estado_horario:			; Motor está no horario, parar por 5s e retornar
		CLR F0
		SETB	P2.7	;Parar o motor
		MOV R1, #4h	;Move um valor para aguardar 5 segundos
		ACALL	aguarda
		RETI

;********************** FUNDAO DE ATRASO ************************************;
aguarda:	MOV	A, R1
		MOV	R0,A
Loop:		DJNZ	R0, $
		DJNZ	R1, Loop
		RET
END
