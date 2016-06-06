#ciag fibonnaciego
SYSCALL = 0x80
SYS_EXIT = 1
STDIN = 0
SYS_READ = 3
STDOUT = 1
SYS_WRITE = 4
.data
buff_last_number: .space 0xFF, 0
buff_curr_number: .space 0XFF, 0

.text
.globl _start

add_multi:
pushl %eax
pushl %ebx
pushl %ecx
pushl %edx
pushl %esi
pushl %edi
pushl %ebp
movl %esp, %ebp

movl $0x1, %ecx # wielokrotnosc rejestru
movl $0x1, buff_last_number

movl $0x0, %esi #licznik ciagu 
movl 0x1C(%esp), %edi #koncowa wartosc

fib_loop:

clc
movl $0x0, %edx
t_loop:
movl buff_last_number(, %edx, 4), %eax
movl buff_curr_number(, %edx, 4), %ebx
movl %ebx, buff_last_number(, %edx, 4)
adcl %ebx, %eax
movl %eax, buff_curr_number(, %edx, 4)
incl %edx
jc carry_is
cmpl %edx, %ecx
jne t_loop
jmp cont_t
carry_is:
cmpl %edx, %ecx
stc
jne t_loop
movl $0x1, buff_curr_number(, %ecx, 4)
incl %ecx

cont_t:
incl %esi
cmpl %edi, %esi
clc 
jne fib_loop 

movl %ebp, %esp
popl %ebp
popl %edi
popl %esi
popl %edx
popl %ecx
popl %ebx
popl %eax
jmp endx 

_start:
pushl $83
jmp add_multi
#call add_multi

endx:
movl $0x1, %ecx
movl buff_curr_number, %eax
movl buff_curr_number(,%ecx,4), %ebx
movl $SYS_EXIT, %eax
movl $0x0, %ebx
int $SYSCALL

