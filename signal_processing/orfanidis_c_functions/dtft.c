/* dtft.c - DTFT of length-L signal at a single frequency w */

#include <cmplx.h>                                   /* complex arithmetic */

complex dtft(L, x, w)                                /* usage: X=dtft(L, x, w); */
double *x, w;                                        /* \(x\) is \(L\)-dimensional */
int L;
{
       complex z, X;
       int n;

       z = cexp(cmplx(0, -w));                       /* set \(z=e\sp{-j\om}\) */

       X = cmplx(0,0);                               /* initialize \(X=0\) */

       for (n=L-1; n>=0; n--)
              X = cadd(cmplx(x[n], 0), cmul(z, X));

       return X;
}
