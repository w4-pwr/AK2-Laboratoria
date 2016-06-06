SYSCALL = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1
ROZNICA = 0x20
.data
komunikat: .ascii "CzESC POKLIASH xd\n"
rozmiar = . - komunikat
.text
.globl _start
_start:
movl $0x0, %ecx #zerujemy licznik
loop_start:
movb komunikat(%ecx,1), %bl #kopiujemy char
cmpb $0x0, %bl
jz loop_end
cmpb $'A', %bl
jb loop_next
cmpb $'Z', %bl
ja loop_next
addb $0x20, %bl
movb %bl, komunikat(%ecx,1)
loop_next:
inc %ecx
jmp loop_start
loop_end:
movl %ecx, %edx
movl $komunikat, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL
movl $EXIT, %eax
int $SYSCALL

