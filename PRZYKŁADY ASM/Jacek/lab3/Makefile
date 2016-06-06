all : zad1.s zad2.s
	gcc -o zad1.o zad1.s
	gcc -o zad2.o zad2.s
zad1:	zad1.s
	rm -rf *.o
	gcc -o zad1.o zad1.s
	./zad1.o

clean:	
	rm -rf *.o

zad2 : zad2.s
	rm -rf *.o
	gcc -o zad2.o zad2.s
	./zad2.o

test : zad1.s zad2.s
	rm -rf .o
	gcc -o zad1.o zad1.s
	./zad1.o
	gcc -o zad2.o zad2.s
	./zad2.o




