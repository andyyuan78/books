/*  bkwlev.c - backward levinson recursion  */

#define MAX   50

void bkwlev(M, a, L)
double a[], L[][MAX+1];
int M;
{
       int i, p;
       double gamma, F;

       for (i=0; i<=M; i++)
              L[M][i] = a[M-i];

       for (p=M; p>=1; p--) {
              gamma = - L[p][0];
              F = 1 - gamma * gamma;
              for (i=0; i<p-1; i++)
                     L[p-1][i] = ( L[p][i+1] + gamma * L[p][p-1-i] ) / F;
              L[p-1][p-1] = 1;
              }
}
