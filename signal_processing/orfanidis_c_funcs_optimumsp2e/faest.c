/*  faest.c - FAEST algorithm  */

#define MAX   50
#define delta  0.01

void faest(M, h, x, y, xhat, e, lambda, init)
double h[], x, y, *xhat, *e, lambda;
int M, *init;
{
       static double w[MAX+1], a[MAX+1], b[MAX+1], ktilde[MAX];
       static double D1a, D1b, nutilde;
       double k[MAX+1], kbar[MAX], nu, nubar;
       double e0a, e0b, e1a, e1b, D0a, D0b, e0, xhat0;
       int i;

       if (*init == 0) {
              for (i=1; i<=M; i++) {
                    h[i] = 0;
                    a[i] = 0;
                    b[i-1] = 0;
                    w[i] = 0;
                    ktilde[i-1] = 0;
                    }
              D1a = delta;
              D1b = delta;
              nutilde = 0;
              h[0] = 0;
              a[0] = 1;
              b[M] = 1;
              *init = 1;
              }
 
       w[0] = y;
 
       for (e0a=0, i=0; i<=M; i++)
              e0a += a[i] * w[i];
 
       e1a = e0a / (1 + nutilde);
       D0a = lambda * D1a;
       k[0] = e0a / D0a;
       D1a =  D0a + e1a * e0a;
 
       for (i=1; i<=M; i++)
              k[i] = ktilde[i-1] + k[0] * a[i];
 
       D0b = lambda * D1b;
       e0b = k[M] *  D0b;
 
       for (i=0; i<M; i++)
              kbar[i] = k[i] - k[M] * b[i];
 
       nu = nutilde + e0a * k[0];
       nubar = nu - e0b * k[M];
 
       e1b = e0b / (1 + nubar);
       D1b =  D0b + e1b * e0b;

       for (i=1; i<=M; i++)
              a[i] -= e1a * ktilde[i-1];
 
       for (i=0; i<M; i++)
              b[i] -= e1b * kbar[i];
 
       for (xhat0=0, i=0; i<=M; i++)
              xhat0 += h[i] * w[i];
 
       e0 = x - xhat0;
       *e = e0 / (1 + nu);
       *xhat = x - *e;
 
       for (i=0; i<=M; i++)
              h[i] += *e * k[i];
 
       for (i=1; i<=M; i++)
              ktilde[i-1] = kbar[i-1];
 
       nutilde = nubar;
 
       for (i=M; i>=1; i--)
              w[i] = w[i-1];
}
