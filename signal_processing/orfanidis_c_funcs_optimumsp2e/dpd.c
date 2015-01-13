/*  dpd.c - dynamic predictive deconvolution  */

#define MAX   50

void corr(), lev();

void dpd(N, R, M, A, B, PHI, L, E)
double R[], A[][MAX+1], B[][MAX+1], PHI[], L[][MAX+1], E[];
int N, M;
{
       int i, j, k;
       double rho0, rho, F;

       corr(N, R, R, M, PHI);

       for (k=1 ; k<=M; k++)
              PHI[k] = -N * PHI[k];

       PHI[0] = 1 - N * PHI[0];

       lev(M, PHI, L, E);

       for (i=0; i<=M; i++)
              A[M][i] = L[M][M-i];

       for (i=0; i<=M; i++)
              for (B[M][i]=0, j=0; j<=i; j++)
                     B[M][i] += A[M][j] * R[i-j];

       rho0 = B[M][M];
       for (i=M; i>=1; i--) {
              rho = B[i][0];
              F = 1 - rho * rho;
              for (j=0; j<=i-1; j++) {
                     A[i-1][j] = (A[i][j] - rho * B[i][j]) / F;
                     B[i-1][j] = (B[i][j+1] - rho * A[i][j+1]) / F;
                     }
              A[i-1][0] = 1;
              B[i-1][i-1] = rho0;
              }
}
