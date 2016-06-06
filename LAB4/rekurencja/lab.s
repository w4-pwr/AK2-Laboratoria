SYSCALL = 0x80
EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
STDIN = 0
ZERO = 0
BUFOR_SIZE = 10
BAZA_SYSTEMU = 10

.data
buf_size = 31
text_size: .long 0
bufor: .space buf_size

.text
.global _start
_start:
	mov $5, %rax

	push %rax #przeslanie parametru
  	call silnia
  	_t9: #wynik w %rax

  	#poprawne wyjscie z programu
  	mov $EXIT, %rax
  	int $SYSCALL

silnia:
  	push %rbp #zapis stosu programu głównego 
  	mov %rsp, %rbp # ustawienie nowego stosu w miejscu aktualnej pozycji stosu 
  	mov 16(%rbp), %rbx # pobranie 1 parametru, czyli 5
  	_t1:

  	cmp $1, %rbx # jeśli 1 to koniec, dalej nie ma potrzeby wchodzi w rekurencje
  	je silnia_ret #do ret

  	dec %rbx
  	push %rbx #kolejny argument na stos, zmniejszony o 1

  	call silnia # rekurencja

  	# pomnożenie aktualnego parametru razy wynik poprzedniego wywołania
  	mov 16(%rbp), %rbx
  	_t2:
  	imul %rbx, %rax
  	_t3:
  	# czyli: n * factorial( n - 1 )

  	# koniec
  	jmp koniec
silnia_ret:
  	mov $1, %rax
koniec:
 	_t5:
  	# przywrocenie stosu POPRZEDNIEGO wywołania funkcji
  	mov %rbp, %rsp
  	pop %rbp
  	ret #powrót do adresu instrukcji zapisanej na stosie
