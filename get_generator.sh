#!/bin/bash

if [ ! -d "robotnik_package_generator" ]; then
  git clone https://github.com/RobotnikAutomation/robotnik_package_generator.git
else
	echo "Directory 'robotnik_package_generator' already exists. Skipping clone."
fi

./robotnik_package_generator/generate_package.sh

# rm -rf get_generator.sh

echo ""
read -p "Do you want to delete the package generator (robotnik_package_generator)? (y/n): " DELETE_OPTION
if [[ "$DELETE_OPTION" =~ ^[Yy]$ ]]; then
    rm -rf "robotnik_package_generator"
    echo "Deleted robotnik_package_generator."
fi