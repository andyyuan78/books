double ran();

double gran(mean, sigma, iseed)
double mean, sigma;
long *iseed;
{
       double u = 0;
       int i;

       for (i = 0; i < 12; i++)
           u += ran(iseed);

       return sigma * (u - 6) + mean;
}
