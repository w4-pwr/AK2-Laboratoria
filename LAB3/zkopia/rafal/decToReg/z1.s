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
HORNER:
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
jmp HORNER
	
KONIEC: #w tym miejscu w rejestrze %edx jest wartosc wprowadzonego 
_t9:

#poprawne wyjscie z programu
movl $EXIT, %eax
int $SYSCALL
	
	
	

