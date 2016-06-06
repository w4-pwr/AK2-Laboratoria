#include <stdio.h>

typedef float v4sf __attribute__ ((vector_size (16)));

int main()
{

   float a[4];
   float b[4];
//   float c[4];

   v4sf va;
   v4sf vb;
   v4sf vc;


   a[0] = 1.0;
   a[1] = 2.0;
   a[2] = 3.0;
   a[3] = 4.0;

   b[0] = 1.3;
   b[1] = 2.3;
   b[2] = 3.3;
   b[3] = 4.3;


//    int i = 0;
//    for (i = 0; i < 4; i++)
//    {
//        c[i] = a[i] + b[i];
//    }

   va = __builtin_ia32_loadups(a);
   vb = __builtin_ia32_loadups(b);

   vc = __builtin_ia32_addps (vb, va);

    float * c = a;

   __builtin_ia32_storeups (c, vc);




//    __asm__(
//            "movups (%[a]), %%xmm0 \n"
//            "movups (%[b]), %%xmm1 \n"
//            "addps %%xmm1, %%xmm0 \n"
//            "movups %%xmm0, %[c] \n"
//            :[c]"=m"(*c)
//            :[a]"r"(a),[b]"r"(b)
//            :"%xmm0","%xmm1"
//    );

   printf("%f, %f, %f, %f\n", c[0], c[1], c[2], c[3]);
}
