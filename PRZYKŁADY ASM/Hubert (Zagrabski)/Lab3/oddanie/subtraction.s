.data
	buf: .ascii ""
.global subtraction
.text
subtraction:
	mov	%rdi, %r8
	mov	$0, %r15		#pierwszy argument po nazwie programu
	
loop:
	inc	%r15
	mov	-1(%r8, %r15, 1), %r13b		#pobieranie przekazanego znaku

	cmpb	$0, %r13b
	je	exit	
		
	mov	%r13, (buf) 			#wypisanie na ekranie
	mov     $1, %rax
        mov     $1, %rdi
        mov     $buf, %rsi
	mov     $1, %rdx
        syscall
	jmp	loop
exit:
	ret
