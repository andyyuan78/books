/*  norm.c - normalization to unit norm  */

#include <math.h>
#include <complex.h>

void norm(M, a)
complex a[];
int M;
{
       int i;
       double D = 0;

       for (i=0; i<=M; i++)
              D += cabs(a[i]) * cabs(a[i]);

       D = sqrt(D);

       for (i=0; i<=M; i++)
              a[i] = rdiv(a[i], D);
}
