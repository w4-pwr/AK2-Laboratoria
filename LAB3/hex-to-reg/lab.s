SYSCALL = 0x80
EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
STDIN = 0
ODCZYT_WARTOSCI_HEX = 55
ZERO = 0
DUZA_LITERA = 0x20
BREAK_LINE = 2

.data 
#bufor do przechowywania tekstu do szyfrowania
buf_size = 31
text_size: .long 0
bufor: .space buf_size

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
subl $BREAK_LINE, text_size #ignorowanie ostatnich 2 znaków konca linii '\n'

# START - ZADANIE
movl $0, %eax #miejsce gdzie bede przechowywac wartosc
movl $-1, %esi

CZYTAJ_ZNAK:
#przesuwa o 4 bity w lewo, na początku nie ma znaczenia, bo sa same zera
shll $4, %eax		
incl %esi
movl $ZERO, %ebx #wyzerowanie smieci, dla pewnosci
movb bufor(%esi,1), %bl

cmp $'9', %bl
jbe DEC_DO_BIN

HEX_DO_BIN:
subb $ODCZYT_WARTOSCI_HEX, %bl
jmp DALEJ

DEC_DO_BIN:
subb $'0', %bl

DALEJ:
addl %ebx, %eax	#dodaje

#sprawdzenie czy koniec bufora
cmp text_size, %esi #czy koniec bufora?
jb CZYTAJ_ZNAK #wroc do petli jesli to nie koniec bufora

_t9: #pułapka dla GDB, w tym miejscu w %rax znajduje się wartość wpisanej liczby HEX

#poprawne wyjscie z programu
movl $EXIT, %eax
int  $SYSCALL
