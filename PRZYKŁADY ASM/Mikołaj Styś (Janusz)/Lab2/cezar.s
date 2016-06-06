SYSCALL = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1
STDIN = 0
READ = 3
BUF_LENGTH = 100
OFFSET = 3
.data
INPUT_TEXT: .ascii "Wprowadz tekst\n"
INPUT_TEXT_LEN = .-INPUT_TEXT
OUT_TEXT: .ascii "Wynik:\n"
OUT_TEXT_LEN = .-INPUT_TEXT
.lcomm buff, BUF_LENGTH
.text
.globl _start
_start:
#write text prompt
movl $INPUT_TEXT_LEN, %edx
movl $INPUT_TEXT, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL

#get it
movl $BUF_LENGTH, %edx
movl $buff, %ecx
movl $STDIN, %ebx
movl $READ, %eax
int $SYSCALL

movl $0x0, %ecx

cezar:
movb buff(%ecx,1), %al
cmpb $0x0, %al
jz write_end
cmpb $'Z', %al
ja small_letters
cmpb $'A', %al
jb next
addb $OFFSET, %al
cmpb $'Z', %al
jbe replace
subb $26, %al
jmp next

small_letters:
cmpb $'a', %al
jb next
cmpb $'z', %al
ja next
addb $OFFSET, %al
cmpb $'z', %al
jbe replace
subb $26, %al  

replace:
movb %al, buff(%ecx,1)

next:
inc %ecx
jmp cezar

write_end:
#write text prompt
movl $OUT_TEXT_LEN, %edx
movl $OUT_TEXT, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL
#jak nie ma to sie nie dubluje, why?
movl $BUF_LENGTH, %edx
movl $buff, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL

movl $EXIT, %eax
int $SYSCALL
