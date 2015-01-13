/* wavgenr.c - wavetable generator (rounding method) */

void gdelay2();

double wavgenr(D, w, A, F, q)       /* usage: y = wavgenr(D, w, A, F, &q); */
int D;                              /* \(D\) = wavetable length */
double *w, A, F, *q;                /* \(A\) = amplitude, \(F\) = frequency, \(q\) = offset index */
{
       double y;
       int k;

       k = (int) (*q + 0.5);                     /* round */

       y = A * w[k];

       gdelay2(D-1, D*F, q);                     /* shift  \(c = DF\) */

       return y;
}
