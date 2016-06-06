all: split

split: split.s
	gcc -g -o split split.s

test: clean all
	./split

clean:
	rm -f split
	rm -rf *.o
