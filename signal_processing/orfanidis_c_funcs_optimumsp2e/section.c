/*  section.c - lattice section  */

void section(gamma, w, xa, xb, ya, yb)
double gamma, *w, xa, xb, *ya, *yb;
{
       *ya = xa - gamma * (*w);
       *yb = (*w) - gamma * xa;

       *w = xb;
}

