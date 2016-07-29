#
# Makefile
#
#

TARGET=prog_main
SRCS=prog_main.c func_a.c func_b.c
BASENAMES    = $(SRCS:%.c=%)
DEBUG_OBJS   = $(SRCS:%.c=Debug/%.o)
RELEASE_OBJS = $(SRCS:%.c=Release/%.o)
CC=gcc
CFLAGS=-I./include
DEBUG_CFLAGS=-g $(CFLAGS)
RELEASE_CFLAGS=-O2 $(CFLAGS)

all : debug release

debug : Debug/$(TARGET)

release : Release/$(TARGET)

Debug/$(TARGET) : Debug $(DEBUG_OBJS)
	$(CC) $(DEBUG_CFLAGS) -o $@ $(DEBUG_OBJS)

Release/$(TARGET) : Release $(RELEASE_OBJS)
	$(CC) $(RELEASE_CFLAGS) -o $@ $(RELEASE_OBJS)

Debug/%.o : %.c
	$(CC) $(DEBUG_CFLAGS) -c -o $@ $<

Release/%.o : %.c
	$(CC) $(RELEASE_CFLAGS) -c -o $@ $<

Debug :
	mkdir Debug

Release :
	mkdir Release

clean :
	rm -rf Debug Release Dependencies.txt

depend :
	(for f in $(BASENAMES) ; do \
	gcc $(CFLAGS) -MM -MT Debug/$$f.o $$f.c ; \
	gcc $(CFLAGS) -MM -MT Release/$$f.o $$f.c ; \
	done ) >Dependencies.txt

-include Dependencies.txt
