#ciag fibonnaciego
SYSCALL = 0x80
SYS_EXIT = 1
STDIN = 0
SYS_READ = 3
STDOUT = 1
SYS_WRITE = 4

SIEVE_SIZE = 100
.data
sieve: .space SIEVE_SIZE*4, 0

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

movl $0x0, %esi #licznik ciagu 
movl 0x20(%esp), %ecx #adres tablicy
movl 0x1C(%esp), %edi #wielkosc
movl $0x2, %ebx

sieve_o_loop:
	movl %ebx, %esi
	cmp $0x0, %esi
	jz next_o_loop

	sieve_i_loop:
		movl $0x0, %edx
		movl (%ecx, %esi, 4), %eax
		cmp $0x0, %eax
		jz retain
		div %ebx
		cmp $0x0, %edx
		jnz retain
		movl $0x0, (%ecx, %esi, 4)
		retain:
		incl %esi
		cmpl %esi, %edi
		jne sieve_i_loop
	
	next_o_loop:
		incl %ebx
		cmpl %ebx, %edi
		jne sieve_o_loop

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
#tworzenie sita
movl $0x0, %ecx
movl $0x1, %eax
creating_sieve:
movl %eax, sieve(, %ecx, 4)
incl %eax
incl %ecx
cmpl $SIEVE_SIZE, %ecx
jne creating_sieve

#szukanie liczb pierwszych
pushl $sieve
pushl $SIEVE_SIZE
jmp add_multi
#call add_multi
endx:

#przejrzenie
#tworzenie sita
movl $SIEVE_SIZE, %ecx
lookup_sieve:
movl sieve(, %ecx, 4), %eax
loop lookup_sieve


movl $SYS_EXIT, %eax
movl $0x0, %ebx
int $SYSCALL

