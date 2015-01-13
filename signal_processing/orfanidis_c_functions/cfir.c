/* cfir.c - FIR filter implemented with circular delay-line buffer */

void wrap();

double cfir(M, h, w, p, x)
double *h, *w, **p, x;                         /* \(p\) = circular pointer to \(w\) */
int M;                                         /* \(M\) = filter order */
{                        
       int i;
       double y;

       **p = x;                                /* read input sample \(x\) */

       for (y=0, i=0; i<=M; i++) {             /* compute output sample \(y\) */
              y += (*h++) * (*(*p)++);
              wrap(M, w, p);
              }

       (*p)--;                                 /* update circular delay line */
       wrap(M, w, p);

       return y;
}
