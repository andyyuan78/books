/* csos2.c - circular buffer implementation of a single SOS */

void wrap2();

double csos2(a, b, w, q, x)
double *a, *b, *w, x;                   /* \(a,b,w\) are 3-dimensional arrays */
int *q;                                 /* \(q\) is circular offset relative to \(w\) */
{
       double y;

       w[*q] = x - a[1] * w[(*q+1)%3] - a[2] * w[(*q+2)%3];

       y = b[0] * w[*q] + b[1] * w[(*q+1)%3] + b[2] * w[(*q+2)%3];

       (*q)--;  
       wrap2(2, q);

       return y;
}
