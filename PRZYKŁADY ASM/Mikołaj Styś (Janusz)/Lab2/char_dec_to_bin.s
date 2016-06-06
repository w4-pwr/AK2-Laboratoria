SYSCALL = 0x80
SYS_EXIT = 1
STDIN = 0
SYS_READ = 3
STDOUT = 1
SYS_WRITE = 4
.data
end_program: .ascii "\nKoniec\n"
end_program_len = . - end_program
buffer: .space 0x40
buffer_len = . - buffer
.text
.globl _start
_start:
movl $buffer_len, %edx
movl $buffer, %ecx
movl $STDIN, %ebx
movl $SYS_READ, %eax
int $SYSCALL
movl $0, %ebx
movl $0, %edx

# convert from char 10 to bin
movl $0, %ecx
movl $0, %eax
convert_c10_2:
movb buffer(%ecx,1), %bl
cmp $'0', %bl
jb clear_buf
cmp $'9', %bl
ja clear_buf
subb $'0', %bl
movl $10, %edx
mul %edx
addl %ebx, %eax
inc %ecx
jmp convert_c10_2

clear_buf:
#clear buffer
movl $buffer_len, %ecx
clear_next:
dec %ecx
movb $0x0, buffer(%ecx)
jnz clear_next


#convert from bin to char 10
movl $buffer_len, %ecx
dec %ecx
movl $10, %ebx
convert_2_c10:
div %ebx
addb $'0', %dl
movb %dl, buffer(%ecx,1)
movb $0x0, %dl
dec %ecx
cmp $10, %eax
ja convert_2_c10
addb $'0', %al
movb %al, buffer(%ecx,1)

finish:
movl $buffer_len, %edx
movl $buffer, %ecx
movl $STDOUT, %ebx
movl $SYS_WRITE, %eax
int $SYSCALL

#end text
movl $end_program_len, %edx
movl $end_program, %ecx
movl $STDOUT, %ebx
movl $SYS_WRITE, %eax
int $SYSCALL

movl $SYS_EXIT, %eax
movl $0, %ebx
int $SYSCALL

