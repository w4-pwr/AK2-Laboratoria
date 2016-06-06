.data
	buf: .ascii ""
.global printi
.text
printi:
	mov	%rdi, %r15
	cmp 	$0, %r15
	je 	wyswietl_zero
	
	mov 	$1, %r14 #w r14 trzymam dlugosc wyniku do wyswietlenia
	mov 	$1, %r10


loop_wyswietlania:
	mov 	%r10, %rax
	mov 	$10, %rbx
	mul 	%rbx
	mov 	%rax, %r10 #w r10 dzielnik
	cmp 	%r15, %rax
	jg 	podzielone
	add 	$1, %r14
	jmp 	loop_wyswietlania	
podzielone:
	mov 	$0, %rdx	#ustawiam liczbe do dzielenia
	mov 	%r10, %rax
	mov 	$10, %rbx
	div 	%rbx
	mov 	%rax, %r10	#zrobilem dzielnik na glowna liczbe

	mov 	%r15, %rax
	mov 	%r10, %rbx
	div 	%rbx
	mov 	%rax, %r9 	#wrzucam do r9 cyfre do wyswietlenia

	mov 	%r10, %rbx
	mul 	%rbx 	#mnoze zeby odjac od glownej liczby najstarsza cyfre

	sub 	%rax, %r15 	#pomniejszylem liczbe
	
	add 	$48, %r9	#zamieniam cyfre na ascii
	movb 	%r9b, (buf)
	
	mov 	$1, %rax
	mov 	$1, %rdi
	mov 	$buf, %rsi
	mov 	$1, %rdx
	syscall

	dec 	%r14 	#dekrementuje ilosc cyfr w liczbie
	cmp 	$0, %r14
	je 	koniec_wyswietlania
	jmp 	podzielone
	
koniec_wyswietlania:
	ret
wyswietl_zero:
	
	mov 	$1, %rax
	mov 	$1, %rdi
	mov 	$48, %rsi
	mov 	$1, %rdx
	syscall
	ret

