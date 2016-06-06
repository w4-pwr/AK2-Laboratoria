.data
	buf: .ascii "0"
.text
	filename: .ascii "plik.txt\0"
.global _start
_start:
	mov $2, %rax
	mov $filename, %rdi
	mov $00, %rsi
	syscall
	mov %rax, %r9

loop:
	mov $0, %rax
	mov %r9, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall
	movb (buf), %r8b
	cmp $10, %r8
	je exit
	mov $10, %rbx
	mov %r10, %rax
	mul %rbx
	sub $48, %r8
	mov %rax, %r10
	add %r8, %r10
	jmp loop

exit:
	nop
	
