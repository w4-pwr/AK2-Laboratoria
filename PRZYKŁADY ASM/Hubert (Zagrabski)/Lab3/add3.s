.global add3
.text
add3:
	mov	$0, %rax
loop:
	add	-8(%rdi, %rsi, 8),%eax
	dec	%rsi
	jnz	loop
	ret
