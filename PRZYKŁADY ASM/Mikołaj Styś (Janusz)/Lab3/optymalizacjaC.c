#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define sizeN 200000000
int tab[sizeN];
int main(void) {
	int i;
	for(i = 0; i < sizeN; i++) {
		tab[i] = 1;
	}
	int sum = 0;
	for(i = 0; i < sizeN; i++) {
		sum += tab[i];
	}
	printf("%d \n",sum);
	return 0;
}
