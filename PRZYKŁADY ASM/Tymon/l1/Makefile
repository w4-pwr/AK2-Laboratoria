all: hello prompt

hello: hello.s
	gcc -g -o hello hello.s

prompt: prompt.s
	gcc -g -o prompt prompt.s

test: clean all
	./hello
	./prompt

clean:
	rm -f hello
	rm -f prompt
	rm -rf *.o

	

