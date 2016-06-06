.align 32
.data 


#wyjatki
invalid_operation: .string "Niedozwolona operacja"
denorm: .string "Zdenormalizowana"
zero_div: .string "Dzielenie przez zero"
ovrflw: .string "Overflow"
undrflw: .string "Underflow"
prcsn: .string "Precision warning"


# liczenie rowniania kwadratowego
a: .float 2.0
b: .float 4.0
c: .float 1.0
const4: .float 4.0
const2: .float 2.0
neg: .float -1.0
delta: .asciz "Pierwiastek: %f\n"

format_output: .string "Test\n"

#------------------------ ZAD 1 - RZUCANIE WYJATKOW -- START
.globl throwExceptions
.type throwExceptions, @function
throwExceptions:
	push %ebp #zapis stosu programu głównego 
  	mov %esp, %ebp # ustawienie nowego stosu w miejscu aktualnej pozycji stosu 
	
	finit #inicjalizuje jednostkę, resetując jej stan (maskowanie wyjątków)
	
	# LICZBA ZDENORMALIZOWANA
	pushl $0x0000000F #liczba zdenormalizowana
	fld (%esp) #daje na stos 0x0000000F
	fldz #laduje +0.0 na stos
	faddp #zgłasza błąd: liczba z denormalizowana
	
	# INVALID OPERATION
	fld1 #laduje 1.0 na stos
	fchs #zmienia znak na ujemny
	fsqrt #zglasza błąd niepoprawnej operacji
	
	# DZIELENIE PRZEZ ZERO
	fld1 #daje 1.0 na stos
	fldz # daje 0.0 na stos
	fdivrp #zglasza blad dzielenie przez 0

	# BLAD PRECYZJI ORAZ NADMIARU
	pushl $32767
	fild (%esp) # daje 32767 na stos
	fld1 #daje 1.0 na stos
	fscale #zglasza blad precyzji oraz nadmiaru

	#BLAD PRECYZJI ORAZ NIEDOMIARU
	pushl $32768 
	fild (%esp) #daje 32768
	fld1 #daje 1.0 na stos
	fscale #zglasza blad precyzji oraz niedomiaru
	
	mov %ebp, %esp
	pop %ebp
  	ret #powrót do adresu instrukcji zapisanej na stosie
#------------------------ ZAD 1 - RZUCANIE WYJATKOW -- STOP


#------------------------ ZAD 1 - ODCZYT WYJATKOW -- START
.globl showExceptions
.type showExceptions, @function
showExceptions:
	push %ebp
	mov %esp, %ebp

	mov $1, %dl
	
	
	mov $0, %eax #czyszcze rejestr przez wprowadzeniem resestru statusu
	fstsw %ax
	_t0: #w %al jest status rejestrów 
	
	#8,9,10 i 14 Condition code bit 2 (C2)
	#fstsw %ax
	#subl $6, %esp

check_invalid_operation:
	testb %al, %dl
	jz check_denormalization
	movl $invalid_operation, (%esp)
	call display_exception
	
check_denormalization:
	salb $1, %dl #przesuniecie o jeden w lewo
	testb %al, %dl # sprawdzenie czy 
	jz check_zero_division # jesli zero (nie ma wyjatku) to kolejne sprawdzeni
	movl $denorm, (%esp)
	call display_exception
	
check_zero_division:
	salb $1, %dl
	testb %al, %dl
	jz check_overflow
	movl $zero_div, (%esp)
	call display_exception
	
check_overflow:
	salb $1, %dl
	testb %al, %dl
	jz check_underflow
	movl $ovrflw, (%esp)
	call display_exception
	
check_underflow:
	salb $1, %dl
	testb %al, %dl
	jz check_precision
	movl $undrflw, (%esp)
	call display_exception

check_precision:
	salb $1, %dl
	testb %al, %dl
	jz end_check
	movl $prcsn, (%esp)
	call display_exception
	
end_check:
	fclex # czysci wszystkie wyjatki
	
	mov %ebp, %esp
	pop %ebp
  	ret
	
display_exception:
	push %eax
	push %edx
	push 12(%esp)
	call puts
	addl $4, %esp
	pop %edx
	pop %eax
	ret
#------------------------ ZAD 1 - ODCZYT WYJATKOW -- STOP
	

#------------------------ ZAD 2 - PIERWIASTEK RÓWNANIA KWADRATOWEGO -- START
.globl quadricEquation
.type quadricEquation, @function
quadricEquation:

	push %ebp #zapis stosu programu głównego 
  	mov %esp, %ebp 

	mov 8(%ebp), %eax 	#a
	mov 12(%ebp), %ebx	#b
	mov 16(%ebp), %ecx 	#c

  	finit 
  	flds 12(%ebp)
  	fmul 12(%ebp)
  	# wynik w st(0) b*b

  	flds const4 # 4 w st(1)
  	fmul 8(%ebp)
  	#wynik w st(1) 4*b
  	#wynik w %st(0) 4*b*c
  	fmul 16(%ebp)

  	fsub %st(0), %st(1)
  	#delta w %st0
  	_delta:

  	fsqrt #pierwiastek(delta) w st(0)

  	flds const2
  	fmul 8(%ebp)
  	# 2 * a w st(0)

  	flds 12(%ebp)
  	fmul neg;
  	# -b w st(0)

  	# fsub %st(2), %st(0) #jeden pierwiastek
  	fadd %st(2), %st(0) #drugi pierwiastek
  	fdiv %st(1), %st(0)

	subl $8, %esp
	fstpl (%esp)

	pushl $delta
	call printf
	add $12, %esp
	pushl $0
  	# -b - sqrt(delta)


	mov %ebp, %esp
	pop %ebp
	ret


display:
	subl $8, %esp
	fstpl (%esp)

	pushl $delta
	call printf
	add $12, %esp
	pushl $0

	mov %ebp, %esp
	pop %ebp
	ret
#------------------------ ZAD 2 - PIERWIASTEK RÓWNANIA KWADRATOWEGO -- STOP


#------------------------ ZAD 3 - HERON -- START
.globl heron
.type heron, @function
heron:
	push %ebp
	mov %esp, %ebp

	# sqrt(p * (p - a) * (p - b) * (p - c))
	fld 8(%ebp)
	fld 12(%ebp)
	fld 16(%ebp)  #dodaje boki na stos

	push $-1
	fild (%esp) # -1 na stos
	fldz #zero na stos

	#obliczam polowe obwodu czyli p = (a+b+c)
	fadd %st(2), %st(0) #wynik w st(0)
	fadd %st(3), %st(0) #wynik w st(0)
	fadd %st(4), %st(0) #wynik w st(0)
	#wynik w st(0) -> p

	fscale # %st(0) ^ 2 p = p/2
	fstp %st(1)

	#od kazdy bok odejmuje od polowy obwodu i zapisuje w jego miejscu
	fsub %st(0), %st(1) # (p - a) -> st(1)
	fsub %st(0), %st(2) # (p - b) -> st(2)
	fsub %st(0), %st(3)	# (p - c) -> st(3)

	#mnoze wartosci i jednoczesnie sciagam ze stosu, 
	#wiec mnoze po kolei wszystkie 4 wartosci 
	fmulp
	fmulp
	fmulp
	
	fsqrt #obliczone pole, koniec
	
	mov %ebp, %esp
	pop %ebp
	ret
#------------------------ ZAD 3 - HERON -- STOP

#------------------------ ZAD 4 - TABLICOWANIE SINUS -- START
.globl sinus
.type sinus, @function
sinus:
	push %ebp
	mov %esp, %ebp



	mov %ebp, %esp
	pop %ebp
	ret
#------------------------ ZAD 4 - TABLICOWANIE SINUS -- STOP



