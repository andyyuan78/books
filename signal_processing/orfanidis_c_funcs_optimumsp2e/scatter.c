/*  scatter.c - direct scattering problem  */

#define MAX   50

#define min(a, b)    (((a) <= (b)) ? (a) : (b))

void scatter(M, rho, A, B, N, R)
double rho[], A[][MAX+1], B[][MAX+1], R[];
int M, N;
{
       int i, j, k;
       double S;

       A[0][0] = 1;
       B[0][0] = rho[0];

       for (i=1; i<=M; i++) {
              A[i][0] = 1;
              A[i][i] = rho[0] * rho[i];
              B[i][0] = rho[i];
              B[i][i] = rho[0];
              for (j=1; j<=i-1; j++) {
                     A[i][j] = A[i-1][j] + rho[i] * B[i-1][j-1];
                     B[i][j] = B[i-1][j-1] + rho[i] * A[i-1][j];
                     }
              }

       R[0] = B[M][0];
       for (k=1; k<N; k++) {
              for (S=0, i=1; i<=min(k, M); i++)
                     S -= A[M][i] * R[k-i];
              if (k <= M)
                     R[k] = B[M][k] + S;
              else
                     R[k] = S;
              }
}
