/* ranh.c - hold random number generator of period D */

double ran();                             /* uniform generator */
void cdelay2();                           /* circular delay */

double ranh(D, u, q, iseed)               /* usage: y = ranh(D, u, &q, &iseed); */
int D, *q;                                /* \(q\) is cycled modulo-\(D\) */
double *u;                                /* \(u\) = 1-dimensional array */
long *iseed;                              /* \(q\), iseed are passed by address */
{
       double y;

       y = u[0];                              /* hold sample for \(D\) calls */

       cdelay2(D-1, q);                       /* decrement \(q\) and wrap mod-\(D\) */

       if (*q == 0)                           /* every \(D\) calls, */
              u[0] = ran(iseed) - 0.5;        /* get new \(u[0]\) (zero mean) */

       return y;
}
