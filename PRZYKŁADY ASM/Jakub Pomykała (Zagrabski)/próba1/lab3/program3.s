.data 
	buf: .ascii "0"
.text
	filename: .ascii "plik3.txt\0"
.global _start
_start: 
	#open
	mov $2, %rax
	mov $filename, %rdi
	mov $00, %rsi
	syscall
	mov %rax, %r9
loop:
	mov $0, %rax
	mov %r9, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall
	movb (buf), %r8b
	cmp $10, %r8 #13 enter // 00 koniec pliku
	je exit
	mov $10, %rbx
	mov %r10, %rax
	mul %rbx
	sub $48, %r8
	mov %rax, %r10
	add %r8, %rax
	jmp loop

exit:
	nop
Autor: Jakub Pomykala 209897\n
1 <- wyswietlenie sumy dwoch liczb\n2 <- zaladowanie 2 liczb z pliku txt, wynik w pliku txt\n3 <- zaladowanie par liczb z pliku tekstowego i zapisanie wyniku dodawania do pliku\n+ <- zeby dodac dwie liczby\n* <- zeby pomnozyc dwie liczby\n0. aby zakonczyc\0
