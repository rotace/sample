


ALL:build

build:
	g++ -I`/usr/bin/python2.7 -c 'from distutils.sysconfig import *; print(get_python_inc())'` -DPIC -shared -fPIC -o basic.so basic.cpp -lboost_python

run:
	/usr/bin/python2.7
