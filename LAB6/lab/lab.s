SYSCALL = 0x80
EXIT = 1


.align 32
.data 

#wyjatki
invalid: .string "Niedozwolona operacja\n"
denormal: .string "Liczba zdenormalizowna\n"
zero: .string "Dzielenie przez zero\n"
overflow: .string "Przepelnienie\n"
underflow: .string "Underflow\n" 
precision: .string "Precision\n"
stack: .string "Stack fault\n"
status: .int 127
.text
#------------------------ ZAD 1 - RZUCANIE WYJATKOW -- START
.globl main

main:
	jmp throw_exceptions

exit:
	movl $EXIT, %eax
	int  $SYSCALL
	
throw_exceptions:
	finit #inicjalizuje jednostkę, resetując jej stan (maskowanie wyjątków)
	
	# INVALID OPERATION
	fld1 #laduje 1.0 na stos
	fchs #zmienia znak na ujemny
	fsqrt #zglasza błąd niepoprawnej operacji
	
	# DZIELENIE PRZEZ ZERO
	fld1 #daje 1.0 na stos
	fldz # daje 0.0 na stos
	fdivrp #zglasza blad dzielenie przez 0

	#underflow i prcision
	pushl $32829
	fild (%esp) # daje na stos
	fld1 #daje 1.0 na stos
	fscale # potega 2

	#liczba zdenormalizowna
	pushl $0x0000001
	fld (%esp) 
	fldz #laduje +0.0 na stos
	faddp 

  	 #powrót do adresu instrukcji zapisanej na stosie
#------------------------ ZAD 1 - RZUCANIE WYJATKOW -- STOP

show_exceptions:
	mov $0, %edi #czyszcze rejestr przez wprowadzeniem resestru statusu
	fstsw status
	mov status, %edi
	_t0:

invalid_e:
	test $1, %edi
	_t1:
	jz denorm_e #jesli zero (nie ma wyjatku) 
	push $invalid
	call printf

denorm_e:
	test $2, %edi
	jz zero_e
	push $denormal
	call printf
	
zero_e:
	test $4, %edi
	jz overflow_e
	push $zero
	call printf

overflow_e:
	test $8, %edi
	jz underflow_e
	push $overflow
	call printf

underflow_e:
	test $16, %edi
	jz precision_e
	push $underflow
	call printf

precision_e:
	test $32, %edi
	jz clear
	push $precision
	call printf
clear:
	nop
	jmp exit
