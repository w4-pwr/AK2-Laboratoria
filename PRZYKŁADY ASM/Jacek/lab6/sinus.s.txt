.data
	.comm tmp, 8
	.comm new_sin, 8
	.comm K, 8
	.comm pre, 8
	.comm save, 8
.align 64

.text

.globl sinus

.type sinus, @function
sinus:
    push    %rbp
    movq    %rsp,    %rbp
    
    mov		 %rdi, %rax
    mov		 %rax, K
    mov		 %rsi, %rax
    mov		 %rax, pre		
    
    
    #przenosze argumenty z rejestru do pamieci
    pushq     %rbp
    movsd    %xmm0,    (%rsp)
    
spr:    
    #zaokraglanie
    #8,9,10,11 bity
    fstcw tmp
    mov tmp, %eax
    mov %eax, save
    mov		pre, %ecx
    andl	%ecx, %eax
    movl	%eax, tmp
    fldcw tmp
    #laduje liczbe na stos zmiennoprzecinkowy
    fldl     (%rsp)
   
	push %rsi
	push %rax 
	
	mov $3, %rax
	mov K, %esi
pow:
	cmp $1,%esi
	je end1
	mov $3,%rcx
	mul %rcx
	dec %esi
	jmp pow
end1:
    mov %rax, tmp
    pop %rax
    pop %rsi
    
    fidivl tmp
    
    mov K, %esi
    for1:
		cmp $0, %esi
		je for2
		
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
		
		fstpl new_sin
		fstp tmp
		fstp tmp
		fldl new_sin
		
		dec %esi
		jmp for1
    for2:
    
    fldcw save
    
    fstpl     (%rsp)
    movsd    (%rsp),    %xmm0
    movq    %rbp, %rsp
    pop    %rbp
    ret 

