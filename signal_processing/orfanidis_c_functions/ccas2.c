/* ccas2.c - circular buffer implementation of cascade realization */

double csos2();                      /* circular-buffer version of single SOS */

double ccas2(K, A, B, W, Q, x)
int K, *Q;                           /* \(Q\) = array of circular pointer offsets */
double **A, **B, **W, x;       
{
       int i;
       double y;

       y = x;

       for (i=0; i<K; i++)
              y = csos2(A[i], B[i], W[i], Q+i, y);       /* note, \(Q+i\) = &\(Q[i]\) */

       return y;
}
