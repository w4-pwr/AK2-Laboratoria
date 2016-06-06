.data
	fileOK: .ascii "Otworzono plik\n"
	fileOK_len = .-fileOK
	fileBAD: .ascii "Nie otworzono pliku\n"
	fileBAD_len = .-fileBAD
	filename: .ascii ""
.global open_file
.text
open_file:
	mov	%rdi, %r8
	
	mov	$0, %r15
	mov	(%r8, %r15, 8), %r13		#pobieranie nazwy pliku
	mov	%r13, (filename)

	mov 	$2, %rax			#otwieranie pliku
	mov 	$filename, %rdi
	mov 	$02, %rsi
	syscall
	
	mov	%rax, %r14
	cmp	$0, %r14
	jl	plik_wrong	
plik_ok:	
	mov     $1, %rax
        mov     $1, %rdi
        mov     $fileOK, %rsi
	mov     $fileOK_len, %rdx
        syscall
	jmp	exit

plik_wrong:
	mov     $1, %rax
        mov     $1, %rdi
        mov     $fileBAD, %rsi
	mov     $fileBAD_len, %rdx
        syscall
	jmp	exit

exit:
	mov	%r14, %rax
	ret
