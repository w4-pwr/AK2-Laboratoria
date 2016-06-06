SYSCALL = 0x80
EXIT = 1
.data

value1: .float 43.65 
value2: .int 22 
value3: .float 76.34
value4: .float 3.1
value5: .float 12.43
value6: .int 6 
value7: .float 140.2
value8: .float 94.21

a: .float 2.0
b: .float 4.0
c: .float 1.0
const4: .float 4.0
const2: .float 2.0
neg: .float -1.0

delta: .asciz "1Delta: %f\n"

output: .asciz "R2esult %f\n"

.equ ARG1, 2*4
.equ ARG2, 3*4
.equ ARG3, 4*4

.text
.global main
main:

	call rownanie


	break:

	nop 
	nop
	call exit;



rownanie:
	push %ebp #zapis stosu programu głównego 
  	mov %esp, %ebp 	
	finit

	# INVALID OPERATION
	fld1 #laduje 1.0 na stos
	fchs #zmienia znak na ujemny
	fsqrt #zglasza błąd niepoprawnej operacji
	
	mov $0, %eax #czyszcze rejestr przez wprowadzeniem resestru statusu
	fstsw %ax
	_t0:
	mov %ebp, %esp
	pop %ebp
	ret

