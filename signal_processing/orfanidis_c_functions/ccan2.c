/* ccan2.c - circular buffer implementation of canonical realization */

void wrap2();                        /* defined in Section \ref{hardware.sec} */

double ccan2(M, a, b, w, q, x)
double *a, *b, *w, x;                /* q = circular pointer offset index */
int M, *q;                           /* a,b have common order M */
{
       int i;
       double y = 0;

       w[*q] = x;                               /* read input sample x */

       for (i=1; i<=M; i++)
              w[*q] -= a[i] * w[(*q+i)%(M+1)];

       for (i=0; i<=M; i++)
              y += b[i] * w[(*q+i)%(M+1)];

       (*q)--;                                  /* update circular delay line */
       wrap2(M, q);

       return y;                                /* output sample */
}
