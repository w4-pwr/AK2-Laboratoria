SYSCALL = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1
STDIN = 0
READ = 3

.data
INPUT_TEXT: .ascii "Wprowadz tekst\n"
INPUT_TEXT_LEN = .-INPUT_TEXT
INPUT_OFFSET: .ascii "Wprowadz offset\n"
INPUT_OFFSET_LEN = .-INPUT_TEXT
OUT_TEXT: .ascii "Wynik:\n"
OUT_TEXT_LEN = .-INPUT_TEXT

.equ BUF_LENGTH, 0xFF
.equ LETTERS_IN_ALPHABET, 26
.equ BASE_NUMBER, 10
.equ OFFSET_P1, 4*2
.equ CEZAR_P1, 4*3
.equ CEZAR_P2, 4*2

buff: .space BUF_LENGTH

.text
.globl _start

get_offset:
#zabezpieczenie
pushl %ebp
movl %esp, %ebp

movl $BASE_NUMBER, %edi #baza systemu
movl OFFSET_P1(%esp), %esi #adres bufora
movl $0x0, %ecx
movl $0x0, %eax
movl $0x0, %ebx
movl $0x0, %edx

movb (%esi), %bl
cmpb $'-', %bl
jne get_offset_loop
incl %ecx
get_offset_loop:
movb (%esi,%ecx,1), %bl
subb $'0', %bl
jl get_offset_end
cmp $'9', %bl
ja get_offset_end

mull %edi
addl %ebx, %eax

incl %ecx
jmp get_offset_loop

get_offset_end: # koniec funkcji, sprawdzanie znaku
movb (%esi), %bl
cmpb $'-', %bl
jne modul
	movl $0x0, %ebx
	subl %eax, %ebx
	movl %ebx, %eax
modul:
movl %eax, OFFSET_P1(%esp) #zwracana wartosc
movl %ebp, %esp
popl %ebp
ret

cezar:
#zabezpieczenie
pushl %ebp
movl %esp, %ebp

#czytwanie danych 1 parametr char*, drugi offset
movl 12(%esp), %edx #offset
movl 8(%esp), %edi #char*
#funkcja
movl $0, %ecx
movl $0, %eax

cezar_funkcja:
movb (%edi, %ecx, 1), %al
andb %al, %al #ide do konca (zero)
jz cezar_end
cmpb $'Z', %al
ja small_letters
cmpb $'A', %al
jb next
addb %dl, %al #zakladam ze mneijszy od 26
cmpb $'Z', %al
jbe replace
ja rotate

small_letters:
cmpb $'a', %al
jb next
cmpb $'z', %al
ja next
addb %dl, %al
cmpb $'z', %al
jbe replace

rotate:
subb $LETTERS_IN_ALPHABET, %al

replace:
movb %al, (%edi, %ecx, 1)

next:
inc %ecx
jmp cezar_funkcja

cezar_end: # koniec funkcji
leave
ret


_start:

#zacheta do wpisania offset
movl $INPUT_OFFSET_LEN, %edx
movl $INPUT_OFFSET, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL

#drukowanie
movl $BUF_LENGTH, %edx
movl $buff, %ecx
movl $STDIN, %ebx
movl $READ, %eax
int $SYSCALL

pushl $buff # adres skad pobieram
call get_offset

#zacheta do wpisania tekstu
movl $INPUT_TEXT_LEN, %edx
movl $INPUT_TEXT, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL

#drukowanie
movl $BUF_LENGTH, %edx
movl $buff, %ecx
movl $STDIN, %ebx
movl $READ, %eax
int $SYSCALL

popl %edx

andl %edx, %edx
jnz po_poprawieniu
movl $0x3, %edx # standardowy offset, gdy wartosc w rejestrze 0

po_poprawieniu:
pushl %edx
pushl $buff
call cezar
subl $(2*4), %esp

#wypisz "wynik"
movl $OUT_TEXT_LEN, %edx
movl $OUT_TEXT, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL

#wypisz wynik
movl $BUF_LENGTH, %edx
movl $buff, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL

#wyjscie z funkcji
movl $EXIT, %eax
int $SYSCALL
