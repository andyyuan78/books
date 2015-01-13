/*  sigav.c - signal averaging  */

#include <stdio.h>

void sigav(M, N, fp, x)
int M, N;
FILE *fp;
double x[];
{
       int i, j;
       double y;

       for (j=0; j<M; j++)
              for (i=0; i<N; i++) {
                     fscanf(fp, "%lf", &y);
                     x[i] += y / M;
              }
}
