/*  spike.c - spiking filter design  */

#define MAX   10
#define NMAX  10

#define max(a, b)    (((a) >= (b)) ? (a) : (b))
#define min(a, b)    (((a) <= (b)) ? (a) : (b))

void lev(), corr();

void spike(N, y, M, R, L, E, P, H, eps)
double y[], R[], L[][MAX+1], E[], P[][NMAX+MAX+1], H[][NMAX+MAX+1], eps;
int N, M;
{
       int i, j, k, s, t;

       corr(N+1, y, y, M, R);

       for (k=0; k<=M; k++)
              R[k] *= N+1;

       R[0] *= 1 + eps;

       lev(M, R, L, E);

       for (i=0; i<=M; i++)
              for (j=0; j<=N+M; j++)
                     for (H[i][j]=0, s=i; s<=M; s++)
                            for (t=max(0, j-N); t<=min(j, s); t++)
                                   H[i][j] += L[s][i] * L[s][t] * y[j-t] / E[s];

       for (i=0; i<=N+M; i++)
              for (j=0; j<=N+M; j++)
                     for (P[i][j]=0, t=max(0, i-N); t<=min(i, M); t++)
                            P[i][j] += y[i-t] * H[t][j];
}
