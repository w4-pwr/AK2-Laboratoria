# ASM x86 equivalent of 
#  puts gets.strip.split(gets.strip).sort
# I miss you ruby...

SYSEXIT       = 1
SYSREAD       = 3
SYSWRITE      = 4
STDIN         = 0
STDOUT        = 1
EXIT_SUCCESS  = 0

.align 32

.data
  .comm data,       100 # 100 x 1byte
  .comm data_len,   4
  .comm sep,        100
  .comm sep_len,    4
  .comm chunks,     800 # just like int[100][2]
  .comm chunks_num, 4
  .comm last_pos,   4   # the last but one chunk position


.text
  msg_data:   .ascii  "Dane: "
  msg_data_len  = . - msg_data

  msg_sep:    .ascii  "Separator: "
  msg_sep_len  = . - msg_sep
  
  msg_nl:     .ascii  "\n"

.global main

main:
  # IO stuff
  
  # show data prompt
  mov $msg_data,      %ecx
  mov $msg_data_len,  %edx
  call print
  
  # read input
  mov $data,          %ecx
  mov $100,           %edx      # max length
  call read
  mov %eax,           data_len  # save data length
  
  # show sep prompt
  mov $msg_sep,       %ecx
  mov $msg_sep_len,   %edx
  call print
  
  # read input
  mov $sep,           %ecx
  mov $100,           %edx      # max length
  call read
  mov %eax,           sep_len   # save sep length
  
  # strip sep and data
  mov sep_len,        %ebx
  sub $1,             %ebx
  mov %ebx,           sep_len
  
  mov data_len,       %eax
  sub $1,             %eax
  mov %eax,           data_len
  
  # Initial values
  movl $0,            last_pos

  mov $0,             %ebx # 8bit, i = 0
  for1:
    cmp data_len,     %ebx
    je end_for1
    
    # check first characters
    mov sep,                %eax
    mov data(, %ebx, 1),    %ecx
    cmp %cl,  %al
    jne sep_not_found
      
      # if matched
      mov $1,   %esi # 'k'
      for2:
        cmp sep_len, %esi
        je for2_end
        
        # compare rest of separator
        push %rbx
        add %esi, %ebx # i += k
        mov data(, %ebx, 1),  %ecx # data[i+k]
        mov sep(, %esi, 1),   %edx # sep[k]
        pop %rbx
        
        cmp %cl,  %dl
        jne sep_not_found         # separator not found, keep searching
        
        inc %esi
        jmp for2
      
      for2_end:

      call chunk
      
      # save last position (used for getting last chunk)
      mov %ebx,     %eax          # last_pos = i+sep_len
      add sep_len,  %eax
      mov %eax,     last_pos
      
      add sep_len,  %ebx          # i += sep_len - 1
      sub $1,       %ebx

    sep_not_found:
    
    inc %ebx
    jmp for1
    
  end_for1:

  # last chunk
  call chunk
  
  # sort & print
  # Pretty dump n^2 sorting
  # First loop goes until printed chunks counter reaches chunks_num value
  # incrementing loop_len (starting from 0)
  # (which means all chunks have been printed)
  xor %esi, %esi # chunks count
  xor %eax, %eax # loop_len
  for5:
    cmp chunks_num, %esi
    je end_for5
    
    # Loop through all chunks
    # if it's length is equal to loop_len counter
    # print it and increment printed chunks counter counter
    
    xor %ebx, %ebx
    for6:
      cmp chunks_num, %ebx
      je end_for6
      
      mov $4, %ecx                        # 4
      movl chunks(%ecx, %ebx, 8),  %edx   # length
      
      cmp %edx, %eax                      # length == loop_len
      jne nope
        # len match -> print
        inc %esi                          # increment 
        push %rax
        push %rbx
        
        xor %eax, %eax                      # 0
        movl chunks(%eax, %ebx, 8),  %ecx   # start index

        add $data, %ecx

        call print
        call nl

        pop %rbx
        pop %rax
        
      nope:
      
      inc %ebx
      jmp for6
    end_for6:
    
    
    inc %eax
    jmp for5
  
  end_for5:
  

  # exit with 0
  mov $SYSEXIT,       %eax
  mov $EXIT_SUCCESS,  %ebx
  int $0x80
  ret

# Store chunks position and length in memory
chunk:
  push %rbx

  mov last_pos, %ecx
  mov chunks_num, %eax
  
  xor %edx, %edx                    # 0
  mov %ecx, chunks(%edx, %eax, 8)   # start index

  sub %ecx, %ebx                    # i-last_pos
  add $4,   %edx                    # 4
  mov %ebx,  chunks(%edx, %eax, 8)  # length
  
  pop %rbx
  
  inc %eax                          # chunks_num++
  mov %eax, chunks_num
  ret

# io utils
print: # print data stored in %ecx with length stored in %edx to STDOUT
  mov $SYSWRITE,      %eax
  mov $STDOUT,        %ebx
  int $0x80
  ret

read: # read max %edx characters from STDIN into %ecx destination, store length in %eax
  mov $SYSREAD,       %eax
  mov $STDIN,         %ebx
  int $0x80
  ret

nl: # print new line
  mov $msg_nl,            %ecx
  mov $1,             %edx
  call print
  ret

