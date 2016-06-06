.global hello
.text
	msg: 	.ascii	"Hello!\n"
hello:
	mov	$1, %rax
	mov	$1, %rdi
	mov 	$msg, %rsi
	mov	$7, %rdx
	syscall
	ret
