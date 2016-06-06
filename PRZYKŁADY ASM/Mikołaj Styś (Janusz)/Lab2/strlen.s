SYSCALL = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1
.data
komunikat: .ascii "CzESC POKLIASH xd\n"
rozmiar = . - komunikat
.text
.globl _start
_start:
movl $0x0, %ecx
loop:
movb komunikat(%ecx,1), %al
inc %ecx
cmpb $0x0, %al
jnz loop
movl %ecx, %edx
movl $komunikat, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL
movl $EXIT, %eax
int $SYSCALL

