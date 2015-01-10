/* adc.c - successive approximation A/D converter */

#include <math.h>

double dac();
int u();

void adc(x, b, B, R)
double x, R;
int *b, B;
{
       int i;
       double y, xQ, Q;

       Q = R / pow(2, B);                        /* quantization width \(Q=R/2\sp{B}\) */
       y = x + Q/2;                              /* rounding */

       for (i = 0; i < B; i++)                   /* initialize bit vector */
              b[i] = 0;

       b[0] = 1 - u(y);                          /* determine MSB */

       for (i = 1; i < B; i++) {                 /* loop starts with \(i=1\) */
              b[i] = 1;                          /* turn \(i\)th bit ON */
              xQ = dac(b, B, R);                 /* compute DAC output */
              b[i] = u(y-xQ);                    /* test and correct bit */
              }
}
