SYSEXIT         = 1
SYSREAD         = 3
SYSWRITE        = 4
STDIN		= 0
STDOUT          = 1
EXIT_SUCCESS    = 0

.align 32

.data
        .comm   storage,  100,    1

.text
        msg_prompt:	.ascii "Prompt >> "
        msg_prompt_len	= . - msg_prompt

.global main

main:
	# print  $msg_prompt
        mov $SYSWRITE,          %eax
        mov $STDOUT,    	%ebx
        mov $msg_prompt,        %ecx
        mov $msg_prompt_len,    %edx
        int $0x80

	# read input
	mov $SYSREAD,		%eax
	mov $STDIN,		%ebx
	mov $storage,		%ecx
	mov $100,		%edx
	int $0x80

	# print input size
        mov $eax,               %ecx
        mov $SYSWRITE,          %eax
        mov $STDOUT,            %ebx
        mov $10,                %edx
        int $0x80


	# print input
        mov $SYSWRITE,          %eax
        mov $STDOUT,            %ebx
        mov $storage,        	%ecx
        mov $100,   		%edx
        int $0x80

        mov $SYSEXIT,   	%eax
        mov $EXIT_SUCCESS,      %ebx
        int $0x80




