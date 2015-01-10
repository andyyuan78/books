/* I0.c - Modified Bessel Function I0(x)
 *
 * I0(x) = \sum_{k=0}^{\infty}[(x/2)^k / k!]^2
 *
*/

#include <math.h>

#define eps   (1.E-9)                     /* \(\ep=10\sp{-9}\) */

double I0(x)                              /* usage: y = I0(x) */
double x;
{
       int n = 1;
       double S = 1, D = 1, T;

       while (D > eps * S) {
              T = x / (2 * n++);
              D *= T * T;
              S += D;
              }

       return S;
}
