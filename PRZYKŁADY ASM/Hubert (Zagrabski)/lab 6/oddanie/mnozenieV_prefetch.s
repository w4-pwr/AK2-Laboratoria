.global mnozenieV_prefetch
.text

mnozenieV_prefetch:
	prefetcht0 -8(%rdi, %rcx, 8)
	prefetcht0 -8(%rsi, %rcx, 8)
	prefetcht0 -8(%rdx, %rcx, 8)
	mov 	-8(%rdi, %rcx, 8), %rax
	mov 	-8(%rsi, %rcx, 8), %rbx
	push	%rdx
	mul	%rbx
	pop	%rdx
	mov 	%rax, -8(%rdx, %rcx, 8)
	loop 	mnozenieV_prefetch	
	ret
