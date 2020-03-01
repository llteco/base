# Copyright (c) 2019 Wenyi Tang
# Author: Wenyi Tang
# E-mail: wenyitang@outlook.com
include(ExternalProject)

set(spdlog_URL https://github.com/gabime/spdlog.git)
set(spdlog_TAG v1.5.0)
set(spdlog_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/spdlog/include)

ExternalProject_Add(spdlog-src
  PREFIX spdlog
  GIT_REPOSITORY ${spdlog_URL}
  GIT_TAG ${spdlog_TAG}
  CMAKE_CACHE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DSPDLOG_BUILD_EXAMPLES:BOOL=OFF
    -DSPDLOG_BUILD_BENCH:BOOL=OFF
    -DSPDLOG_BUILD_TESTS:BOOL=OFF
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_CXX_FLAGS_DEBUG:STRING=${CMAKE_CXX_FLAGS_DEBUG}
    -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
    -DCMAKE_INSTALL_PREFIX:STRING=<INSTALL_DIR>)

add_library(spdlog INTERFACE)
add_dependencies(spdlog spdlog-src)
target_include_directories(spdlog INTERFACE 
  $<INSTALL_INTERFACE:include>
  $<BUILD_INTERFACE:${spdlog_INCLUDE_DIRS}>
)
target_compile_definitions(spdlog INTERFACE SPDLOG SPDLOG_WCHAR_FILENAMES)

install(TARGETS spdlog
  EXPORT spdlog-export
  DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
install(DIRECTORY ${spdlog_INCLUDE_DIRS} DESTINATION ${CMAKE_INSTALL_PREFIX})
install(EXPORT spdlog-export DESTINATION ${CMAKE_INSTALL_PREFIX})
