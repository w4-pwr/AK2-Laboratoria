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

breakline: .ascii "\n"
breakline_size = . - breakline

horner_buf: .long 31
inv_horner_buf: .long 31

.text
.global _start
_start:
	#pierwszy parametr
	mov $ZERO, %rdx
	call pobierz_wejscie
	push %rdx	
	
	#drugi parametr
	mov $ZERO, %rdx	
	call pobierz_wejscie
	push %rdx
	
	#dodawanie
  	call dodaj
	
	#wyswietlenie wyniku dodawania
	mov $ZERO, %rdx
	pop %rdx # wynik funkcji dodaj w %rdx	
	mov %rdx, %rax
	call pokaz_wynik

	# nowa linia 
	call BREAKLINE

	# pobieranie danych do obliczenia silni
	mov $ZERO, %rdx
	call pobierz_wejscie
	push %rdx

	call silnia #silnia w %rax
	_t8:
	mov $ZERO, %rdx
	mov %rax, %rdx
	call pokaz_wynik
	
	jmp koniec

silnia:
  	push %rbp #zapis stosu programu głównego 
  	mov %rsp, %rbp # ustawienie nowego stosu w miejscu akt. poz. stosu 
  	mov 16(%rbp), %rbx # pobranie 1 parametru, czyli 5

  	cmp $1, %rbx # jeśli 1 to koniec, dalej nie ma potrzeby wchodzi w rekurencje
	je test_silnia  	
	dec %rbx
  	push %rbx #kolejny argument na stos, zmniejszony o 1

  	call silnia #rekurencyjne wywolanie funkcji
	# po ret bedzie powrot do tego miejsca 

  	# pomnożenie aktualnego parametru razy wynik poprzedniego wywołania
  	mov 16(%rbp), %rbx
  	_t2:
  	imul %rbx, %rax # wynik mnozeina w %rax
  	_t3:
  	# czyli: n * silnia( n - 1 )
	jmp wyjscie_silnia

test_silnia:
	mov $1, %rax

  	# koniec
wyjscie_silnia:
 	_t5:
  	# przywrocenie stosu POPRZEDNIEGO wywołania funkcji
  	mov %rbp, %rsp
  	pop %rbp
  	ret #powrót do adresu instrukcji zapisanej na stosie

dodaj:
  	push %rbp #zapis stosu programu głównego 
  	mov %rsp, %rbp # ustawienie nowej ramki miejscu akt. poz. stosu 
	mov 16(%rbp), %rax # pobranie 1 parametru, czyli 10
	mov 24(%rbp), %rbx # pobranie 2 parametru, czyli 5
	
	#proste obliczenia, wynik w rbx
	add %rax, %rbx
	mov %rbx, 16(%rbp) #zwrocenie wyniku w miejsce 10
		
  	# przywrocenie stosu POPRZEDNIEGO wywołania funkcji
  	mov %rbp, %rsp
  	pop %rbp
  	ret #powrót do adresu instrukcji zapisanej na stosie

pobierz_wejscie:
	#wczytanie
	movl $READ, %eax
	movl $STDIN, %ebx
	movl $bufor, %ecx
	movl $buf_size, %edx
	int $SYSCALL

	mov $ZERO, %edx	# rejestr przechowywujący wynik
	mov $ZERO, %esi # zerowanie licznika który który iteruje po buforze
	mov $ZERO, %ecx # rejestr pomocniczy
	mov $ZERO, %ebx # rejestr przechowywujący znak z buforaś
	mov $ZERO, %eax # rejestr wykorzystywany przy mnożeniu (przechowuje bazę systemu)

	#schemat Hornera
	HORNER_DO_REG:
	movb bufor(,%esi,1), %bl # odczyt znaku z bufora
		
	# sprawdzenie czy to koniec znaków w buforze
	cmpb $'\n',%bl
	je KONIEC

	# obliczenie wartości z kodu ASCII
	subb $'0',%bl

	# przygotownie do mnożenia 
	mov $BAZA_SYSTEMU, %eax

	# mnożenie bazy systemu razy obecna wartość 
	mul %edx
	mov %eax, %edx

	# przygotowanie do kolejnego mnożenia o wyżej wadze 
	add %ebx, %edx

	inc %esi
	jmp HORNER_DO_REG
	
	KONIEC: #w tym miejscu w rejestrze %edx jest wartosc wprowadzonego 
	mov $ZERO, %eax
	ret
# --------------------------------- FUNKCJA WYSWIETLAJACA REJESTR RAX
pokaz_wynik:
# --------------START - SCHEMAT HORNERA
movl $ZERO, %esi #wyzerowanie licznika od bufora horner_buf 

#schemat Hornera
HORNER:
	cdq #Convert Double to Quad
	movl $BAZA_SYSTEMU, %ebx #będziemy dzielic przez bazę systemu
	div %ebx #dzielimy przez baze systemu, wynik w EAX, reszta w EDX
	movl %edx, horner_buf(,%esi,1) #zapis reszty
	incl %esi
	cmpl $ZERO, %eax #czy to juz koniec?
	jne HORNER
# --------------STOP - SCHEMAT HORNERA


# --------------START - ZAMIANA WARTOSCI NA KODY ASCII W TABLICY HORNER_BUF

movl %esi, %eax
movl $ZERO, %esi
#zamiana kazdej wartosci w tablicy horner_buf na znak ASCII
HORNER_TO_ASCII:
	movb horner_buf(,%esi,1), %bl
	addb $'0', %bl # utworzenie znaku ASCII

	cmp $'9', %bl # jak większe od 9 to musi dodac inna wartosc
	jbe ZAMIANA_BUFORA
	addb $Z_DEC_DO_HEX, %bl # utworzenie znaku ASCII
	
	ZAMIANA_BUFORA:
	movb %bl, horner_buf(,%esi,1)
	incl %esi
	cmp %eax, %esi
	jne HORNER_TO_ASCII

# --------------STOP - ZAMIANA WARTOSCI NA KODY ASCII W TABLICY HORNER_BUF

# --------------START - ODWROCENIE BUFORA HORNER_BUF
movl %esi, %eax # %eax wykorzystane do sprawdzenia czy koniec bufora
movl %esi, %edi # wykorzystane do inv_horner_buf
movl $ZERO, %esi #zerowanie licznika który iteruje po horner_buf

INVERT_HORNER_BUF:
	movb horner_buf(,%esi,1), %bl
	movb %bl, inv_horner_buf(,%edi,1)
	incl %esi
	decl %edi
	cmp %eax, %esi
	jne INVERT_HORNER_BUF

incl %esi #dodatkowa cyfra do wyświetlenia
# --------------STOP - ODWROCENIE BUFORA HORNER_BUF

#wyswietlenie z bufora
WYSWIETL:
	movl $WRITE, %eax
	movl $STDOUT, %ebx
	movl $inv_horner_buf, %ecx
	movl %esi, %edx
	int  $SYSCALL
	call BREAKLINE
	ret

# ------------------------ FUNKCJA NOWEJ LINII
BREAKLINE:
	movl $WRITE, %eax
	movl $STDOUT, %ebx
	movl $breakline, %ecx
	movl $breakline_size, %edx
	int  $SYSCALL
	ret

# ------------------------------- POPRAWNE WYJSCIE Z PROGRAMU
koniec:
	#poprawne wyjscie z programu
  	mov $EXIT, %rax
  	int $SYSCALL

