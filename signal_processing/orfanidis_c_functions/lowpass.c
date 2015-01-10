/* lowpass.c - lowpass reverberator with feedback filter G(z) */

double tap(), can();
void cdelay();

double lowpass(D, w, p, M, a, b, v, x)
double *w, **p, *a, *b, *v, x;                   /* \(v\) = state vector for \(G(z)\) */
int D;                                           /* \(a,b,v\) are \((M+1)\)-dimensional */
{
       double y, sD;

       sD = tap(D, w, *p, D);                    /* delay output is \(G(z)\) input */
       y = x + can(M, a, M, b, v, sD);           /* reverb output */
       **p = y;                                  /* delay input */
       cdelay(D, w, p);                          /* update delay line */

       return y;
}
