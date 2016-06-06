
.data
napis: .ascii "Blah blah\0"
.text
.globl main
main:
push $napis
call puts
call exit
