#include <stdio.h>

float f1, f2, wynik;
void float_mul() __attribute__((noinline));



void float_mul(){
	wynik = f1*f2;
}

int main(){
	
	scanf("%f %f",&f1,&f2);
	float_mul();
	printf("%f\n",wynik);
	printf("%f\n",f1/f2);
	return 0;
}
