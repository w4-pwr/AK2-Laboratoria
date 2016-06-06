.data
result: .float 0.0, 0.0, 0.0
oneReal: .string "Tylko jeden prawdziwy, nie szukam"
oneRoot: .string "Trzy identyczne"
reals: .string "Trzy rzeczywiste"
inv_op: .string "Invalid operation!"
denorm: .string "Denormalized!"
zero_div: .string "Zero divide!"
ovrflw: .string "Overflow!"
undrflw: .string "Underflow!"
prcsn: .string "Precision warning!"
.equ P1, 2*4
.equ P2, 3*4
.equ P3, 4*4
.equ P4, 5*4
.text
.globl floatHeron
.type floatHeron, @function
floatHeron:
	pushl %ebp
	movl %esp, %ebp

	fld P1(%ebp)
	fld P2(%ebp)
	fld P3(%ebp)  #dodaje boki na stos
	
	pushl $-1
	fild (%esp)
	movl $0, (%esp)
	fild (%esp)
	#obliczam polowe obwodu
	fadd %st(2), %st(0) 
	fadd %st(3), %st(0)
	fadd %st(4), %st(0)

	fscale
	fstp %st(1)
	#od kazdy bok odejmuje od polowy obwodu i zapisuje w jego miejscu
	fsub %st(0), %st(1)
	fsub %st(0), %st(2)
	fsub %st(0), %st(3)
	#mnoze wartosci 
	fmulp
	fmulp
	fmulp
	
	fsqrt #obliczone pole
	
	leave
	ret
	
.globl floatFlatHeron
.type floatFlatHeron, @function
floatFlatHeron:
	pushl %ebp
	movl %esp, %ebp
	#sortuje argumenty
	xchg P1(%ebp), %eax
	xchg P2(%ebp), %ebx
	xchg P3(%ebp), %ecx
	
	cmpl %ebx, %eax
	jbe next1
	xchg %ebx, %eax
next1:
	cmpl %ecx, %ebx
	jbe next2
	xchg %ecx, %ebx
next2:
	cmpl %ecx, %eax
	jbe next3
	xchg %ecx, %ebx
next3:
	xchg P1(%ebp), %eax
	xchg P2(%ebp), %ebx
	xchg P3(%ebp), %ecx
	#dodaje boki do FPU
	flds P1(%ebp)
	flds P2(%ebp)
	flds P3(%ebp)
	
	fldz
	#obliczam kolejne czynniki
	fadd %st(1), %st(0)
	fadd %st(2), %st(0)
	fadd %st(3), %st(0)

	fldz
	fadd %st(4), %st(0)
	fsub %st(3), %st(0)
	fsubr %st(2), %st(0)
	fmulp %st(0), %st(1)
	
	fldz
	fadd %st(4), %st(0)
	fsub %st(3), %st(0)
	fadd %st(2), %st(0)
	fmulp %st(0), %st(1)
	
	fldz
	fadd %st(3), %st(0)
	fsub %st(2), %st(0)
	fadd %st(4), %st(0)
	fmulp %st(0), %st(1)
	
	fsqrt
	
	pushl $-2
	fild (%esp)
	fxch %st(1)
	fscale #dziele przez 4
	#otrzymuje wynik
	leave
	ret
	
.globl setFloatInnerType
.type setFloatInnerType, @function
setFloatInnerType:
	pushl %ebp
	movl %esp, %ebp
	
	pushl %eax
	pushl %ebx
	
	movb P1(%ebp), %al
	andb $0x03, %al
	
	subl $2, %esp
	fstcw (%esp)
	movb 1(%esp), %bl
	andb $0xFC, %bl
	orb %al, %bl
	movb %bl, 1(%esp)
	fldcw (%esp)
	addl $2, %esp
	
	popl %ebx
	popl %eax
	
	leave
	ret
	
.globl setFloatRC
.type setFloatRC, @function
setFloatRC:
	pushl %ebp
	movl %esp, %ebp
	
	pushl %eax
	pushl %ebx
	
	movb P1(%ebp), %al #pobieram z argumentu 2 ostatnie bity
	andb $0x03, %al #i ustawiam je w odpowienim miejscu
	shlb $3, %al
	
	subl $2, %esp #pobieram na stos rejestr sterujący
	fstcw (%esp)
	movb 1(%esp), %bl 
	andb $0xF3, %bl #wymieniam wartość w rejestrze odpowiadajacą
	orb %al, %bl #za tryb zaokrąglania
	movb %bl, 1(%esp)
	fldcw (%esp) #wczytuje zmodyfikowany rejestr
	addl $2, %esp
	
	popl %ebx
	popl %eax
	
	leave
	ret
.globl getFloatErrorsAndClearThem
.type getFloatErrorsAndClearThem, @function
getFloatErrorsAndClearThem:
	pushl %ebp
	movl %esp, %ebp
	pushl %edx
	pushl %eax
	movl $0, %eax
	movl $0, %edx
	movb $1, %dl
	
	subl $6, %esp
	fstsw 4(%esp)
	movb 4(%esp), %al
	
	testb %al, %dl
	jz post_invalid_operation
	movl $inv_op, (%esp)
	call savePuts
	
post_invalid_operation:
	salb $1, %dl
	testb %al, %dl
	jz post_denormal
	movl $denorm, (%esp)
	call savePuts
	
post_denormal:
	salb $1, %dl
	testb %al, %dl
	jz post_zero_divide
	movl $zero_div, (%esp)
	call savePuts
	
post_zero_divide:
	salb $1, %dl
	testb %al, %dl
	jz post_overflow
	movl $ovrflw, (%esp)
	call savePuts
	
post_overflow:
	salb $1, %dl
	testb %al, %dl
	jz post_underflow
	movl $undrflw, (%esp)
	call savePuts

post_underflow:
	salb $1, %dl
	testb %al, %dl
	jz post_precision
	movl $prcsn, (%esp)
	call savePuts
	
post_precision:
	addl $6, %esp
	fclex
	
	popl %eax
	popl %edx
	leave
	ret
	
savePuts:
	pushl %eax
	pushl %edx
	pushl 12(%esp)
	call puts
	addl $4, %esp
	popl %edx
	popl %eax
	ret
	


	
.globl cubicEquation
.type cubicEquation, @function
cubicEquation:
	pushl %ebp
	movl %esp, %ebp
	#oparte na: http://www.1728.org/cubic2.htm
	#obliczam f
	pushl $3
	fild (%esp) #wczytuje 3
	fld P1(%ebp) #wczytuje a
	fld P3(%ebp) #wczytuje c
	fmul %st(2), %st(0)
	fdiv %st(1), %st(0)
	fld P2(%ebp) #wczytuje b
	fdiv %st(2), %st(0)
	fmul %st(0), %st(0)
	fsubrp 
	fstp %st(1)
	fdivp
	#obliczam g
	movl $2, (%esp) #kolejne stale
	pushl $-9
	pushl $27
	fld P2(%ebp) #wczytuje b
	fld P1(%ebp) #wczytuje a
	fld %st(1) #b
	fdiv %st(1), %st(0) #/a
	fld %st(0)
	fmul %st(0), %st(1) #^2
	fmulp #^3
	fimul 8(%esp)
	fld P3(%ebp)
	fimul 4(%esp) #*-9
	fmul %st(3), %st(0) #*b
	fdiv %st(2), %st(0) #/a
	fdiv %st(2), %st(0) #/a
	faddp
	fld P4(%ebp) #d
	fdiv %st(2), %st(0) #/a
	fimul (%esp) #*27
	faddp
	fidiv (%esp) #/27
	#h
	fstp %st(1)
	fstp %st(1) 
	fxch #zostaje g i f
	addl $4, %esp
	movl $3, (%esp)
	fidiv (%esp)
	addl $4, %esp
	fld %st(0)
	fmul %st(1), %st(0)
	fmulp
	fld %st(1)
	fidiv (%esp)
	fmul %st(0), %st(0)
	faddp #otrzymuje h
	fldz
	addl $4, %esp
	fcomip %st(1), %st(0)
	jc jeden_real
	jz identyczne
	
	pushl $reals
	call puts
	
	movl $2, (%esp) #obliczam i
	fild (%esp)
	fld %st(2)
	fdiv %st(1), %st(0)
	fmul %st(0), %st(0)
	fsub %st(2)
	fsqrt

	fst %st(1) #obliczam L -> j
	pushl $20
	pushl $3 #precyzja, 0.02 sie sypie
	subl $4, %esp
	fstp (%esp)
	call floatRoot
	fchs
	fld %st(1) #obliczam k
	movl $2, (%esp) 
	fild (%esp)
	fmulp
	fld %st(4)
	fdivp
	fchs
	fstp (%esp)
	call floatACos 
	movl $3, (%esp)
	fild (%esp)
	fdivrp
	fst %st(2) # k -> i
	fcos
	fstp %st(3) #zamiast H
	fld  %st(1) #kolejnosc L, k/3, M. g
	fsin
	fild (%esp) #pobieram 3
	fsqrt #sqrt 3
	fmulp #obliczylem N
	fld P2(%ebp)
	fld P1(%ebp)
	fild (%esp)
	fmulp
	fdivrp
	fchs #obliczylem p
	fstp %st(5) #teraz jest N, L, k/3, M, P
	fld %st(0)
	fadd %st(4), %st(0) #x2, blad 0.02
	fmul %st(2), %st(0)
	fadd %st(5)
	fstp (result + 4)
	fld %st(0)
	fsubr %st(4), %st(0) #x2
	fmul %st(2), %st(0)
	fadd %st(5) #x3
	fstp (result + 8)
	fxch
	fchs
	movl $2, (%esp)
	fild (%esp)
	fmulp #2j, N, k/3 , M, P
	fstp %st(3)
	fstp %st(0) #k/3, 2j, P
	fcos
	fmulp
	faddp
	fstp result
	jmp end_cubic
	
jeden_real:
	pushl $oneReal
	call puts
	jmp end_cubic
identyczne:
	pushl $oneRoot
	call puts
	
	fld P1(%ebp) #sprzatem stos i obliczam pierwiatsek
	fstp %st(2) 
	fld P4(%ebp)
	fstp %st(1) 
	fdivp
	pushl $20
	pushl $3
	subl $4, %esp
	fstp (%esp)
	call floatRoot
	fchs
	
end_cubic:
	movl $result, %eax
	leave
	ret

.globl floatRoot
.type floatRoot, @function
floatRoot:
	pushl %ebp
	movl %esp, %ebp
	
	pushl %ecx
	movl P3(%ebp), %ecx
	#numeryczne zondzom

	fild P2(%ebp) #b
	fld P1(%ebp) #a
	fld %st(0) #wartosc przyblizenia
	
times:
	fld %st(0)
	fdivr %st(2), %st(0)
	faddp
	fdiv %st(2), %st(0)
	
	loop times
	fstp %st(1)
	fstp %st(1)
	popl %ecx

	#pushl $3
	#call setFloatRC
	#movl $3, (%esp)
	#call setFloatInnerType
	#addl $4, %esp

	#fldl 4*4(%ebp)
	#fldl 2*4(%ebp)
	#fyl2x
	#fld  %st(0)     
	#frndint       
	#fsub %st(0), %st(1)
	#fxch   
	#f2xm1         
	#fld1          
	#faddp  
	#fscale        
	#fstp %st(1)    
	
	leave
	ret
	
.globl floatACos
.type floatACos, @function
floatACos:
	pushl %ebp
	movl %esp, %ebp

	fld P1(%ebp) #X
	fld %st(0)
	fmul %st(0), %st(0)
	fld1
	fsubp
	fsqrt
	fxch
	fld1
	faddp
	fpatan
	pushl $2
	fild (%esp)
	fmulp
	
	leave
	ret
	
.globl floatAction
.type floatAction, @function
floatAction:
	pushl %ebp
	movl %esp, %ebp	

	
	finit #inicjalizuje jednostkę, resetując jej stan (maskowanie wyjątków)
	
	pushl $0x0000000F #liczba zdenormalizowana
	fld (%esp)
	fldz #dodaje zero
	faddp #zgłasza błąd: liczba zdenormalizowana
	
	fld1
	fchs #pierwiastek z liczby ujemnej
	fsqrt #zglasza błąd niepoprawnej operacji
	
	fld1
	fldz
	fdivrp #zglasza blad dzielenie przez 0

	pushl $32767
	fild (%esp)
	fld1
	fscale #zglasza blad precyzji oraz nadmiaru

	pushl $32768
	fild (%esp)
	fld1
	fscale #zglasza blad precyzji oraz niedomiaru
	
	leave
	ret
