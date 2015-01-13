/*  lev.c - Levinson's algorithm  */

#define MAX   50

void lev(M, R, L, E)
double R[], L[][MAX+1], E[];
int M;
{
       int i, p;
       double delta, gamma;

       L[0][0] = 1;
       E[0] = R[0];

       for (p=1; p<=M; p++) {
              for (delta=0, i=0; i<p; i++)
                     delta += R[i+1] * L[p-1][i];
              gamma = delta / E[p-1];
              L[p][0] = - gamma;
              for (i=1; i<p; i++)
                     L[p][i] = L[p-1][i-1] - gamma * L[p-1][p-1-i];
              L[p][p] = 1;
              E[p] = E[p-1] * (1 - gamma * gamma);
              }
}
