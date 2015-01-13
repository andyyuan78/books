/* sine.c - sine wavetable of length D */

#include <math.h>

double sine(D, i)
int D, i;
{
       double pi = 4 * atan(1.0);

       return sin(2 * pi * i / D);
}
