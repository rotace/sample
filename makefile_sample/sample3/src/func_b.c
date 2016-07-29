#include <func_b.h>
#include <stdio.h>

int func_b(int a, int b) {
  int result;
  result = a+b;
  printf ("This is func_b. I received %d and %d. I will return %d.\n",a,b,result);
  return result;
}

