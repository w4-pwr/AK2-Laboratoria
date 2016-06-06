.data
liczbaf: .float 25
output: .ascii "Wynikiem dzialan jest kolejno: %f\n\0"
.text
.globl main
main:

#pushl $14
#pushl $26
#pushl $10
#call dodajTrzyLiczby
#addl $(2*4), %esp
#movl %eax, (%esp)

#pushl $10
#pushl $10
#pushl $5
#call pomnozDodaj
#addl $(2*4), %esp
#movl %eax, (%esp)

fld liczbaf
fstps (%esp)
call	obliczPierwiastek
fstps	liczbaf

fld liczbaf
fstpl (%esp)
call obliczPierwiastek
pushl $output
call printf
call exit

