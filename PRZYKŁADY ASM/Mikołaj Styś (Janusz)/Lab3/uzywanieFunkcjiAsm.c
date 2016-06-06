#include <stdio.h>
extern int asmStrlen(char* str);
extern float asmDodajFloat(float f1, float f2);
extern char asmGetCharAt(char* str, int index);
extern float asmFloat;
int zmiennaC = 45;

int main(void) {
	int liczba = asmStrlen("hue hue hue");
	float dod = asmDodajFloat(asmFloat, 24.333);
	char ch = asmGetCharAt("hue hue hue", 2);
	printf("%d	%c	%f\n", liczba, ch, dod);
}
