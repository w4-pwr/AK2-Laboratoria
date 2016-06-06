all: float

assembly:
	gcc -S -O2 -o cheat.s cheat.c

cheat: cheat.c
	gcc -o cheat cheat.c
	./cheat

replace: assembly
	./replace.rb

float: replace float.s
	gcc -g -o float float.s

test: clean all
	./float

clean:
	rm -f cheat cheat.s float.s float
	rm -rf *.o
