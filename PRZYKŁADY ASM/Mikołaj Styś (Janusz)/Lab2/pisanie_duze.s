SYSCALL = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1
ROZNICA = 0x20
.data
komunikat: .ascii "CzESC poklikasz ? xd\n"
.text
.globl _start
_start:
movl $0x0, %ecx #zerujemy licznik
loop_start:
movb komunikat(%ecx,1), %bl #kopiujemy char
cmpb $0x0, %bl #czy nie jest znakiem konca lancucha
jz loop_end
cmpb $'a', %bl
jb loop_next
cmpb $'z', %bl #wieksze, mniejsze od dane znaku, odpada
ja loop_next
subb $0x20, %bl #odejmujemy 0x20, czyli z malych na duze wedlug ASCII
movb %bl, komunikat(%ecx,1) #zastapimy znak
loop_next:
inc %ecx #kolejne wykonanie, zwiekszenie licznika
jmp loop_start
loop_end:
movl %ecx, %edx
movl $komunikat, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL
movl $EXIT, %eax
int $SYSCALL

