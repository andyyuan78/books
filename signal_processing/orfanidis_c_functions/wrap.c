/* wrap.c - circular wrap of pointer p, relative to array w */

void wrap(M, w, p)
double *w, **p;
int M;
{
       if (*p > w + M)  
              *p -= M + 1;          /* when \(*p=w+M+1\), it wraps around to \(*p=w\) */

       if (*p < w)  
              *p += M + 1;          /* when \(*p=w-1\), it wraps around to \(*p=w+M\) */
}
