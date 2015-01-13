/*  snap.c - random snapshot generator  */

#include <math.h>
#include <complex.h>

double ran(), gran();

#define LMAX  10

void snap(L, k, P, M, y, iseed)
double k[], P[];
complex y[];
int L, M;
long *iseed;
{
       int i, j;
       complex A[LMAX];
       double phi, v1, v2, sigma = 1 / sqrt(2.0), pi = 4 * atan(1.0);

       for (i=0; i<L; i++) {
              phi = 2 * pi * ran(iseed);
              A[i] = rmul(sqrt(P[i]), cexp(cmplx(0., phi)));
              }

       for (j=0; j<=M; j++) {
              v1 = gran(0., sigma, iseed);
              v2 = gran(0., sigma, iseed);
              y[j]=cmplx(v1, v2);
              for (i=0; i<L; i++)
                     y[j] = cadd(y[j], cmul(A[i], cexp(cmplx(0., -j * k[i]))));
              }
}
