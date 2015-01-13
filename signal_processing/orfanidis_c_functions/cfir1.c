/* cfir1.c - FIR filter implemented with circular delay-line buffer */

void wrap();

double cfir1(M, h, w, p, x)
double *h, *w, **p, x;
int M;
{                        
       int i;
       double y;

       *(*p)-- = x;
       wrap(M, w, p);                          /* \(p\) now points to \(s\sb{M}\) */

       for (y=0, h+=M, i=M; i>=0; i--) {       /* \(h\) starts at \(h\sb{M}\) */
              y += (*h--) * (*(*p)--);
              wrap(M, w, p);
              }

       return y;
}
