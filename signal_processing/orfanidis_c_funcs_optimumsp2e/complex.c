/*  complex.c - complex arithmetic functions  */

#include <math.h>

typedef struct complex complex;

complex cmplx(x, y)
double x, y;
{
       complex z;

       z.x = x;
       z.y = y;

       return z;
}

complex conjg(z)
complex z;
{
       return cmplx(z.x, -z.y);
}

complex cadd(a, b)
complex a, b;
{
       return cmplx(a.x + b.x, a.y + b.y);
}

complex csub(a, b)
complex a, b;
{
       return cmplx(a.x - b.x, a.y - b.y);
}

complex cmul(a, b)
complex a, b;
{
       return cmplx(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

complex rmul(a, z)
double a;
complex z;
{
       return cmplx(a * z.x, a * z.y);
}

complex cdiv(a, b)
complex a, b;
{
   double D = b.x * b.x + b.y * b.y;

   return cmplx((a.x * b.x + a.y * b.y) / D, (a.y * b.x - a.x * b.y) / D);
}

complex rdiv(z, a)
complex z;
double a;
{
       return cmplx(z.x / a, z.y / a);
}

double real(z)
complex z;
{
       return z.x;
}

double aimag(z)
complex z;
{
       return z.y;
}

complex cexp(z)
complex z;
{
       double R = exp(z.x);

       return cmplx(R * cos(z.y), R * sin(z.y));
}
