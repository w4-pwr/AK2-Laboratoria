all : zad2.c
	rm -rf zad
	gcc -fopenmp zad2.c -o zad -pg -lm

clean :
	rm -rf zad plot.png
test : all
	env OMP_NUM_THREADS=2 ./zad 3 13 100000
	gnuplot plot

