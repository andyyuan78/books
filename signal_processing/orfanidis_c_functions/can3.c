/* can3.c - IIR filtering in canonical form, emulating a DSP chip */

double can3(M, a, b, w, x)                /* usage: y = can3(M, a, b, w, x); */
double *a, *b, *w, x;                     /* \(w\) = internal state vector */
int M;                                    /* \(a,b\) have common order \(M\) */
{
       int i;
       double y;

       w[0] = x;                                 /* read input sample */

       for (i=1; i<=M; i++)                      /* forward order */
              w[0] -= a[i] * w[i];               /* MAC instruction */

       y = b[M] * w[M];

       for (i=M-1; i>=0; i--) {                  /* backward order */
              w[i+1] = w[i];                     /* data shift instruction */
              y += b[i] * w[i];                  /* MAC instruction */
              }

       return y;                                 /* output sample */
}
