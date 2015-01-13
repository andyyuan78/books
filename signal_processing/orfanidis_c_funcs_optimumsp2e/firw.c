/*  firw.c - FIR Wiener filter design  */

#define MAX   50

void lev();

void firw(M, Rxy, Ryy, L, E, g, h)
double Rxy[], Ryy[], L[][MAX+1], E[], g[], h[];
int M;
{
       int i, p;

       lev(M, Ryy, L, E);

       for (p=0; p<=M; p++) {
              for (g[p]=0, i=0; i<=p; i++)
                     g[p] += L[p][i] * Rxy[i];
              g[p] /= E[p];
              }

       for (p=0; p<=M; p++)
              for (h[p]=0, i=p; i<=M; i++)
                     h[p] += L[i][p] * g[i];
}
