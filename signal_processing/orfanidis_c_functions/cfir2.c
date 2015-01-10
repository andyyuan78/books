/* cfir2.c - FIR filter implemented with circular delay-line buffer */

void wrap2();

double cfir2(M, h, w, q, x)
double *h, *w, x;                                /* \(q\) = circular offset index */
int M, *q;                                       /* \(M\) = filter order */
{                        
       int i;
       double y;

       w[*q] = x;                                /* read input sample \(x\) */

       for (y=0, i=0; i<=M; i++) {               /* compute output sample \(y\) */
              y += (*h++) * w[(*q)++];
              wrap2(M, q);
              }

       (*q)--;                                   /* update circular delay line */
       wrap2(M, q);
       
       return y;
}
