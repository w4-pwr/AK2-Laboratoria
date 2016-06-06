	.file	"cheat.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"ASM"
.LC1:
	.string	"C++"
.LC2:
	.string	"B"
.LC3:
	.string	"A"
.LC4:
	.string	"%40s | %40s | %40s | %40s\n"
.LC5:
	.string	"-"
.LC6:
	.string	"\n"
	.text
	.p2align 4,,15
.globl print_header
	.type	print_header, @function
print_header:
.LFB38:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	movl	$.LC0, %r9d
	movl	$.LC1, %r8d
	movl	$.LC2, %ecx
	movl	$.LC3, %edx
	movl	$.LC4, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	xorl	%ebx, %ebx
	.cfi_offset 3, -16
	call	__printf_chk
	.p2align 4,,10
	.p2align 3
.L2:
	xorl	%eax, %eax
	movl	$.LC5, %esi
	movl	$1, %edi
	addl	$1, %ebx
	call	__printf_chk
	cmpl	$169, %ebx
	jne	.L2
	popq	%rbx
	movl	$.LC6, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	jmp	__printf_chk
	.cfi_endproc
.LFE38:
	.size	print_header, .-print_header
	.section	.rodata.str1.1
.LC7:
	.string	"%lu"
.LC8:
	.string	" "
	.text
	.p2align 4,,15
.globl print_long
	.type	print_long, @function
print_long:
.LFB35:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	movq	%rdi, %r12
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	movl	$1, %ebp
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	movl	$63, %ebx
	.cfi_offset 3, -32
	.p2align 4,,10
	.p2align 3
.L14:
	movl	%ebx, %ecx
	movq	%rbp, %rdx
	xorl	%eax, %eax
	salq	%cl, %rdx
	movl	$.LC7, %esi
	movl	$1, %edi
	andq	%r12, %rdx
	subq	$1, %rbx
	shrq	%cl, %rdx
	call	__printf_chk
	cmpq	$-1, %rbx
	je	.L15
	leaq	-30(%rbx), %rax
	cmpq	$1, %rax
	jbe	.L11
	cmpq	$22, %rbx
	.p2align 4,,3
	jne	.L14
.L11:
	movl	$.LC8, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	jmp	.L14
	.p2align 4,,10
	.p2align 3
.L15:
	popq	%rbx
	popq	%rbp
	popq	%r12
	movl	$.LC6, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	jmp	__printf_chk
	.cfi_endproc
.LFE35:
	.size	print_long, .-print_long
	.section	.rodata.str1.1
.LC9:
	.string	"Ec & 0xFFFFFFFF80000000L"
.LC10:
	.string	"%20s:  "
	.text
	.p2align 4,,15
.globl float_mul
	.type	float_mul, @function
float_mul:
.LFB36:
	.cfi_startproc
	movq	%rbx, -40(%rsp)
	movq	%rbp, -32(%rsp)
	movq	%r12, -24(%rsp)
	movq	%r13, -16(%rsp)
	movq	%r14, -8(%rsp)
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movss	a(%rip), %xmm0
	movss	b(%rip), %xmm1
	mulss	%xmm1, %xmm0
	movss	%xmm0, q(%rip)
	movl	a(%rip), %eax
	testl	%eax, %eax
	je	.L17
	.cfi_offset 14, -16
	.cfi_offset 13, -24
	.cfi_offset 12, -32
	.cfi_offset 6, -40
	.cfi_offset 3, -48
	movl	b(%rip), %eax
	testl	%eax, %eax
	je	.L17
	movl	a(%rip), %ebx
	movl	b(%rip), %edx
	movl	a(%rip), %eax
	andl	$2139095040, %eax
	cmpl	$2139095040, %eax
	je	.L28
.L20:
	movl	b(%rip), %eax
	andl	$2139095040, %eax
	cmpl	$2139095040, %eax
	je	.L29
.L21:
	movl	a(%rip), %r13d
	movl	b(%rip), %r12d
	xorl	%edx, %ebx
	andl	$-2147483648, %ebx
	andl	$2139095040, %r13d
	andl	$2139095040, %r12d
	subq	$1065353216, %r13
	movq	%r13, %rbp
	addq	%r12, %rbp
	js	.L27
	movq	%rbp, %r14
	movl	$.LC9, %edx
	movl	$.LC10, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	andq	$-2147483648, %r14
	call	__printf_chk
	movq	%r14, %rdi
	call	print_long
	testq	%r14, %r14
	jne	.L30
	movl	a(%rip), %edx
	andl	$8388607, %edx
	movl	%edx, %eax
	orl	$8388608, %eax
	testq	%r13, %r13
	cmovne	%eax, %edx
	movl	b(%rip), %eax
	mov	%edx, %edx
	andl	$8388607, %eax
	movl	%eax, %ecx
	orl	$8388608, %ecx
	testq	%r12, %r12
	cmovne	%ecx, %eax
	mov	%eax, %eax
	imulq	%rdx, %rax
	movabsq	$140737488355328, %rdx
	andq	%rax, %rdx
	movq	%rdx, %rcx
	shrq	$24, %rdx
	shrq	$47, %rcx
	leaq	(%rdx,%rbp), %rbp
	shrq	%cl, %rax
	movq	%rax, %rcx
	orl	%ebp, %ebx
	andl	$4194304, %ecx
	leaq	(%rax,%rcx,2), %rax
	shrq	$23, %rax
	andl	$8388607, %eax
	orl	%eax, %ebx
.L27:
	movl	%ebx, c(%rip)
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L17:
	movl	$0, c(%rip)
.L26:
	movq	(%rsp), %rbx
	movq	8(%rsp), %rbp
	movq	16(%rsp), %r12
	movq	24(%rsp), %r13
	movq	32(%rsp), %r14
	addq	$40, %rsp
	ret
	.p2align 4,,10
	.p2align 3
.L28:
	movl	a(%rip), %eax
	testl	$8388607, %eax
	je	.L20
	movl	a(%rip), %eax
	movl	%eax, c(%rip)
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L29:
	movl	b(%rip), %eax
	testl	$8388607, %eax
	je	.L21
	movl	b(%rip), %eax
	movl	%eax, c(%rip)
	jmp	.L26
	.p2align 4,,10
	.p2align 3
.L30:
	orl	$2139095040, %ebx
	movl	%ebx, c(%rip)
	jmp	.L26
	.cfi_endproc
.LFE36:
	.size	float_mul, .-float_mul
	.section	.rodata.str1.1
.LC11:
	.string	"%40f * %40f = %40f | %40f\n"
	.text
	.p2align 4,,15
.globl run
	.type	run, @function
run:
.LFB37:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	xorl	%eax, %eax
	call	float_mul
	movss	c(%rip), %xmm3
	movl	$.LC11, %esi
	movss	q(%rip), %xmm2
	movl	$1, %edi
	movss	b(%rip), %xmm1
	movl	$4, %eax
	movss	a(%rip), %xmm0
	addq	$8, %rsp
	unpcklps	%xmm0, %xmm0
	unpcklps	%xmm3, %xmm3
	unpcklps	%xmm2, %xmm2
	unpcklps	%xmm1, %xmm1
	cvtps2pd	%xmm0, %xmm0
	cvtps2pd	%xmm3, %xmm3
	cvtps2pd	%xmm2, %xmm2
	cvtps2pd	%xmm1, %xmm1
	jmp	__printf_chk
	.cfi_endproc
.LFE37:
	.size	run, .-run
	.section	.rodata.str1.1
.LC12:
	.string	"%u"
	.text
	.p2align 4,,15
.globl print
	.type	print, @function
print:
.LFB34:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	movl	$31, %r12d
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	movl	%edi, %ebp
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	movl	$1, %ebx
	.cfi_offset 3, -32
	.p2align 4,,10
	.p2align 3
.L41:
	movl	%r12d, %ecx
	movl	%ebx, %edx
	xorl	%eax, %eax
	sall	%cl, %edx
	movl	$.LC12, %esi
	movl	$1, %edi
	andl	%ebp, %edx
	subl	$1, %r12d
	shrl	%cl, %edx
	call	__printf_chk
	cmpl	$-1, %r12d
	je	.L42
	cmpl	$22, %r12d
	je	.L38
	cmpl	$30, %r12d
	.p2align 4,,5
	jne	.L41
.L38:
	movl	$.LC8, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L42:
	popq	%rbx
	popq	%rbp
	popq	%r12
	movl	$.LC6, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	jmp	__printf_chk
	.cfi_endproc
.LFE34:
	.size	print, .-print
	.p2align 4,,15
.globl rand_test
	.type	rand_test, @function
rand_test:
.LFB39:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	xorl	%edi, %edi
	xorl	%eax, %eax
	pushq	%rbx
	.cfi_def_cfa_offset 24
	xorl	%ebx, %ebx
	.cfi_offset 3, -24
	.cfi_offset 6, -16
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	time
	movl	%eax, %edi
	call	srand
	.p2align 4,,10
	.p2align 3
.L44:
	call	rand
	movl	%eax, %ebp
	addl	$1, %ebx
	call	rand
	movl	%ebp, %edx
	shrl	$31, %edx
	addl	%edx, %ebp
	andl	$1, %ebp
	subl	%edx, %ebp
	leal	-1(%rbp,%rbp), %ebp
	imull	%eax, %ebp
	movl	%ebp, a(%rip)
	call	rand
	movl	%eax, %ebp
	call	rand
	movl	%ebp, %edx
	shrl	$31, %edx
	addl	%edx, %ebp
	andl	$1, %ebp
	subl	%edx, %ebp
	leal	-1(%rbp,%rbp), %ebp
	imull	%eax, %ebp
	xorl	%eax, %eax
	movl	%ebp, b(%rip)
	call	run
	cmpl	$10, %ebx
	jne	.L44
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	ret
	.cfi_endproc
.LFE39:
	.size	rand_test, .-rand_test
	.section	.rodata.str1.1
.LC13:
	.string	"%f"
.LC14:
	.string	"Usage: %s     - random test\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC15:
	.string	"       %s A B - test specified numbers\n"
	.text
	.p2align 4,,15
.globl main
	.type	main, @function
main:
.LFB40:
	.cfi_startproc
	cmpl	$1, %edi
	pushq	%rbx
	.cfi_def_cfa_offset 16
	movq	%rsi, %rbx
	.cfi_offset 3, -16
	je	.L52
	cmpl	$3, %edi
	je	.L53
	movq	(%rsi), %rdx
	movl	$1, %edi
	movl	$.LC14, %esi
	xorl	%eax, %eax
	call	__printf_chk
	movq	(%rbx), %rdx
	movl	$.LC15, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	__printf_chk
.L49:
	xorl	%eax, %eax
	popq	%rbx
	ret
	.p2align 4,,10
	.p2align 3
.L53:
	xorl	%eax, %eax
	call	print_header
	movq	8(%rbx), %rdi
	movl	$a, %edx
	movl	$.LC13, %esi
	xorl	%eax, %eax
	call	__isoc99_sscanf
	movq	16(%rbx), %rdi
	movl	$b, %edx
	movl	$.LC13, %esi
	xorl	%eax, %eax
	call	__isoc99_sscanf
	xorl	%eax, %eax
	call	run
	xorl	%eax, %eax
	popq	%rbx
	ret
	.p2align 4,,10
	.p2align 3
.L52:
	xorl	%eax, %eax
	call	print_header
	xorl	%eax, %eax
	call	rand_test
	jmp	.L49
	.cfi_endproc
.LFE40:
	.size	main, .-main
	.comm	a,4,4
	.comm	b,4,4
	.comm	c,4,4
	.comm	q,4,4
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
