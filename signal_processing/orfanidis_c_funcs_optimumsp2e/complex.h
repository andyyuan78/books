/*  complex.h  --  complex arithmetic declarations
 *
 *  math.h contains the declarations for
 *  struct complex { double x, y; }; and
 *  cabs(z) = sqrt(z.x * z.x + z.y * z.y);
 */

typedef struct complex complex;

complex cmplx(double, double);
complex conjg(complex);

complex cadd(complex, complex);
complex csub(complex, complex);
complex cmul(complex, complex);
complex rmul(double, complex);
complex cdiv(complex, complex);
complex rdiv(complex, double);

double real(complex);
double aimag(complex);

complex cexp(complex);
