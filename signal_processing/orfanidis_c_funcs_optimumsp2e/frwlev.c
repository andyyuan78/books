/*  frwlev.c - forward Levinson recursion  */

#define  MAX  50

void frwlev(M, gamma, L)
double L[][MAX+1], gamma[];
int M;
{
       int i, p;

       L[0][0] = 1;

       for (p=1; p<=M; p++) {
              L[p][0] = -gamma[p-1];
              L[p][p] = 1;
              for (i=1; i<p; i++)
                     L[p][i] = L[p-1][i-1] - gamma[p-1] * L[p-1][p-1-i];
              }
}
