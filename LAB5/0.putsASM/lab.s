.data
napis: .ascii "napis\0"
        .text
        .global main

main:
        mov  $napis, %rdi
        call puts
	call exit
