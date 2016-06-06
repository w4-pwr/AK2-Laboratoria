.text
	msg: .ascii "Hello!\n"
.global _start
_start:
	mov $1, %rax
	mov $1, %rdi
	mov $msg, %rsi
	mov $7, %rdx
	_break:
	syscall
	mov $60, %rax
	mov $0, %rdi
	syscall
