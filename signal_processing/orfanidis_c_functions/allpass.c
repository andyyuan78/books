/* allpass.c - allpass reverberator with circular delay line */

double tap();
void cdelay();

double allpass(D, w, p, a, x)                   /* usage: y=allpass(D,w,&p,a,x); */
double *w, **p, a, x;                           /* \(p\) is passed by address */
int D;
{
       double y, s0, sD;

       sD = tap(D, w, *p, D);                   /* \(D\)th tap delay output */
       s0 = x + a * sD;
       y  = -a * s0 + sD;                       /* filter output */
       **p = s0;                                /* delay input */
       cdelay(D, w, p);                         /* update delay line */

       return y;
}
