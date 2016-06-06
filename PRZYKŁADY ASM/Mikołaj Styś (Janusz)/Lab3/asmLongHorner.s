.data
liczba: .long 0x00000001, 0x00000000
dane: .string "%d\n"
dlugosc: .int 2
.text
.globl main
main:

onext:
	movl $0, %edx
	movl $0, %ecx
	movl $10, %ebx #podstawa systemu
	movl dlugosc, %edi #dlugosc liczby w rejestrach
	nextx:
		#pobranie nowej porcji bajtów
		movl liczba(,%ecx,4), %eax
		#podzielenie przez podstawe systemu
		divl %ebx
		#zapisywanie wyniku
		movl %eax, liczba(,%ecx,4)
		#podzielenie reszty wraz z kolejną
		#porcją danych w następnej iteracji
		incl %ecx
		cmpl %edi, %ecx
		jne nextx
	#wypisywanie końcowej reszty na ekranie	
	pushl %eax
	pushl %edx
	pushl $dane
	call printf
	addl $8, %esp
	popl %eax
	andl %eax, %eax
	#generowanie kolejnych liczb
	jnz onext

call exit
