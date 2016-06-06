
.data
format_string: .ascii "Hello: %s, oraz %f xd\0"
param1: .ascii "Worlds?\0"
param2: .float 25.5
fun: .float 1.45
.text
.globl main
main:
subl $4, %esp 
fld param2
fld fun
faddp
fstpl (%esp)
pushl $param1
pushl $format_string
call printf
call exit
