SYSCALL = 0x80
SYS_EXIT = 1
STDIN = 0
SYS_READ = 3
STDOUT = 1
SYS_WRITE = 4
.data
.equ additional_sub, 'A'-':'
buffer: .space 0x40
buffer_len = . - buffer
.text
.globl _start
_start:
movl $buffer_len, %edx
movl $buffer, %ecx
movl $STDIN, %ebx
movl $SYS_READ, %eax
int $SYSCALL
movl $0, %ebx
movl $0, %ecx

convert:
movb buffer(%ecx,1), %al
cmpb $'0', %al #znak konca - "nie liczba"
jb finish
cmpb $'F', %al
ja finish
cmpb $'9', %al
jbe conv
cmpb $'A', %al  #znak konca - "nie liczba"
jb finish 
subb $additional_sub, %al

conv:
subb $'0', %al
cmpl $0x0, %ecx #u2
jnz conv2
cmpb $0x8, %al
jb conv2
addb %al, %bl
subl $0x10, %ebx
jmp next_loop
conv2:
sall $4, %ebx #zakladam, ze liczba zmiesci sie w rejestrze
addb %al, %bl

next_loop:
inc %ecx
jmp convert

finish:
movl $32, %ecx
write_bin:
sarl $1, %ebx
jc carry
movb $'0', buffer(%ecx,1)
jmp end_loop
carry:
movb $'1', buffer(%ecx,1)
end_loop:
loop  write_bin #some strange errors with letters
movl $33, %ecx
movb $'\n', buffer(%ecx,1)
movb $'\n', buffer
movl $buffer_len, %edx
movl $buffer, %ecx
movl $STDOUT, %ebx
movl $SYS_WRITE, %eax
int $SYSCALL

movl $SYS_EXIT, %eax
movl $0, %ebx
int $SYSCALL

