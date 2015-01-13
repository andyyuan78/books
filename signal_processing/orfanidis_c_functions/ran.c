/* ran.c - uniform random number generator in [0, 1) */

#define  a    16807                              /* that is, \(a = 7\sp{5}\) */
#define  m    2147483647                         /* that is, \(m = 2\sp{31}-1\) */
#define  q    127773                             /* note, \(q = m/a\) = quotient */
#define  r    2836                               /* note, \(r = m\%a\) = remainder */

double ran(iseed)                                /* usage: u = ran(&iseed); */
long *iseed;                                     /* iseed passed by address */
{
    *iseed = a * (*iseed % q) - r * (*iseed / q);          /* update seed */

    if (*iseed < 0)                              /* wrap to positive values */
           *iseed += m;

    return (double) *iseed / (double) m;
}
