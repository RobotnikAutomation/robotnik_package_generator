#!/bin/bash

if [ ! -d "robotnik_package_generator" ]; then
  git clone https://github.com/RobotnikAutomation/robotnik_package_generator.git
else
	echo "Directory 'robotnik_package_generator' already exists. Skipping clone."
fi

./robotnik_package_generator/generate_package.sh

rm -rf get_generator.sh