# 1. Wyświetlanie sumy dodawania na ekranie 1pkt
# 2. Zaimplementowanie 2 podprogramów wykonywalnych przez rozkaz call 
# realizujących 2 dowolne funkcje (dodawanie odejmowanie) 1pkt
# 3. Wywołanie odpowiedniego programu w zależności od danych wejściowych STDIN 0.5pkt
# 4. Załadowanie 2 liczb z pliku tekstowego, zapisanie wyniku dowolnego
# działania na nich do 2giego pliku txt 1pkt
# 5. Załadowanie serii par liczb z pliku tekstowego i zapisanie wyniku
# dowolnego działania na każdej z par do 2giego pliku tekstowego 1pkt
# 6. Pobranie nazw tych plików i rodzaju działania z STDIN 0.5pkt

.data 
	buf: .ascii "0"

.text
	zad1: .ascii "Zadanie 1\n\0"
	welcome_msg: .ascii "Autor: Jakub Pomykala 209897\n\0"
	menu_msg: .ascii "1 <- wyswietlenie sumy dwoch liczb\n2 <- zaladowanie 2 liczb z pliku txt, wynik w pliku txt\n3 <- zaladowanie par liczb z pliku tekstowego i zapisanie wyniku dodawania do pliku\n+ <- zeby dodac dwie liczby\n* <- zeby pomnozyc dwie liczby\n0 <- aby zakonczyc\n\0"
	input: .ascii "input.txt\0"
	output: .ascii "output.txt\0"
	
.global _start
#start programu
_start:
	call welcome		#wiadomosc powitalna
	call menuinput		#menu
	jmp exit		#koniec programu

#wiadomosc powitalana
welcome:
	mov $1, %rax
	mov $1, %rdi
	mov $welcome_msg, %rsi
	mov $30, %rdx
	syscall
	ret

#opcje menu
displaymenu:
	mov $1, %rax
	mov $1, %rdi
	mov $menu_msg, %rsi
	mov $254, %rdx
	syscall
	ret

#menu, pobieranie danych wpisanych z klawiatury, zadanie 2
menuinput:
	call displaymenu	#wyświelamy dostepne opcje
	
	#przygotowanie
	mov $0, %rax		#sys_read
        mov $0, %rdi		#0, out
        mov $buf, %rsi		#bufor dajemy do rsi
        mov $2, %rdx		#rozmiar 2
        syscall			
        
        #sprawdzamy co wpisano
        movb (buf), %r12b
        
        cmp $48, %r12		# 0. zakoncz program
        je exit		
        
        cmp $49, %r12		# 1. wyswietlanie sumy dwoch liczb
        je displaysum		
        
        cmp $50, %r12		# 2. zaladowanie 2 liczb z pliku txt i zapisanie ich do innego pliku
	je load_single_numers	
	
        #cmp $51, %r12		# 3. zaladowanie par liczb, nie za bardzo dziala
        #je load_pair_numbers
        
        cmp $43, %r12		# czy wybrano dodwanie? ( 43 -> + ), porównuję kod ascii z tym co wpisano na klawiaturze
        je addition		# skocz do dodawania
        
        cmp $42, %r12		# czy wybrano mnozenie? ( 42 -> * ), porównuję kod ascii z tym co wpisano na klawiaturze
        je multiplication	# skocz do mnozenia         
     

#zadanie 1, wyswietlenie sumy dodawania na ekranie
displaysum:

	#wyswietlanie
	mov $1, %rax		
	mov $1, %rdi
	mov $zad1, %rsi 	#tekst o zadaniu
	mov $11, %rdx		#liczba znaków
	syscall

        #dodajemy 4 + 5
        mov $5, %r15
        add $4, %r15
        
        #wyswietlamy
        add $48, %r15		#konwersja liczby na kod ascii
	movb %r15b, (buf)
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $2, %rdx
	syscall
	ret

#dodawanie dwoch liczb
addition:
	
	#jakie liczby bedziemy dodawac
	mov $7, %r15
	mov $2, %r14
	
	#dodajemy
        add %r14, %r15		#wynik w r15
        add $48, %r15		#zamieniam na ascii
        
        movb %r15b, (buf)
        
        #wypisywanie
        mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $2, %rdx
	syscall
	
	ret

#mnozenie dwoch liczb
multiplication:
	#jakie liczby bedziemy mnozyc
	mov $2, %r14
	
	#mnozymy
	mov $3, %rax
        mul %r14		#wynik w r15
        mov %rax, %r15
        add $48, %r15		#zamieniam na ascii
        
        movb %r15b, (buf)
        
        #wypisywanie
        mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $2, %rdx
	syscall

	ret


#zadanie 3, zaladowanie dwoch liczb z pliku i zapisanie wyniku dodawania do innego pliku
load_single_numers:
	#otwieramy plik txt
	mov $2, %rax		#sys_open
	mov $input, %rdi	#otwieramy plik input.txt
	mov $00, %rsi		#flagi 00
	syscall
	mov %rax, %r8		#status trzymamy w r8
	
		
	mov $0, %r15		#zeruje
	mov $0, %r14		#zeruje
	
	jmp pierwsza_liczba


#bedzie przechowywana w rejestrze r15
#rejestr r9 dzialaja jako tymczasowy
pierwsza_liczba:

	
	# 0. przygotowanie do odczytu
	mov $0, %rax		#przestawiamy się na czytanie, sys_read
	mov %r8, %rdi		#wpisuję status do rdi
	mov $buf, %rsi		#wpisuję bufor do rsi
	mov $1, %rdx		#po jednym znaku
	syscall
	
	movb (buf), %r9b	# zapisuję liczbę do r9 jako kod ascii, tmp
	add %r9, %r15

	
	# 1. sprawdzamy czy kolejny znak jest spacja ktora oznacza kolejna liczbe do dodania
	cmp $32, %r9		# 32 spacja, sprawdzamy czy jest spacja
	je druga_liczba		# jesli jest spacja to przechodzimy to funkcji "druga_liczba"

	syscall 
	jmp pierwsza_liczba	#kolejny znak

#bedzie przechowywana w rejestrze r14
druga_liczba:
	
	sub $32, %r15 		#odejmujemy ta spacje, ktora dodalismy
	
	# 0. przygotowanie do odczytu
	mov $0, %rax		#przestawiamy się na czytanie, sys_read
	mov %r8, %rdi		#wpisuję status do rdi
	mov $buf, %rsi		#wpisuję bufor do rsi
	mov $1, %rdx		#po jednym znaku
	syscall
	
	movb (buf), %r9b	# zapisuję liczbę do r9 jako kod ascii, tmp
	add %r9, %r14
		
	# 1. sprawdzenie czy koniec pliku
	#cmp $0, %rax
	jmp zapis_do_pliku	# EOF, wiec zapisujemy wynik

	syscall 
	jmp druga_liczba	#kolejny znak

zapis_do_pliku:


	#samo przekodowanie kodu ascii
	sub $48, %r15
	sub $48, %r14

	#dodajemy dwie liczby
        add %r14, %r15

     	add $48, %r15    
       	movb %r15b, (buf)
  	
       	                
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
	mov $1, %rdx
	syscall
	jmp exit


	
#koniec programu
exit:

	mov $60, %rax 		# sys_exit
	mov $0, %rdi		# z kodem 0, czyli poprawnie zakończono
	syscall
