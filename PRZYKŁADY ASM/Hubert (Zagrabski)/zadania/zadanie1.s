.data
	buf: .ascii ""
	zly_arg: .ascii "podano zly argument. Dostepne polecenia to min, max, sum"
	zly_arg_len = .-zly_arg	
	sum: .ascii "sumowanie"
	min: .ascii "minimum"
	max: .ascii "maximum"
	
.text
	newline: .ascii "\n"
	space: .ascii " "
	filename: .ascii "plik.txt\0"
	
.global _start
_start:
	
#---------------------------
# pobieranie nazwy pliku
#---------------------------
	mov	$1, %r11		#pierwszy argument po nazwie programu

	mov	8(%rsp, %r11, 8), %r13	#w %r13 ustwiam poczatkowy bajt ciagu ze stosu
	inc	%r11			#zwiekszenie mnoznika
	mov	8(%rsp, %r11, 8), %r15	#poczatkowy bajt kolejnego argumentu
	sub	%r13, %r15		#obliczam dlugosc nazwy pliku

	#wypisanie na ekranie
	mov     $1, %rax
        mov     $1, %rdi
        mov     %r13, %rsi
	mov     %r15, %rdx
        syscall
	call 	wysw_nowa_linia
#---------------------------mov $0, %rcx	#rcx jako licznik
# otwieranie pliku
#---------------------------	
	mov 	$2, %rax
	mov 	%r13, %rdi
	mov 	$02, %rsi
	syscall
#---------------------------
# otwieranie pliku
#---------------------------	
	mov 	%rax, %r8
	mov 	$9, %rax
	mov 	$0,  %rdi
	mov 	$4096, %rsi
	mov 	$0x3, %rdx
	mov 	$0x1, %r10
	mov 	$0, %r9
	syscall
	push	%rax		#adres pliku na stos
	mov 	$0, %rcx	#rcx jako licznik

#---------------------------
# pobieranie argumentu
#---------------------------
	pop	%r9		#zdejmuje ze stosu bo inaczej nie dostane argumentu
	mov	24(%rsp), %r13	#w %r13 ustwiam poczatkowy bajt ciagu ze stosu
	
	mov	$0, %r15		#r15 bedzie przechowywalo sume argumentow
	mov	$0, %r11		#drugi argument po nazwie programu
loop_arg:
	mov	(%r13, %r11, 1), %r14b	#pobieram numery ascii znakow tworzacych argument		
	
	mov	%r15, %rax
	mov	$1000, %rbx		#mnoze zeby moc "dopisac" kolejne ascii
	mul	%rbx			#nie muszac sprawdzac za duzo
	mov	%rax, %r15

	add	%r14, %r15
	inc	%r11
	cmp	$3, %r11		#argumenty sa 3literowe, petla ma sie wykonac 3 razy
	jl	loop_arg	
	
	push	%r9			#oddaje na stos otwarty plik
	cmp	$109105110, %r15		#"min"
	je	obsluga_min
	cmp	$109097120, %r15		#"max"
	je	obsluga_max
	cmp	$115117109, %r15		#"sum"
	je	obsluga_sum
	
	call wysw_zly_arg
	jmp exit
#---------------------------
# wczytywanie liczby pierwszej
#---------------------------	
czytaj_liczbe:
	cmpb $0, (%rax, %rcx,1)
	je exit
	inc %rcx
	
	#cmpb $97,-1(%rax,%rcx,1)
	#jl czytaj_liczbe

	#cmpb $122, -1(%rax,%rcx,1)
	#jg czytaj_liczbe

#---------------------------
# szukanie minimalnej
#---------------------------	
obsluga_min:
	mov	$0, %r11
	jmp	po_pliku
#---------------------------
# szukanie max
#---------------------------	
obsluga_max:
	mov	$1, %r11
	jmp	po_pliku	
#---------------------------
# sumowanie liczb z pliku
#---------------------------	
obsluga_sum:
	mov	$2, %r11
	jmp	po_pliku
#---------------------------
# interacja po pliku i operacje wg ustawionego %r11
#---------------------------	

po_pliku:
	pop %rax		#otworzony plik
	
	mov	$0, %r15	#w r15 trzymam wynik
	mov	$0, %r14	#w r14 trzymam liczbe wczytywana z pliku
	mov 	$0, %rcx	#licznik bitow po pliku
	jmp	po_porownaniu

wczytywanie_kolejnej_liczby:
	cmp	$2, %r11
	je	dzialania_sum
	jmp	porownywania
dzialania_sum:
	add	%r14, %r15
	jmp	po_porownaniu

porownywania:
	cmp	$0, %r15	#jesli jest 0 w r15 to znaczy ze nie bylo jeszcze zadnej wpisanej
	je	zamien_wynik
	cmp	$1, %r11
	je	dzialania_max

dzialania_min:
	cmp	%r14, %r15	#jesli jest wieksza mozna przejsc do wczytywania kolejnej liczby
	jl	po_porownaniu
	jmp	zamien_wynik
dzialania_max:
	cmp	%r14, %r15	#jesli jest wieksza mozna przejsc do wczytywania kolejnej liczby
	jg	po_porownaniu
	jmp	zamien_wynik

zamien_wynik:
	mov	%r14, %r15

po_porownaniu:
	mov	$0, %r14	#do r14 wczytuje nowa liczbe z pliku

wczytywanie_liczby:
	cmpb 	$0, (%rax, %rcx,1)
	je 	wysw_wynik
	inc 	%rcx
	mov	-1(%rax,%rcx,1), %r10b
	
	cmpb 	$48, %r10b
	jl 	wczytywanie_kolejnej_liczby #jesli ponizej 0 ascii

	cmpb 	$122, %r10b
	jg 	wczytywanie_kolejnej_liczby #jezeli powyzej 9 ascii
	
	push	%rax

	#robie miejsce na nowa cyfre
	mov	$10, %rax
	mul	%r14
	mov	%rax, %r14

	pop	%rax
	
	add	%r10, %r14
	sub	$48, %r14
	

	jmp wczytywanie_liczby


wysw_wynik:
	mov     $1, %rax
        mov     $1, %rdi
        mov     $min, %rsi  
	mov     $3, %rdx
        syscall
	
	mov	%r15, (buf)
	mov     $1, %rax
        mov     $1, %rdi
        mov     $buf, %rsi  
	mov     $3, %rdx
        syscall
	call wysw_nowa_linia
	jmp exit	

#---------------------------
# do wyswietlenia komunikatu o złym argumencie
#---------------------------	
wysw_zly_arg:
	mov     $1, %rax
        mov     $1, %rdi
        mov     $zly_arg, %rsi  
	mov     $zly_arg_len, %rdx
        syscall
	call wysw_nowa_linia
	ret	 
#---------------------------
# do wyswietlenia nowej linii
#---------------------------	
wysw_nowa_linia:
	mov     $1, %rax
        mov     $1, %rdi
        mov     $newline, %rsi  
	mov     $1, %rdx
        syscall
	ret
#---------------------------
# konczenie programu
#---------------------------	
exit: 
	mov %rax, %rdi
	mov $11, %rax
	mov $4096, %rsi
	syscall
	mov $60, %rax
	mov $0, %rdi
	syscall
