#include <rclcpp/rclcpp.hpp>
#include "__PKG_NAME__/__NODE_NAME__.hpp"

int main(int argc, char * argv[])
{
  rclcpp::init(argc, argv);

	auto node = rcomponent::make_component<__CLASS_NAME__>("__NODE_NAME__");
  rclcpp::executors::SingleThreadedExecutor executor;
  executor.add_node(node->get_node_base_interface());
  executor.spin();

  rclcpp::shutdown();
  return 0;
}