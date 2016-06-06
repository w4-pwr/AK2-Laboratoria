SYSCALL = 0x80
SYS_EXIT = 1
STDIN = 0
SYS_READ = 3
STDOUT = 1
SYS_WRITE = 4
.data
array_s: .int 0x4, 0x2, 0x5
array_d: .int 0xFFFFFFFF, 0x54, 0x4

.type add_multi @function
add_multi:
	pushl %eax
	pushl %ebx
	pushl %ecx
	pushl %edx
	pushl %esi
	pushl %edi
	pushl %ebp
	movl %esp, %ebp

	movl 0x1C(%esp), %edi #3 - parametr: wielkosc liczby w rejestrach
	movl 0x20(%esp), %ebx #2 - parametr: zrodlo
	movl 0x24(%esp), %edx #1 - parametr: cel
	movl $0x0, %esi #indeks liczby
	CLC #czyszcze, dzieki czemu adc dziala jak add
	pushf

	next_add:
		movl (%ebx, %esi, 4), %eax
		popf
		adcl %eax, (%edx, %esi, 4)
		pushf
		incl %esi
		cmpl %esi, %edi
		jne  next_add

	popf
	movl %ebp, %esp
	popl %ebp
	popl %edi
	popl %esi
	popl %edx
	popl %ecx
	popl %ebx
	popl %eax
ret

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

	movl 0x20(%esp), %edi #3 - parametr: wielkosc liczby w rejestrach
	movl 0x24(%esp), %ebx #2 - parametr: zrodlo
	movl 0x28(%esp), %edx #1 - parametr: cel
	movl $0x0, %esi #indeks liczby

	CLC #czyszcze, aby pierwsze sbb ddzialalo jak sub
	pushf
	
	next_sub:
		movl (%ebx, %esi, 4), %eax
		popf
		sbbl %eax, (%edx, %esi, 4)
		pushf
		incl %esi
		cmpl %esi, %edi
		jne  next_sub

	popf
	movl %ebp, %esp
	popl %ebp
	popl %edi
	popl %esi
	popl %edx
	popl %ecx
	popl %ebx
	popl %eax
ret

.type multi_cmp_function @function
multi_cmp_function:
	pushl %eax
	pushl %ebx
	pushl %ecx
	pushl %edx
	pushl %esi
	pushl %edi
	pushl %ebp
	movl %esp, %ebp

	movl 0x20(%esp), %edi #3 - parametr: wielkosc liczby w rejestrach
	movl 0x24(%esp), %ebx #2 - parametr: zrodlo
	movl 0x28(%esp), %edx #1 - parametr: cel, a takze wynik porownania
	movl $0x0, %esi #indeks liczby

	next_cmp:
		movl (%ebx, %esi, 4), %eax
		movl (%edx, %esi, 4), %ecx
		sub %eax, %ecx
		je end_cmp_function
		incl %esi
		cmpl %esi, %edi
		jne  next_sub

	end_cmp_function:
		movl %ecx, 0x28(%esp);
		movl %ebp, %esp
		popl %ebp
		popl %edi
		popl %esi
		popl %edx
		popl %ecx
		popl %ebx
		popl %eax
ret #0 - rowne, 0 < - wieksze, 0 > mniejsze

.type mul_multi @function
mul_multi:
	pushl %eax
	pushl %ebx
	pushl %ecx
	pushl %edx
	pushl %esi
	pushl %edi
	pushl %ebp
	movl %esp, %ebp

	movl 0x24(%esp), %ebx	# 2 parametr: wartosc mnoznika
	movl 0x28(%esp), %ecx	# 1 parametr: wskaznik na mnozna
	movl $0x0, %esi
	movl $0x0, %edi

	CLC
	pushf
	next_mul:
		movl (%ecx, %esi, 4), %eax
		mul %ebx
		popf
		addl %edi, %eax
		pushf
		movl %edx, %edi
		movl %eax, (%ecx, %esi, 4)
		incl %esi
		cmpl 0x20(%esp), %esi
		jne  next_mul

popf
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
pushl $array_s
pushl $0x3
#call add_multi
jmp add_multi
endx:
movl $0x0, %esi
movl array_d(,%esi, 4), %eax
incl %esi
movl array_d(,%esi, 4), %ebx
incl %esi
movl array_d(,%esi, 4), %ecx

movl $SYS_EXIT, %eax
movl $0x0, %ebx
int $SYSCALL

