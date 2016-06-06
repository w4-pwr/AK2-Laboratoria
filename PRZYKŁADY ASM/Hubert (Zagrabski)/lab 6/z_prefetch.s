.global z_prefetch
.text

z_prefetch:
	prefetcht0 -8(%rdi, %rcx, 8)
	mov -8(%rdi, %rcx, 8), %rax
	add -8(%rsi, %rcx, 8), %rax
	mov %rax, -8(%rdx, %rcx, 8)
	loop z_prefetch	
	ret
