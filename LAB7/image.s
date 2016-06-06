ZERO = 0
.data
miejsce: .int 0
.text

.globl getHeader
.type getHeader, @function
getHeader:
	push %ebp
	mov %esp, %ebp

	#54 bajty header

	movl 8(%ebp), %esi
	movl $miejsce, %eax

	movl 18(%esi), %ebx #szerokosc
	movl %ebx, 0(%eax)
	
	movl 22(%esi), %ebx #wysokosc
	movl %ebx, 4(%eax)
	
	movl 10(%esi), %ebx #adres gdzie rozpoczynają się dane
	movl %ebx, 8(%eax)

	movl 2(%esi), %ebx #wielkosc pliku w bajtach
	movl %ebx, 12(%eax)

	movl 28(%esi), %ebx #ilosc bitów na pixel
	movl %ebx, 16(%eax)

	movl 30(%esi), %ebx #typ kompresji - compression type (0=none, 1=RLE-8, 2=RLE-4)
	movl %ebx, 20(%eax)

	movl $ZERO, %ebx
	mov 0(%esi), %bx #sygnatura, tylko 2 bajty
	mov %ebx, 24(%eax)

	mov %ebp, %esp
	pop %ebp
	ret

.globl negateImageMMX
.type negateImageMMX, @function
negateImageMMX:
	push %ebp
	mov %esp, %ebp
	movl $ZERO, %ebx
	movl 8(%ebp), %ebx # adres gdzie zaczyna sie ciag pikseli pliku bmp
	movl $ZERO, %esi
	
	movl 12(%ebp), %edi # długość pliku
	
	pushl $-1
	pushl $-1
MMX:
	#pobranie 64 bitów zawierającego piksele do mm0
	movq (%ebx), %mm0

	#pobranie ciągu jedynek ze stosu
	movq (%esp), %mm1
	
	#odjecie ciągu jedynek od wartości kanałów pikseli
	psubq %mm0, %mm1
	
	#nadpisanie informacji o wartościach kanałów
	movq %mm1, (%ebx)
	
	#zwiększnie licznika
	addl $8, %esi

	#następne 8 bajtów tablicy bajtów
	addl $8, %ebx
	
	#czy koniec danych
	cmpl %edi, %esi 
	jb MMX
	
	emms #znów można korzystać z FPU
	mov %ebp, %esp
	pop %ebp
	ret

.globl negateImage
.type negateImage, @function
negateImage:
	push %ebp
	mov %esp, %ebp
	
	movl 8(%ebp), %ebx
	movl $ZERO, %esi
	movl 12(%ebp), %edi

NOMMX:
	movl (%ebx), %eax # pobranie części bitów danych
	movl $-1, %edx #same jedynki
	subl %eax, %edx #wynik w edx
	movl %edx, (%ebx) #zastąpienie bitów danych
	addl $4, %esi
	addl $4, %ebx
	cmpl %edi, %esi 
	jb NOMMX
	
	mov %ebp, %esp
	pop %ebp
	ret
