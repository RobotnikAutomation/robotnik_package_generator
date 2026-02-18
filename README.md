# robotnik_package_generator
This package provides a tool to generate Robotnik ROS 2 packages based on templates with predefined structures and configurations, making it easier to set up new projects.

## 1. Generate a package

### Generator

Execute in your terminal the package generator:

```
wget https://raw.githubusercontent.com/RobotnikAutomation/robotnik_package_generator/refs/heads/ros2-devel/get_generator.sh && chmod +x get_generator.sh && ./get_generator.sh
```

### Parameters

Setup the package with selecting your own options. This example creates `mock_package`.

```
=============================
Robotnik ROS2 Package Generator
=============================
Is the package public or private?
1) Public
2) Private
Choose an option: 1
Select the type of package to generate:
1) rclcpp
2) rclpy
Choose an option: 1
Package name (ex: robotnik_laser_scan): mock_package
Node name (ex: laser_scan): mock
Class name (ex: LaserScan): Mock
Author name: John Doe
Author email: john.doe@example.com

```

If successful, the package will be generated in the same directory where the command was executed.

```
Copying template rclcpp...
Adding common files...
Copying license BSD_LICENSE.md...
Replacing tokens...
Adding license to code files...
Renaming files...
---------------------------------
Package generated successfully
```

### Compilation

Move the generated package to your ROS 2 workspace and build it to start using it. Make sure to have `rcomponent` package dependency.

```
mv mock_package ~/ros2_ws/src
git clone -b ros2-devel https://github.com/RobotnikAutomation/rcomponent.git ~/ros2_ws/src/rcomponent
cd ~/ros2_ws
colcon build --symlink-install
source install/setup.bash
```

### Launch

Launch the package:

```
ros2 launch mock_package mock_package.launch.py
```
