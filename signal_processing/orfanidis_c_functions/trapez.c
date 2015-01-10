/* trapez.c - trapezoidal wavetable: D1 rising, D2 steady */

double trapez(D, D1, D2, i)
int D, D1, D2, i;
{
       if (i < D1)
              return i/(double) D1;
       else
            if (i < D1+D2)
                 return 1;
            else
                 return (D - i)/(double) (D - D1 - D2);
}
