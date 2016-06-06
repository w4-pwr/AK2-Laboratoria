	.file	"lab6c.c"
.globl x
	.data
	.align 8
	.type	x, @object
	.size	x, 8
x:
	.long	0
	.long	1074528256
	.section	.rodata
.LC0:
	.string	"hax sin:  %10.10f\n"
	.text
.globl main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	movq	%rsp, %rbp
	.cfi_offset 6, -16
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movsd	x(%rip), %xmm0
	movl	$.LC0, %eax
	movq	%rax, %rdi
	movl	$1, %eax
	call	printf
	movl	$0, %eax
	leave
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits
