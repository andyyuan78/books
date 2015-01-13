/*  abs2db.c - absolute units to decibels  */

#include <math.h>

void abs2db(NF, AF)
double AF[];
int NF;
{      
       int i;

       for (i=0; i<NF; i++)
              AF[i] = 10 * log10(AF[i]);
}
