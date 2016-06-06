as -o printi.o printi.s
as -o prints.o prints.s
as -o subtraction.o subtraction.s
as -o allocate.o allocate.s
as -o open_file.o open_file.s


	ld -o allocate allocate.o 
gcc -o main.o main.c -c
gcc -o main main.o printi.o prints.o subtraction.o allocate.o open_file.o 
