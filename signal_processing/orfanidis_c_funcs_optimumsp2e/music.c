/*  music.c - MUSIC spectrum  */

#include <math.h>
#include <complex.h>

#define MAX   10

void music(M, E, K, NF, S, AF, a)
complex E[][MAX+1], a[];
double S[], AF[];
int M, K, NF;
{
       int i, j;

       for (j=0; j<NF; j++)
              S[j] = 0;

       for (i=0; i<K; i++) {
              select(M, E, i, a);
              fresp(M, a, NF, AF);
              for (j=0; j<NF; j++)
                     S[j] += AF[j] / K;
              }

       invresp(NF, S);
}
