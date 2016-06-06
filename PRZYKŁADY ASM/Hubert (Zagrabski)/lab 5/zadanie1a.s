.global _start
.data
	buf: .ascii ""
	arg:	.byte 0
	adres: 	.word 0
	offset:	.byte 54
.text
	newline: .ascii "\n"
	zero: .ascii "0"
	przedzialek: .ascii " - "
_start:
#---------------------------
# zapisuje argument do arg
#---------------------------
	mov	24(%rsp), %r13	
	movb	(%r13), %r14b
	mov	%r14, (arg)
	mov	arg, %rbx


#---------------------------
# rezerwacja pamieci na tablice histogramu
#---------------------------
	mov $4096, %rsi
	mov $9, %rax
	mov $0, %rdi
	mov $0x3, %rdx
	mov $0x22, %r10
	mov $0, %r8
	mov $0, %r9
	syscall

	mov	%rax, adres
dupaadres:
	
#---------------------------
# wczytywanie pliku, rezerwowanie pamieci
#---------------------------
	mov $2, %rax
	mov 16(%rsp), %rdi
	mov $2, %rsi
	syscall
	cmp $0, %rax
	jg 1f
	mov $60, %rax
	mov $1, %rdi
	syscall
1:	
	mov %rax, %r8
	mov $9, %rax
	mov $0, %rdi
	mov $122880, %rsi
	mov $3, %rdx	#flagi
	mov $1, %r10
	mov $0, %r9
	syscall
dupaadres2:
	mov 2(%rax), %r15d 	#do r15 wrzucamy dlugosc obrazka
	
	cmp 	$114, %r14		#jesli r
	je	r
	cmp 	$103, %r14	#jesli g
	je 	g	
	cmp 	$98, %r14	#jesli b
	je	b
r:	
	mov	$2, %rcx
	jmp	1f
g:
	mov	$1, %rcx
	jmp	1f
b:
	mov	$0, %rcx


1:
	mov	adres, %r14
	mov	$0, %r13
1:	
	#zaczynam iteracje po pliku
	mov	54(%rax, %rcx, 1), %r13b
	add	$1, (%r14, %r13, 8)
	add	$3, %rcx
	cmp 	%r15, %rcx
	jl	1b
	jmp	end




end:
	mov	$0, %rcx 	#licznik, do 255
	mov	adres, %r14
1:
	push	%r14
	mov	%rcx, %r15	#wyswietlam numerek
	push	%rcx
	call	wyswietl_r15
	call	wysw_przedzialek
	pop	%rcx
	pop	%r14


	mov	$0, %r15
	mov	(%r14, %rcx, 8), %r15
	push	%r14
	push	%rcx
	call	wyswietl_r15	#wyswietlam wartosc

	call	wysw_nowa_linia	
	pop	%rcx	
	pop	%r14
	inc	%rcx
	cmp	$256, %rcx
	jl	1b

	

1:
	mov %rax, %rdi
	mov $11, %rax
	mov $122880, %rsi
	syscall

	mov adres, %rdi
	mov $11, %rax
	mov $4096, %rsi
	syscall

	mov $60, %rax
	mov $0, %rdi
	syscall


#---------------------------
# funkcja wyswietlajaca liczbe spod r15
#---------------------------
wyswietl_r15:
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
	mov 	$zero, %rsi
	mov 	$1, %rdx
	syscall
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
# do wyswietlenia przedzialka
#---------------------------	
wysw_przedzialek:
	mov     $1, %rax
        mov     $1, %rdi
        mov     $przedzialek, %rsi  
	mov     $3, %rdx
        syscall
	ret
