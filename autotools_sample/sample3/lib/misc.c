
#include <stdio.h>

int
library_test_call(char *msg)
{
    fprintf( stdout, "%s:%s(%d)\n",__FILE__,__FUNCTION__,__LINE__);
    fprintf( stdout, "%s\n", msg );
    return( 0 );
}
