; Copyright (C) 2013-2016 Wataha.net
; All Rights Reserved
;
; LICENSE Creative Commons BY-NC-ND 4.0
; See LICENSE.TXT
;
; Main developer:
;	Andrzej (akasei) Adamczyk [e-mail: akasei from wataha.net]
;-------------------------------------------------------------------------------

; Use:
; nasm - http://www.nasm.us/

; kolory, stałe
%include	'config.asm'

; 64 Bitowy kod programu
[BITS 64]

; adresowanie względne (skoki, etykiety)
[DEFAULT REL]

; adres kodu programu w przestrzeni logicznej
[ORG VARIABLE_MEMORY_HIGH_REAL_ADDRESS]

start:
	; ustaw wskaźnik na tablice
	mov	rsi,	command_table + 0x08	; pomiń pierwszą wartość

	; pobierz rozmiar komórki 'polecenie'
	mov	r8,	qword [rsi - 0x08]

	; procedura - wyświetl ciąg znaków na ekranie w miejscu kursora
	mov	ax,	0x0101

	; domyślny kolor tła
	mov	rdx,	VARIABLE_COLOR_BACKGROUND_DEFAULT

.loop:
	; sprawdź czy koniec tablicy?
	cmp	qword [rsi],	VARIABLE_EMPTY
	je	.end	; tak

	; wyświetl polecenie
	mov	ebx,	VARIABLE_COLOR_DEFAULT
	mov	rcx,	r8	; rozmiar ciągu znaków
	int	0x40	; wykonaj

	; zachowaj wskaźnik
	push	rsi

	; przesuń wskaźnik na opis polecenia
	mov	rsi,	qword [rsi + r8]

	; wyświetl opis polecenia
	mov	ebx,	VARIABLE_COLOR_GRAY
	mov	rcx,	-1	; wyświetl cały ciąg
	int	0x40	; wykonaj

	; przywróć wskaźnik
	pop	rsi

	; przesuń wskaźnik na następny rekord
	add	rsi,	r8	; rozmiar komórki 'polecenie'
	add	rsi,	0x08	; rozmiar wskaźnika do ciągu opisu

	; kontynuuj
	jmp	.loop

.end:
	; wyjdź z programu
	xor	ax,	ax
	int	0x40	; wykonaj

command_table:
	dq	7	; rozmiar komórki 'polecenie'

	db	'args   '
	dq	text_args

	db	'clear  '
	dq	text_clear

	db	'date   '
	dq	text_date

	db	'exit   '
	dq	text_exit

	db	'help   '
	dq	text_help

	db	'ls     '
	dq	text_ls

	db	'moko   '
	dq	text_moko

	db	'ps     '
	dq	text_ps

	db	'uptime '
	dq	text_uptime

	; koniec tablicy
	dq	VARIABLE_EMPTY

text_args	db	"example: transfer variables(args) from command line to process,", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
text_clear	db	"clean console screen,", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
text_date	db	"display the current time,", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
text_exit	db	"logout,", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
text_help	db	"yes, it's me,", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
text_ls		db	"show files owned by user,", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
text_moko	db	"system text editor,", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
text_ps		db	"displays information about active processes,", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
text_uptime	db	"tells how long the system has been running.", VARIABLE_ASCII_CODE_ENTER, VARIABLE_ASCII_CODE_NEWLINE, VARIABLE_ASCII_CODE_TERMINATOR
