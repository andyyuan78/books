/* wavgeni.c - wavetable generator (interpolation method) */

void gdelay2();

double wavgeni(D, w, A, F, q)      /* usage: y = wavgeni(D, w, A, F, &q); */
int D;                             /* \(D\) = wavetable length */
double *w, A, F, *q;               /* \(A\) = amplitude, \(F\) = frequency, \(q\) = offset index */
{
       double y;
       int i, j;

       i = (int) *q;                        /* interpolate between \(w[i], w[j]\) */
       j = (i + 1) % D;                     

       y = A * (w[i] + (*q - i) * (w[j] - w[i]));

       gdelay2(D-1, D*F, q);                     /* shift  \(c = DF\) */

       return y;
}
