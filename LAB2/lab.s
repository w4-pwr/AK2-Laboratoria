SYSCALL = 0x80
EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
STDIN = 0

.data 
informacja: .ascii "AK2 LAB - wpisz tekst\n"
rozmiar_informacja = . - informacja # w jaki sposob to oblicza?

buf_size = 31
text_size: .long 0
bufor: .space buf_size
#buf_size: .space text_size

.text
.global _start

_start:
#wypisyanie tekstu
movl $WRITE, 			%eax
movl $STDOUT, 			%ebx
movl $informacja, 		%ecx
movl $rozmiar_informacja, 	%edx
int  $SYSCALL

#wczytwanie z klawiatury do bufora 
movl $READ, %eax
movl $STDIN, %ebx
movl $bufor, %ecx
movl $buf_size, %edx
int  $SYSCALL

movl %eax, text_size 		#liczba wpisanych znakow w text_size
movl $-1, %esi			#wstawienie 1 na 32bitach

#zamiana malych liter na duze
_petla:
incl %esi			#zwiekszenie licznika
movb bufor(,%esi, 1), %al 	#w rejestrze al znak z bufora

#sprawdzenie czy jest to litera do zamiany
cmp $'a', %al
jb WYSWIETL
cmp $'z', %al
ja WYSWIETL

#zamiana zmiana wielkosc
xorb $0x20, %al			#maska dla zamany
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
