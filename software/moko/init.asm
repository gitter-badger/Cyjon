; Copyright (C) 2013-2015 Wataha.net
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

; 64 Bitowy kod programu
[BITS 64]

initialization:
	; tworzenie dokumentu rozpocznij za kodem programu od adresu pełnej strony
	mov	rdi,	stop
	call	library_align_address_up_to_page

	; zapisz adres początku dokumentu
	mov	qword [variable_document_address_start],	rdi
	mov	qword [variable_cursor_indicator],	rdi	; wskaźnik kursora na początku dokumentu

	; zapisz adres końca dokumentu
	mov	qword [variable_document_address_end],	rdi
	add	qword [variable_document_address_end],	VARIABLE_MEMORY_PAGE_SIZE

	; poproś o przestrzeń o rozmiarze jednej strony
	mov	rcx,	1

	; zarezerwuj miejsce (rejestracja w tablicy stronicowania programu)
	mov	ax,	0x0003
	int	0x40	; wykonaj

	; pobierz informacje o ekranie
	mov	ax,	0x0106
	int	0x40

	; zapisz rozmiar ekranu w znakach
	mov	qword [variable_screen_size],	rbx

	;-----------------------------------------------------------------------
	; wyświetl interfejs ---------------------------------------------------

	; wyczyść ekran
	mov	ax,	0x0100
	int	0x40	; wykonaj

	xor	rcx,	-1

	; ustaw tło nagłówka
	mov	ax,	0x0102
	mov	rbx,	VARIABLE_COLOR_BACKGROUND_DEFAULT
	mov	ecx,	dword [variable_screen_size]
	mov	r8,	VARIABLE_ASCII_CODE_SPACE
	mov	rdx,	VARIABLE_COLOR_DEFAULT
	int	0x40

	; ustaw kursor w pozycji nazwy pliku
	mov	ax,	0x0105
	mov	ebx,	1	; wiersz 0, kolumna 1
	int	0x40

	; wyświetl nazwę pliku
	mov	ax,	0x0101
	mov	rbx,	VARIABLE_COLOR_BACKGROUND_DEFAULT
	mov	rdx,	VARIABLE_COLOR_DEFAULT

	; sprawdź czy plik został wczytany lub zapisany pod konkretną nazwą
	cmp	qword [variable_file_name_chars_count],	VARIABLE_EMPTY
	je	.new_file

	; plik posiada nazwę własną
	mov	rcx,	qword [variable_file_name_chars_count]
	mov	rsi,	variable_file_name_buffor

	jmp	.named

.new_file:
	mov	rsi,	text_header_default

.named:
	int	0x40

	mov	rcx,	-1

	; ustaw kursor w pozycji menu
	mov	ax,	0x0105
	mov	ebx,	dword [variable_screen_size + 0x04]
	dec	rbx	; liczymy od ZERA
	shl	rbx,	32
	int	0x40

	; skrót X ==============================================================
	mov	ax,	0x0101
	mov	rbx,	VARIABLE_COLOR_BACKGROUND_DEFAULT
	mov	rdx,	VARIABLE_COLOR_DEFAULT
	mov	rsi,	text_exit_shortcut
	int	0x40

	; opis
	xchg	rbx,	rdx
	mov	rsi,	text_exit
	int	0x40
	
	; inicjalizuj początkową pozycje kursora na ekranie
	mov	ax,	0x0105
	mov	rbx,	VARIABLE_CURSOR_POSITION_INIT
	int	0x40

	; powrót z procedury
	ret
