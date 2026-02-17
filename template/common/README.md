# __PKG_NAME__ 

Package description goes here.

## Installation

Create the workspace:

```
mkdir -p ~/ros2_ws/src 
cd ~/ros2_ws/src
```

Install dependencies:

```
cd ~/ros2_ws
rosdep update && rosdep install --from-paths src --ignore-src -y -r --rosdistro jazzy
```

Build the repository:

```
colcon build --symlink-install
source install/setup.bash
```

## Bringup

Set and source the repository:

```
cd ~/ros2_ws
source install/setup.bash
```

Launch __PKG_NAME__ :

```
ros2 launch __PKG_NAME__ __PKG_NAME__.launch.py
```

## Node interface

### Publishers

### Subscribers

### Services

### Actions

### Parameters