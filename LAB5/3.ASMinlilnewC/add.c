#include <stdio.h>

int main() {

int x = 0;
int z = 0;
int w = 0;
printf("Dodawanie 2 liczb\n");
printf("a = ");
scanf("%d", &x);

printf("b = ");
scanf("%d", &z);

__asm__ __volatile__ (
	"addl %%ecx, %%ebx\n"
	"movl %%ebx, %%edx\n" 
	: "=c"(x),"=b"(z),"=d"(w)
	: "c"(x), "b"(z), "d"(w)
	);

	printf("Wynik: %d\n", w);	
	return 0;
}
