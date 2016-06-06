SYSCALL = 0x80
EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
STDIN = 0
LICZBA_LITER_ALFABETU = 'Z'-'A'-1
ZERO = 0
DUZA_LITERA = 0x20
BREAK_LINE = 2
BAZA_SYSTEMU = 10
WYPELNIENIE_JEDYNKAMI = -1
Z_DEC_DO_HEX = 7

.data 
#bufor do przechowywania tekstu do szyfrowania
buf_size = 31
text_size: .long 0
bufor: .space buf_size

horner_buf: .long 31
inv_horner_buf: .long 31

.text
.global _start

_start:
#wczytwanie z klawiatury do bufora ciagu znakow do zakodowania 
movl $READ, %eax
movl $STDIN, %ebx
movl $bufor, %ecx
movl $buf_size, %edx
int  $SYSCALL

movl %eax, text_size #liczba wpisanych znakow w text_size
subl $BREAK_LINE, text_size #odjecie entera od liczby znakow

# --------------START - CZYTANIE BIN W ASCII DO REJESTRU EAX
movl $ZERO, %eax #miejsce gdzie bede przechowywac wartosc
movl $WYPELNIENIE_JEDYNKAMI, %esi

CZYTAJ_ZNAK:
	incl %esi
	movb bufor(%esi,1), %bl

	#zakladam że wprowadzane sa tylko 0 i 1
	subb $'0', %bl #wartosc ze znaku ASCII, 1 lub 0
	shll $1, %eax #przesuniecie w prawo o 1, zeby zrobic miejsce na nowy bit
	orb %bl, %al #zamiana najmłodego bitu jeśli na wejsciu jest '1' (czyt. z bufora)

	#sprawdzenie czy koniec bufora
	cmp text_size, %esi #czy koniec bufora?
	jb CZYTAJ_ZNAK #wroc do petli jesli to nie koniec bufora

# --------------KONIEC - CZYTANIE BIN W ASCII DO REJESTRU EAX
#teraz w rejestrze EAX, powinna byc wartosc tego co wpisal uzytkownik jako kod binarny
_t0: #pulapka dla debuggera

# --------------START - SCHEMAT HORNERA
movl $ZERO, %esi #wyzerowanie licznika od bufora horner_buf 

#schemat Hornera
HORNER:
	cdq #Convert Double to Quad
	movl $BAZA_SYSTEMU, %ebx #będziemy dzielic przez bazę systemu
	div %ebx #dzielimy przez baze systemu, wynik w EAX, reszta w EDX
	movl %edx, horner_buf(,%esi,1) #zapis reszty
	incl %esi
	cmpl $ZERO, %eax #czy to juz koniec?
	jne HORNER
# --------------STOP - SCHEMAT HORNERA


# --------------START - ZAMIANA WARTOSCI NA KODY ASCII W TABLICY HORNER_BUF

movl %esi, %eax
movl $ZERO, %esi
#zamiana kazdej wartosci w tablicy horner_buf na znak ASCII
HORNER_TO_ASCII:
	movb horner_buf(,%esi,1), %bl
	addb $'0', %bl # utworzenie znaku ASCII

	cmp $'9', %bl # jak większe od 9 to musi dodac inna wartosc
	jbe ZAMIANA_BUFORA
	addb $Z_DEC_DO_HEX, %bl # utworzenie znaku ASCII
	
	ZAMIANA_BUFORA:
	movb %bl, horner_buf(,%esi,1)
	incl %esi
	cmp %eax, %esi
	jne HORNER_TO_ASCII

# --------------STOP - ZAMIANA WARTOSCI NA KODY ASCII W TABLICY HORNER_BUF

# --------------START - ODWROCENIE BUFORA HORNER_BUF
movl %esi, %eax # %eax wykorzystane do sprawdzenia czy koniec bufora
movl %esi, %edi # wykorzystane do inv_horner_buf
movl $ZERO, %esi #zerowanie licznika który iteruje po horner_buf

INVERT_HORNER_BUF:
	movb horner_buf(,%esi,1), %bl
	movb %bl, inv_horner_buf(,%edi,1)
	incl %esi
	decl %edi
	cmp %eax, %esi
	jne INVERT_HORNER_BUF

incl %esi #dodatkowa cyfra do wyświetlenia
# --------------STOP - ODWROCENIE BUFORA HORNER_BUF

#wyswietlenie z bufora
WYSWIETL:
	movl $WRITE, %eax
	movl $STDOUT, %ebx
	movl $inv_horner_buf, %ecx
	movl %esi, %edx
	int  $SYSCALL
#poprawne wyjscie z programu
movl $EXIT, %eax
int  $SYSCALL


