#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

typedef float v4sf __attribute__ ((vector_size (16)));

float ** read_matrix(char * filename, int row, int column){
   float** tab;
   int i,j;
   tab = (float**)malloc(row * sizeof(float*));
   for(i=0; i<row; i++)
        tab[i] = (float*)malloc(column * sizeof(float));
   
    FILE * f;
    f = fopen(filename, "r");
    float x;
    char c;
    char nl = 0;
    for(i=0; i<row; i++)
        for(j=0; j<column; j++){
            fscanf(f, "%f", &x);
            tab[i][j] = x;
            c = fgetc(f);
        }
    
   return tab;
}

float * read_vector(char * filename, int row){
   float * tab;
   int i,j;
   tab = (float*)malloc(row * sizeof(float));
      
    FILE * f;
    f = fopen(filename, "r");
    float x;
    char c;
    char nl = 0;
    for(i=0; i<row; i++){
            fscanf(f, "%f", &x);
            tab[i] = x;
            c = fgetc(f);
        }
    
   return tab;
}

void print_matrix(float * tab, int row){
    int i,j;
    for(i=0; i<row; i++) {
            printf("%5.4f\n",tab[i]);
    }
}

void mul(float * tab, float ** a, float * b, int n){
    int i,k;
    for(i=0;i<n;i++)
        for(k=0; k<n; k++)
            tab[i] += a[i][k] * b[k];
}

void mul6(float * tab, float ** a, float * b, int n){
    int i,j;    
    float add[4];
    v4sf va, vb, vc;
   
    for(i=0;i<n;i++){
        va = __builtin_ia32_loadups(a[i]);
        vb = __builtin_ia32_loadups(b);
        vc = __builtin_ia32_mulps (vb, va);
        __builtin_ia32_storeups (add, vc);
       
        for(j=4; j<n; j+=4){
            va = __builtin_ia32_loadups(a[i]+j);
            vb = __builtin_ia32_loadups(b+j);
            vc = __builtin_ia32_mulps (vb, va);
            va = __builtin_ia32_loadups(add);
            vb = __builtin_ia32_addps (vc, va);
            __builtin_ia32_storeups (add, vb);
        }
        for(j=0; j<4; j++)
            tab[i] += add[j];
    }
}



unsigned long long int rdtsc(void){
     unsigned long long int x;
     unsigned long long a, d;

     __asm__ volatile("rdtsc" : "=a" (a), "=d" (d));

     return ((unsigned long long)a) | (((unsigned long long)d) << 32);
}

int main(int argc, char * args[]){
    int i,j,it;
    unsigned long long counter, stop;
    char a[256], b[256];
    FILE * f;
    f = fopen("results.txt","w");
    

    
    
    
    for(it=2; it<=13; it++){
        fprintf(f,"%d ",it);
        sprintf(a,"mat_%d_a.mat",it);
        sprintf(b,"mat_%d_b.mat",it);
        int a_row = (int)pow(2,it), a_column = (int)pow(2,it), b_row = (int)pow(2,it), b_column = 1;
        
        
        //alokacja pamięci na macierze
        float ** m1 = read_matrix(a,a_row,a_column);
        float * m2 = read_vector(b,b_row);
        float * mw1 = (float*)malloc(a_row* sizeof(float));
		
		
		
		for(i=0; i<a_row; i++)
                mw1[i] = 0;
        counter = rdtsc(); 
        mul(mw1,m1,m2,a_row);
        stop = rdtsc() - counter;
        fprintf(f,"%llu ",stop / (int)pow(2,2*it));
        printf("%d\n",it);
		
		
		for(i=0; i<a_row; i++)
                mw1[i] = 0;
        counter = rdtsc(); 
        mul6(mw1,m1,m2,a_row);
        stop = rdtsc() - counter;
        fprintf(f,"%llu ",stop / (int)pow(2,2*it));
        printf("%d\n",it);
        
        
//print_matrix(mw1,a_row);

        //zwalnianie pamięci
        for(i=0; i<a_row; i++)
		    free(m1[i]);
	    free(m1); 
	    free(m2);
	    free(mw1);
	    fprintf(f,"\n");
	}
	fclose(f);
	return 0;
}


