.global add2
.text
add2:
	mov	(%rsi), %eax
	add	(%rdi), %eax
	ret
