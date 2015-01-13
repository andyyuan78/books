/*  minorm.c - minimum norm eigenvector  */

#include <math.h>
#include <complex.h>

#define MAX   10

void minorm(M, E, K, d)
complex E[][MAX+1], d[];
int M, K;
{
       int i, j;

       for (j=0; j<=M; j++)
              for (d[j]=cmplx(0., 0.), i=0; i<K; i++)
                     d[j] = cadd(d[j], cmul(conjg(E[0][i]), E[j][i]));
}
