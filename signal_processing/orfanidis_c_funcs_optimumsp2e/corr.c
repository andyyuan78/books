/*  corr.c - sample cross correlation  */

void corr(N, y, x, M, R)
double y[], x[], R[];
int N, M;
{
      int k, i;

       for (k=0; k<=M; k++)
              for (R[k]=0, i=0; i<N-k; i++)
                     R[k] += y[i+k] * x[i] / N;
}
