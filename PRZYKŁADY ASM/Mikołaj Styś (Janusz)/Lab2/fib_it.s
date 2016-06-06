#ciag fibonnaciego
SYSCALL = 0x80
SYS_EXIT = 1

.data

.text
.globl _start

.type fib @function
fib:
	movl 0x4(%esp), %ecx # parametr - ktora liczba?
	cmpl $0x1, %ecx
	ja end_fib
	movl $0x1, %eax
	movl $0x0, %ebx
ret
end_fib:
	decl %ecx
	pushl %ecx
	call fib # n - 1
	addl $0x4, %esp
	movl %ebx, %edx
	addl %eax, %edx
	movl %eax, %ebx
	movl %edx, %eax
ret

fib_it:
	movl 0xC(%esp), %ecx # parametr - ktora liczba?
	movl $0x1, %esi
	movl $0x0, %eax
	movl $0x0, %ebx
	
fib_it_loop:
	movl %eax, %edx
	addl %ebx, %edx
	movl %ebx, %eax
	movl %edx, %ebx
	incl %esi
	cmpl %esi, %ecx
	jne fib_it_loop
	
ret

_start:
pushl $10
call fib
popl %ebx
_t1:

movl $SYS_EXIT, %eax
int $SYSCALL

