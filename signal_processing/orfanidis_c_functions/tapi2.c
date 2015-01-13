/* tapi2.c - interpolated tap output of a delay line */

double tap2();

double tapi2(D, w, q, d)                  /* usage: sd = tapi2(D, w, q, d); */
double *w, d;                             /* \(d\) = desired non-integer delay */
int D, q;                                 /* \(q\) = circular offset index */
{
       int i, j;
       double si, sj;

       i = (int) d;                       /* interpolate between \(s\sb{i}\) and \(s\sb{j}\) */
       j = (i+1) % (D+1);                 /* if \(i=D\), then \(j=0\); otherwise, \(j=i+1\) */

       si = tap2(D, w, q, i);             /* note, \(s\sb{i}(n) = x(n-i)\) */
       sj = tap2(D, w, q, j);             /* note, \(s\sb{j}(n) = x(n-j)\) */

       return si + (d - i) * (sj - si);
}
