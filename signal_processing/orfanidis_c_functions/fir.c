/* fir.c - FIR filter in direct form */

double fir(M, h, w, x)                       /* Usage: y = fir(M, h, w, x); */
double *h, *w, x;                            /* \(h\) = filter, \(w\) = state, \(x\) = input sample */
int M;                                       /* \(M\) = filter order */
{                        
       int i;
       double y;                             /* output sample */

       w[0] = x;                             /* read current input sample \(x\) */

       for (y=0, i=0; i<=M; i++)
              y += h[i] * w[i];              /* compute current output sample \(y\) */

       for (i=M; i>=1; i--)                  /* update states for next call */
              w[i] = w[i-1];                 /* done in reverse order */

       return y;
}
