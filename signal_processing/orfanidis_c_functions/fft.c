/* fft.c  --  in-place decimation-in-time FFT */

#include <cmplx.h>

void shuffle(), dftmerge();

void fft(N, X)
complex *X;
int N;
{
       shuffle(N, X);
       dftmerge(N, X);
}
