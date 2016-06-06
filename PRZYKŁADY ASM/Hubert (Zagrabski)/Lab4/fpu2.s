.global _start
.data
	buf1: .space 18
	buf2: .space 10
	kropka: .ascii "."
	enter: .ascii "\n"
.text
_start:
	mov	16(%rsp), %rdi
	mov	$2, %rax
	mov	$0, %rsi
	syscall	
	cmp	$0, %rax
	jg	1f

	mov	$60, %rax
	mov	$2, %rdi
	syscall

1: 
	mov	%rax, %r8
	mov	$9, %rax
	mov	$0, %rdi
	mov	$4096, %rsi
	mov	$1, %rdx
	mov	$2, %r10
	mov	$0, %r9
	syscall

	mov 	$0, %r8		#pozycja w pliku
	mov	$0, %r9		#pozycja w buforeze
	mov	$0, %r10	#pozycja kropki

1:	
	mov	(%rax, %r8, 1), %dl
	cmp	$0x0a, %dl	#koniec pliku
	je	2f
	cmp	$0x2e, %dl
	jne	3f
	mov	%r8, %r10
	inc	%r8
	jmp	1b

3:	
	sub	$0x30, %dl
	mov	%dl, buf1(,%r9, 1)
	inc	%r8
	inc	%r9	#przesuniecie pozycji w buforze
	jmp	1b
2:
	nop
	
	mov	%r9, %r11
	sub	%r10, %r11	#r9 pozycja w buf1
	dec 	%r9
	mov	$0, %r8 	#pozycja buf2

1:
	mov	$0, %al
	mov	buf1(,%r9, 1), %bl
	dec	%r9
	cmp	$0, %r9
	jl	2f
	mov	buf1(,%r9, 1), %al

2:
	shl	$4, %al		#przesuniecie bitowe w lewo
	or	%al, %bl	#dodanie bitowe
	mov	%bl, buf2(,%r8, 1)
	inc	%r8
	dec	%r9
	cmp	$0, %r9
	jge	1b		#rowne wieksze r9=>0
	fbld 	buf2

	mov	%r11, %r12
	jmp	1f
ten: .quad 10
1:	
	fld1	
1:	
	cmp 	$0, %r11
	jle	1f
	fildq	ten
	fmulp	%st(0), %st(1)
	dec	%r11
	jmp	1b

1:
	fdivrp	%st(0), %st(1)	#fdiv podzieli (0)/(1) ->1, a fdivr (1)/(0) ->1

zrobilismyPoleKola:
	fld	%st(0)
	fmulp	%st(0), %st(1)
	fldpi
	fmulp	%st(0), %st(1)	#jak jest z p to znika ze stacka

	fld1
	mov	%r12, %r11
1:
	cmp	$0, %r11
	jle	1f
	fildq	ten
	fmulp	%st(0), %st(1)
	dec	%r11
	jmp	1b
1:	
	fmulp	%st(0), %st(1)
	fbstp	buf2


	mov	$0, %r8	#pozycja w buf1
	mov	$9, %r9	#pozycja w buf2
1:
	dec	%r9
	cmpb	$0, buf2(,%r9,1)
	je	1b
	
	mov	buf2(,%r9,1), %al
	and	$0xF0, %al	#daje pierwsza cyfre bez drugiej
	jnz	1f		#jesli pierwsza nie zero
	mov	buf2(,%r9,1), %al
	add	$0x30, %al
	mov	%al, buf1(,%r8,1)
	dec	%r9
	inc	%r8

1:
	cmp	$0, %r9
	jl	1f	#jesli juz nie jestesmy w tablicy
	mov	buf2(,%r9,1), %al
	mov	%al, %bl
	shr	$4, %al		#przesuniecie w prawo
	and	$0x0F, %bl	#kasuje poczatek zostawia koniec
	add 	$0x30, %al
	add	$0x30, %bl	#na asci	

	mov	%al, buf1(,%r8,1)
	inc	%r8
	mov	%bl, buf1(,%r8,1)
	inc	%r8
	dec	%r9
	jmp 	1b
1:
	mov	$1, %rax
	mov	$1, %rdi
	mov	$buf1, %rsi
	mov	%r8, %rdx
	sub	%r12, %rdx
	syscall

	mov	$1, %rax
	mov	$1, %rdi
	mov 	$kropka,	%rsi
	mov	$1, %rdx
	syscall

	mov	$1, %rax
	mov	$1, %rdi
	lea	buf1(,%r8,1), %rsi
	sub	%r12, %rsi	
	mov	%r12, %rdx
	syscall
	
	
	mov	$1, %rax
	mov	$1, %rdi
	mov 	$enter,	%rsi
	mov	$1, %rdx
	syscall
