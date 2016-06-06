SYSCALL = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1
ROZNICA = 0x20
.data
komunikat: .string "Ala MA KoTa?"
.text
.globl _start
_start:
movl $0x0, %ecx #zerujemy licznik

loop_start:
movb komunikat(%ecx,1), %bl #kopiujemy char
cmpb $0x0, %bl #czy nie jest znakiem konca lancucha
jz end_write #jak tak to koncze

movl %ecx, %eax #kopiuje wartosc licznika
andl $0x1, %eax #sprawdzam parzystosc
jnp loop_next #jak nieparzyste tak to skacze do nastepnej (liczac od zera)

cmpb $'A', %bl
jb loop_next
cmpb $'z', %bl
ja loop_next #nie sa literami

cmpb $'Z', %bl
jbe decapitalise
cmpb $'a', %bl
jae capitalise


decapitalise:
addb $0x20, %bl
jmp moveLetter
capitalise:
subb $0x20, %bl

moveLetter:
movb %bl, komunikat(%ecx,1)

loop_next:
inc %ecx #kolejne wykonanie, zwiekszenie licznika
jmp loop_start

end_write:
movl %ecx, %edx
movl $komunikat, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL
movl $EXIT, %eax
int $SYSCALL

