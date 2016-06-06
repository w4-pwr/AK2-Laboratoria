SYSCALL = 0x80
EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
STDIN = 0
LICZBA_LITER_ALFABETU = 'Z'-'A'-1
ZERO = 0
DUZA_LITERA = 0x20

.data 
#informacja poczatkowa
informacja: .ascii "AK2 LAB2 - Szyfr Cezara\nmala litera - szyfrowanie\nDUZA LITERA - deszyfrowanie\n"
rozmiar_informacja = . - informacja # w jaki sposob to oblicza?

#informacja z prosba o wprowadzenie tekstu do zakodowania
prosba: .ascii "Prosze podac tekst: "
rozmiar_prosba = . - prosba 

#informacja z prosba o wprowadzenie klucza
prosba_o_klucz: .ascii "Prosze podac klucz: " 
rozmiar_prosba_o_klucz = . - prosba_o_klucz

#informacja o blednym kluczu
bledny_klucz: .ascii "Klucz musi byc cyfra"
rozmiar_bledny_klucz = . - bledny_klucz

#bufor do przechowywania klucza
klucz_buf_size = 7
klucz_size: .long 0
klucz_bufor: .space klucz_buf_size

#bufor do przechowywania tekstu do szyfrowania
buf_size = 31
text_size: .long 0
bufor: .space buf_size

.text
.global _start

_start:
#informacja o starcie programu
movl $WRITE, 			%eax
movl $STDOUT, 			%ebx
movl $informacja, 		%ecx
movl $rozmiar_informacja, 	%edx
int  $SYSCALL

#prosba o wpisanie tekstu do zakodowania
movl $WRITE, 			%eax
movl $STDOUT, 			%ebx
movl $prosba,	 		%ecx
movl $rozmiar_prosba,	 	%edx
int  $SYSCALL

#wczytwanie z klawiatury do bufora ciagu znakow do zakodowania 
movl $READ, %eax
movl $STDIN, %ebx
movl $bufor, %ecx
movl $buf_size, %edx
int  $SYSCALL

movl %eax, text_size 		#liczba wpisanych znakow w text_size

#informacja o starcie programu
movl $WRITE, 			%eax
movl $STDOUT, 			%ebx
movl $prosba_o_klucz, 		%ecx
movl $rozmiar_prosba_o_klucz, 	%edx
int  $SYSCALL

#wprowadzenie rozmiaru klucza
movl $READ, %eax
movl $STDIN, %ebx
movl $klucz_bufor, %ecx
movl $klucz_buf_size, %edx
int  $SYSCALL

movl %eax, klucz_size 		#liczba wpisanych znakow w klucz_size
movl $ZERO, %esi			#wstawienie 1 na 32bitach

#odczytanie klucza
movb klucz_bufor(,%esi, 1), %bl #w rejestrze bl znak z bufora

cmp $'Z', %bl			#jesli mala litera to szyfrowanie
ja SZYFROWANIE

DESZYFROWANIE:
subb $'A', %bl			#zamiana ASCII na wartosc liczbowa
negb %bl
jmp CEZAR

SZYFROWANIE: 
subb $'a', %bl			#zamiana ASCII na wartosc liczbowa

CEZAR:
#przygotowanie do iteracji po znakach do zaszyfrowania
movl $-1, %esi
#petla ktora idzie znak po znaku w buforze
_petla:
incl %esi			#zwiekszenie licznika
movb bufor(,%esi, 1), %al 	#w rejestrze al znak z bufora

#sprawdzenie czy jest to litera do zamiany
cmp $'a', %al
jb WYSWIETL
cmp $'z', %al
ja WYSWIETL

#zamiana
add %bl, %al			#klucz

#sprawdzenie czy nowy znak dalej jest litera
cmp $'z', %al
_t0:
jbe WPISZ_DO_BUFORA #jak znak dalej jest w tablicy ACII to wpisujemy go od bufora

NAPRAW_ZNAK: #naprawia znak ktory jest poza tablica ASCII
sub $LICZBA_LITER_ALFABETU, %al

WPISZ_DO_BUFORA:
movb %al, bufor(,%esi, 1)	#zastapienie aktualnego znaku w buforze

#sprawdzenie czy koniec bufora
cmp text_size, %esi 		#czy koniec bufora?
jb _petla			#wroc do petli jesli to nie koniec bufora

#wyswietlenie z bufora
WYSWIETL:
movl $WRITE, %eax
movl $STDOUT, %ebx
movl $bufor, %ecx
movl $buf_size, %edx
int  $SYSCALL

#poprawne wyjscie z programu
movl $EXIT, %eax
int  $SYSCALL
