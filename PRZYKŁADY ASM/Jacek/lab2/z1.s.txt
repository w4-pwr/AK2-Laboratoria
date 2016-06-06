#===================================================================
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCES = 0
#===================================================================

#===================================================================
.data
	.comm separator,100
	.comm ciag,100
	.comm ciag_len,4
	.comm separator_len,4
	.comm string_count,4
	.comm tab,400
	.comm lenght,400
	.comm tmp,4
#===================================================================

#===================================================================
.align 32

.text
    msg_separator : .ascii "Podaj separator (max 100 zankow) : "
    msg_separator_len = .- msg_separator
    
    newline : .ascii "\n"
    
    dupa : .ascii "Powinno byc kurwa dobrze\n"
    dupa_len = .- dupa
    
    msg_ciag : .ascii "Podaj ciag (max 100 znakow) : "
    msg_ciag_len = .- msg_ciag
#===================================================================

#===================================================================
.global main

main :
	
#komunikat informujacy o podaniu separator
    mov     $msg_separator,%ecx
    mov     $msg_separator_len,%edx
    call    out

#wczytanie separatora
    mov     $separator,%ecx
    mov     $100,%edx
    call    in
    
 #zapisanie dlugosci separatora
    dec		%eax
    mov		%eax,separator_len
    
#wyswietlenie komunikatu o wczytywaniu ciagu znakow
    mov     $msg_ciag,%ecx
    mov     $msg_ciag_len,%edx
    call    out

#wczytanie ciagu znakow
    mov     $ciag,%ecx
    mov     $100,%edx
    call    in

#zapisanie dlugosci ciagu    
    dec		%eax
    mov		%eax,ciag_len
#==================
    xor		%eax,%eax	#iterator po ciagu
    xor		%ebx,%ebx	#iterator po separatorze
    mov		%eax,string_count	#wyzerowanie ilosci slow
    
loop1:
	mov		ciag(,%eax,1),%cl
	mov		separator(,%ebx,1),%ch
	cmp		%cl,%ch
	jne		sep_ne_ciag
		inc		%ebx
		cmp		%ebx,separator_len
		jne		spr_ciag
			mov		string_count,%esi
			mov		lenght(,%esi,4),%ecx
			mov		%eax,%edx
			sub		%ecx,%edx
			push 	%eax
			mov		separator_len,%eax
			sub		$1,%eax
			sub		%eax,%edx
			pop		%eax
			mov		%edx,tab(,%esi,4)
			
	inc		%esi
	mov		%esi,string_count
	cmp		%ebx,separator_len
	je		sep_zeruj
	
sep_ne_ciag:
	mov		string_count,%ecx
	mov		lenght(,%ecx,4),%edx
	inc		%edx
	mov		%edx,lenght(,%ecx,4)
sep_zeruj:
	xor		%ebx,%ebx
spr_ciag:
	inc		%eax
	cmp		ciag_len,%eax
	jl		loop1

	mov		string_count,%esi
	mov		lenght(,%esi,4),%edx
	mov		ciag_len,%eax
	sub		%edx,%eax
	mov		%eax,tab(,%esi,4)

#sortowanie
	xor		%esi,%esi

sort1:
	xor		%edi,%edi
	sort2:
			mov		lenght(,%esi,4),%eax
			mov		lenght(,%edi,4),%ebx
			cmp		%eax,%ebx
			jg		zamien
			jle		end
			zamien:
					mov 	%eax,%edx
					mov		%ebx,%eax
					mov		%edx,%ebx
					mov		%eax,lenght(,%esi,4)
					mov		%ebx,lenght(,%edi,4)
					mov		tab(,%esi,4),%eax
					mov		tab(,%edi,4),%ebx
					mov 	%eax,%edx
					mov		%ebx,%eax
					mov		%edx,%ebx
					mov		%eax,tab(,%esi,4)
					mov		%ebx,tab(,%edi,4)
			end:
					inc		%edi
					cmp		string_count,%edi
					jle		sort2
			
			inc		%esi
			cmp		string_count,%esi
			jle		sort1
			
#wypisanie na ekranie
	xor		%esi,%esi

loop2:
	mov		tab(,%esi,4),%eax
	mov		lenght(,%esi,4),%ebx
	mov		$ciag,%ecx
	add		%eax,%ecx
	mov		%ebx,%edx
	call	out
	call	new_line	
	inc		%esi
	cmp		string_count,%esi
	jle		loop2
	
	
    
#koniec programu
    mov     $SYSEXIT,%eax
    mov     $EXIT_SUCCES,%ebx
    int     $0x80
#===================================================================

#===================================================================
#funkcja wczytujaca
in:
    mov     $STDIN,%ebx
    mov     $SYSREAD,%eax
    int     $0x80
    ret

#funkcja wypisujaca
out:
    push	%eax
	push	%ebx
    mov     $STDOUT,%ebx
    mov     $SYSWRITE,%eax
    int     $0x80
    pop		%ebx
	pop		%eax
    ret
 
#przejscie do nowego wiersza
new_line: 
	mov		$newline,%ecx
	mov		$1,%edx
	call	out
	ret
	
dupa_out:
	mov		$dupa,%ecx
	mov		$dupa_len,%edx
	call	out

#===================================================================



