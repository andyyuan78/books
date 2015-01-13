/*  select.c - select eigenvector  */

#include <math.h>
#include <complex.h>

#define MAX   10

void select(M, E, i, a)
complex E[][MAX+1], a[];
int M, i;
{
       int j;

       for (j=0; j<=M; j++)
              a[j] = E[j][i];
}
