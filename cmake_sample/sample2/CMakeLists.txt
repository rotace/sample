# cmake version
cmake_minimum_required(VERSION 2.6)

# executable TAGET dir
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ./bin)

# library TAGET dir
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ./lib)

# project name
project(sample)

# version
set(serial "0.1.0")
set(soserial "1")

# include_dir
include_directories("${PROJECT_SOURCE_DIR}" include)

# dependent src files
file(GLOB SourceFiles src/prog_main.c src/subsrc/*.c)
file(GLOB TestSourceFiles t/*.c src/subsrc/*.c)

# library TAGET
add_LIBRARY(misc SHARED libsrc/misc.c)

# executable TAGET
add_executable(run ${SourceFiles})
add_executable(run_test ${TestSourceFiles})
target_link_libraries(run_test misc)

# run_test command (after build)
add_custom_command(
    TARGET run_test
    POST_BUILD
    COMMAND run_test
    WORKING_DIRECTORY ./bin)

