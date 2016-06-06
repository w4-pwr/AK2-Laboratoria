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
	pushl %ebx
	pushl %ecx
	.cfi_def_cfa_register 5
	movl	$0, %ecx
	jmp	.L2
.L3:
	movl	$1, tab(,%ecx,4)
	incl	%ecx
.L2:
	cmpl	$199999999, %ecx
	jle	.L3
	movl	$0, %ebx
	movl	$0, %ecx
	jmp	.L4
.L5:
	addl	tab(,%ecx,4), %ebx
	incl	%ecx
.L4:
	cmpl	$199999999, %ecx
	jle	.L5
	pushl	%ebx
	pushl	$.LC0
	call	printf
	movl	$0, %eax
	popl %ecx
	popl %ebx
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
