.data
timer: .long 0, 0
szerokosc: .long 0
wysokosc: .long 0
i: .long 0
j: .long 0
hszerokosc: .long 0
hwysokosc: .long 0

.equ P1, 2*4
.equ P2, 3*4
.equ P3, 4*4
.equ P4, 5*4
.equ RGBcount, 3
info: .long 0, 0, 0
.text
.globl getBitmapInfo
.type getBitmapInfo, @function
getBitmapInfo:
	pushl %ebp
	movl %esp, %ebp
	pushl %esi
	pushl %ebx
	
	movl P1(%ebp), %esi
	movl $info, %eax
	movl 0x12(%esi), %ebx #szerokosc
	#bswapl %ebx
	movl %ebx, 0(%eax)
	
	movl 0x16(%esi), %ebx #wysokosc
	#bswapl %ebx
	movl %ebx, 4(%eax)
	
	movl 0xA(%esi), %ebx #poczatek danych
	#bswapl %ebx
	movl %ebx, 8(%eax)
	
	
	popl %ebx
	popl %esi
	leave
	ret
	
.globl grayScale
.type grayScale, @function
grayScale:
	pushl %ebp
	movl %esp, %ebp
	pusha

	movl P1(%ebp), %ebx
	movl $0, %esi
	movl P2(%ebp), %edi
	
	movl $3, %ecx
grayMake:
	movl $0, %eax
	movl $0, %edx
	movb (%ebx, %esi, 1), %al
	addl %edx, %eax
	movb 1(%ebx, %esi, 1), %dl
	addl %edx, %eax
	movb 2(%ebx, %esi, 1), %dl
	addl %edx, %eax
	movb $0, %dl
	divl %ecx
	
	movb %al, (%ebx, %esi, 1);
	movb %al, 1(%ebx, %esi, 1);
	movb %al, 2(%ebx, %esi, 1);
	addl $3, %esi
	cmpl %esi, %edi
	ja grayMake
	
	popa
	leave
	ret
	

.globl grayScaleMmx
.type grayScaleMmx, @function
grayScaleMmx:
	pushl %ebp
	movl %esp, %ebp
	pusha
	emms
	
	movl P1(%ebp), %ebx
	movl $0, %esi
	movl P2(%ebp), %edi
	
grayMakeMmx:

	pxor %mm0, %mm0
	movq (%ebx, %esi, 1), %mm1
	movq %mm1, %mm2
	
	psllq $16, %mm2 #usuwam dwa ostatnie bity
	psrlq $8, %mm2
	
	movq %mm2, %mm3
	punpckhbw %mm0, %mm3 #separuje piksele
	punpcklbw %mm0, %mm2
	
	psadbw %mm0, %mm3#sumuje wartości
	psadbw %mm0, %mm2
	
	psllq $32, %mm3
	paddq %mm3, %mm2
	
	movq2dq %mm2, %xmm0
	cvtdq2ps %xmm0, %xmm0

	pushl $3
	pushl $3
	movq (%esp), %xmm1 #dzielenei przez 3
	cvtdq2ps %xmm1, %xmm1
	divps %xmm1, %xmm0
	cvtps2pi %xmm0, %mm2


	movq %mm2, %mm3
	movq %mm2, %mm4
	psrlq $8, %mm4
	psllq $8, %mm4
	psrlq $8, %mm3
	por %mm3, %mm4
	pxor %mm4, %mm2
	
	movq %mm2, %mm3
	psllq $8, %mm3
	por %mm3, %mm2
	psllq $8, %mm3
	por %mm3, %mm2
	
	movl $0xFFFF0000, 4(%esp)
	movl $0x0, (%esp)
	movq (%esp), %mm0
	pand %mm0, %mm1
	por %mm2, %mm1
	movq %mm1, (%ebx, %esi, 1)
	
	addl $2*4, %esp
	addl $6, %esi
	cmp %esi, %edi
	ja grayMakeMmx
	
	emms
	popa
	leave
	ret
	
.globl changeBrightnessMmx
.type changeBrightnessMmx, @function
changeBrightnessMmx:
	pushl %ebp
	movl %esp, %ebp
	pusha
	emms
	
	movl P1(%ebp), %ebx
	movl $0, %esi
	movl P2(%ebp), %edi
	
	
	movl P3(%ebp), %eax

	cmpl $0, %eax
	jg nextMmxBr
	negl %eax
	
nextMmxBr:
	movd %eax, %xmm0
	movdqa %xmm0, %xmm1
	movl $16, %ecx
mmxBrightnessFill:
	pslldq $1, %xmm1
	por %xmm1, %xmm0
	loop mmxBrightnessFill
	
	movl P3(%ebp), %eax
	cmpl $0, %eax
	jl mmxDarkness
	
mmxBrightness:
	movdqu (%ebx, %esi, 1), %xmm1
	paddusb %xmm0, %xmm1
	movdqu %xmm1, (%ebx, %esi, 1) 
	addl $4, %esi
	cmp %esi, %edi
	ja mmxBrightness
	jmp endMmxBrightness
	
mmxDarkness:
	movdqu (%ebx, %esi, 1), %xmm1
	psubusb %xmm0, %xmm1
	movdqu %xmm1, (%ebx, %esi, 1) 
	addl $4, %esi
	cmp %esi, %edi
	ja mmxDarkness

endMmxBrightness:
	emms
	popa
	leave
	ret

.globl changeBrightness
.type changeBrightness, @function
changeBrightness:
	pushl %ebp
	movl %esp, %ebp
	pusha

	movl P1(%ebp), %ebx
	movl $0, %esi
	movl $0, %eax
	movl $0xFF, %edx
	movl P2(%ebp), %edi
	movl P3(%ebp), %ecx
	
	cmpl $0, %ecx
	jge cbto1
	movb $0, %dl
	negl %ecx
cbto2:
	movb (%ebx, %esi, 1), %al
	subb %cl, %al
	jnc cBn2
	movb %dl, %al
cBn2:
	movb %al, (%ebx, %esi, 1)
	incl %esi
	cmpl %esi, %edi
	ja cbto2
	
	jmp cbtnend
	
cbto1:
	movb (%ebx, %esi, 1), %al
	addb %cl, %al
	jnc cBn1
	movb %dl, %al
cBn1:
	movb %al, (%ebx, %esi, 1)
	incl %esi
	cmpl %esi, %edi
	ja cbto1
	
cbtnend:


	popa
	leave
	ret
	
	
.globl changeContrastMmx
.type changeContrastMmx, @function
changeContrastMmx:
	pushl %ebp
	movl %esp, %ebp
	pusha
	
	movl P1(%ebp), %ebx
	movl P2(%ebp), %edi

	finit
	pushl $255
	fild (%esp)
	movl $259, (%esp)
	fild (%esp)
	fild P3(%ebp)
	fld %st(0)
	fadd %st(3), %st(0)
	fxch %st(1)
	fsubr %st(2), %st(0)
	fmulp %st(0), %st(3)
	fmulp %st(0), %st(1)
	fdivp %st(0), %st(1)
	fstp (%esp)
	emms
	movd (%esp), %xmm0
	
	addl $4, %esp
	movdqu %xmm0, %xmm1
	pslldq $4, %xmm1
	por %xmm1, %xmm0
	pslldq $4, %xmm1
	por %xmm1, %xmm0
	pslldq $4, %xmm1
	por %xmm1, %xmm0
	
	
nextContrast:
	movd (%ebx, %esi, 1), %xmm1
	pxor %xmm2, %xmm2
	punpcklbw %xmm2, %xmm1
	punpcklwd %xmm2, %xmm1
	cvtdq2ps %xmm1, %xmm1
	
	mulps %xmm0, %xmm1
	cvtps2dq %xmm1, %xmm1
	
	packuswb %xmm2, %xmm1
	packuswb %xmm2, %xmm1
	
	movd %xmm1, (%ebx, %esi, 1)
	addl $4, %esi
	cmp %esi, %edi
	ja nextContrast
	
	emms
	popa
	leave
	ret
	
.globl mirrorHorizontalMmx
.type mirrorHorizontalMmx, @function
mirrorHorizontalMmx:
	pushl %ebp
	movl %esp, %ebp
	pusha
	emms
	
	movl P1(%ebp), %ebx
	movl P2(%ebp), %ecx
	movl P3(%ebp), %edx

	pxor %xmm2, %xmm2
	
xchgMirrrorV0:
	movl $0, %esi
	movl %edx, %edi
	decl %edi
	movl %edx, %eax
	sarl %eax
	
xchgMirrrorV:
	movd (%ebx, %esi, 1), %mm0
	#movd %mm0, %mm3
	movd (%ebx, %edi, 1), %mm1
	#movd %mm1, %mm4
	
	punpcklbw %mm2, %mm1
	punpcklbw %mm2, %mm0
	
	pshufw $0b01001110, %mm0, %mm0
	pshufw $0b01001110, %mm1, %mm1
	
	
	packuswb %mm2, %mm0
	packuswb %mm2, %mm1
	movq %mm1, (%ebx, %esi, 1)
	movq %mm0, (%ebx, %edi, 1)
	
	addl $4, %esi
	subl $4, %edi
	cmpl %esi, %eax
	ja xchgMirrrorV
	
loop xchgMirrrorV0
	emms
	popa
	leave
	ret
	
.globl changeContrast
.type changeContrast, @function
changeContrast:
	pushl %ebp
	movl %esp, %ebp
	pusha
	
	movl P1(%ebp), %ebx
	movl P2(%ebp), %edi

	finit
	pushl $255
	fild (%esp)
	movl $259, (%esp)
	fild (%esp)
	addl $4, %esp
	fild P3(%ebp)
	fld %st(0)
	fadd %st(3), %st(0)
	fxch %st(1)
	fsubr %st(2), %st(0)
	fmulp %st(0), %st(3)
	fmulp %st(0), %st(1)
	fdivp %st(0), %st(1)
	movl $0, %eax
nextContrast2:
 	movb (%ebx, %esi, 1), %al
	pushl %eax
	fild (%esp)
	
	fmul %st(1), %st(0)
	
	fistp (%esp)
	popl %eax
	cmpl $0xFF, %eax
	jbe nc2
	movl $0xFF, %eax
	
nc2:
	movb %al, (%ebx, %esi, 1)
	incl %esi
	cmp %esi, %edi
	ja nextContrast2
	
	emms
	popa
	leave
	ret
	
.globl rotate
.type rotate, @function
rotate:
	pushl %ebp
	movl %esp, %ebp
	pusha
	finit
	
	movl P1(%ebp), %esi #source
	movl P2(%ebp), %edi #dest
	fldl P4(%ebp)
	
	movl P3(%ebp), %ebx #info
	movl 4(%ebx), %eax #height
	movl %eax, wysokosc
	sarl %eax
	movl %eax, hwysokosc
	
	movl (%ebx), %eax #width
	movl %eax, szerokosc
	sarl %eax
	movl %eax, hszerokosc
	
rotateO:
	movl $0, j
	
rotateI:
	
	movl i , %eax
	movl j, %ebx
	
	#cmpl $300, %eax
	#jne lol
	#cmpl $1000, %ebx
	#jne lol
	#testl %eax, %eax
	#lol:
	
	#to cartesian
	movl hwysokosc, %eax
	subl i, %eax
	
	movl j, %ebx
	subl hszerokosc, %ebx
	
	
	#obliczam dlugosc
	pushl %eax
	pushl %ebx
	fild 4(%esp)
	fmul %st(0), %st(0)
	fild (%esp)
	fmul %st(0), %st(0)
	faddp %st(0), %st(1)
	fsqrt #obliczam r
	
	#obliczam kat
	fild 4(%esp)
	fild (%esp)
	fpatan
	
	fsub %st(2), %st(0)
	
	#to cartesian
	fsincos
	fmul %st(2), %st(0)
	fxch %st(1)
	fmul %st(2), %st(0)
	
	fistpl 4(%esp)
	fistpl (%esp)
	
	popl %ebx	
	rdtsc
	movl %eax, timer+4
	movl %edx, timer
	popl %ecx
	fstp %st(0)
	
	#to normal
	addl hszerokosc, %ebx
	movl hwysokosc, %eax
	subl %ecx, %eax
	
	movl i, %ecx
	movl j, %edx
	imull szerokosc, %ecx
	addl %ecx, %edx
	imull $3, %edx
	
	cmpl $0, %eax
	jl blackRotate
	cmpl $0, %ebx
	jl blackRotate
	cmpl wysokosc, %eax
	jge blackRotate
	cmpl szerokosc, %ebx
	jge blackRotate
	
	
	imull szerokosc, %eax
	addl %eax, %ebx
	imull $3, %ebx

	
	movb (%esi, %ebx), %al
	movb %al, (%edi, %edx)
	movb 1(%esi, %ebx), %al
	movb %al, 1(%edi, %edx)
	movb 2(%esi, %ebx), %al
	movb %al, 2(%edi, %edx)
	
	jmp endRotate
blackRotate:

	movb $0x00, %al
	movb %al, 0(%edi, %edx)
	movb %al, 1(%edi, %edx)
	movb %al, 2(%edi, %edx)

endRotate:
	
	movl j, %eax
	incl %eax
	cmpl szerokosc, %eax
	movl %eax, j
	jb rotateI
	
	movl i, %eax
	incl %eax
	cmpl wysokosc, %eax
	movl %eax, i
	jb rotateO
	
	emms
	popa
	leave
	ret
	
.globl negativeMmx
.type negativeMmx, @function
negativeMmx:
	pushl %ebp
	movl %esp, %ebp
	pusha
	
	movl P1(%ebp), %ebx
	movl $0, %esi
	movl P2(%ebp), %edi
	
	pushl $0xFFFFFFFF
	pushl $0xFFFFFFFF
	pushl $0xFFFFFFFF
	pushl $0xFFFFFFFF
	
	movdqu (%esp), %xmm0
	addl $16, %esp
	
mmxNegative:
	movdqu (%ebx, %esi, 1), %xmm1
	movdqu %xmm0, %xmm2
	psubb %xmm1, %xmm2
	movdqu %xmm2, (%ebx, %esi, 1) 

	addl $16, %esi
	cmpl %edi, %esi
	jb mmxNegative
	
	emms
	popa
	leave
	ret
