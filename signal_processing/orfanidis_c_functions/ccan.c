/* ccan.c - circular buffer implementation of canonical realization */

void wrap();                              /* defined in \ref{hardware.sec} */

double ccan(M, a, b, w, p, x)             /* usage: y=ccan(M, a, b, w, &p, x); */
double *a, *b, *w, **p, x;                /* \(p\) = circular pointer to buffer \(w\) */
int M;                                    /* \(a,b\) have common order \(M\) */
{
       int i;
       double y = 0, s0;

       **p = x;                                 /* read input sample \(x\) */

       s0  = *(*p)++;                           /* \(s\sb{0}=x\) */
       wrap(M, w, p);                           /* \(p\) now points to \(s\sb{1}\) */

       for (a++, i=1; i<=M; i++) {              /* start with \(a\) incremented to \(a\sb{1}\) */
              s0 -= (*a++) * (*(*p)++);
              wrap(M, w, p);
              }

       **p = s0;                                /* \(p\) has wrapped around once */

       for (i=0; i<=M; i++) {                   /* numerator part */
              y += (*b++) * (*(*p)++);
              wrap(M, w, p);                    /* upon exit, \(p\) has wrapped */
              }                                 /* around once again */

       (*p)--;                                  /* update circular delay line */
       wrap(M, w, p);

       return y;                                /* output sample */
}
