/*  schur.c - Schur algorithm  */

#define MAX   10

void schur(M, R, gamma, EM)
double R[], gamma[], *EM;
{
       int k, p;
       double ga[MAX+1], gb[MAX+1], c, temp;

       for (k=0; k<=M; k++) {
              ga[k] = R[k];
              gb[k] = R[k];
              }

       for (p=0; p<M; p++) {
              c = ga[p+1] / gb[p];
              for (k=M; k>=p+1; k--) {
                     temp = ga[k];
                     ga[k] = temp - c * gb[k-1];
                     gb[k] = gb[k-1] - c * temp;
                     }
              gamma[p] = c;
              }

       *EM = gb[M];
}
