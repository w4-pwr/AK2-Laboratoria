UNAME := $(shell uname -s)

CC = gcc -O2 -Wall

ifneq ($(UNAME), Darwin)
	CC += -lm
endif

all: lab6c

lab6c:
	$(CC) -o lab6c sinus.s lab6c.c


clean:
	rm -f *.o lab6c lab6asm

test: clean all
	./lab6c

