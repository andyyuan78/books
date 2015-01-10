/* plain.c - plain reverberator with circular delay line */

double tap();
void cdelay();

double plain(D, w, p, a, x)                     /* usage: y=plain(D,w,&p,a,x); */
double *w, **p, a, x;                           /* \(p\) is passed by address */
int D;
{
       double y, sD;

       sD = tap(D, w, *p, D);                   /* \(D\)th tap delay output */
       y = x + a * sD;                          /* filter output */
       **p = y;                                 /* delay input */
       cdelay(D, w, p);                         /* update delay line */

       return y;
}
