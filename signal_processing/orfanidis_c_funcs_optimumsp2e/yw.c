/*  yw.c - Yule-Walker method  */

#define MAX   50

void corr(), lev();

void yw(N, y, M, R, L, E)
double y[], R[], L[][MAX+1], E[];
int N, M;
{
       corr(N, y, y, M, R);
       lev(M, R, L, E);
}
