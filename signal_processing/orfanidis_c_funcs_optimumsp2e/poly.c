/*  poly.c - polynomial evaluation  */

#include <math.h>
#include <complex.h>

complex poly(M, a, z)
complex a[], z;
int M;
{
       int i;
       complex p;

       for (p=a[M], i=M-1; i>=0; i--)
              p = cadd(a[i], cmul(z, p));

       return p;
}
