.data
.text
.globl sinus
.type sinus, @function
sinus:
	pushq %rbp
	movq %rsp, %rbp
	finit
	
	pushq %rax
	pushq %rbx
	pushq %rsi
	pushq %rdi

        ##pobieram dane - zauwaz, ze ebp
      	movq %rdx, %rax #pierwszy argument
        salq %rax ## * 2
        movq %rax, %rdi                 #licznik obiegow petli
       
        movq $0, %rsi                  # i = 0, esi i edi bo oznaczaja source index i dest index - lubie ich uzywac
        
         subq $8, %rsp #miejsce na stosie dla  4bajtow
        
        #laduje przed petla, zdejmje wiekszosc po
        movq %xmm0, (%rsp)
        fldl (%rsp)
        fld %st(0) #kopiuje
        fmul %st(1), %st(0)##skrocilem
        fchs

 		fldz #miejsce na wynik
 		fld1 #laduje mianownik
 		
petla:
		fld %st(3) #kopiuje licznik
		fdiv %st(1), %st(0) #licznik * mianownik
		faddp %st(0), %st(2) #dodaje do wyniku i usuwam ze stosu
		
		fld %st(3) #kopiuje licznik ponownie
		fmul %st(3), %st(0) #indeksy sie zmieniaja, pamietaj 
		#ponadto wiekszosc operacji jest tylko na szcyzcie stosu
 		fxch %st(4) #zamiana starego z nowym
 		
 		movq %rsi, %rbx
 		movq %rsi, %rax
 		addq $2, %rax
 		addq $3, %rbx #immul to mnozenie dolne - takie jak w c dla inta
 		imulq %rbx, %rax
 		
        fstp (%rsp) #nieudolne pozbywanie sie rejestru
        movq %rax, (%rsp) #ladowanie na szczyt stosu wartosci (i+3)*(i+2)
        fild (%rsp)  #nei mozna tego zrobic miedzy rejestrami - sa odseparowane
        
        fmulp %st(0), %st(1)
 
        addq $2, %rsi
        cmpq %rsi, %rdi #wzgledem edi czy jest wieksze, pamiętaj o suffixach odpowiednich :)
        ja petla
        
        fxch %st(1) #czyszcze stos i zostawie w xmm0 wynik dla c
        fstpl (%rsp)
        movq (%rsp), %xmm0
        
        fxch %st(3)
        fstp (%rsp)
        fstp (%rsp)
        fstp (%rsp)
        
        addq $8, %rsp #usuwam miejsce na stosie
        #stare wartosci
        popq %rdi
        popq %rsi
        popq %rbx
        popq %rax
        
        leave
		ret

