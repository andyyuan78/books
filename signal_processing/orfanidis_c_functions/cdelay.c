/* cdelay.c - circular buffer implementation of D-fold delay */

void wrap();

void cdelay(D, w, p)
int D;
double *w, **p;
{
       (*p)--;                      /* decrement pointer and wrap modulo-\((D+1)\) */
       wrap(D, w, p);               /* when \(*p=w-1\), it wraps around to \(*p=w+D\) */
}
