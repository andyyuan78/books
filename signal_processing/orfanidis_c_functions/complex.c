/* complex.c - complex arithmetic functions */

#include <math.h>                         /* for MSC and TC/BC, it declares: */
                                          /* \ttt{struct complex} and \ttt{cabs()} */
/* struct complex {double x, y;}; */      /* uncomment if not MSC or TC/BC */

                                          /* uncomment if not MS or TC/BC */
/*  double cabs(z)
 *  complex z;
 *  {
 *      return sqrt(z.x * z.x + z.y * z.y);
 *  }
*/


typedef struct complex complex;

complex cmplx(x, y)                              /* z = cmplx(x,y) = x+jy */
double x, y;
{
       complex z;

       z.x = x;  z.y = y;

       return z;
}

complex conjg(z)                                 /* complex conjugate of z=x+jy */
complex z;
{
       return cmplx(z.x, -z.y);                  /* returns z* = x-jy */
}

complex cadd(a, b)                               /* complex addition */
complex a, b;
{
       return cmplx(a.x + b.x, a.y + b.y);
}

complex csub(a, b)                               /* complex subtraction */
complex a, b;
{
       return cmplx(a.x - b.x, a.y - b.y);
}

complex cmul(a, b)                               /* complex multiplication */
complex a, b;
{
       return cmplx(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

complex rmul(a, z)                               /* multiplication by real */
double a;
complex z;
{
       return cmplx(a * z.x, a * z.y);
}

complex cdiv(a, b)                               /* complex division */
complex a, b;
{
   double D = b.x * b.x + b.y * b.y;

   return cmplx((a.x * b.x + a.y * b.y) / D, (a.y * b.x - a.x * b.y) / D);
}

complex rdiv(z, a)                               /* division by real */
complex z;
double a;
{
       return cmplx(z.x / a, z.y / a);
}

double real(z)                                   /* real part Re(z) */
complex z;
{
       return z.x;
}

double aimag(z)                                  /* imaginary part Im(z) */
complex z;
{
       return z.y;
}

complex cexp(z)                                  /* complex exponential */
complex z;
{
       double R = exp(z.x);

       return cmplx(R * cos(z.y), R * sin(z.y));
}
