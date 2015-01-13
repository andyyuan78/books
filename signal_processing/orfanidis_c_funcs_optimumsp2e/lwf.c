/*  lwf.c - lattice Wiener filter  */

#define MAX   50

void lwf(M, g, gamma, x, y, xhat, e, init)
double g[], gamma[], x, y, *xhat, *e;
int M, *init;
{
       int i, p;
       double ea[MAX+1], eb[MAX+1];
       static double w[MAX];

       if (*init == 0) {
              for (i=0; i<=M-1; i++)
                     w[i] = 0;
              *init = 1;
              }

       ea[0] = y;
       eb[0] = y;
       *xhat = g[0] * eb[0];
       *e = x - *xhat;

       for (p=1; p<=M; p++) {
              ea[p] = ea[p-1] - gamma[p-1] * w[p-1];
              eb[p] = w[p-1] - gamma[p-1] * ea[p-1];
              w[p-1] = eb[p-1];
              *xhat += g[p] * eb[p];
              *e -= g[p] * eb[p];
              }
}
