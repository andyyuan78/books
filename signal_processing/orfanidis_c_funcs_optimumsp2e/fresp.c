/*  fresp.c - frequency response  */

#include <math.h>
#include <complex.h>

complex poly();

void fresp(M, a, NF, AF)
complex a[];
double AF[];
int M, NF;
{
       int i;
       complex z;
       double omega, pi = 4 * atan(1.);

       for (i=0; i<NF; i++) {
              omega = pi * i / NF;
              z = cexp(cmplx(0., -omega));
              AF[i] = cabs( poly(M, a, z) );
              AF[i] = AF[i] * AF[i];
              }
}
