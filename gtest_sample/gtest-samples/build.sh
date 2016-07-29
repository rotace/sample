#!/bin/bash
pushd `dirname $0` > /dev/null
##############################
### variable setting

### sample1
echo "compile1"
/usr/bin/c++ -c -I/home/usr/local/src/gtest-1.7.0/include sample1.cc sample1_unittest.cc
echo "link1"
# /usr/bin/c++ -I/home/usr/local/src/gtest-1.7.0/include -L/home/usr/local/src/gtest-1.7.0/build sample1.o sample1_unittest.o -Wl,-dn -lgtest -lgtest_main -Wl,-dy -lpthread
/usr/bin/c++ -I/home/usr/local/src/gtest-1.7.0/include -L/home/usr/local/src/gtest-1.7.0/build -Wl,-dn,--whole-archive -lgtest -lgtest_main -Wl,-dy,--no-whole-archive -lpthread sample1.o sample1_unittest.o 
echo "remove1"
rm *.o *.out


### sample10
echo "compile10"
/usr/bin/c++ -c -I/home/usr/local/src/gtest-1.7.0/include sample10_unittest.cc
echo "link10"
/usr/bin/c++ -I/home/usr/local/src/gtest-1.7.0/include -L/home/usr/local/src/gtest-1.7.0/build -Wl,-dn,--whole-archive -lgtest -Wl,-dy,--no-whole-archive -lpthread sample10_unittest.o 
echo "remove10"
rm *.o *.out

##############################
popd > /dev/null
