all: conv

split: conv.s
	gcc -g -o conv conv.s

test: clean all
	./conv

clean:
	rm -f conv
	rm -rf *.o
