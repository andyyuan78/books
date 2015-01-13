/*  lms.c - LMS adaptive Wiener filter  */

#define MAX   50

void lms(M, h, x, y, xhat, e, mu, init)
double h[], x, y, *xhat, *e, mu;
int M, *init;
{
       int p;
       static double w[MAX+1];

       if (*init == 0) {
              for (p=1; p<=M; p++) {
                     w[p] = 0;
                     h[p] = 0;
                     }
              h[0] = 0;
              *init = 1;
              }

       w[0] = y;

       for (*xhat=0, p=0; p<=M; p++)
              *xhat += h[p] * w[p];

       *e = x - *xhat;

       for (p=0; p<=M; p++)
              h[p] += 2 * mu * *e * w[p];

       for (p=M; p>=1; p--)
              w[p] = w[p-1];
}
