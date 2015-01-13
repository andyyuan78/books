/*  mgs.c - modified Gram-Schmidt adaptive preprocessor  */

#define MAX   10

void mgs(M, B, y, eps, d, lambda, beta)
double B[][MAX+1], y[], eps[], d[], lambda, beta;
int M;
{
       int i, p;

       for (p=0; p<=M; p++) {
              eps[p] = y[p];
              d[p] = lambda * d[p] + eps[p] * eps[p];
              for (i=p+1; i<=M; i++) {
                     y[i] -= B[i][p] * eps[p];
                     B[i][p] += beta * eps[p] * y[i] / d[p];
                     }
              }
}
