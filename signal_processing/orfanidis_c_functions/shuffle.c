/* shuffle.c - in-place shuffling (bit-reversal) of a complex array */

#include <cmplx.h>

void swap();
int bitrev();

void shuffle(N, X)
complex *X;
int N;                                    /* \(N\) must be a power of 2 */
{
       int n, r, B=1;

       while ( (N >> B) > 0 )             /* \(B\) = number of bits */
              B++;

       B--;                               /* \(N = 2\sp{B}\) */

       for (n = 0; n < N; n++) {
           r = bitrev(n, B);              /* bit-reversed version of \(n\) */
           if (r < n) continue;           /* swap only half of the \(n\)s */
           swap(X+n, X+r);                /* swap by addresses */
           }
}
