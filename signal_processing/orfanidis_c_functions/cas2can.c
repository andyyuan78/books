/* cas2can.c - cascade to canonical */

#include <stdlib.h>                                     /* declares calloc */

void conv();

void cas2can(K, A, a)                                   /* \(a\) is \((2K+1)\)-dimensional */
double **A, *a;                                         /* \(A\) is \(Kx3\) matrix */
int K;                                                  /* \(K\) = no. of sections */
{
       int i,j;
       double *d;

       d = (double *) calloc(2*K+1, sizeof(double));

       a[0] = 1;                                        /* initialize */

       for(i=0; i<K; i++) {
              conv(2, A[i], 2*i+1, a, d);               /* \(d = a[i] \ast a\) */
              for(j=0; j<2*i+3; j++)                    /* \(a = d\) */
                     a[j] = d[j];
              }
}
