/*  aicmdl.c - AIC and MDL criteria  */

#include <math.h>

void aicmdl(M, lambda, N, AIC, MDL)
double lambda[], AIC[], MDL[];
int M, N;
{
       int k;
       double L, avlog = 0, av = 0, logN = log((double) N);

       for (k=1; k<=M+1; k++) {
              av += (lambda[k-1] - av) / k;
              avlog += (log(lambda[k-1]) - avlog) / k;
              L = avlog - log(av);
              AIC[k-1] = - 2 * N * k * L + 2 * (M + 1 - k) * (M + 1 + k);
              MDL[k-1] = - N * k * L + 0.5 * (M + 1 - k) * (M + 1 + k) * logN;
              }
}
