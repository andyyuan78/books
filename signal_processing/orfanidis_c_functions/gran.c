/* gran.c - gaussian random number generator */

double ran();                            /* uniform generator */

double gran(m, s, iseed)                 /* usage: x = gran(m, s, &iseed); */
double m, s;                             /* \(m\) = mean, \(s\sp{2}\) = variance */
long *iseed;                             /* iseed passed by address */
{
       double v = 0;
       int i;

       for (i = 0; i < 12; i++)          /* sum 12 uniform random numbers */
              v += ran(iseed);

       return s * (v - 6) + m;           /* adjust mean and variance */
}
