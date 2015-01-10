/* cas.c - IIR filtering in cascade of second-order sections */

double sos();                                    /* single second-order section */

double cas(K, A, B, W, x)
int K;
double **A, **B, **W, x;                         /* \(A,B,W\) are \(Kx3\) matrices */
{
       int i;
       double y;

       y = x;                                    /* initial input to first SOS */

       for (i=0; i<K; i++)
              y = sos(A[i], B[i], W[i], y);      /* output of \(i\)th section */

       return y;                                 /* final output from last SOS */
}
