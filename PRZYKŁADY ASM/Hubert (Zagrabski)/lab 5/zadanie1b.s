.global _start
.text
	a:  	.byte  0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00
		.byte  0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00
		.byte  0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF
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
	mov $0, %rcx
brejk:
	mov	24(%rsp), %r13	#w %r13 argument programu
	movb	(%r13), %r14b
	cmp 	$114, %r14	#jesli r
	je	r
	cmp 	$103, %r14	#jesli g
	je 	g	
	cmp 	$98, %r14	#jesli b
	je	b
	jmp 	end
r:
	mov	$0, %r8
	jmp	1f
g:
	mov	$2, %r8
	jmp 	1f
b:
	mov $1, %r8	#iterator po maskach

1:
	movq 54(%rax, %rcx, 1), %mm0
	movq a(,%r8,8), %mm1
	psubusb %mm1, %mm0
	movq %mm0, 54(%rax, %rcx, 1)
	cmp $2, %r8
	jne 2f
	movq $-1, %r8
2:	inc %r8
	add $8, %rcx
	cmp %r15, %rcx
	jl 1b
	
end:
	mov %rax, %rdi
	mov $11, %rax
	mov $122880, %rsi
	syscall


	mov $60, %rax
	mov $0, %rdi
	syscall
