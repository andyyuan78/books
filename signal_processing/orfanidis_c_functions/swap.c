/*  swap.c  --  swap two complex numbers (by their addresses)  */

#include <cmplx.h>

void swap(a,b)
complex *a, *b;
{
       complex t;

        t = *a;
       *a = *b;
       *b =  t;
}
