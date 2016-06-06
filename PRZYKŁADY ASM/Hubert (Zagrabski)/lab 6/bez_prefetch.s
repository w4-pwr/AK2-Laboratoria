.global bez_prefetch
.text

bez_prefetch:
	mov -8(%rdi, %rcx, 8), %rax
	add -8(%rsi, %rcx, 8), %rax
	mov %rax, -8(%rdx, %rcx, 8)
	loop bez_prefetch
	ret
