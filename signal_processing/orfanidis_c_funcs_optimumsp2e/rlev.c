/*  rlev.c - reverse of Levinson's algorithm  */

#define MAX   50

void bkwlev();

void rlev(M, a, EM, R, L)
double a[], EM, R[], L[][MAX+1];
int M;
{
       int i, p;

       bkwlev(M, a, L);

       for (R[0]=EM, p=1; p<=M; p++)
              R[0] /= 1 - L[p][0] * L[p][0];

       for (p=1; p<=M; p++)
              for (R[p]=0, i=0; i<p; i++)
                     R[p] -= L[p][i] * R[i];
}
