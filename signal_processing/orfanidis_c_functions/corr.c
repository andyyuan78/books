/* corr.c - sample cross correlation of two length-N signals */

void corr(N, x, y, M, R)                  /* computes \(R[k]\), \(k = 0, 1,\dotsc, M\) */
double *x, *y, *R;                        /* \(x,y\) are \(N\)-dimensional */
int N, M;                                 /* \(R\) is \((M+1)\)-dimensional */
{
       int k, n;

       for (k=0; k<=M; k++)
              for (R[k]=0, n=0; n<N-k; n++)
                     R[k] += x[n+k] * y[n] / N;
}
