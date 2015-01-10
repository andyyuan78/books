/* wavgen.c - wavetable generator (truncation method) */

void gdelay2();

double wavgen(D, w, A, F, q)        /* usage: y = wavgen(D, w, A, F, &q); */
int D;                              /* \(D\) = wavetable length */
double *w, A, F, *q;                /* \(A\) = amplitude, \(F\) = frequency, \(q\) = offset index */
{
       double y;
       int i;

       i = (int) (*q);                             /* truncate down */

       y = A * w[i];

       gdelay2(D-1, D*F, q);                       /* shift  \(c = DF\) */

       return y;
}
