/* can2.c - IIR filtering in canonical form */

double dot();
void delay();

double can2(M, a, L, b, w, x)             /* usage: y = can2(M, a, L, b, w, x); */
double *a, *b, *w, x;
int M, L;
{
       int K;
       double y;

       K = (L <= M) ? M : L;                     /* \(K=\max(M,L)\) */

       w[0] = 0;                                 /* needed for dot(M,a,w) */

       w[0] = x - dot(M, a, w);                  /* input adder */

       y = dot(L, b, w);                         /* output adder */

       delay(K, w);                              /* update delay line */

       return y;                                 /* current output sample */
}
