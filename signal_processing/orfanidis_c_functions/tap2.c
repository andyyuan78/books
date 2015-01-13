/* tap2.c - i-th tap of circular delay-line buffer */

double tap2(D, w, q, i)                   /* usage: si = tap2(D, w, q, i); */
double *w;
int D, q, i;                              /* \(i=0,1,\dotsc,D\) */
{
       return w[(q + i) % (D + 1)];
}
