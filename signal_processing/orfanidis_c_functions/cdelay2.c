/* cdelay2.c - circular buffer implementation of D-fold delay */

void wrap2();

void cdelay2(D, q)
int D, *q;
{
       (*q)--;                      /* decrement offset and wrap modulo-\((D+1)\) */
       wrap2(D, q);                 /* when \(*q=-1\), it wraps around to \(*q=D\) */
}
