#include "__PKG_NAME__/__NODE_NAME__.hpp"

__CLASS_NAME__::__CLASS_NAME__(const std::string& node_name)
 : rcomponent::Rcomponent(node_name)
{
	RCOMPONENT_INFO("__CLASS_NAME__ created");

	// --- Declare parameters ---

	declare_parameter<std::string>("chatter_publisher.topic", "chatter");
	declare_parameter<int>("chatter_publisher.qos_depth", 10);

	declare_parameter<std::string>("listener_subscriber.topic", "listener");
	declare_parameter<int>("listener_subscriber.qos_depth", 10);

	// --- End declare parameters ---

}

rcomponent::CallbackReturn __CLASS_NAME__::rc_configure()
{
	RCOMPONENT_INFO("__CLASS_NAME__ configure");

	// --- Read parameters ---

	std::string chatter_topic_ = this->get_parameter("chatter_publisher.topic").as_string();
	int chatter_qos_depth_ = this->get_parameter("chatter_publisher.qos_depth").as_int();

	std::string listener_topic_ = this->get_parameter("listener_subscriber.topic").as_string();
	int listener_qos_depth_ = this->get_parameter("listener_subscriber.qos_depth").as_int();

	// --- End read parameters ---

	// --- Create interfaces ---

	publisher_ = this->create_publisher<std_msgs::msg::String>(chatter_topic_, chatter_qos_depth_);

	subscriber_ = this->create_subscription<std_msgs::msg::String>(
			listener_topic_, listener_qos_depth_,
			[this](std_msgs::msg::String::SharedPtr msg) {
					RCLCPP_INFO(this->get_logger(), "listener -> Received: %s", msg->data.c_str());
			}
	);

	rc_publisher_ =  this->create_rc_publisher<std_msgs::msg::String>("rc_" + chatter_topic_);

	rc_subscriptor_ = this->create_rc_subscription<std_msgs::msg::String>(
			"rc_" + listener_topic_,
			[this](std_msgs::msg::String::SharedPtr msg) {
					RCLCPP_INFO(this->get_logger(), "rc_listener -> Received: %s", msg->data.c_str());
			}
	);

	// --- End create interfaces ---

	return rcomponent::CallbackReturn::SUCCESS;
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_activate()
{
	RCOMPONENT_INFO("__CLASS_NAME__ activate");
	publisher_->on_activate();

	return rcomponent::CallbackReturn::SUCCESS;
}

void __CLASS_NAME__::rc_loop()
{
	RCOMPONENT_INFO("__CLASS_NAME__ loop");

	auto msg = std_msgs::msg::String();
	msg.data = "Hello world";
	publisher_->publish(msg);
	rc_publisher_->publish(msg);
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_deactivate()
{
	RCOMPONENT_INFO("__CLASS_NAME__ deactivate");
	publisher_->on_deactivate();

	return rcomponent::CallbackReturn::SUCCESS;
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_cleanup()
{
	RCOMPONENT_INFO("__CLASS_NAME__ cleanup");
	subscriber_.reset();
	publisher_.reset();
	
	return rcomponent::CallbackReturn::SUCCESS;
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_shutdown()
{
	RCOMPONENT_INFO("__CLASS_NAME__ shutdown");

	return rcomponent::CallbackReturn::SUCCESS;
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_error()
{
	RCOMPONENT_INFO("__CLASS_NAME__ error");

	return rcomponent::CallbackReturn::SUCCESS;
}

