.global _start
.text
	a: .byte 0, 1, 1, 0, 2, 3, 3, 2
	b: .word 1024, 1025, 2048, 2050
	c: .long 100000, 200000
	d: .single 1.25, 2.25, 4.125, 8.5

_start:
	movq a, %mm0
	movq a, %mm1
	movq b, %mm2

	paddb %mm0, %mm1  	#byte+byte
	paddw %mm0, %mm2 	#byte+word = dziwne wyjdzie


	movups d, %xmm0
	movups d, %xmm1

	addps %xmm0, %xmm1
