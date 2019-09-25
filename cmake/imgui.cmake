# Copyright (c) 2019 Wenyi Tang
# Author: Wenyi Tang
# E-mail: wenyitang@outlook.com
include (ExternalProject)

set(imgui_URL https://github.com/ocornut/imgui.git)
set(imgui_TAG v1.60)
set(imgui_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/imgui/include)

if(NOT EXISTS ${LL_SCRIPT_ROOT})
  set(LL_SCRIPT_ROOT ${CMAKE_SOURCE_DIR}/scripts/cmake)
endif()

if(WIN32)
  set(imgui_STATIC_LIBS
    ${CMAKE_CURRENT_BINARY_DIR}/imgui/lib/imgui.lib)
  set(imgui_STATIC_LIBS_DEBUG
    ${CMAKE_CURRENT_BINARY_DIR}/imgui/lib/imguid.lib)
else()
  set(imgui_STATIC_LIBS
    ${CMAKE_CURRENT_BINARY_DIR}/imgui/lib/libimgui.a)
  set(imgui_STATIC_LIBS_DEBUG
    ${CMAKE_CURRENT_BINARY_DIR}/imgui/lib/libimguid.a)
endif()

ExternalProject_Add(imgui-src
  PREFIX imgui
  GIT_REPOSITORY ${imgui_URL}
  GIT_TAG ${imgui_TAG}
  PATCH_COMMAND 
    ${CMAKE_COMMAND} -E copy_if_different
        ${LL_SCRIPT_ROOT}/patches/imgui/CMakeLists.txt <SOURCE_DIR>
    && ${CMAKE_COMMAND} -E copy
        ${LL_SCRIPT_ROOT}/patches/imgui/imconfig.h <SOURCE_DIR>
  CMAKE_CACHE_ARGS
    -DIMGUI_BUILD_EXAMPLES:BOOL=ON
    -DCMAKE_DEBUG_POSTFIX:STRING=${CMAKE_DEBUG_POSTFIX}
    -DCMAKE_CXX_FLAGS_DEBUG:STRING=${CMAKE_CXX_FLAGS_DEBUG}
    -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
    -DCMAKE_INSTALL_PREFIX:STRING=<INSTALL_DIR>)

include_directories(${imgui_INCLUDE_DIRS})
add_library(imgui STATIC IMPORTED)
add_dependencies(imgui imgui-src)
set_target_properties(imgui PROPERTIES
  IMPORTED_LOCATION ${imgui_STATIC_LIBS}
  IMPORTED_LOCATION_DEBUG ${imgui_STATIC_LIBS_DEBUG})
