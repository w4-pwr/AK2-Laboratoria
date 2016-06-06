.global _start
.data
	arg:	.byte 0
	a:  	.byte  0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00
		.byte  0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00
		.byte  0x00, 0xFF, 0x00, 0x00, 0xFF, 0x00, 0x00, 0xFF
.text
_start:
#---------------------------
# zapisuje argument do arg
#---------------------------
	mov	24(%rsp), %r13	
	movb	(%r13), %r14b
	mov	%r14, arg
#---------------------------
# przygotowanie maski do dodawania
#---------------------------
	mov	32(%rsp), %r13	

	mov	$0, %r15	#licznik
	mov	$0, %r12	#wynik
	
petla:
	movb	(%r13, %r15, 1), %r14b	
	cmp	$0, %r14
	je	1f
	sub	$48, %r14

	mov	$10, %rax	#mnoze zeby zrobic miejsce na nowa liczbe
	mul	%r12
	mov	%rax, %r12

	add	%r14, %r12
	inc 	%r15
	cmp	$3, %r15
	je	1f
	jmp 	petla
	

#w r12 znajduje sie liczba jaka chcemy dodawac do zmiennych

	mov	$0, %r14
1:
	movb	a(,%r14, 1), %r15b
	inc	%r14
	cmp	$23, %r14
	jg	1f
	cmp	$0, %r15
	je	1b
	movb	%r12b, a(,%r14, 1)
	jmp	1b
1:
	
#---------------------------
# wczytywanie pliku, rezerwowanie pamieci
#---------------------------
	mov $2, %rax
	mov 16(%rsp), %rdi
	mov $2, %rsi
	syscall
	cmp $0, %rax
	jg 1f
	mov $60, %rax
	mov $1, %rdi
	syscall
1:	
	mov %rax, %r8
	mov $9, %rax
	mov $0, %rdi
	mov $122880, %rsi
	mov $3, %rdx	#flagi
	mov $1, %r10
	mov $0, %r9
	syscall
	
	mov 2(%rax), %r15d 	#do r15 wrzucamy dlugosc obrazka
	mov $0, %rcx


	cmp 	$114, arg	#jesli r
	je	r
	cmp 	$103, arg	#jesli g
	je 	g	
	cmp 	$98, arg	#jesli b
	je	b
	jmp 	end
r:
	mov	$0, %r8
	jmp	1f
g:
	mov	$2, %r8
	jmp 	1f
b:
	mov $1, %r8	#iterator po maskach

1:
	movq 54(%rax, %rcx, 1), %mm0
	movq a(,%r8,8), %mm1
	paddusb %mm1, %mm0
	movq %mm0, 54(%rax, %rcx, 1)
	cmp $2, %r8
	jne 2f
	movq $-1, %r8
2:	inc %r8
	add $8, %rcx
	cmp %r15, %rcx
	jl 1b
	
end:
	mov %rax, %rdi
	mov $11, %rax
	mov $122880, %rsi
	syscall


	mov $60, %rax
	mov $0, %rdi
	syscall
