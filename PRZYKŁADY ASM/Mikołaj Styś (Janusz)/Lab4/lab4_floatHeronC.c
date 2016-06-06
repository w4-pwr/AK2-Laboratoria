#include <stdio.h>
#include <math.h>
extern float floatHeron(float a, float b, float c);
extern float floatFlatHeron(float a, float b, float c);
extern void setFloatInnerType(char type);
extern void setFloatRC(char type);
extern void getFloatErrorsAndClearThem(void);
extern float* cubicEquation(float a, float b, float c, float d);
extern float floatRoot(float a, int b, int times);
extern float floatACos(float a);
extern double floatAction(void);
int main() {
	//setFloatInnerType(0);
	//float a = 2, b = 1.00001, c = 1.000001;
	//float f1 = floatHeron(a,b,c);
	//setFloatRC(3);
	
	//float f2 = floatFlatHeron(a,b,c);
	//getFloatErrorsAndClearThem();
	//printf("Wynik: %.11f vs %.11f \n", f1, f2);
	//float b = floatRoot(10, 3, 20);
	
	setFloatRC(1);
	float* x = cubicEquation(2.0, -4.0, -22.0, 24.0);
	printf("%.9f, %.9f, %.9f\n", x[0], x[1], x[2]);
	
	//float* x = cubicEquation(2.0, -4.0, -22.0, 24.0);
	//float x1 = floatACos(0.65);
	//printf("%f %f %f", x[0], x[1], x[2]);
	//printf("%lf\n", floatAction());
	//getFloatErrorsAndClearThem();
	return 0;
}
