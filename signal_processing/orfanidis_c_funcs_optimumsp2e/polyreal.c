/*  polyreal.c - real polynomial evaluation  */

#include <math.h>
#include <complex.h>

complex polyreal(M, a, z)
double a[];
complex z;
int M;
{
       int i;
       complex p;

       for (p=cmplx(a[M],0.), i=M-1; i>=0; i--)
              p = cadd(cmplx(a[i],0.), cmul(z, p));

       return p;
}
