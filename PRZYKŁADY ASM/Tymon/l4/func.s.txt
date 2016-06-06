  pushq	%rbp
  movq	%rsp, %rbp
  subq	$16, %rsp
  call	mcount
  movapd	%xmm0, %xmm2
  movsd	%xmm2, -16(%rbp)
  call	sin
  movsd	-16(%rbp), %xmm2
  movsd	.LC0(%rip), %xmm1
  leave
  divsd	%xmm2, %xmm1
  addsd	%xmm0, %xmm1
  movapd	%xmm2, %xmm0
  jmp	pow
  