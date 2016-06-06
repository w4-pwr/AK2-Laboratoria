#include <stdlib.h>
#include <stdio.h>
 
extern float sinus(double kat, int n);
 
int main()
{
        double kat, kat_rad;
        int n;
 
        printf("\nPodaj kat (w stopniach): ");
        scanf("%f", &kat);
        printf("\nPodaj precyzje: ");
        scanf("%d", &n);
        kat_rad=(kat*3.14)/180;
        double sinus_kata = sinus(kat_rad, n);
        printf("Sinus(%.2f) = %.30lf dla %d krokow\n", kat, sinus_kata, n);
        return 0;
}
