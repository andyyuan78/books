/* csos.c - circular buffer implementation of a single SOS */

void wrap();

double csos(a, b, w, p, x)                      /* \(a,b,w\) are 3-dimensional */
double *a, *b, *w, **p, x;                      /* \(p\) is circular pointer to \(w\) */
{
       double y, s0;

       *(*p) = x;                               /* read input sample \(x\) */

       s0  = *(*p)++;           wrap(2, w, p);
       s0 -= a[1] * (*(*p)++);  wrap(2, w, p);
       s0 -= a[2] * (*(*p)++);  wrap(2, w, p);

       *(*p) = s0;                              /* \(p\) has wrapped around once */

       y  = b[0] * (*(*p)++);  wrap(2, w, p);
       y += b[1] * (*(*p)++);  wrap(2, w, p);
       y += b[2] * (*(*p));                     /* \(p\) now points to \(s\sb{2}\) */

       return y;
}
