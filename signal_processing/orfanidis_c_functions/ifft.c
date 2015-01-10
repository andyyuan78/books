/* ifft.c - inverse FFT */

#include <cmplx.h>

void fft();

void ifft(N, X)
complex *X;
int N;
{
    int k;

    for (k=0; k<N; k++)
         X[k] = conjg(X[k]);                     /* conjugate input */

    fft(N, X);                                   /* compute FFT of conjugate */

    for (k=0; k<N; k++)
         X[k] = rdiv(conjg(X[k]), (double)N);    /* conjugate and divide by \(N\) */
}
