/* dir.c - IIR filtering in direct form */

double dir(M, a, L, b, w, v, x)           /* usage: y = dir(M, a, L, b, w, v, x); */
double *a, *b, *w, *v, x;                 /* \(v,w\) are internal states */
int M, L;                                 /* denominator and numerator orders */
{
       int i;

       v[0] = x;                          /* current input sample */
       w[0] = 0;                          /* current output to be computed */

       for (i=0; i<=L; i++)               /* numerator part */
              w[0] += b[i] * v[i];

       for (i=1; i<=M; i++)               /* denominator part */
              w[0] -= a[i] * w[i];

       for (i=L; i>=1; i--)               /* reverse-order updating of \(v\) */
              v[i] = v[i-1];

       for (i=M; i>=1; i--)               /* reverse-order updating of \(w\) */
              w[i] = w[i-1];

       return w[0];                       /* current output sample */
}
