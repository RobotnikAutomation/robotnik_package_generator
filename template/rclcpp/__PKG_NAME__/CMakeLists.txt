cmake_minimum_required(VERSION 3.8)
project(__PKG_NAME__)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rcomponent REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)

include_directories(include)

add_executable(__NODE_NAME___node
  src/__NODE_NAME___node.cpp
  src/__NODE_NAME__.cpp
)

ament_target_dependencies(__NODE_NAME___node
	rcomponent
  rclcpp
)

if(BUILD_TESTING)

endif()

install(TARGETS
  __NODE_NAME___node
  DESTINATION lib/${PROJECT_NAME}
)

install(DIRECTORY
  config
  launch
  DESTINATION share/${PROJECT_NAME}
)

ament_package()
