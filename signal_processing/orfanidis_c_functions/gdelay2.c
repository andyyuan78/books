/* gdelay2.c - generalized circular delay with real-valued shift */

void gdelay2(D, c, q)
int D;
double c, *q;                             /* \(c\)=shift, \(q\)=offset index */
{
       *q -= c;                           /* decrement by \(c\) */

       if (*q < 0)  
              *q += D+1;

       if (*q > D)
              *q -= D+1;
}
