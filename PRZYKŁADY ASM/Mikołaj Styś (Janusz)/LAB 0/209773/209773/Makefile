plik: plik.o
	ld -m elf_i386 plik.o -o plik
plik.o: plik.s
	as --gstabs --32 plik.s -o plik.o
