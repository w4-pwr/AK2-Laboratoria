SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
BUFOR_SIZE = 10
BASE = 10
.data
bufor: .space BUFOR_SIZE
bufor_len = . - bufor 

.text
.global _start


_start:

	#wczytanie
	movl $bufor_len, %edx
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $READ, %eax
	
	int $SYSCALL32
	
	mov $0,%edx		#wynik
	mov $0,%edi
	mov $0,%ecx
L1:
	
	movb bufor(,%edi,1), %cl
		
	cmpb $'\n',%cl
	je out
	
	L2:
		mov $BASE,%eax
		mul %edx
		mov %eax,%edx
		
		subb $'0',%cl
				
		add %ecx,%edx
			

	inc %edi
	jmp L1
	
break:	
	

	out:
	#wyswietlenie
	movl $bufor_len, %edx
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

