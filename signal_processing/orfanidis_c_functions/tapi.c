/* tapi.c - interpolated tap output of a delay line */

double tap();

double tapi(D, w, p, d)                   /* usage: sd = tapi(D, w, p, d); */
double *w, *p, d;                         /* \(d\) = desired non-integer delay */
int D;                                    /* \(p\) = circular pointer to \(w\) */
{
       int i, j;
       double si, sj;

       i = (int) d;                       /* interpolate between \(s\sb{i}\) and \(s\sb{j}\) */
       j = (i+1) % (D+1);                 /* if \(i=D\), then \(j=0\); otherwise, \(j=i+1\) */

       si = tap(D, w, p, i);              /* note, \(s\sb{i}(n) = x(n-i)\) */
       sj = tap(D, w, p, j);              /* note, \(s\sb{j}(n) = x(n-j)\) */

       return si + (d - i) * (sj - si);
}
