/*  gauss.c - generates an array of gaussian random numbers  */

double gran();

void gauss(N, x, mean, sigma, iseed)
double x[], mean, sigma;
int N;
long *iseed;
{
       int i;

       for (i=0; i<N; i++)
              x[i] = gran(mean, sigma, iseed);
}
