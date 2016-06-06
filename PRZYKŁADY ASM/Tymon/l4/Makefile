CC = gcc -O2 -Wall -lm -pg

all: integral_parallel integral_serial

integral_parallel:
	$(CC) -o integral_parallel integral.c -fopenmp

integral_serial:
	$(CC) -o integral_serial integral.c

test: clean all
	time ./integral_serial 2 20 10000000
	OMP_NUM_THREADS=1  time ./integral_parallel 2 20 10000000
	OMP_NUM_THREADS=2  time ./integral_parallel 2 20 10000000
	OMP_NUM_THREADS=4  time ./integral_parallel 2 20 10000000
	OMP_NUM_THREADS=8  time ./integral_parallel 2 20 10000000

clean:
	rm -f integral integral.s int.s int
	rm -rf *.o
