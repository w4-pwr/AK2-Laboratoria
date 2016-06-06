.data
	start_msg: .ascii "Wprowadz 1 aby dodac lub 2 aby odjac liczby z pliku input.txt\n3 wyjscie z programu\n"
	start_msg_len = .-start_msg
	buf: .ascii "00/n"
	buf_arg: .ascii "00/n"
	add_msg: .ascii "dodawanie\n"
	add_msg_len = .-add_msg
	mul_msg: .ascii "mnozenie\n"
	mul_msg_len = .-mul_msg
	bledna_liczba: .ascii "\nPodano zla liczbe\n"
	bledna_liczba_len = .-bledna_liczba
.text
	in_filename: .ascii "input.txt\0"
	out_filename: .ascii "output.txt\0"
.global _start
_start:
	mov $1, %rax
	mov $1, %rdi
	mov $start_msg, %rsi
	mov $start_msg_len, %rdx
	syscall

pobieranie_z_klawiatury:
	mov $0, %rax
	mov $0, %rdi
	mov $buf_arg, %rsi
	mov $2, %rdx
	syscall
	#sprawdzam co wpisano
	movb (buf_arg), %r8b
	cmp $49, %r8
	je dodawanie
	movb (buf_arg), %r8b
	cmp $50, %r8
	je mnozenie
	movb (buf_arg), %r8b
	cmp $51, %r8
	je koniec
	dec %rax
	jmp zly_argument	

koniec:
	nop
	mov $60, %rax
	mov $0, %rdi
	syscall

dodawanie:
	mov $1, %rax
	mov $1, %rdi
	mov $add_msg, %rsi
	mov $add_msg_len, %rdx
	syscall
	
	call wczytaj_liczby

	mov %r12, %r14
	add %r13, %r14

	call wyswietl_liczby_r14

	mov %r12, %r14
	add %r13, %r14

	call zapisz_r14
	jmp koniec

mnozenie: 
	mov $1, %rax
	mov $1, %rdi
	mov $mul_msg, %rsi
	mov $mul_msg_len, %rdx
	syscall
	call wczytaj_liczby

	mov %r12, %rax
	mov %r13, %rbx
	mul %rbx
	mov %rax, %r14

	call wyswietl_liczby_r14

	mov %r12, %rax
	mov %r13, %rbx
	mul %rbx
	mov %rax, %r14

	call zapisz_r14
	jmp koniec

zly_argument:
	mov $1, %rax
	mov $1, %rdi
	mov $bledna_liczba, %rsi
	mov $bledna_liczba_len, %rdx
	syscall
	jmp _start

#pierwsza liczba zostaje wczytana do r12 druga r13
wczytaj_liczby:
	mov $0, %r12
	mov $0, %r13 #wyzerowanie rejestrow do przetrzymywania liczb

	mov $2, %rax  #odczytywanie z pliku syscall
	mov $in_filename, %rdi
	mov $00, %rsi #ustawienie flagi otwarcia pliku
	syscall

	mov %rax, %r8 #zapisanie strumienia do r8

wczytaj_pierwsza_liczbe:
	mov $0, %rax
	mov %r8, %rdi
	mov $buf, %rsi
	mov $1, %rdx #odczytywanie po 1 znaku z pliku
	syscall
	cmp $0, %rax #sprawdzenie EOF
	je brak_drugiej_liczby
	movb (buf), %r9b
	cmp $10, %r9
	je wczytaj_druga_liczbe
	cmp $32, %r9 #sprawdzanie czy byla spacja
	je wczytaj_druga_liczbe
	sub $48, %r9
	mov %r12, %rax
	mov $10, %rbx
	mul %rbx
	add %r9, %rax
	mov %rax, %r12
break:
	jmp wczytaj_pierwsza_liczbe

wczytaj_druga_liczbe: #druga liczba w r13
	mov $0, %rax
	mov %r8, %rdi
	mov $buf, %rsi
	mov $1, %rdx #odczytywanie po 1 znaku z pliku
	syscall
	cmp $0, %rax #sprawdzenie EOF
	je koniec
	movb (buf), %r9b
	cmp $10, %r9
	je skoncz_wczytywanie
	cmp $32, %r9 #sprawdzanie czy byla spacja
	je skoncz_wczytywanie
	sub $48, %r9
	mov %r13, %rax
	mov $10, %rbx
	mul %rbx
	add %r9, %rax
	mov %rax, %r13
	jmp wczytaj_druga_liczbe	
skoncz_wczytywanie:
	ret


brak_drugiej_liczby:
	nop
	jmp koniec


wyswietl_liczby_r14:
	cmp $0, %r14
	je wyswietl_zero
	
	mov $1, %r15 #w r15 trzymam dlugosc wyniku do wyswietlenia
	mov $1, %r10


loop_wyswietlania:
	mov %r10, %rax
	mov $10, %rbx
	mul %rbx
	mov %rax, %r10 #w r10 dzielnik
	cmp %r14, %rax
	jg podzielone
	add $1, %r15
	jmp loop_wyswietlania	
podzielone:
	mov %r14, %r8
	sub $1, %r15

	cmp $0, %r15
	je wyswietl

	mov %r15, %r9 #r9 jako licznik petli
	mov $1, %r10
dziel:
	mov %r8, %rax
	mov $10, %rbx
	div %rbx
	mov %rax, %r8
	mov %r10, %rax
	mul %rbx
	mov %rax, %r10
	sub $1, %r9
	mov %r9, %rax
brejk:	
	nop
	cmp $0, %rax
	je wyswietl
	jmp dziel

	#wyswietlanie
wyswietl:
	mov %r10, %rax
	mov %r8, %rbx
	mul %rbx

	sub %rax, %r14
	add $48, %r8

cotujest:
	movb %r8b, (buf)
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall
	
	mov %r15, %rax
	cmp $0, %rax
	je koniec_wyswietlania
	jmp wyswietl_liczby_r14
	
koniec_wyswietlania:
	ret
wyswietl_zero:
	
	mov $1, %rax
	mov $1, %rdi
	mov $48, %rsi
	mov $1, %rdx
	syscall
	ret


zapisz_r14:
	mov $3, %rax #zamkniecie pliku
	mov $1, %rdi
	syscall

	mov $2, %rax
	mov $out_filename, %rdi
	mov $02, %rsi
	mov $1, %rdx
	syscall

	mov %rax, %r9
	
	mov %r15, (buf)
	mov $1, %rax
	mov %r8, %rdi
	mov $1, %rsi
	mov $1, %rdx
	syscall	

	mov $3, %rax #zamkniecie pliku
	mov $1, %rdi
	syscall

	ret



