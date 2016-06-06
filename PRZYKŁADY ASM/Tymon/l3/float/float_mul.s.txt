# ===== begin of float_mul.s =====
  # original (for comparision, saves to q)
  movss a, %xmm0
  movss b, %xmm1
  mulss %xmm1, %xmm0
  movss %xmm0, q
  # end of original
  
  push %rax
  push %rbx
  push %rcx
  push %rdx

  movl a, %eax
  movl b, %ebx
  
  # check for NaN
  mov %eax, %ecx
  call .NaN
  cmp $0, %edx
  jne .FM2
  
  mov %ebx, %ecx
  call .NaN
  cmp $0, %edx
  jne .FM2
  
  # check for 0
  cmp $0, %eax
  je .FM0
  cmp $0, %ebx
  je .FM0
  
  # sign
  andl $0x80000000, %eax
  andl $0x80000000, %ebx
  xorl %eax, %ebx
  mov %ebx, c

  # exponent
  movl a, %eax
  movl b, %ebx

  andq $0x7F800000, %rax
  andq $0x7F800000, %rbx
  
  # store for later use
  mov %eax, %esi
  mov %ebx, %edi

  subq $0x3F800000, %rax
  addq %rax, %rbx
  
  # check for inf
  mov %rbx, %rcx
  cmp $0x7F800000, %rcx
  jg .FM3

  # check for 0
  mov %rbx, %rcx
  cmp $0, %rcx
  jl .FM1
  
  orl %ebx, c

  # mantissa
  movl a, %eax
  movl b, %ebx
  

  # hidden bit
  andl $0x7FFFFF, %eax
  cmp $0, %esi
  je .FM5
  orl $0x800000, %eax
.FM5:
  
  andl $0x7FFFFF, %ebx
  cmp $0, %edi
  je .FM6
  orl $0x800000, %ebx
.FM6:

  
  imul %rbx

  # correct exponent
  mov %rax, %rcx
  mov $0x800000000000, %rbx
  andq %rbx, %rcx
  shr $24, %rcx
  add %ecx, c
  shr $23, %rcx
  shrq %cl, %rax
  
  mov %rax, %rcx
  andq $0x400000, %rcx
  shlq $1, %rcx
  add %rcx, %rax
  shrq $23, %rax
  andq $0x7FFFFF, %rax
  orl %eax, c

  jmp .FM1

.FM0:
  movl $0, c
  jmp .FM1
  
.FM2:
  movl %ecx, c
  jmp .FM1
  
.FM3:
  orl $0x7F800000, c

.FM1:
  pop %rbx
  pop %rcx
  pop %rbx
  pop %rax
  ret
  
.NaN:
  push %rcx
  movl $0, %edx
  andl $0x7F800000, %ecx
  cmp $0x7F800000, %ecx
  jne .NaN0 # normal number
  
  pop %rcx
  push %rcx
  
  andl $0x7FFFFF, %eax
  cmp $0, %eax
  je .NaN1 # inf
  
  # NaN
  movl $2, %edx # NaN
  pop %rcx
  push %rcx
  
.NaN1:
  movl $1, %edx # inf
  movl $0, %ecx
  
.NaN0:
  pop %rcx
  ret
  

# ===== end of float_mul.s =====
