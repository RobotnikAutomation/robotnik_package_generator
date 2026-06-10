#include "__PKG_NAME__/__NODE_NAME__.hpp"

__CLASS_NAME__::__CLASS_NAME__(const std::string& node_name)
 : rcomponent::Rcomponent(node_name)
{
	RCOMPONENT_INFO("__CLASS_NAME__ created");
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_configure()
{
	RCOMPONENT_INFO("__CLASS_NAME__ configure");

	// --- Read parameters ---

	auto chatter_topic_ = get_rc_param<std::string>("chatter_publisher.topic", "chatter");
	auto chatter_qos_depth_ = get_rc_param<int>("chatter_publisher.qos_depth", 10);
	auto listener_topic_ = get_rc_param<std::string>("listener_subscriber.topic", "listener");
	auto listener_qos_depth_ = get_rc_param<int>("listener_subscriber.qos_depth", 10);

	// --- End read parameters ---

	// --- Create interfaces ---
	
	const bool required = false;

	rc_publisher_ =  this->create_rc_publisher<std_msgs::msg::String>("rc_" + chatter_topic_, 
		rclcpp::QoS(chatter_qos_depth_), required);

	rc_subscriptor_ = this->create_rc_subscription<std_msgs::msg::String>(
		listener_topic_,
		[this](std_msgs::msg::String::SharedPtr msg) {
			this->on_message(msg);
		},
		rclcpp::QoS(listener_qos_depth_), required
	);

	// --- End create interfaces ---

	return rcomponent::CallbackReturn::SUCCESS;
}

void __CLASS_NAME__::on_message(std_msgs::msg::String::SharedPtr msg)
{
	RCOMPONENT_INFO("rc_listener -> Received: %s", msg->data.c_str());
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_activate()
{
	RCOMPONENT_INFO("__CLASS_NAME__ activate");
	return rcomponent::CallbackReturn::SUCCESS;
}

void __CLASS_NAME__::rc_loop()
{
	RCOMPONENT_INFO("__CLASS_NAME__ loop");
	auto msg = std_msgs::msg::String();
	msg.data = "Hello world";
	rc_publisher_->publish(msg);
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_deactivate()
{
	RCOMPONENT_INFO("__CLASS_NAME__ deactivate");
	return rcomponent::CallbackReturn::SUCCESS;
}

rcomponent::CallbackReturn __CLASS_NAME__::rc_cleanup()
{
	RCOMPONENT_INFO("__CLASS_NAME__ cleanup");
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

