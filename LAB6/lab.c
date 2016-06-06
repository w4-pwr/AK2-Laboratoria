#include <stdio.h>

extern void throwExceptions();
extern void showExceptions();

extern float* quadricEquation(float a, float b, float c);

extern float heron(float a, float b, float c);
extern void  sinus();


int main() {

	printf("-------------------------------- ZAD 1. - pokaż wyjątki\n");
	throwExceptions();
	showExceptions();

	printf("\n-------------------------------- ZAD 2. - równanie kwadratowe\n");
	quadricEquation(2.0, 4.0, 1.0);

	printf("\n-------------------------------- ZAD 3. - wzor herona\n");
	float wynik = heron(5.0, 6.0, 4.0);
	printf("Pole trojkata: %.9f\n", wynik);

	printf("\n-------------------------------- ZAD 4. - tablicownaie funkcji sinus\n");
	sinus();

	return 0;
}
