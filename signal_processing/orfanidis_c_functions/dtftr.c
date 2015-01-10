/* dtftr.c - N DTFT values over frequency range [wa, wb) */

#include <cmplx.h>                                 /* complex arithmetic */

complex dtft();                                    /* DTFT at one frequency */

void dtftr(L, x, N, X, wa, wb)                     /* usage: dtftr(L, x, N, X, wa, wb); */
double *x, wa, wb;                                 /* \(x\) is \(L\)-dimensional real */
complex *X;                                        /* \(X\) is \(N\)-dimensional complex */
int L, N;
{
       int k;
       double dw = (wb-wa)/N;                      /* frequency bin width */

       for (k=0; k<N; k++)
              X[k] = dtft(L, x, wa + k*dw);        /* \(k\)th DTFT value \(X(\om\sb{k})\) */
}
