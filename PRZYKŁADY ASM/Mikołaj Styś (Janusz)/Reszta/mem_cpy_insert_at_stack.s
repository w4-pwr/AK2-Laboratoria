#ciag fibonnaciego
SYSCALL = 0x80
SYS_EXIT = 1

.data
.equ P1_INDEX, 4
.equ P2_VAL, 2*4

.equ MCPY_P1_DST, 3*4
.equ MCPY_P2_SRC, 2*4
.equ MCPY_P3_N, 1*4

buf1: .int 0x1,0x5,0x2
buf2: .space 4*3

.text
.globl _start

insert_at_stack: #sama po sobie "czysci" wiec nie ma potzreby zdejmowania po wywolaniu
	pushf
	pushl %edi
	pushl %ebx
	pushl %eax
	pushl %esi
	pushl %ebp
	movl %esp, %ebp
	addl $(4*6), %esp #chowam zachowane wartosci

	movl P1_INDEX(%esp), %edi #parametr 2 - indeks liczac prze wywaloanei funkcji
	movl P2_VAL(%esp), %ebx #parametr 1 - wartosc
	popl %eax
	movl %eax, (%esp) # zmniejszam stos o 1 zachowujac adres powrotu
	movl $0x1, %esi # omjam adres powrotu
shift_stack:
	movl 4(%esp, %esi, 4), %eax
	movl %eax, (%esp, %esi, 4)
	incl %esi
	decl %edi
	andl %edi, %edi
	jnz shift_stack
	
	movl %ebx, (%esp, %esi, 4) #wkladam wartosc
	#koncze
	movl %ebp, %esp
	popl %ebp
	popl %esi
	popl %eax
	popl %ebx
	popl %edi
	popf
	addl $0x4, %esp # latam dziure
ret

mem_cpy: #kopiowanie pamieci
	pushf
	pushl %edi
	pushl %ebx
	pushl %eax
	pushl %esi
	pushl %ebp
	movl %esp, %ebp

	addl $(4*6), %esp #chowam zachowane wartosci

	movl MCPY_P1_DST(%esp), %edi #parametr 1 - cel
	movl MCPY_P2_SRC(%esp), %esi #parametr 2 - zrodlo
	movl MCPY_P3_N(%esp), %ecx #parametr 3 - ilosc bajtow
	
	copy_one_cell:
	decl %ecx
	movl (%esi, %ecx, 1), %eax
	movl %eax, (%edi, %ecx, 1)
	andl %ecx, %ecx
	jnz copy_one_cell

	#koncze
	movl %ebp, %esp
	popl %ebp
	popl %esi
	popl %eax
	popl %ebx
	popl %edi
	popf
ret	



_start:
pushl $buf2
pushl $buf1
pushl $(3*4)
call mem_cpy
addl $(3*4), %esp 

movl buf2, %eax
movl buf2+4, %eax
movl buf2+8, %eax
movl $SYS_EXIT, %eax
movl $0x0, %ebx
int $SYSCALL

