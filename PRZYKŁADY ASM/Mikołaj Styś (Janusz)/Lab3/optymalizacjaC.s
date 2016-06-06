	.file	"optymalizacjaC.c"
	.comm	tab,800000000,32
	.section	.rodata
.LC0:
	.string	"%d \n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	andl	$-16, %esp
	subl	$32, %esp
	movl	$0, 28(%esp)
	jmp	.L2
.L3:
	movl	28(%esp), %eax
	movl	$1, tab(,%eax,4)
	addl	$1, 28(%esp)
.L2:
	cmpl	$199999999, 28(%esp)
	jle	.L3
	movl	$0, 24(%esp)
	movl	$0, 28(%esp)
	jmp	.L4
.L5:
	movl	28(%esp), %eax
	movl	tab(,%eax,4), %eax
	addl	%eax, 24(%esp)
	addl	$1, 28(%esp)
.L4:
	cmpl	$199999999, 28(%esp)
	jle	.L5
	movl	24(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC0, (%esp)
	call	printf
	movl	$0, %eax
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
