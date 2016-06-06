	.file	"asmWstawka.c"
	.section	.rodata
.LC0:
	.string	"%d oraz %d"
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
	pushl	%esi
	pushl	%ebx
	andl	$-16, %esp
	subl	$48, %esp
	.cfi_offset 6, -12
	.cfi_offset 3, -16
	movl	$5, 44(%esp)
	movl	$10, 40(%esp)
	movl	44(%esp), %edx
	movl	40(%esp), %ecx
	movl	%ecx, 24(%esp)
	movl	%edx, %ebx
	movl	24(%esp), %ecx
#APP
# 6 "asmWstawka.c" 1
	

# 0 "" 2
#NO_APP
	movl	%ebx, 28(%esp)
	movl	%ecx, %esi
	movl	%esi, 44(%esp)
	movl	28(%esp), %ebx
	movl	%ebx, 40(%esp)
	movl	40(%esp), %eax
	movl	%eax, 8(%esp)
	movl	44(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC0, (%esp)
	call	printf
	leal	-8(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
