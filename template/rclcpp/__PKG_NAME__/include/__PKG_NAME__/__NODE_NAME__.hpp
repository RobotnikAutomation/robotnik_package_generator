#pragma once

#include <rclcpp/rclcpp.hpp>
#include <rcomponent/rcomponent.hpp>

class __CLASS_NAME__ : public Rcomponent
{

	public:

		__CLASS_NAME__() = delete;
		explicit __CLASS_NAME__(const std::string& node_name);

	private:

		// Periodic control loop (timer-driven), executed at a
		// fixed frequency by Rcomponent
		void control_loop() override;
};