	.file	"uzywanieFunkcjiAsm.c"
	.globl	zmiennaC
	.data
	.align 4
	.type	zmiennaC, @object
	.size	zmiennaC, 4
zmiennaC:
	.long	45
	.section	.rodata
.LC0:
	.string	"hue hue hue"
.LC2:
	.string	"%d\t%c\t%f\n"
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
	subl	$48, %esp
	movl	$.LC0, (%esp)
	call	asmStrlen
	movl	%eax, 44(%esp)
	movl	asmFloat, %eax
	movl	.LC1, %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	asmDodajFloat
	fstps	40(%esp)
	movl	$2, 4(%esp)
	movl	$.LC0, (%esp)
	call	asmGetCharAt
	movb	%al, 39(%esp)
	flds	40(%esp)
	movsbl	39(%esp), %eax
	fstpl	12(%esp)
	movl	%eax, 8(%esp)
	movl	44(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC2, (%esp)
	call	printf
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.section	.rodata
	.align 4
.LC1:
	.long	1103276540
	.ident	"GCC: (Debian 4.7.2-5) 4.7.2"
	.section	.note.GNU-stack,"",@progbits
