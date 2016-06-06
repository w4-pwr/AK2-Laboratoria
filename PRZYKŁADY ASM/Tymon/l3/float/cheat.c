#include <stdlib.h>
#include <stdio.h>

#define _(x) printf("%20s:  ", #x); print(x);
#define __(x) printf("%20s:  ", #x); print_long(x);


typedef union {
    float f;
    unsigned int i;
} fi;

typedef unsigned int ui;
typedef unsigned long ul;

void float_mul() __attribute__((noinline));

volatile fi a,b,c,q;

void print(ui x){
    int i;
    for(i=31; i>=0; i--){
        if(i == 30 || i == 22) printf(" ");
        printf("%u", (x & (1 << i)) >> i);
    }
    printf("\n");
}

void print_long(ul x){
    long i;
    for(i=63; i>=0; i--){
        if(i == 31 || i == 30 || i == 22) printf(" ");
        printf("%lu", (x & (1L << i)) >> i);
    }
    printf("\n");
}


void float_mul(){
    q.f = a.f * b.f; // original
    
    if(a.i == 0 || b.i == 0){
        c.i = 0;
        return;
    }
    
    // sign
    ui Sa = a.i & (1 << 31);
    ui Sb = b.i & (1 << 31);
    ui Sc = Sa ^ Sb;

    // exponent
    
    // NaN
    if((a.i & (0xFF << 23)) == (0xFF << 23)){
        if((a.i & 0x7FFFFF) != 0) { c.i = a.i; return;}
    }
    
    // Nan
    if((b.i & (0xFF << 23)) == (0xFF << 23)){
        if((b.i & 0x7FFFFF) != 0) { c.i = b.i; return;}
    }
    
    
    ul Ea = (((ul)a.i) & (0xFF << 23)) - (127 << 23);
    ul Eb = (b.i & (0xFF << 23));
    ul Ec = Ea + Eb;
    
    if((Ec & (1L << 63)) != 0) { c.i = Sc; return; }
    __(Ec & 0xFFFFFFFF80000000L)
    if((Ec & 0xFFFFFFFF80000000L) != 0) { c.i = Sc | (0xFF << 23); return; }
       // _(Ec)
    // if((Ec & (1 << 31)) != 0) { c.i = Sc; return;}
 


    // mantissa
    ui Ma = a.i & 0x7FFFFF;
    if(Ea != 0) Ma |= (1 << 23);
    ui Mb = b.i & 0x7FFFFF;
    if(Eb != 0) Mb |= (1 << 23);
    ul Mc = (ul)Ma * (ul)Mb;
    
    Ec += (Mc & (1L << 47)) >> 24;
    Mc >>= (Mc & (1L << 47)) >> 47;
    Mc += (Mc & (1 << 22)) << 1;
    Mc >>= 23;
    Mc &= 0x7FFFFF;

    c.i = Sc | Ec | Mc;
}


void run(){
    int f;
    float_mul();
    
    printf("%40f * %40f = %40f | %40f\n", a.f, b.f, q.f, c.f);
}

void print_header(){
    printf("%40s | %40s | %40s | %40s\n", "A", "B", "C++", "ASM");
    int i; for(i =0; i<169; i++) printf("-");
    printf("\n");
}

void rand_test(){
    int n = 10;
    int seed = 1;
    int i;

    srand((int)time(NULL));

    for(i=0; i<n; i++){
        a.i = (((rand() % 2)*2)-1) * rand();
        b.i = (((rand() % 2)*2)-1) * rand();
        run();
    }
}

int main(int argc, const char * argv[]){
    if(argc == 1){
        print_header();
        rand_test();
    } else if(argc == 3){
        print_header();
        sscanf(argv[1], "%f", &a.f);
        sscanf(argv[2], "%f", &b.f);
        run();
    } else {
        printf("Usage: %s     - random test\n", argv[0]);
        printf("       %s A B - test specified numbers\n", argv[0]);
    }
    return 0;
}
