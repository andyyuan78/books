/*  db2abs.c - decibels to absolute units  */

#include <math.h>

void db2abs(NF, AF)
double AF[];
int NF;
{      
       int i;

       for (i=0; i<NF; i++)
              AF[i] = pow(10., AF[i] / 10);
}

