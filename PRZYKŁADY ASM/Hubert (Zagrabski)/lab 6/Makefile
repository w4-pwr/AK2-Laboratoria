as -o z_prefetch.o z_prefetch.s
as -o bez_prefetch.o bez_prefetch.s

gcc -o main.o main.c -c
gcc -o main main.o bez_prefetch.o z_prefetch.o
