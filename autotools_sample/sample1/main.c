#include<stdio.h>


int main(int argc, char *argv[])
{
  fprintf( stdout, "%s:%s(%d)\n",__FILE__,__FUNCTION__,__LINE__);
  return 0;
}
