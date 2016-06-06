all: mul

mul: mul.s
	gcc -g -o mul mul.s

test: clean all
	./mul

clean:
	rm -f mul
	rm -rf *.o
