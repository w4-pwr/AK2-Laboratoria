#include <stdio.h>


extern double sinus(double x, int k, int pre);

int main(){
	
	
	
	double x=54, a, c;
	int k = 16, i;
	
	int pre1 = 0xCFF, pre2 = 0xEFF, pre3 = 0xFFF; 
	
	for(i =10; i<20; i++){
		k = i;
		printf("******************k=%d******************\n",k);
		c = sin(x);
		printf("control : %10.10f\n",c);
		a = sinus(x, k, pre3);
		printf("pre_def : %10.10f\n",a);
		a = sinus(x, k, pre1);
		printf("pre  1  : %10.10f\n",a);
		a = sinus(x, k, pre2);
		printf("pre  1  : %10.10f\n",a);
	}
	return 0;
}
