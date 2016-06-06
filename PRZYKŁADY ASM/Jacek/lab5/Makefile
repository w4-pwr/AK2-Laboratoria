all: matrix.c
	gcc -O2 -o matrix matrix.c -lm -msse 
clean: 
	rm -rf matrix plot.png results_0.txt results_1.txt
test: clean all
	./matrix 
	gnuplot plot
