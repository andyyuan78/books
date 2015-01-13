/*  sampcov.c - recursive updating of sample covariance matrix  */

#define MAX   10

void sampcov(M, R, y, N)
double R[][MAX+1], y[];
int M, N;
{
       int i, j;

       for (i=0; i<=M; i++)
              for (j=0; j<=i; j++)  {
                     R[i][j] += (y[i] * y[j] - R[i][j]) / N;
                     R[j][i] = R[i][j];
              }
}

