#include <stdio.h>
extern unsigned add1(unsigned, unsigned);
extern long add2(long*, long*);
extern long add3(long*,int);
extern long* add4(long*, int);

int main(){
	unsigned a,b,c;
	a = 10;
	b = 12;
	long d=15, e=18, f;
	long tab[]={1,2,3,4,5,6,7,8};
	long* wynik;


	c = add1(a,b);
	printf("%u\n",c);

	f = add2(&d,&e);
	printf("%ld\n",f);
	
	f = add3(tab,4);
	printf("%ld\n",f);

	wynik = add4(tab,5);
	int i;	
	for(i=0; i<5; i++)
		printf("%ld ", wynik[i]);
	printf("\n");

	return 0;

}
