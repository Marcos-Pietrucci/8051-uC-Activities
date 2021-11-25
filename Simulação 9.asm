;*	Marcos Vinícius Firmino Pietrucci      *
;*	10770072			       *
;***********************************************

; ****************** PROGRAMA ******************

;Lê caracteres do teclado matricial e exibe em display LDC 2x16

	;Pinos de controle de dados e de informações do LCD
	RS	EQU	P3.4
	RW	EQU	P3.3
	ENAB	EQU	P3.2
	DAT	EQU	P2

;************************************************

	ORG	0
SETUP:	ACALL	INIT_LCD
	ACALL	CLR_LCD
	MOV	A, #00	; O simlador não posiciona o cursos na posição 0
	ACALL	POS_LCD

;***** VARREDURA DO TECLADO MATRICIAL ************
INIC:	MOV	P1, #0FFH
	