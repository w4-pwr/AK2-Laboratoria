#ciag fibonnaciego
SYSCALL = 0x80
SYS_EXIT = 1

.data
.equ P1_INDEX, 4
.equ P2_VAL, 2*4

.equ FIB_P1, 7*4
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


fib:
	pushf
	pushl %edi
	pushl %ebx
	pushl %eax
	pushl %esi
	pushl %ebp
	movl %esp, %ebp

	movl FIB_P1(%esp), %eax
	cmpl $0x1, %eax
	ja fib_next_rec
	movl $0x1, FIB_P1(%esp) #ilosc reg na stosie
	pushl %eax #wartosc do wsadzenia
	pushl FIB_P1(%esp) #index
	movl %eax, FIB_P1(%esp) #zwracam wart z msc parametru
	#koncze
	movl %ebp, %esp
	popl %ebp
	popl %esi
	popl %eax
	popl %ebx
	popl %edi
	popf
ret
fib_next_rec:
	subl $2, %eax # n-2
	pushl %eax
	call fib
	incl %eax #n -1
	pushl %eax
	call fib
	popl %edi #ilosc w 2 wywolaniu, bedzize wiekszy, bo jest wiekszy nr ciagu
	popl %esi #ilosc w 1
	movl $7, %ebx # zmienia sie adres w stosie
	movl %edi, (%esp, %ebx, 4) #ilosc w nastepnym powrocie
insert_values:
	movl (%esp, %ebx, 4), %eax
	pushl %ebx #wartosc komorki juz jest na szczycie stosu
	call insert_at_stack #wkladamy do stosu
	incl %ebx
	decl %edi
	jnz insert_values
	clc
	movl $9, %ebx # + 1 i jeszcze pushuje
	pushf
add_values:
	movl (%esp, %ebx, 4), %eax
	popf
	adcl %eax, (%esp, %ebx, 4)
	pushf
	incl %ebx
	decl %esi
	jnz add_values

	popf
	jnc koncze
	addl $0x1, FIB_P1(%esp) #gdy carry
	push $0x1
	push %ebx
	call insert_at_stack
	koncze:
	movl %ebp, %esp
	popl %ebp
	popl %esi
	popl %eax
	popl %ebx
	popl %edi
	popf
ret

_start:
movl $0x0, %esi
pushl $10
call fib
popl %eax

movl $SYS_EXIT, %eax
movl $0x0, %ebx
int $SYSCALL

