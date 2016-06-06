UNAME := $(shell uname -s)

CC = gcc -O2 -Wall -msse

ifneq ($(UNAME), Darwin)
	CC += -lm
endif

OBJECTS = matrix.o utils.o

all: matrix

matrix: $(OBJECTS)
	$(CC) -o matrix $(OBJECTS)

clean:
	rm -f *.o matrix

test: clean all
	./matrix

test-all: test
	cat times.dat

ifeq ($(UNAME), Darwin)
graph:
	gnuplot graph.g
	open graph.pdf
endif

