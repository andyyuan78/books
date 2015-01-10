/* cmplx.h - complex arithmetic declarations */

#include <math.h>                         /* in MSC and TC/BC, it declarares: */
                                          /* \ttt{struct complex} and \ttt{cabs(z)} */

/* struct complex{double x, y;}; */       /* uncomment if neccessary */
/* double cabs(struct complex); */        /* uncomment if neccesary */

typedef struct complex complex;

complex cmplx(double, double);            /* define complex number */
complex conjg(complex);                   /* complex conjugate */

complex cadd(complex, complex);           /* complex addition */
complex csub(complex, complex);           /* complex subtraction */
complex cmul(complex, complex);           /* complex multiplication */
complex cdiv(complex, complex);           /* complex division */

complex rmul(double, complex);            /* multiplication by real */
complex rdiv(complex, double);            /* division by real */

double real(complex);                     /* real part */
double aimag(complex);                    /* imaginary part */

complex cexp(complex);                    /* complex exponential */
