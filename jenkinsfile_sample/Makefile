CXX = g++
CXXFLAGS = -g -Wall -static -fprofile-arcs -ftest-coverage -I./ -pthread
LDFLAGS = -L./ -lCppUTest -lCppUTestExt
TARGET = hello_cpputest
SRCS = hello_cpputest.cpp geom.cpp
OBJS = $(SRCS:.cpp=.o)


all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)

$(OBJS): $(SRCS)
	$(CXX) -c $(CXXFLAGS) $^

%.o: %.cpp
	$(CXX) -c $(CXXFLAGS) $<

.PHONY: clean
clean:
	rm -f $(TARGET) $(OBJS) *.gcno *.gcov *~ *.xml
	find . -name "*.gcda" | xargs -r rm