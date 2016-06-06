.text
	filename: .ascii "plik.txt\0"
.global _start
_start:
	mov $2, %rax
	mov $filename, %rdi
	mov $02, %rsi
	syscall 
	
	mov %rax, %r8
	mov $9, %rax
	mov $0, %rdi
	mov $4096, %rsi
	mov $0x3, %rdx
	mov $0x1, %r10
	mov $0, %r9
	syscall
#zamieniamy teraz male litery na duze litery
	mov $0, %rcx
loop:
	cmp $0, (%rax, %rcx, 1)
	je exit
	inc %rcx
	cmpb $97, -1(%rax, %rcx, 1)
	jl loop				#ponizej malej literki a
	cmpb $122, -1(%rax, %rcx, 1)
	jg loop
	subb $32, -1(%rax, %rcx, 1)
	jmp loop
exit:
	mov %rax, %rdi
	mov $11, %rax
	mov $4096, %rsi
	syscall	
	mov $60, %rax
	mov $0, %rdi
	syscall
