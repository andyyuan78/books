/*  glwf.c - gradient Lattice Wiener filter  */

#define MAX   50

void glwf(M, g, gamma, x, y, xhat, e, lambda, beta, init)
double g[], gamma[], x, y, *xhat, *e, lambda, beta;
int M, *init;
{
       int p;
       static double w[MAX], db[MAX+1], d[MAX];
       double ea[MAX+1], eb[MAX+1];
 
       if (*init == 0) {
              for (p=1; p<=M; p++) {
                     w[p-1] = 0;
                     g[p] = 0;
                     gamma[p-1] = 0;
                     d[p-1] = 0;
                     db[p] = 0;
                     }
              g[0] = 0;
              db[0] = 0;
              }
 
       ea[0] = y;
       eb[0] = y;
       *xhat = g[0] * eb[0];
       *e = x - *xhat;
 
       db[0] = lambda * db[0] + eb[0] * eb[0];
       g[0] += beta * *e * eb[0] / db[0];
 
       for (p=1; p<=M; p++) {
             ea[p] = ea[p-1] - gamma[p-1] * w[p-1];
             eb[p] = w[p-1] - gamma[p-1] * ea[p-1];
 
             d[p-1] = lambda * d[p-1] + ea[p-1] * ea[p-1] + w[p-1] * w[p-1];

             gamma[p-1] += beta * (ea[p] * w[p-1] + eb[p] * ea[p-1]) / d[p-1];
 
             *xhat += g[p] * eb[p];
             *e -= g[p] * eb[p];
 
             db[p] = lambda * db[p] + eb[p] * eb[p];

             if (p <= *init)
                   g[p] += beta * *e * eb[p] / db[p];
 
             w[p-1] = eb[p-1];
             }
 
       (*init)++;
}

