/* conv.c - convolution of x[n] with h[n], resulting in y[n] */

#include <stdlib.h>                       /* defines max( ) and min( ) */

void conv(M, h, L, x, y)
double *h, *x, *y;                        /* \(h,x,y\) = filter, input, output arrays */
int M, L;                                 /* \(M\) = filter order, \(L\) = input length */
{
       int n, m;

       for (n = 0; n < L+M; n++)
              for (y[n] = 0, m = max(0, n-L+1); m <= min(n, M); m++)
                     y[n] += h[m] * x[n-m];
}
