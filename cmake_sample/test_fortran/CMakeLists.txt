# Cmake project file for main.f

cmake_minimum_required(VERSION 2.6)
project(test-fortran)
enable_language(Fortran)

# build excutables
add_executable("test_fortran" main.f)
add_executable("test_c" main.c)

# info
message("
----------------------------

Current fortran compiler options:
     CC:                             ${CMAKE_C_COMPILER}
     CMAKE_C_FLAGS:                  ${CMAKE_C_FLAGS}
     CMAKE_C_FLAGS_RELEASE           ${CMAKE_C_FLAGS_RELEASE}
     CMAKE_C_FLAGS_DEBUG             ${CMAKE_C_FLAGS_DEBUG}

Current fortran compiler options:
     FC:                             ${CMAKE_Fortran_COMPILER}
     CMAKE_Fortran_FLAGS:            ${CMAKE_Fortran_FLAGS}
     CMAKE_Fortran_FLAGS_RELEASE     ${CMAKE_Fortran_FLAGS_RELEASE}
     CMAKE_Fortran_FLAGS_DEBUG       ${CMAKE_Fortran_FLAGS_DEBUG}

----------------------------
")




