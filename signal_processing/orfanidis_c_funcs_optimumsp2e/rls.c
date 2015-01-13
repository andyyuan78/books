/*  rls.c - conventional RLS algorithm  */

#define MAX   50
#define delta  0.01

void rls(M, h, x, y, xhat, e, lambda, init)
double h[], x, y[], *xhat, *e, lambda;
int M, *init;
{
       double k0[MAX+1], k1[MAX+1], mu, nu, xhat0, e0;
       static double P[MAX+1][MAX+1];
       int i, j;

       if (*init == 0) {
              for (i=0; i<=M; i++)
                     for (h[i]=0, j=0; j<=M; j++)
                            if (j == i)
                                   P[i][j] = 1 / delta;
                            else
                                   P[i][j] = 0;
              *init = 1;
              }

       for (i=0; i<=M; i++)
              for (k0[i]=0, j=0; j<=M; j++)
                     k0[i] += P[i][j] * y[j] / lambda;

       for (nu=0, i=0; i<=M; i++)
              nu += k0[i] * y[i];

       mu = 1 / (1 + nu);

       for (i=0; i<=M; i++)
              k1[i] = mu * k0[i];

       for (i=0; i<=M; i++)
             for (j=0; j<=i; j++) {
                   P[i][j] = P[i][j] / lambda - k1[i] * k0[j];
                   P[j][i] = P[i][j];
                   }

       for (xhat0=0, i=0; i<=M; i++)
              xhat0 += h[i] * y[i];

       e0 = x - xhat0;
       *e = mu * e0;
       *xhat = x - *e;

      for (i=0; i<=M; i++)
              h[i] += e0 * k1[i];
}
