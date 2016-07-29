#include <func_a.h>
#include <func_b.h>
#include <stdio.h>

int main(int argc, char *argv[]){
    int sum;

    func_a("prog_main calls func_a");

    sum = func_b(10,20);
    printf("The sum of 10 and 20 is %d.\n",sum);

    return 0;
}


