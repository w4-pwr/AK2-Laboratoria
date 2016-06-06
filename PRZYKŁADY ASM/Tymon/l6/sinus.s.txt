
.data
 .comm tmp, 8 
 .comm saved, 8
 .comm nouse, 8
 .comm k, 4
 
.align 64


 
.text

.globl sinus

.type sinus, @function
sinus:
    push    %rbp
    movq    %rsp,    %rbp
    
    pushq     %rbp
    movsd    %xmm0,    (%rsp)
    
    
spr:    
    mov %rdi, k # ustawienie k
    mov %rsi, %rbx # precyzja

	# ustawienia precyzji
	fstcw tmp
	movl tmp, %eax
	movl %eax, saved
	andl %ebx, %eax
	movl %eax, tmp
	fldcw tmp
	
	# 8,9,10,11


    #laduje liczbe na stos zmiennoprzecinkowy
    fldl  (%rsp) # x na stosie
    

    
   mov k, %esi
   mov $3, %rax
   mov $3, %rbx
   L1:
      cmp $1, %esi
      je L2
      mul %rbx      
      
      dec %esi
      jmp L1
    L2:
    
  
    
    mov %rax, tmp

    fidivl tmp # x/3^K na stosie
    
    mov k, %esi
    L3:
		cmp $0, %esi
		je L4


		fld %st(0)
		fmul %st(1)
		fmul %st(1)
		mov $4, %eax
		mov %eax, tmp
		fimul tmp
		
		fld %st(1)
		mov $3, %eax
		mov %eax, tmp
		fimul tmp
		
		fsub %st(1)
		
		fstpl tmp
		fstp nouse
		fstp nouse
		fldl tmp
		
		
		dec %esi
		jmp L3
    L4:
     
    
    # movl $3, tmp
    # fimul  tmp # pomoz razy 3
    
    # fsin
    # fldl2e
    # fmull    (%rsp)
    # fcos
    # fmulp     

	fldcw saved

    fstpl     (%rsp)
    movsd    (%rsp),    %xmm0
    movq    %rbp, %rsp
    pop    %rbp
    ret

  
