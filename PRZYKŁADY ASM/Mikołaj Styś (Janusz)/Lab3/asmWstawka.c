#include <stdio.h>

int main(void) {
	int x = 5;
	int y = 10;
	__asm__ __volatile__ (
		"\n"
		: "=c"(x), "=b"(y)
		: "b"(x), "c"(y)
		: "%eax"
		);
	
	printf("%d oraz %d",x,y);
}
