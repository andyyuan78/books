/* ran1f.c - 1/f random number generator */

double ranh();                              /* random hold periodic generator */

double ran1f(B, u, q, iseed)                /* usage: y = ran1f(B, u, q, &iseed); */
int B, *q;                                  /* \(q, u\) are \(B\)-dimensional */
double *u;
long *iseed;                                /* passed by address */
{
    double y;
    int b;

    for(y=0, b=0; b<B; b++)
          y += ranh(1<<b, u+b, q+b, iseed);         /* period = (1<<b) = 2\(\sp{b}\) */

    return y / B;
}
