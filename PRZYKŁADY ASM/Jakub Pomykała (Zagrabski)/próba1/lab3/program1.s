.data 
	buf: .ascii "123/n"
.global _start
_start:
	mov $0, %rdx
	mov $0, %rdi
	mov $buf, %rsi
	mov $3, %rdi 
	syscall 
	mov (buf), %r8b 
	mov (buf)+1, %r9b 
	sub $48,  %r8
	sub $0x30, %r9
	mov %r8, %rax
	mov $10, %rbx
	mul %rbx
	add %r9, %rax
	inc %rdi
	mov %rax, %r9
	mov $10, %rbx
	div %rbx
	mov %rax, %r8
	mov $10, %rbx
	mul %rbx
	sub %rax, %r9   
	add $48, %r8
	add $48, %r9
	movb %r8b, (buf)
	movb %r9b, (buf)+1
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $3, %rdx
	syscall
	mov $60, %rax
	mov $0, %rdi
	syscall
	
	
	#do rax wpisujesz numer systemowy
	#do rdi to czy to ma byc in czy out (0/1)
	#do rsi to dajesz bufor (do wczytania albo wypisania)
	#do rdx dlugosc tego bufora
