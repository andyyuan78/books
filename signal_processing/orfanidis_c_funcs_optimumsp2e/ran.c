#define  a    25173
#define  c    13849
#define  m    65536

double ran(iseed)
long *iseed;
{
       *iseed = (a * *iseed + c) % m;
       return (double) *iseed / (double) m;
}
