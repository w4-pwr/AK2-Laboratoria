.align 32
.data

format_input: .string "%d"
zmienna: .long 0

format_string:
	 .asciz "Test printf to jest tekst: %s, a to jest liczba: %d\n"
      text: .string "test"
      .global main
main:
	#pobranie zmiennej
	push $zmienna
	push $format_input
	call scanf

	#wypisanie zmiennej 
	push zmienna
	push $text
        push $format_string
        call printf
	call exit
