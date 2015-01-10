/* blockcon.c - block convolution by overlap-add method */

void conv();

void blockcon(M, h, L, x, y, ytemp)
double *h, *x, *y, *ytemp;                    /* ytemp is tail of previous block */
int M, L;                                     /* \(M\) = filter order, \(L\) = block size */
{
    int i;

    conv(M, h, L, x, y);                      /* compute output block y */

    for (i=0; i<M; i++) {
        y[i] += ytemp[i];                     /* add tail of previous block */
        ytemp[i] = y[i+L];                    /* update tail for next call */
        }
}
