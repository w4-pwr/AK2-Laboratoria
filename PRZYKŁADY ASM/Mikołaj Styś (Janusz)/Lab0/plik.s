SYSCALL = 0x80
EXIT = 1
WRITE = 4
READ = 3
STDIN = 0
STDOUT = 1
.data
komunikat: .space 0x40
rozmiar = . - komunikat
.text
.globl _start
_start:
movl $rozmiar, %edx
movl $komunikat, %ecx
movl $STDIN, %ebx
movl $READ, %eax
int $SYSCALL
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL
movl $EXIT, %eax
int $SYSCALL

