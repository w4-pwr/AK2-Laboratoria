#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "utils.h"

typedef float v4sf __attribute__ ((vector_size (16)));

#define bool char
#define true 1
#define false 0

#define N 11

#define SERIAL_FILENAME "times_serial.dat"
#define SSE_FILENAME "times_sse.dat"

typedef struct {
    float ** data;
    int n,m;
} matrix;

void free_matrix(matrix * mtx){
    int i;
    for(i=0; i<mtx->n; i++){
        free(mtx->data[i]);
    }
    free(mtx->data);
    free(mtx);
}

matrix * read_matrix(const char * filename, int n, int m){
    printf("Reading matrix: %s\n", filename);
    FILE * f = fopen(filename, "r");
    matrix * mtx = (matrix *)malloc(sizeof(matrix));
    mtx->n = n;
    mtx->m = m;
    mtx->data = (float **)malloc(n*sizeof(float *));

    int i,j;

    for(i=0; i<n; i++){
        mtx->data[i] = (float *)malloc(m*sizeof(float));
        for(j=0; j<m; j++){
            fscanf(f, "%f", &mtx->data[i][j]);
            fgetc(f);
        }
    }


    fclose(f);

    return mtx;
}

void print_matrix(matrix * mtx){
    printf("size: %d x %d\n", mtx->n, mtx->m);
    int i,j;
    for(i=0; i<mtx->n; i++){
        for(j=0; j<mtx->m; j++){
            printf("%5.4f ", mtx->data[i][j]);
        }
        printf("\n");
    }
}

matrix * prepare(matrix * m1, matrix * m2){
    int i;
    
    matrix * m3 = (matrix *)malloc(sizeof(matrix));
    m3->data = (float **)malloc(m1->n*sizeof(float *));
    
    m3->n = m1->n;
    m3->m = m2->m;
    
    for(i=0; i<m1->n; i++){
        m3->data[i] = (float *)malloc(m2->m*sizeof(float *));
    }
    
    for(i=0; i<m1->n; i++){
        m3->data[i][0] = 0;
    }
    
    return m3;
}

matrix * multiplySerial(matrix * m1, matrix * m2, unsigned long long * elapsed, bool release){
    int i,k;
    
    matrix * m3 = prepare(m1, m2);
    
    timer_start();
    for(i=0; i<m1->n; i++){
        for(k=0; k<m1->m; k++){
            m3->data[i][0] += m1->data[i][k] * m2->data[k][0];
        }
    }
    *elapsed += timer_stop();
    
    if(release) free_matrix(m3);
    
    return m3;
}

matrix * multiplySSE(matrix * m1, matrix * m2, unsigned long long * elapsed, bool release){
    int i,k,n,m;
    
    float sum;
    
    v4sf va, vb, vc;
    float *a, *b;
    float * muls = (float *)malloc(m1->m*sizeof(float));

    matrix * m3 = prepare(m1, m2);

    timer_start();
    for(i=0; i<m1->n; i++){
        for(k=0; k<m1->m; k++){
            muls[k] = m1->data[i][k] * m2->data[k][0];
        }

        n = m1->m;

        while(n > 4){
            n >>= 1; //n /= 2;
            m = (n >> 2); //n/4;
            
            for(k=0; k<m; k++){
                a = muls + 4*k;
                b = muls + 4*(m + k);
                
                va = __builtin_ia32_loadups(a);
                vb = __builtin_ia32_loadups(b);
                vc = __builtin_ia32_addps(vb, va);
                __builtin_ia32_storeups(a, vc);
            }
        }
        
        sum = 0;
        for(k=0; k<4; k++){
            sum += muls[k];
        }

        m3->data[i][0] = sum;
        
        
    }
    
    *elapsed += timer_stop();

    free(muls);
    if(release) free_matrix(m3);
    
    return m3;
}

void save_matrix(matrix * mtx, const char * filename){
    int i,j;
    FILE * f = fopen(filename, "w");
    for(i=0; i<mtx->n; i++){
        fprintf(f, "%5.4f", mtx->data[i][0]);
        for(j=1; j<mtx->m; j++){
            fprintf(f, ", %5.4f", mtx->data[i][0]);
        }
        fprintf(f, "\n");
    }
    fclose(f);
}

void save_times(unsigned long long * times, int n, const char * filename){
    int i;
    FILE * f = fopen(filename, "w");
    for(i=0; i<n; i++){
        fprintf(f, "%d %llu\n", i+3, times[i]);
    }
    fclose(f);
}

int main(int argc, char const *argv[]){
    int i,j;
    char filename[256];
    unsigned long long times[2][N];
    int tn = 100;

    for(i=0; i<N; i++){
        int k = i+3;
        int n = pow(2, k);
        sprintf(filename, "matrices/mat_%d_a.mat", k);
        matrix * m1 = read_matrix(filename, n, n);
        sprintf(filename, "matrices/mat_%d_b.mat", k);
        matrix * m2 = read_matrix(filename, n, 1);
        
        // print_matrix(m1);
        // print_matrix(m2);
        
        // unsigned long long t1, t2;
        // matrix * res1 = multiplySerial(m1, m2, &t1, false);
        // matrix * res2 = multiplySSE(m1, m2, &t2, false);
        // save_matrix(res1, "_res_serial.mat");
        // save_matrix(res1, "_res_sse.mat");


        printf("Multiply serial\n");
        times[0][i] = 0;
        for(j=0; j<tn; j++) multiplySerial(m1, m2, &times[0][i], true);
        times[0][i] = times[0][i] / (n*n) / tn;
        
        printf("Multiply SSE\n");
        times[1][i] = 0;
        for(j=0; j<tn; j++) multiplySSE(m1, m2, &times[1][i], false);
        times[1][i] = times[1][i] / (n*n) / tn;
    }
    
    save_times(times[0], N, SERIAL_FILENAME);
    save_times(times[1], N, SSE_FILENAME);

    return 0;
}
