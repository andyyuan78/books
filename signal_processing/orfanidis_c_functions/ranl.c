/* ranl.c - linearly interpolated random generator of period D */

double ran();                             /* uniform generator */
void cdelay2();                           /* circular delay */

double ranl(D, u, q, iseed)               /* usage: y = ranl(D, u, &q, &iseed); */
int D, *q;                                /* \(q\) is cycled modulo-\(D\) */
double *u;                                /* \(u\) = 2-dimensional array */
long *iseed;                              /* \(q\), iseed are passed by address */
{
       double y;
       int i;

       i = (D - *q) % D;                      /* interpolation index */

       y = u[0] + (u[1] - u[0]) * i / D;      /* linear interpolation */

       cdelay2(D-1, q);                       /* decrement \(q\) and wrap mod-\(D\) */

       if (*q == 0) {                         /* every \(D\) calls, */
              u[0] = u[1];                    /* set new \(u[0]\) and */
              u[1] = ran(iseed) - 0.5;        /* get new \(u[1]\) (zero mean) */
              }

       return y;
}
