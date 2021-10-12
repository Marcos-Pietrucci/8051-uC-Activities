;***********************************************
;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ********* PROGRAMA 2 ***************

ORG		0
		SJMP 	PROG

ORG		0003H
		SJMP 	EXT_0

PROG:		SETB 	EA		;Configurar interrupcao
		SETB 	EX0
		SETB 	IT0
		SETB 20H.0		;O endereço de memoria 20 armazena o estado do programa

Opcao1:		CPL  P2.2		;Loop com a opção de atraso 1
		ACALL ATRASO1
		JB  20H.0, Opcao1

Opcao2:		CPL  P2.2		;Loop com a opção de atraso 2
		ACALL ATRASO2
		JNB 20H.0, Opcao2

		SJMP Opcao1

; START: Wait loop, time: 100 us
; Clock: 12000.0 kHz (12 / MC)
; Used registers: R0
ATRASO1:	MOV	R0, #031h
		NOP
		DJNZ	R0, $
		RET
; Rest: 0
; END: Wait loop

; START: Wait loop, time: 200 us
; Clock: 12000.0 kHz (12 / MC)
; Used registers: R0
ATRASO2:	MOV	R0, #063h
		NOP
		DJNZ	R0, $
		RET
; Rest: 0
; END: Wait loop

;********************** INTERRUPCAO EXTERNA 0************************************;
EXT_0:
		CPL	20H.0
		RETI