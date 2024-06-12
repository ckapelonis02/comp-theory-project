#include "lambdalib.h"
#include <math.h>


#define SELF struct RandomNumberGenerator *self
typedef struct RandomNumberGenerator
{
  int number;

  int (*next) (SELF);
  void (*setNumber) (SELF, int x);
} RandomNumberGenerator;

int
next (SELF)
{
  self->number = (self->number * 1103515245 + 12345) % 2147483648;
  if (self->number < 0)
    {
      self->number = -self->number;
    }
  return self->number;
}


void
setNumber (SELF, int x)
{
  self->number = x;
}


const RandomNumberGenerator ctor_RandomNumberGenerator = {.next =
    next,.setNumber = setNumber };
#undef SELF


void
swap (int a[], int i, int j)
{

  int temp;
  temp = a[i];
  a[i] = a[j];
  a[j] = temp;
}


void
quickSort (int a[], int low, int high)
{

  int pivot, i, j;
  if (low < high)
    {
      pivot = low;
      i = low;
      j = high;
      while (i < j)
	{
	  while (a[i] <= a[pivot] && i < high)
	    {
	      i = i + 1;
	    }
	  while (a[j] > a[pivot])
	    {
	      j = j - 1;
	    }
	  if (i < j)
	    {
	      swap (a, i, j);
	    }
	}
      swap (a, pivot, j);
      quickSort (a, low, j - 1);
      quickSort (a, j + 1, high);
    }
}


void
printArray (int a[], int size)
{
  for (int i = 0; i < size; i++)
    {
      writeInteger (a[i]);
      if (i == size - 1)
	{
	  continue;
	}
      writeStr (", ");
    }
  writeStr ("\n");
}


int
prime (int n)
{

  int i;

  int result, isPrime;
  if (n < 0)
    {
      result = prime (-n);
    }
  else
    {
      if (n < 2)
	{
	  result = 0;
	}
      else
	{
	  if (n == 2)
	    {
	      result = 1;
	    }
	  else
	    {
	      if (n % 2 == 0)
		{
		  result = 0;
		}
	      else
		{
		  i = 3;
		  isPrime = 1;
		  while (isPrime && (i < n / 2))
		    {
		      isPrime = n % i != 0;
		      i = i + 2;
		    }
		  result = isPrime;
		}
	    }
	}
    }
  return result;
}


double
calcAvg (int a[], int size)
{

  double avg;
  avg = 0;
  for (int i = 0; i < size; i++)
    {
      avg += a[i];
    }
  return avg / size;
}


void
isPrime (int a[], int size)
{
  int *primeArray = (int *) malloc (100 * sizeof (int));
  for (int array_i = 0; array_i < 100; ++array_i)
    primeArray[array_i] = prime (a[array_i]);
  for (int i = 0; i < size; i++)
    {
      if (primeArray[i])
	{
	  writeInteger (a[i]);
	  writeStr (" is prime!\n");
	}
    }
}

int
main ()
{

  const int aSize = 100;

  int a[aSize];

  RandomNumberGenerator rand = ctor_RandomNumberGenerator;
  writeStr ("Hello people!\n\n");
  writeStr ("Give a seed for the random number generator: ");
  rand.setNumber (&rand, readInteger ());
  for (int i = 0; i < aSize; i++)
    {
      a[i] = rand.next (&rand) % 1000;
    }
  writeStr ("Random array generated:\n");
  printArray (a, aSize);
  quickSort (a, 0, aSize - 1);
  writeStr ("Sorted array:\n");
  printArray (a, aSize);
  writeStr ("Prime numbers of the array:\n");
  isPrime (a, 100);
  writeStr ("Average of array:\n");
  writeScalar (calcAvg (a, aSize));
  writeStr ("\nBye people!\n");
}
