/* delay.c - delay by D time samples */

void delay(D, w)                          /* \(w[0]\) = input, \(w[D]\) = output */
int D;
double *w;
{
       int i;

       for (i=D; i>=1; i--)               /* reverse-order updating */
              w[i] = w[i-1];

}
