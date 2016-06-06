#Najwiekszy wspolny dzielnik metoda Euklidesa
SYSCALL = 0x80
SYS_EXIT = 1
STDIN = 0
SYS_READ = 3
STDOUT = 1
SYS_WRITE = 4
.data

.type nwd_function @function
nwd_function:
pushl %eax
pushl %ebx
pushl %ecx
pushl %edx
pushl %esi
pushl %edi
pushl %ebp
movl %esp, %ebp

movl $0x0, %esi
movl 0x24(%esp), %ebx #2 liczba
movl 0x28(%esp), %ecx #1 liczba

nwd_loop:
sub_multi


nwd_end:
movl %ebp, %esp
popl %ebp
popl %edi
popl %esi
popl %edx
popl %ecx
popl %ebx
popl %eax
ret

#odejmowanie liczb o wielkiej długości
.type sub_multi @function
sub_multi:
pushl %eax
pushl %ebx
pushl %ecx
pushl %edx
pushl %esi
pushl %edi
pushl %ebp
movl %esp, %ebp

movl 0x20(%esp), %edi
movl 0x24(%esp), %ebx
movl 0x28(%esp), %edx
movl $0x0, %esi

CLC
next_sub:
movl (%ebx, %esi, 4), %eax
sbbl %eax, (%edx, %esi, 4)
incl %esi
cmpl %esi, %edi
jne  next_sub

movl %ebp, %esp
popl %ebp
popl %edi
popl %esi
popl %edx
popl %ecx
popl %ebx
popl %eax
ret

.text
.globl _start

_start:
pushl $array_d
pushl $0x2
pushl $0x3
call mul_multi

movl $0x0, %esi
movl array_d(,%esi, 4), %eax
incl %esi
movl array_d(,%esi, 4), %ebx
incl %esi
movl array_d(,%esi, 4), %ecx

movl $SYS_EXIT, %eax
movl $0x0, %ebx
int $SYSCALL

