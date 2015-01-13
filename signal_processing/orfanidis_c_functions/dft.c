/* dft.c - N-point DFT of length-L real-valued signal */

#include <cmplx.h>                               /* complex arithmetic */

void dtftr();                                    /* DTFT's over a frequency range */

void dft(L, x, N, X)                             /* usage: dft(L, x, N, X); */
double *x;                                       /* \(x\) is \(L\)-dimensional real */
complex *X;                                      /* \(X\) is \(N\)-dimensional complex */
int L, N;
{
       double pi = 4 * atan(1.0);

       dtftr(L, x, N, X, 0.0, 2*pi);             /* \(N\) frequencies over \([0,2\pi)\) */
}
