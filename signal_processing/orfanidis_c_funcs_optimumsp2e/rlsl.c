/*  rlsl.c - double/direct RLS lattice  */

#define MAX   50

void rlsl(M, g, ga, gb, x, y, xhat, e, lambda, init)
double g[], ga[], gb[], x, y, *xhat, *e, lambda;
int M, *init;
{
       double e0a[MAX+1], e0b[MAX+1], e1a[MAX+1], e1b[MAX+1], D1b[MAX+1], e0;
       static double w0[MAX], w1[MAX], D1a[MAX+1], D[MAX+1];
       int p;

       if (*init == 0) {
              for (p=1; p<=M; p++) {
                     w0[p-1] = 0;
                     w1[p-1] = 0;
                     ga[p-1] = 0;
                     gb[p-1] = 0;
                     D1a[p] = 0;
                     D[p] = 0;
                     g[p] = 0;
                     }
              D1a[0] = 0;
              D[0] = 0;
              g[0] = 0;
              }
 
       e0b[0] = y;
       e0a[0] = y;
       e1b[0] = y;
       e1a[0] = y;
 
       D1a[0] = lambda * D1a[0] + e1a[0] * e0a[0];
       D1b[0] = lambda * D[0] + e1b[0] * e0b[0];
 
       e0 = x - g[0] * e0b[0];
       g[0] += e0 * e1b[0] / D1b[0];
       *xhat = g[0] * e1b[0];
       *e = x - *xhat;
 
       for (p=1; p<=M; p++) {
              e0a[p] = e0a[p-1] - gb[p-1] * w0[p-1];
              e0b[p] = w0[p-1] - ga[p-1] * e0a[p-1];
 
              if (p <= *init) {
                     ga[p-1] += e0b[p] * e1a[p-1] / D1a[p-1];
                     gb[p-1] += e0a[p] * w1[p-1] / D[p-1];
                     }
 
              e1a[p] = e1a[p-1] - gb[p-1] * w1[p-1];
              e1b[p] = w1[p-1] - ga[p-1] * e1a[p-1];
 
              D1a[p] = lambda * D1a[p] + e1a[p] * e0a[p];
              D1b[p] = lambda * D[p] + e1b[p] * e0b[p];
 
              w0[p-1] = e0b[p-1];
              w1[p-1] = e1b[p-1];
              D[p] = D1b[p];
 
              e0 -= g[p] * e0b[p];

              if (p <= *init)
                     g[p] += e0 * e1b[p] / D1b[p];

              *e -= g[p] * e1b[p];
              *xhat += g[p] * e1b[p];
              }
 
       D[0] = D1b[0];
 
       (*init)++;
}
