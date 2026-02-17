from launch import LaunchDescription
from launch.substitutions import LaunchConfiguration, PathJoinSubstitution
from launch.actions import GroupAction
from launch_ros.actions import Node, PushRosNamespace
from launch_ros.substitutions import FindPackageShare


def generate_launch_description():

	node_ns = LaunchConfiguration("node_ns", default="robot")
	use_sim = LaunchConfiguration("use_sim", default="true")

	config = PathJoinSubstitution([
		FindPackageShare('__PKG_NAME__'),
		'config',
		'config.yaml'
	])

	laser_scan = Node(
		package="__PKG_NAME__",
		executable="__NODE_NAME___node",
		name="__NODE_NAME__",
		parameters=[config, {'use_sim_time': use_sim}],
	)

	group = GroupAction([
		PushRosNamespace(node_ns),
		laser_scan,
	])

	return LaunchDescription([group])
