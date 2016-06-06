	.file	"b.c"
	.section	.rodata
.LC0:
	.string	"\nPodaj kat (w stopniach): "
.LC1:
	.string	"%f"
.LC2:
	.string	"\nPodaj precyzje: "
.LC3:
	.string	"%d"
	.align 8
.LC6:
	.string	"Sinus(%.2f) = %.30lf dla %d krokow\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	leaq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC1, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movl	$.LC2, %edi
	movl	$0, %eax
	call	printf
	leaq	-28(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	__isoc99_scanf
	movsd	-24(%rbp), %xmm1
	movsd	.LC4(%rip), %xmm0
	mulsd	%xmm1, %xmm0
	movsd	.LC5(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movsd	%xmm0, -8(%rbp)
	movl	-28(%rbp), %edx
	movq	-8(%rbp), %rax
	movl	%edx, %edi
	movq	%rax, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	call	sinus
	unpcklps	%xmm0, %xmm0
	cvtps2pd	%xmm0, %xmm0
	movsd	%xmm0, -16(%rbp)
	movl	-28(%rbp), %ecx
	movq	-24(%rbp), %rax
	movq	-16(%rbp), %rdx
	movl	%ecx, %esi
	movq	%rdx, -40(%rbp)
	movsd	-40(%rbp), %xmm1
	movq	%rax, -40(%rbp)
	movsd	-40(%rbp), %xmm0
	movl	$.LC6, %edi
	movl	$2, %eax
	call	printf
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 8
.LC4:
	.long	1374389535
	.long	1074339512
	.align 8
.LC5:
	.long	0
	.long	1080459264
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
