project(gtest-samples)
cmake_minimum_required(VERSION 2.6)

include_directories(${PROJECT_SOURCE_DIR})
set(CMAKE_CXX_FLAGS "-lpthread")

# include_directories(/home/usr/local/src/gtest-1.7.0/include)
# set(CMAKE_CXX_FLAGS "-Wl,-dn,--whole-archive -lgtest -lgtest_main -Wl,-dy,--no-whole-archive -lpthread")
# set(CMAKE_CXX_FLAGS "-I/home/usr/local/src/gtest-1.7.0/include -L/home/usr/local/src/gtest-1.7.0/build -Wl,-dn,--whole-archive -lgtest -lgtest_main -Wl,-dy,--no-whole-archive -lpthread")
# set(CMAKE_CXX_FLAGS "-rdynamic -lpthread -Wl,-Bstatic -lgtest -lgtest_main -Wl,-Bdynamic")


add_executable(sample1 sample1.cc sample1_unittest.cc)
target_link_libraries(sample1
	gtest.a
	gtest_main.a)


add_executable(sample2 sample2_unittest.cc sample2.cc)
target_link_libraries(sample2
	gtest.a
	gtest_main.a)

add_executable(sample3 sample3_unittest.cc)
target_link_libraries(sample3
	gtest.a
	gtest_main.a)

add_executable(sample4 sample4_unittest.cc sample4.cc)
target_link_libraries(sample4
	gtest.a
	gtest_main.a)

add_executable(sample5 sample5_unittest.cc sample1.cc)
target_link_libraries(sample5
	gtest.a
	gtest_main.a)

add_executable(sample6 sample6_unittest.cc)
target_link_libraries(sample6
	gtest.a
	gtest_main.a)
      
add_executable(sample7 sample7_unittest.cc)
target_link_libraries(sample7
	gtest.a
	gtest_main.a)
      
add_executable(sample8 sample8_unittest.cc)
target_link_libraries(sample8
	gtest.a
      	gtest_main.a)

add_executable(sample9 sample9_unittest.cc)
target_link_libraries(sample9
	gtest.a)

add_executable(sample10 sample10_unittest.cc)
target_link_libraries(sample10
	gtest.a)


      
message(STATUS "project_source_dir = ${PROJECT_SOURCE_DIR}")
message(STATUS "project_binary_dir = ${PROJECT_BINARY_DIR}")
