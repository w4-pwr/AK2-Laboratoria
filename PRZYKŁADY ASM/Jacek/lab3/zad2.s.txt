
znak = 		0b10000000000000000000000000000000
mantysa = 	         0b11111111111111111111111
wykladnik = 0b01111111100000000000000000000000
stala = 	  0b111111100000000000000000000000
ukryte1	= 	        0b100000000000000000000000
inf1 = 		0b01111111100000000000000000000000
inf2 = 		0b11111111100000000000000000000000
mask_inf =  0b01111111111111111111111111111111

	.text
	.p2align 4,,15
.globl float_mul
	.type	float_mul, @function
float_mul:
.LFB11:
	.cfi_startproc
	push	%rax
	push	%rbx
	push	%rcx
	push	%rdx
	
	movl		f1,%eax
	movl		f2,%ebx
	
	#sprawdzanie czy nie jest zerem
	cmp		$0,%eax
	je		zero
	cmp		$0,%ebx
	je		zero
	
	#ustawianie 1 bitu znaku
	andl	$znak,%eax
	andl	$znak,%ebx
	xorl	%eax,%ebx
	movl	%ebx,wynik
	
	#wykladnik
	movl	f1,%eax
	movl	f2,%ebx
	andl 	$wykladnik, %eax
	andl	$wykladnik, %ebx
	subl 	$stala, %eax
	addl 	%eax, %ebx
	cmp		$wykladnik,%rbx
	jg		nieskonczonosc	
	orl		%ebx,wynik
	
	#mantysa
	movl	f1,%eax
	movl	f2,%ebx
	andl	$mantysa,%eax
	andl	$mantysa,%ebx
	orl 	$ukryte1, %eax
	orl 	$ukryte1, %ebx
	imul 	%rbx
	
	#sprawdzanie czy nie wystapilo przeniesienie i zaokraglenie wyniku
	mov 	%rax, %rcx
	mov 	$0x800000000000, %rbx
	andq 	%rbx, %rcx
	shr 	$24, %rcx
	add 	%ecx, wynik
	shr 	$23, %rcx
	shrq 	%cl, %rax
  
	mov 	%rax, %rcx
	andq 	$0x400000, %rcx
	shlq 	$1, %rcx
	add 	%rcx, %rax
	shrq 	$23, %rax
	andq 	$0x7FFFFF, %rax
	orl 	%eax, wynik
	
	
	
	
	
	end:
		pop		%rdx
		pop		%rcx
		pop		%rbx
		pop		%rax
		ret
		
	nieskonczonosc:
		movl	$inf1,%eax
		orl		%eax,wynik
		pop		%rdx
		pop		%rcx
		pop		%rbx
		pop		%rax
		ret
	zero:
		mov		$0,%eax
		mov		%eax,wynik
		pop		%rdx
		pop		%rcx
		pop		%rbx
		pop		%rax
		ret
	
	.cfi_endproc
.LFE11:
	.size	float_mul, .-float_mul
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"%f %f"
.LC1:
	.string	"%f\n"
.LC2:
	.string "*"
	.text
	.p2align 4,,15
.globl main
	.type	main, @function
main:
.LFB12:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$f2, %edx
	movl	$f1, %esi
	movl	$.LC0, %edi
	xorl	%eax, %eax
	call	__isoc99_scanf
	xorl	%eax, %eax
	call	float_mul
	
	
	movss	wynik(%rip), %xmm0
	movl	$.LC1, %edi
	movl	$1, %eax
	cvtps2pd	%xmm0, %xmm0
	call	printf
	xorl	%eax, %eax
	addq	$8, %rsp
		
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE12:
	.size	main, .-main
	.comm	f1,4,4
	.comm	f2,4,4
	.comm	wynik,4,4
	.comm	wynik2,4,4

debug:
	movl	$.LC2, %edi
	movl	$1, %eax
	call	printf
	ret

