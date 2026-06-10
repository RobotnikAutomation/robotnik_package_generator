#pragma once

#include <rclcpp/rclcpp.hpp>
#include <rcomponent/rcomponent.hpp>

#include <std_msgs/msg/string.hpp>

class __CLASS_NAME__ : public rcomponent::Rcomponent
{

	public:

		// --- User space ---

		__CLASS_NAME__() = delete;
		explicit __CLASS_NAME__(const std::string& node_name);

		// --- End user space ---

		// --- Rcomponent space ---

		rcomponent::CallbackReturn rc_configure() override;
    rcomponent::CallbackReturn rc_activate() override;
		rcomponent::CallbackReturn rc_deactivate() override;
		rcomponent::CallbackReturn rc_cleanup() override;
		rcomponent::CallbackReturn rc_shutdown() override;
		rcomponent::CallbackReturn rc_error() override;

		// Periodic control loop (timer-driven), executed at a rc_loop_frequency
		void rc_loop() override;

		// --- End rcomponent space ---

	private:

		// --- User space ---

		void on_message(std_msgs::msg::String::SharedPtr msg);
		
		rcomponent::Publisher<std_msgs::msg::String>::SharedPtr rc_publisher_;
		rcomponent::Subscriptor<std_msgs::msg::String>::SharedPtr rc_subscriptor_;

		std::string chatter_topic_;
		int chatter_qos_depth_;

		std::string listener_topic_;
		int listener_qos_depth_;

		// --- End user space ---
};