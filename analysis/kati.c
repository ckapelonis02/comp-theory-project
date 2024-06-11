#include "lambdalib.h"
#include <math.h>



const int N = 100;

int a[100];
int main() {
for (int i = 0; i < N; i++) {
a[i] = i;
}
double* half = (double*)malloc(100 * sizeof(double));
for (int array_i = 0; array_i < 100; ++array_i)
	half[array_i] = a[array_i] / 2;
}

