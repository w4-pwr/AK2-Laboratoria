.global add4
.text
add4:
	mov	%rdi, %r14
	mov	%rsi, %rax 	#mniejszy rejestr do wiekszego przez movz
	mov	$0, %rdx
	mov	$4096, %rbx
	div	%rbx
	inc	%rax

	mov	%rsi, %r15
	mov	%rax, %rsi
	mov	$9, %rax
	mov	$0, %rdi
	mov	$3, %rdx
	mov	$0x21, %r10	#flaga MAP_ANONYMOUS i jeszcze jakas
	mov	$0, %r8
	mov	$0, %r9
	syscall

loop:
	mov	-8(%r14, %r15, 8), %ebx
	add	$5, %ebx
	mov	%ebx, -8(%rax, %r15,8)
	dec	%r15
	jnz 	loop

	ret
