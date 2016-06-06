SYSCALL = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1
.data
komunizm: .string "%d\n"
komunikat: .string "CzESC POKLIASH xd\n"
rozmiar = . - komunikat
.text
.globl main
main:
movl $0x0, %ecx
loop:
movl $komunikat, %edx
movb (%edx, %ecx,1), %al
inc %ecx
cmpb $0x0, %al
jnz loop
pushl %ecx
pushl $komunizm
call printf
call exit

