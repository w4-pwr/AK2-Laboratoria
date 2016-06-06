.text
	newline: .ascii "\n"
	space: .ascii " "
.global _start
_start:
	addq $48, (%rsp) #odwolujemy sie do miejsca w pamieci rsp
	mov $1, %rax
	mov $1, %rdi
	lea (%rsp), %rsi
	mov $1, %rdx
	syscall
	
	subq $48,(%rsp)
	mov $0, %rcx #ile argumentow na stosie -> rcx
arg_loop:	
	mov 8(%rsp, %rcx, 8), %r8
	mov $0, %r9

string_loop:
	mov (%r8,%r9,1),%r10b
	cmp $0, %r10b
	je string_end
	
	mov $1, %rax
	mov $1, %rdi
	lea (%r8, %r9,1),%rsi
	mov $1, %rdx
	push %rcx
	syscall
	pop %rcx
	inc %r9
	jmp string_loop
		
string_end:
	mov $1, %rax
	mov $1, %rdi
	mov $space, %rsi
	mov $1, %rdx
	push %rcx
	syscall
	pop %rcx
	inc %rcx
	cmp (%rsp), %rcx
	jnz arg_loop

	mov $1, %rax
	mov $1, %rdi
	mov $newline, %rsi
	mov $1, %rdx
	syscall
	jmp exit

exit: 
	mov $60, %rax
	mov $0, %rdi
	syscall
