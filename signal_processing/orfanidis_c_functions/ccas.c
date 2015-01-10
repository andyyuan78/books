/* ccas.c - circular buffer implementation of cascade realization */

double csos();                          /* circular-buffer version of single SOS */

double ccas(K, A, B, W, P, x)
int K;
double **A, **B, **W, **P, x;           /* \(P\) = array of circular pointers */
{
       int i;
       double y;

       y = x;

       for (i=0; i<K; i++)
              y = csos(A[i], B[i], W[i], P+i, y);        /* note, \(P+i\) = &\(P[i]\) */

       return y;
}
