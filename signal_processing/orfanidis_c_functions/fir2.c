/* fir2.c - FIR filter in direct form */

double dot();
void delay();

double fir2(M, h, w, x)                       /* Usage: y = fir2(M, h, w, x); */
double *h, *w, x;                             /* \(h\) = filter, \(w\) = state, \(x\) = input */
int M;                                        /* \(M\) = filter order */
{                        
       double y;

       w[0] = x;                              /* read input */

       y = dot(M, h, w);                      /* compute output */

       delay(M, w);                           /* update states */

       return y;
}
