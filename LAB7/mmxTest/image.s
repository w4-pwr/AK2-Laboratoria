ZERO = 0
.data
info: .long 0, 0, 0
.text

.globl main
main:
	pushl $4 #4 bajty na stos, 32bit
	pushl $1 #64 bit
	pushl $2 #96 bit
	pushl $4 #128
	movdqu (%esp), %xmm0 #wyslanie tego co na stosie (128bity) do %xmm0

	_b1:

	pushl $6
	pushl $5
	pushl $8
	# mov 8(%ebp), %eax
    # movq (%eax), %mm0

	movq (%esp), %xmm1
	_b2:

	paddb %xmm0, %xmm1

	_b3:
	
	movq (%ebx, %esi, 1), %xmm1 #1 bajt * %esi (na poczatku 0) z ebx (poczatek danych) do %xmm
	movq %xmm0, %xmm2 # xmm0 (same 0xF) do xmm2
	psubd %xmm1, %xmm2
	#wynik w xmm2
	movq %xmm2, (%ebx, %esi, 1) # zastąpienie tego co policzono

	addl $16, %esi #kolejna porcja bajtów, zwiekszenie licznika
	cmpl %edi, %esi #czy juz koniec? tzn czy 

	
	emms #znów można używać FPU

