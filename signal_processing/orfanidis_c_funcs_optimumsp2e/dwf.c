/*  dwf.c - direct form Wiener filter  */

#define MAX   50

void dwf(M, h, x, y, xhat, e, init)
double h[], x, y, *xhat, *e;
int M, *init;
{
       int i, p;
       static double w[MAX+1];

       if (*init == 0) {
              for (i=1; i<=M; i++)
                     w[i] = 0;
              *init = 1;
              }

       w[0] = y;

       for (*xhat=0, p=0; p<=M; p++)
              *xhat += h[p] * w[p];

       *e = x - *xhat;

       for (p=M; p>=1; p--)
              w[p] = w[p-1];
}
