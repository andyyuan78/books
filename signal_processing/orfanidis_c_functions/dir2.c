/* dir2.c - IIR filtering in direct form */

double dot();
void delay();

double dir2(M, a, L, b, w, v, x)          /* usage: y = dir2(M, a, L, b, w, v, x); */
double *a, *b, *w, *v, x;
int M, L;
{
       v[0] = x;                                 /* current input sample */
       w[0] = 0;                                 /* needed for dot(M,a,w) */

       w[0] = dot(L, b, v) - dot(M, a, w);       /* current output */

       delay(L, v);                              /* update input delay line */

       delay(M, w);                              /* update output delay line */

       return w[0];
}
