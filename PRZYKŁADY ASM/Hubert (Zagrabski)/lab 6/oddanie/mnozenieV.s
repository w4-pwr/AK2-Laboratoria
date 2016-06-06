.global mnozenieV
.text

#mnozenie wektorowe wektorow

mnozenieV:
	mov 	-8(%rdi, %rcx, 8), %rax
	mov 	-8(%rsi, %rcx, 8), %rbx
	push	%rdx
	mul	%rbx
	pop	%rdx
	mov	%rax, -8(%rdx, %rcx, 8)
	loop 	mnozenieV
	
	ret
