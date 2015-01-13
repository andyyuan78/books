/*  schur1.c - Schur algorithm for Cholesky factorization  */

#define MAX   10

void schur1(M, R, gamma, G)
double R[], gamma[], G[][MAX+1];
int M;
{
       int k, p;
       double ga[MAX+1], c, temp;

       for (k=0; k<=M; k++) {
              ga[k] = R[k];
              G[k][0] = R[k];
              }

       for (p=0; p<M; p++) {
              c = ga[p+1] / G[p][p];
              for (k=p+1; k<=M; k++) {
                     temp = ga[k];
                     ga[k] = temp - c * G[k-1][p];
                     G[k][p+1] = G[k-1][p] - c * temp;
                     }
              gamma[p] = c;
              }
}
