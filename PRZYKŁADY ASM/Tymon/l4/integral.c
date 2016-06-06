#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double func(double) __attribute__((noinline));

unsigned long long int rdtsc(void){
    unsigned a, d;

    __asm__ volatile("rdtsc" : "=a" (a), "=d" (d));

    return ((unsigned long long)a) | (((unsigned long long)d) << 32);
}

double func(double x){
    // unsigned long long int prev = rdtsc();
    double res = pow(x, sin(x)+(1/x));
    // printf("%llu\n", rdtsc() - prev);
    return res;
}

double integrate(double a, double b, double step, int i){
    double ya = func(a + i*step);
    double yb = func(a + (i+1)*step);
    return (ya+yb)/2 * step;
}

int main (int argc, char const *argv[]){
    if(argc < 4){
        printf("Usage: %s [A] [B] [N]\n", argv[0]);
        exit(0);
    }
        
    double a = atof(argv[1]);
    double b = atof(argv[2]);
    int n = atoi(argv[3]);
    double step = (b-a)/n;
    double sum;
    int p,i;
    double * sums = (double *)malloc(sizeof(double)*n);
    
    for(p=0; p<n; p++) sums[p] = 0.0;
    
    #pragma omp parallel for
    for(i=0; i<n; i++){
        sums[i] = integrate(a,b,step,i);
    }

    
    sum = 0;
    for(p=0; p<n; p++) sum += sums[p];

    printf("sum = %f\n", sum);

    return 0;
}