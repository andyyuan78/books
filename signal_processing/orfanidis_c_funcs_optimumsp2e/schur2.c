/*  schur2.c - split Schur algorithm  */

#define MAX   10

void schur2(M, R, gamma, EM)
double R[], gamma[], *EM;
int M;
{
       int k, p;
       double g[MAX+1][MAX+1], alpha, c = 0;

       g[0][0] = R[0];

       for (k=1; k<=M; k++) {
              g[0][k] = 2 * R[k];
              g[1][k] = R[k] + R[k-1];
              }

       for (p=0; p<=M-2; p++) {
              alpha = g[p+1][p+1] / g[p][p];
              c = -1 + alpha / (1 - c);
              gamma[p] = c;
              for (k=p+2; k<=M; k++)
                     g[p+2][k] = g[p+1][k] + g[p+1][k-1] - alpha * g[p][k-1];
              }

       alpha = g[M][M] / g[M-1][M-1];
       gamma[M-1] = -1 + alpha / (1 - c);
       *EM = g[M][M] * (1 - gamma[M-1]);
}
