/* cheby.c - Chebyshev polynomial \(C\sb{N}(x)\) */

#include <math.h>

double cheby(N, x)                               /* usage: y = cheby(N, x); */
int N;                                           /* \(N\) = polynomial order */
double x;                                        /* \(x\) must be non-negative */
{
       if (x <= 1)
              return cos(N * acos(x));
       else
              return cosh(N * log(x + sqrt(x*x-1)));
}
