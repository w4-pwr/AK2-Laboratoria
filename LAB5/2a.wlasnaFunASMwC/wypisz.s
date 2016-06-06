.align 32
SYSCALL = 0x80
EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
STDIN = 0

.data 
informacja: .ascii "Funkcja z asm\n"
rozmiar_informacja = . - informacja 

format_output: .string "Dwa parametry: %d, %d\n"
zmienna: .long 0


        .globl  wypisz
        
        .text
wypisz:
	push %ebp #zapis stosu programu głównego 
  	mov %esp, %ebp # ustawienie nowego stosu w miejscu aktualnej pozycji stosu 
	#4n+8 dla 32 bitow
	mov 8(%ebp), %eax
	mov 12(%ebp), %ebx
	
	
	push %eax
	push %ebx

	push $format_output
	call printf

	mov %ebp, %esp
	pop %ebp
  	ret #powrót do adresu instrukcji zapisanej na stosie
