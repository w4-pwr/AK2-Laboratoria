.data
.globl asmFloat
asmFloat: .float 50.5
f1l: .float 5.4
.type zmiennaC, @object
.size zmiennaC, 4
.text
.globl asmStrlen
.type asmStrlen, @function
asmStrlen:
	pushl %ebp
	movl %esp, %ebp
	pushl %ecx
	pushl %esi
	movl 2*4(%ebp), %esi
	movl $-1, %ecx
	movl $0, %eax
	strlenLoop:
	incl %ecx
	movb (%esi, %ecx, 1), %al
	andb %al, %al
	jnz strlenLoop
	movl %ecx, %eax
	popl %esi
	popl %ecx
	leave
	ret
.globl asmDodajFloat
.type asmDodajFloat, @function
asmDodajFloat:
	flds	4(%esp)
	fadds	8(%esp)
	ret
.globl asmGetCharAt
.type asmGetCharAt, @function
asmGetCharAt:
	pushl %ebp
	movl %esp, %ebp
	pushl %ecx
	pushl %esi
	movl 2*4(%ebp), %esi
	movl 3*4(%ebp), %ecx
	movb (%esi, %ecx, 1), %al
	popl %esi
	popl %ecx
	leave
	ret
	ret
	
