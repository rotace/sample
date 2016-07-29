# cmake version
cmake_minimum_required(VERSION 2.6)

# executable TAGET dir
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ./bin)

# project name
project(sample)

# version
set(serial "0.1.0")

# include_dir
include_directories("${PROJECT_SOURCE_DIR}" include)

# dependent src files
file(GLOB TestSourceFiles t/*.c src/*.c)

# executable TAGET
add_executable(run_test ${TestSourceFiles})

# run_test command (after build)
add_custom_command(
    TARGET run_test
    POST_BUILD
    COMMAND run_test
    WORKING_DIRECTORY ./bin)

