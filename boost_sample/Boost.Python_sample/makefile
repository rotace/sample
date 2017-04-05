
# http://d.hatena.ne.jp/moriyoshi/20091214/1260779899

SRCS=basic.cpp basic2.cpp
OBJS=$(SRCS:%.cpp=%.so)

CFLAGS=-I`/usr/bin/python2.7 -c 'from distutils.sysconfig import *; print(get_python_inc())'` -DPIC -shared -fPIC
LDFLAGS=-lboost_python

all:$(OBJS)

%.so:%.cpp
	g++ $(CFLAGS) -o $@ $< $(LDFLAGS)

run:
	/usr/bin/python2.7
