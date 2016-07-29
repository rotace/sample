project(sample)


#variable setting
set(cpputest_home "/usr/local")



# version
set(serial "0.1.0")
set(soserial "1")

# cmake version
cmake_minimum_required(VERSION 2.6)

# # executable TAGET dir
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ./bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ./lib)

# set flags
set(CMAKE_CXX_FLAGS "-g -Wall -static -fprofile-arcs -ftest-coverage")
# set(CMAKE_CXX_FLAGS_DEBUG "")
# set(CMAKE_CXX_FLAGS_RELEASE "")


# set include and library # gcc -I(include_dir) -L(lib_dir)
include_directories(${PROJECT_SOURCE_DIR}/include ${cpputest_home}/include)
link_directories(${PROJECT_SOURCE_DIR}/lib ${cpputest_home}/lib)
link_directories(${PROJECT_BINARY_DIR}/lib)



# dependent src files
file(GLOB SourceFiles main-src/*.cpp src/*.cpp)
file(GLOB TestSourceFiles t/*.cpp src/*.cpp )

# library TAGET
# add_LIBRARY(misc SHARED libsrc/misc.c)

# executable TAGET
# add_executable(run ${SourceFiles})
add_executable(run_test ${TestSourceFiles})

# set compile option (-l{library} ...)
target_link_libraries(run_test CppUTest CppUTestExt)
set_target_properties(run_test
  PROPERTIES
  COMPILE_FLAGS "")



# run_test command (after build)
add_custom_command(
    TARGET run_test
    POST_BUILD
    COMMAND run_test
    WORKING_DIRECTORY ./bin)


# message
message(STATUS "################## message ######################")
message(STATUS "project_source_dir = ${PROJECT_SOURCE_DIR}")
message(STATUS "project_binary_dir = ${PROJECT_BINARY_DIR}")
message(STATUS "cmake_cxx_flags = ${CMAKE_CXX_FLAGS}")
message(STATUS "cmake_cxx_flags_debug = ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "cmake_cxx_flags_release = ${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "cmake_build_type = ${CMAKE_BUILD_TYPE}")
message(STATUS "################## message ######################")
  
