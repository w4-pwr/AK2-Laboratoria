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
	
	mov %rax, %r8

loop:
	mov $0, %rax
	mov %r8, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall
	cmp $0, %rax
	je exit
	
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall
	jmp loop
exit:
	movb $13, (buf)
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall
	mov $60, %rax
	mov $0, %rdi
	syscall
