/*  lattice.c - lattice filter  */

void section();

void lattice(M, gamma, w, xa, xb, ya, yb)
double gamma[], w[], xa, xb, *ya, *yb;
int M;
{
       int i;

       for (i=0; i<M; i++) {
              section(gamma[i], w+i, xa, xb, ya, yb);
              xa = *ya;
              xb = *yb;
              }
}
