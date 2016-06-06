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

        .globl main
        
        .text
main:
		push $10
		push $5
		call wypisz
		call exit
