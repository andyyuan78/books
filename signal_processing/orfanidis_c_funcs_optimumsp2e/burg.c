/*  burg.c - Burg's method  */

#define MAX   50
#define NMAX  500

void burg(N, y, M, L, E)
double y[], L[][MAX+1], E[];
int N, M;
{
       int i, p;
       double ea[NMAX], eb[NMAX], num, den, gamma, temp;

       for (E[0]=0, i = 0; i < N; i++) {
              E[0] += y[i] * y[i];
              ea[i] = y[i];
              eb[i] = y[i];
              }
       E[0] /= N;
       L[0][0] = 1;

       for (p=1; p<=M; p++) {
              for (num=den=0, i=p; i<N; i++) {
                     num += 2 * ea[i] * eb[i-1];
                     den += ea[i] * ea[i] + eb[i-1] * eb[i-1];
                     }

              gamma = num / den;

              E[p] = E[p-1] * (1 - gamma * gamma);

              L[p][p] = 1;
              L[p][0] = - gamma;
              for (i=1; i<p; i++)
                     L[p][i] = L[p-1][i-1] - gamma * L[p-1][p-1-i];

              for (i=N-1; i>=p; i--) {
                     temp = ea[i];
                     ea[i] = temp - gamma * eb[i-1];
                     eb[i] = eb[i-1] - gamma * temp;
                     }
              }
}
