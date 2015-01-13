/* dac.c - bipolar two's complement D/A converter */

double dac(b, B, R)
int *b, B;                         /* bits are dimensioned as \(b[0], b[1], \dotsc, b[B-1]\) */
double R;
{
       int i;
       double dac = 0;

       b[0] = 1 - b[0];                          /* complement MSB */

       for (i = B-1; i >= 0; i--)                /* H\"orner's rule */
          dac = 0.5 * (dac + b[i]);

       dac = R * (dac - 0.5);                    /* shift and scale */

       b[0] = 1 - b[0];                          /* restore MSB */

       return dac;
}
