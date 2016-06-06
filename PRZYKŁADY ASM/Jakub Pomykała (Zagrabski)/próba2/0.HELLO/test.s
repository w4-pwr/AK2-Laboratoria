SYSEXIT	 = 1
SYSREAD	 = 3
SYSWRITE = 4
SYSCALL = 0x80

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0

.text

komunikat: .ascii "Hello, world!\n"
rozmiar = . - komunikat

.global _start
_start:
	#wypisanie na ekran napisu
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $komunikat, %ecx
	mov $rozmiar, %edx
	int $SYSCALL

	#poprawne wyjscie z programu
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx
	int $SYSCALL

