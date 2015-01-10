/* modwrap.c - modulo-N wrapping of length-L signal */

void modwrap(L, x, N, xtilde)                /* usage: modwrap(L, x, N, xtilde); */
int L, N;                                    /* \(x\) is \(L\)-dimensional */
double *x, *xtilde;                          /* xtilde is \(N\)-dimensional */
{
    int n, r, m, M;

    r = L % N;                               /* remainder \(r=0,1,\dotsc,N-1\) */
    M = (L-r) / N;                           /* quotient of division \(L/N\) */

    for (n=0; n<N; n++) {
         if (n < r)                          /* non-zero part of last block */
             xtilde[n] = x[M*N+n];           /* if \(L<N\), this is the only block */
         else
             xtilde[n] = 0;                  /* if \(L<N\), pad \(N-L\) zeros at end */

         for (m=M-1; m>=0; m--)              /* remaining blocks */
              xtilde[n] += x[m*N+n];         /* if \(L<N\), this loop is skipped */
         }
}
