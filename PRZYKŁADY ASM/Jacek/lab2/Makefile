all		:	z1 z2	

z1		:	z1.s
	gcc -g -o zad1 z1.s
z2		:	z2.s
	gcc -g -o zad2 z1.s

clean	:
	rm -rf zad1 zad2
test1	:
	rm -rf zad1
	gcc -g -o zad1 z1.s
	./zad1
test2	:
	rm -rf zad2
	gcc -g -o zad2 z2.s
	./zad2
test	:
	rm	-rf	zad1 zad2
	gcc	-g -o zad1 z1.s
	gcc	-g -o zad2 z2.s
	./zad1
	./zad2
