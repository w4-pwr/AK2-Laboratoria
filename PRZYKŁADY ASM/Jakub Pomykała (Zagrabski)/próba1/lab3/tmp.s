.data 
	buf: .ascii "0"

.text
	welcome: .ascii "Autor: Jakub Pomykala 209897\0"
	input: .ascii "input.txt\0"
	output: .ascii "output.txt\0"
	
.global _start

_start:
	jmp openfile


openfile:
	#otwieramy plik txt
	mov $2, %rax		#sys_open
	mov $input, %rdi	#otwieramy plik input.txt
	mov $00, %rsi		#flagi 00
	syscall
	mov %rax, %r8		#status trzymamy w r8

	#czytanie po kolei
loop:
	mov $0, %rax		#przestawiamy się na czytanie, sys_read
	mov %r8, %rdi		#wpisuję to co jest w r8 do rdi
	mov $buf, %rsi		#wpisuję bufor do rsi	
	mov $1, %rdx		#jedna liczba
	syscall 
	cmp $0, %rax		#ustawiana jest flaga ZF, ustawia się jeśli operacja jest TRUE
	je exit			#koniec, jeśli flaga ZF została ustawiona na 1, co oznacza koniec liczb

	mov $1, %rax		#inaczej przestawiamy się na wypisywanie na ekran 
	mov $1, %rdi		#out
	mov $buf, %rsi		#bufor wpisuję do rsi, czyli to co będę wypisywać
	
	#zapis wartosci do rejestru
	movb (buf), %r10b	#zapisuję liczbę do r10 jako kod ascii
	sub $48, %r10b		#odejmuję 48 od tego co jest w rejestrze r10 żeby mieć wartość z kodu ascii
	
	_break:
	
	mov $1, %rdx		#wielkość, czyli jeden bo jedną liczba
	syscall 
	jmp loop  		#lecimy od nowa, lecimy kurwa tutaj, jest dobrze fchuj
	
#koniec programu
exit:
	movb $13, (buf)
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall
	mov $60, %rax
	mov $0, %rdi
	syscall
	
	#do rax wpisujesz numer systemowy
	#do rdi to czy to ma byc in czy out (0/1)
	#do rsi to dajesz bufor (do wczytania albo wypisania)
	#do rdx dlugosc tego bufora
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
#otwieranie pliku
openfile:
	#otwieramy plik txt
	mov $2, %rax		#sys_open
	mov $input, %rdi	#otwieramy plik input.txt
	mov $00, %rsi		#flagi 00
	syscall
	mov %rax, %r8		#status trzymamy w r8


#czytanie po kolei
loop2:
	mov $0, %rax		#przestawiamy się na czytanie, sys_read
	mov %r8, %rdi		#wpisuję to co jest w r8 do rdi
	mov $buf, %rsi		#wpisuję bufor do rsi	
	mov $1, %rdx		#jedna liczba
	syscall 
	cmp $0, %rax		#ustawiana jest flaga ZF, ustawia się jeśli operacja jest TRUE
	je exit			#koniec, jeśli flaga ZF została ustawiona na 1, co oznacza koniec liczb

	mov $1, %rax		#inaczej przestawiamy się na wypisywanie na ekran 
	mov $1, %rdi		#out
	mov $buf, %rsi		#bufor wpisuję do rsi, czyli to co będę wypisywać
	
	#zapis wartosci do rejestru
	movb (buf), %r10b	#zapisuję liczbę do r10 jako kod ascii
	sub $48, %r10b		#odejmuję 48 od tego co jest w rejestrze r10 żeby mieć wartość z kodu ascii
	
	mov $1, %rdx		#wielkość, czyli jeden bo jedną liczba
	syscall 
	jmp loop2  		#lecimy od nowa, lecimy kurwa tutaj, jest dobrze fchuj

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	mov $1, %r9
	mov $2, %r10

	#dodajemy
        add %r9, %r10
        add $48, %r10

       	movb %r10b, (buf)
        
        #otwieramy plik do zapisu
        mov $2, %rax
	mov $output, %rdi
	mov $02, %rsi
	mov $1, %rdx
	syscall
        
        #zapisujemy do pliku
        mov %rax, %r8
	mov $1, %rax
	mov %r8, %rdi
	mov $buf, %rsi
	mov $2, %rdx
	syscall

        
        #wracamy do loop
        #jmp load_pair_numbers
        jmp exit
