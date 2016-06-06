.data 
	buf: .ascii "0"
.text
	filename: .ascii "plik.txt\0"
.global _start
_start:
	mov $2, %rax
	mov $filename, %rdi
	mov $00, %rsi
	syscall
	mov %rax, %r8

loop:
	mov $0, %rax		#czytanie
	mov %r8, %rdi		#wpisuję to co jest w r8 do rdi
	mov $buf, %rsi		#wpisuję bufor do rsi
	mov $1, %rdx		#jedna liczba
	syscall 
	cmp $0, %rax		#
	je exit

	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall 
	jmp loop

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

