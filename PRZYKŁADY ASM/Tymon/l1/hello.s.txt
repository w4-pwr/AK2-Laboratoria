SYSEXIT		= 1
SYSREAD		= 3
SYSWRITE	= 4
STDOUT		= 1
EXIT_SUCCESS	= 0

.align 32

.data
	.comm	nazwa,	100,	1

.text
	msg_hello:	.ascii "Hello, world!\n"
	msg_hello_len	= . - msg_hello

.global main

main:
	mov $SYSWRITE,		%eax
	mov $STDOUT,		%ebx
	mov $msg_hello,		%ecx
	mov $msg_hello_len,	%edx
	int $0x80

	mov $SYSEXIT,	%eax
	mov $EXIT_SUCCESS,	%ebx
	int $0x80
