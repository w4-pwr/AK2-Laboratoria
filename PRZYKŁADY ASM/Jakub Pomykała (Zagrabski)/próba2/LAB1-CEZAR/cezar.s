SYSCALL = 0x80
STDIN = 0
STDOUT = 1
SYSREAD = 3
SYSWRITE = 4
SYSEXIT = 1
EXIT_SUCCESS = 0

.data
INFO: .ascii "Szyfr cezara\n"
INFO_ROZMIAR = . - INFO

TEKST_MAX = 63
TEKST: .space TEKST_MAX
TEKST_ROZMIAR: .long 0

KLUCZ_MAX = 2
KLUCZ: .space KLUCZ_MAX
KLUCZ_ROZMIAR: .byte

.text
.global _start

_start:
# poczatkowa informacja
mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $INFO, %ecx
mov $INFO_ROZMIAR, %edx
int $SYSCALL

# wczytanie tekstu
mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $TEKST, %ecx
mov $TEKST_MAX, %edx
int $SYSCALL

mov %eax, TEKST_ROZMIAR #dlugosc tekstu, w TEKST_ROZMIAR

# wczytywanie klucza
mov $SYSREAD, %eax
mov $STDIN, %ebx
mov $KLUCZ, %ecx
mov $KLUCZ_MAX, %edx
int $SYSCALL

mov %eax, KLUCZ_ROZMIAR #dlugosc klucza, w KLUCZ_ROZMIAR

#szyfr cezara
#klucz w edx

# właściwa cześc algorytmu
xor %edx, %edx
movb KLUCZ, %dl
sub $'A', %edx
add $1, %edx

mov $0, %ecx 		#licznik petli
sub $1, TEKST_ROZMIAR 	#odejmujemy 1 od rozmiaru tekstu do zakodowania

#ograniczenia co do szyfrowanych znakow
SZYFROWANIE_PETLA:
mov TEKST(, %ecx, 1), %eax 	#przesuwamy aktualny znak do rejestru al, na podstawie %ecx
cmp $'A', %al
jb NIE_SZYFRUJ_ZNAKU 	#jesli mniejsze niz 'A' (poczatek ascii) - na pewno nie litera alfabetu
cmp $'z', %al
ja NIE_SZYFRUJ_ZNAKU 	#jesli wieksze niz 'z' (koniec ascii) - na pewno nie litera alfabetu

#szyfrowanie i sprawdzenie czy nie wyszedl poza ascii
SZYFROWANIE_ZNAKU:
add %edx, %eax			#przekodowanie, dodanie klucza
cmp $'z', %al			#sprawdzenie czy znak dalej jest w ASCII
jae POPRAW_ZNAK
cmp $'a', %al
jae ZNAK_POPRAWNY
cmp $'Z', %al

ja POPRAW_ZNAK
jmp ZNAK_POPRAWNY

#odjemujemy 26, zeby byl ascii
POPRAW_ZNAK:
sub $26, %al

#znak jest poprawny
ZNAK_POPRAWNY:
movb %al, TEKST(, %ecx, 1)

NIE_SZYFRUJ_ZNAKU:
add $1, %ecx 			#inkrementacja licznika petli
cmp %ecx, TEKST_ROZMIAR 	#sprawdzamy czy to juz koniec tekstu
jne SZYFROWANIE_PETLA 		#jesli nie to od poczatku

add $1, TEKST_ROZMIAR

#wyswietlenie zaszyfrowanego tekstu
WYSWIETL:
mov $SYSWRITE, %eax
mov $STDOUT, %ebx
mov $TEKST, %ecx
mov TEKST_ROZMIAR, %edx
int $SYSCALL

EXIT:
# zakonczenie programu
mov $SYSEXIT, %eax
mov $EXIT_SUCCESS, %ebx
int $SYSCALL
