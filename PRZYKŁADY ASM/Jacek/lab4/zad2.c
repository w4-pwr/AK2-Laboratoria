#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>




double function(double x){
	return pow(x,pow(x,sin(x)));
}



double integrate(double begin, double end, int count){
	double score = 0 , width = (end-begin)/(1.0*count), i=begin, y1, y2;	
	

	for(i = 0; i<count; i++){
		score += (function(begin+(i*width)) + function(begin+(i+1)*width)) * width/2.0;
    }
	return score;
}




double thread2(double begin, double end, int count){
	double score = 0 , width = (end-begin)/(1.0*count), y1, y2;	
	
	int i;
	#pragma omp parallel for reduction(+:score) private(y1,i) shared(count)
    for(i = 0; i<count; i++){
	    y1 = ((function(begin+(i*width)) + function(begin+(i+1)*width)) * width/2.0);
        score = score + y1;
	}
	
	return score;
}


double thread1(double begin, double end, int count){
	double score = 0 , width = (end-begin)/(1.0*count), y1, y2;	
	
	int i;
	double * tab = (double*)malloc(count * sizeof(double));	

	#pragma omp parallel  for 
	for(i = 0; i<count; i++){
		tab[i] = (function(begin+(i*width)) + function(begin+(i+1)*width)) * width/2.0;
	}
	
	for(i=0; i<count; i++)
		score += tab[i];	
	return score;
}

int suma(int * tab, int i){
    int result = 0, j;
    for(j = 0; j < i; j++)
        result += tab[j];
    
    return result;
}

double thread3(double begin, double end, int count){
    double score = 0 , width = (end-begin)/(1.0*count), yp, yk;	
    int i,j, k;
    

    #pragma omp 
    {
        int thread_num = omp_get_num_threads(),  sum = 1; 
        int * tab = (int*)malloc(sizeof(int) * (thread_num +1));
        
        for(i=0; i<thread_num + 1; i++)
            tab[i] = 0;
        for(i = 0; i < count; i++, sum++){
            if(sum == (thread_num + 1)) sum = 1;
            tab[sum]++;
        }
        
       for(i = 1; i < thread_num +1; i++)
            tab[i] += tab[i-1]; 
        
        #pragma omp parallel for private(yp, yk) reduction(+:score)
        for( i=0; i<thread_num; i++){
            yp = function(begin + (tab[i]*width));
            yk = function(begin + ((tab[i]+1)*width));
            score += (yp + yk) * width / 2.0;
            
            for(j=tab[i]+2; j<=tab[i+1]; j++){
                yp = yk;
                yk = function(begin + (j*width));
                score += (yp + yk) * width / 2.0;
            }
            
        }
    }
    return score;
}

unsigned long long int rdtsc(void){
     unsigned long long int x;
     unsigned a, d;

     __asm__ volatile("rdtsc" : "=a" (a), "=d" (d));

     return ((unsigned long long)a) | (((unsigned long long)d) << 32);
}

int main(int argc, char** argv){
	unsigned long long counter = 0, stop;	
	unsigned long long tab[3];
	int i, j;
	double d, dokl;

	//Przebiegi rozgrzewające
    integrate (atof(argv[1]), atof(argv[2]), atoi(argv[3]));
    integrate (atof(argv[1]), atof(argv[2]), atoi(argv[3]));
    integrate (atof(argv[1]), atof(argv[2]), atoi(argv[3]));
  	
    double begin = atof(argv[1]);
    double end = atof(argv[2]);
    int count = 10;
    
    FILE * c;
    FILE * t1;
    FILE * t2;
    FILE * t3;
    
    c = fopen ("control","w");
	for(i=10; i<=1000000; i*=10){
        counter = rdtsc();
        d = integrate(atof(argv[1]), atof(argv[2]), i);  	
        tab[0] = rdtsc()-counter;
        fprintf(c,"%d %lld ",i, tab[0]);
        printf("Wynik : %10.10f, dokładność : nie wiem jak bo wolfram jest mniej dokladny \n",d,1.0);
        counter = rdtsc();
        thread1(atof(argv[1]), atof(argv[2]), i);  	
        tab[1] = rdtsc()-counter;
        fprintf(c,"%lld ",tab[1]);
        counter = rdtsc();
        thread2(atof(argv[1]), atof(argv[2]), i);  	
        tab[2] = rdtsc()-counter;
        fprintf(c,"%lld ", tab[2]);
        counter = rdtsc();
        thread3(atof(argv[1]), atof(argv[2]), i);  	
        stop = rdtsc()-counter;
        fprintf(c,"%lld\n", stop);
        
        for(j=0; j<3; j++)
            printf("bład względny czasu według najszybszej funkcji : %lf%  \n",100.0*(tab[j] - stop)/stop);
    }
	fclose(c);
	
	return 0;
}

