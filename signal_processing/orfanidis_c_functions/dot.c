/* dot.c - dot product of two length-(M+1) vectors */

double dot(M, h, w)                            /* Usage: y = dot(M, h, w); */
double *h, *w;                                 /* \(h\) = filter vector, \(w\) = state vector */
int M;                                         /* \(M\) = filter order */
{                        
       int i;
       double y;

       for (y=0, i=0; i<=M; i++)               /* compute dot product */
              y += h[i] * w[i];      

       return y;
}
