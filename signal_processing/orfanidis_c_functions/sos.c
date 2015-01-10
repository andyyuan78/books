/* sos.c - IIR filtering by single second order section */

double sos(a, b, w, x)                    /* \(a, b, w\) are 3-dimensional */
double *a, *b, *w, x;                     /* \(a[0]=1\) always */
{
       double y;

       w[0] = x - a[1] * w[1] - a[2] * w[2];
       y = b[0] * w[0] + b[1] * w[1] + b[2] * w[2];

       w[2] = w[1];
       w[1] = w[0];

       return y;
}
