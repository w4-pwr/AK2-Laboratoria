#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define N 2048

extern void bez_prefetch(long long unsigned* A, long long unsigned* B, long long unsigned* C, int n);
extern void z_prefetch(long long unsigned* A, long long unsigned* B, long long unsigned* C, int n);

int main(){
	long long unsigned* A = malloc(N*8);
	long long unsigned* B = malloc(N*8);
	long long unsigned* C = malloc(N*8);
	long long unsigned* D = malloc(N*8);
	long long unsigned* E = malloc(N*8);
	long long unsigned* F = malloc(N*8);
	long long unsigned* G = malloc(N*8);

	clock_t p1, p2, p3;
	p1 = clock();
	bez_prefetch(A, B, C, N);
	p2 = clock();
	z_prefetch(D, E, F, N);
	p3 = clock();

	printf("Bez, ilosc cykli: %d, czas %.6f \n", p2-p1, ((float)(p2-p1))/CLOCKS_PER_SEC);

	printf("Z, ilosc cykli: %d, czas %.6f \n", p3-p2, ((float)(p3-p2))/CLOCKS_PER_SEC);
	return 0;
}
