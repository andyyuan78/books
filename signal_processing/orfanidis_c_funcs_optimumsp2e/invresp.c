/*  invresp.c - inverse frequency response  */

void invresp(NF, AF)
double AF[];
int NF;
{
       int i;

       for (i=0; i<NF; i++)
              AF[i] = 1 / AF[i];
}
