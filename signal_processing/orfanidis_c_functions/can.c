/* can.c - IIR filtering in canonical form */

double can(M, a, L, b, w, x)              /* usage: y = can(M, a, L, b, w, x); */
double *a, *b, *w, x;                     /* \(w\) = internal state vector */
int M, L;                                 /* denominator and numerator orders */
{
       int K, i;
       double y = 0;

       K = (L <= M) ? M : L;              /* \(K=\max(M,L)\) */

       w[0] = x;                          /* current input sample */

       for (i=1; i<=M; i++)               /* input adder */
              w[0] -= a[i] * w[i];

       for (i=0; i<=L; i++)               /* output adder */
              y += b[i] * w[i];

       for (i=K; i>=1; i--)               /* reverse updating of \(w\) */
              w[i] = w[i-1];

       return y;                          /* current output sample */
}
