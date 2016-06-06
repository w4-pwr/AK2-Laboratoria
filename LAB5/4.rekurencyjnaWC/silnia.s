.align 32
SYSCALL = 0x80
EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
STDIN = 0
ZERO = 0
BUFOR_SIZE = 10
BAZA_SYSTEMU = 10
WYPELNIENIE_JEDYNKAMI = -1
Z_DEC_DO_HEX = 7

.data
buf_size = 31
text_size: .long 0
bufor: .space buf_size

format_output: .string "Wynik: %d\n"
zmienna: .long 0

.text
.globl silnia

silnia:
  	push %ebp #zapis stosu programu głównego 
  	mov %esp, %ebp # ustawienie nowego stosu w miejscu akt. poz. stosu 
  	mov 12(%ebp), %ebx # pobranie 1 parametru, czyli 5

  	cmp $1, %ebx # jeśli 1 to koniec, dalej nie ma potrzeby wchodzi w rekurencje
	je test_silnia  	
	dec %ebx
  	push %ebx #kolejny argument na stos, zmniejszony o 1

  	call silnia #rekurencyjne wywolanie funkcji
	# po ret bedzie powrot do tego miejsca 

  	# pomnożenie aktualnego parametru razy wynik poprzedniego wywołania
  	mov 12(%ebp), %ebx
  	_t2:
  	imul %ebx, %eax # wynik mnozeina w %rax
  	_t3:
  	# czyli: n * silnia( n - 1 )
	jmp wyjscie_silnia

test_silnia:
	mov $1, %eax

  	# koniec
wyjscie_silnia:
 	_t5:
  	# przywrocenie stosu POPRZEDNIEGO wywołania funkcji
  	mov %ebp, %esp
  	pop %ebp
  	ret #powrót do adresu instrukcji zapisanej na stosie

