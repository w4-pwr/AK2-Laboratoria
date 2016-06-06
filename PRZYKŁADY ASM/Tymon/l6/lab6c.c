#include <stdio.h>
#include <stdlib.h>
#include <math.h>

extern double sinus(double x, int k, int prec);
int k;
int main (int argc, char const *argv[]){
    // long double a = 1.4;
    // printf("%10.10f\n", a);
    // 
    // long double x = 3.12345678;
    // long double oldsin, newsin;
    // int k = 16;
    // 
    // oldsin = x/pow(3, k);
    // 
    // 
    // for(k=16; k>0; k--){
    //     newsin = 3*oldsin - 4*pow(oldsin, 3);
    //     oldsin = newsin;
    // }
    
	double x = 3.5;
   
   
	
   
	double real = sin(x);
	double a;
    
	printf("sin:      %10.10lf\n", sin(x));
    
	for(k=10; k<20; k++){
		printf("\nk=%d\n", k);
		a = sinus(x, k, 0xCFF);
		printf("hax sin:  %10.10lf (%10.10lf)\n", a, real-a);
		a = sinus(x, k, 0xFFF);
		printf("hax sin:  %10.10lf (%10.10lf)\n", a, real-a);   
		a = sinus(x, k, 0xEFF);
		printf("hax sin:  %10.10lf (%10.10lf)\n", a, real-a);
	}


    
    return 0;
}
