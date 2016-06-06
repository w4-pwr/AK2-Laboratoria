.data
	buf: .ascii ""
.global allocate
.text
allocate:
	mov	%rdi, %r15	#zapisuje ile potrzebuje pamieci
	mov	$4096, %r14	#obliczam ile musze zarezerwowac
	mov	$0, %r13	#mnoznik do obliczenia ile potrzebuje miejsca

obliczanie_wielkosci_pamieci:
	inc	%r13
	mov	%r14, %rax
	mul	%r13
	mov	%rax, %r14
	cmp	%r15, %r14
	jl	obliczanie_wielkosci_pamieci


	mov 	$9, %rax	#sys_mmap
	mov 	$0,  %rdi
	mov 	%r14, %rsi
	mov 	$0x3, %rdx
	mov 	$0x22, %r10
	mov 	$0, %r9
	mov	$0, %r8
	syscall
			#wynik juz znajduje sie w rax, nie ma potrzeby przesuwania
	ret
