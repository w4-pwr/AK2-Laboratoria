.global _start
.data
	a: .single 16.5
	b: .double 32.25
	c: .tfloat 64.125
_start:
	flds 	a
	fldl	b
	fadd	%st(0), %st(1) 	#zawsze musi byc st(0)
	fsts	a
	finit
	flds	a
	fldl 	b
	faddp	%st(0), %st(1)
	fstps 	a
	
	fld1	#wrzuca 1 na gore stosu
	fldpi
	fldl2t
	
	finit
	fld	a
	fsqrt	#pierwiastek z gory stosu)
	
	fchs	#zmienia znak
	fabs	#wartosc bezwzgledna
	
	fld	%st(0) 	#klonuje gore stosu
	fmulp	%st(0), %st(1)	#mnozenie
	#fdiv dzielimy

liczba:	.long 882
brejk:
1:
	fildl	liczba 	#laduje inta
	fimul	liczba	#mnozy / kwadrat robi
	#fistl	liczba	#zapisuje liczbe (nie do tekstu!)
	
