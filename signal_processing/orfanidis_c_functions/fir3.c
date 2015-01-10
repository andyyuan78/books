/* fir3.c - FIR filter emulating a DSP chip */

double fir3(M, h, w, x)
double *h, *w, x;
int M;
{                        
       int i;
       double y;

       w[0] = x;                                 /* read input */

       for (y=h[M]*w[M], i=M-1; i>=0; i--) {
              w[i+1] = w[i];                     /* data shift instruction */
              y += h[i] * w[i];                  /* MAC instruction */
              }

       return y;
}
