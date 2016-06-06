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
.equ OFFSET_P1, 4*2
.equ BASE_NUMBER, 10

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
popl %ecx
movl $0x4, %eax
movl $0x0, %edx
imull %ecx

#wyjscie z funkcji
movl $EXIT, %eax
int $SYSCALL
