#include "utils.h"

unsigned long long rdtsc(){
    unsigned long long a,d;
    
    __asm__ volatile("rdtsc" : "=a" (a), "=d" (d));
    
    return ((unsigned long long)a) | (((unsigned long long)d) << 32);
}


unsigned long long timer_start_time;

void timer_start(){
    timer_start_time = rdtsc();
}

unsigned long long timer_stop(){
    return (rdtsc() - timer_start_time);
}

