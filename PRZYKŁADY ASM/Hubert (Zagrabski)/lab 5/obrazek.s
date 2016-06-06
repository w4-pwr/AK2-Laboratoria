.global _start
.text
	a: .byte 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30, 0x30

_start:
	mov $2, %rax
	mov 16(%rsp), %rdi
	mov $2, %rsi
	syscall
	cmp $0, %rax
	jg 1f
	mov $60, %rax
	mov $1, %rdi
	syscall
1:	
	mov %rax, %r8
	mov $9, %rax
	mov $0, %rdi
	mov $122880, %rsi
	mov $3, %rdx	#flagi
	mov $1, %r10
	mov $0, %r9
	syscall
	
	mov 2(%rax), %r15d 	#do r15 wrzucamy dlugosc obrazka
	mov $0, %rcx		#rcx jako licznik
	movq a,%mm1
	
1:	movq 54(%rax, %rcx, 1), %mm0
	psubusb %mm1, %mm0 			#dodajemy z nasyceniem
	movq %mm0, 54(%rax, %rcx, 1)
	add $8, %rcx
	cmp %r15, %rcx
	jl 1b
	
	mov %rax, %rdi
	mov $11, %rax
	mov $122880, %rsi
	syscall


	mov $60, %rax
	mov $0, %rdi
	syscall
