#!/bin/bash

if [ ! -d "robotnik_package_generator" ]; then
  git clone https://github.com/RobotnikAutomation/robotnik_package_generator.git
else
	echo "Directory 'robotnik_package_generator' already exists. Skipping clone."
fi

./robotnik_package_generator/generate_package.sh

rm -rf get_generator.sh

read -p "Do you want to delete the generated package at $OUTPUT_DIR? (y/N): " DELETE_OPTION
if [[ "$DELETE_OPTION" =~ ^[Yy]$ ]]; then
    rm -rf "$OUTPUT_DIR"
    echo "Deleted $OUTPUT_DIR."
else
    echo "Package kept at $OUTPUT_DIR."
fi