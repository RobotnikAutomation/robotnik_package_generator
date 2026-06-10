#!/bin/bash
set -e

# ========================================
# Robotnik ROS2 Package Generator
# ========================================

TEMPLATE_DIR="$(dirname "$0")/template"
COMMON_DIR="$TEMPLATE_DIR/common"

echo "============================="
echo "Robotnik ROS2 Package Generator"
echo "============================="

# --- Ask if the package is public or private ---
echo "Is the package public or private?"
echo "1) Public"
echo "2) Private"

read -p "Choose an option: " VISIBILITY_OPTION

case "$VISIBILITY_OPTION" in
    1)
        PKG_VISIBILITY="public"
				LICENSE="BSD-3-Clause"
        LICENSE_FILE="BSD_LICENSE.md"
        ;;
    2)
        PKG_VISIBILITY="private"
				LICENSE="Proprietary Software License"
        LICENSE_FILE="PROP_LICENSE.md"
        ;;
    *)
        echo "Invalid option. Only 1 or 2 are allowed."
        exit 1
        ;;
esac


# --- Ask for package type ---
echo "Select the type of package to generate:"
echo "1) rclcpp"
# TODO: echo "2) rclpy"

read -p "Choose an option: " OPTION

case "$OPTION" in
    1)
        PKG_TYPE="rclcpp"
        ;;
    2)
        PKG_TYPE="rclpy"
        ;;
    *)
        echo "Invalid option. Only 1 or 2 are allowed."
        exit 1
        ;;
esac

# --- Ask for package parameters ---
read -p "Package name (ex: robotnik_laser_scan): " PKG_NAME
read -p "Package description: " DESCRIPTION
read -p "Node name (ex: laser_scan): " NODE_NAME
read -p "Class name (ex: LaserScan): " CLASS_NAME
read -p "Author name: " AUTHOR_NAME
read -p "Author email: " AUTHOR_EMAIL

# --- Output directory ---
OUTPUT_DIR="./$PKG_NAME"
if [[ -d "$OUTPUT_DIR" ]]; then
    echo "The directory $OUTPUT_DIR already exists, aborting."
    exit 1
fi

# --- Copy template --- 
echo "Copying template $PKG_TYPE..."
cp -r "$TEMPLATE_DIR/$PKG_TYPE/__PKG_NAME__" "$OUTPUT_DIR"

# --- Copy common content ---
echo "Adding common files..."
cp -r "$COMMON_DIR/." "$OUTPUT_DIR/"

# --- Copy the corresponding license ---
echo "Copying license $LICENSE_FILE..."
cp "$COMMON_DIR/licenses/$LICENSE_FILE" "$OUTPUT_DIR/LICENSE.md"

# --- Remove the licenses folder ---
rm -rf "$OUTPUT_DIR/licenses"

# --- Function to replace tokens ---
replace_tokens() {
    local dir="$1"
    find "$dir" -type f -exec sed -i \
        -e "s/__PKG_NAME__/$PKG_NAME/g" \
				-e "s/__DESCRIPTION__/$DESCRIPTION/g" \
        -e "s/__NODE_NAME__/$NODE_NAME/g" \
        -e "s/__CLASS_NAME__/$CLASS_NAME/g" \
        -e "s/__AUTHOR_NAME__/$AUTHOR_NAME/g" \
        -e "s/__AUTHOR_EMAIL__/$AUTHOR_EMAIL/g" \
				-e "s/__CURRENT_YEAR__/$(date +%Y)/g" \
        -e "s/__DATE__/$(date +%Y-%m-%d)/g" \
        -e "s/__LICENSE__/$LICENSE/g" {} +
}

# --- Replace tokens in all files ---
echo "Replacing tokens..."
replace_tokens "$OUTPUT_DIR"


# --- Add license as header in code files ---
echo "Adding license to code files..."
if [[ "$PKG_TYPE" == "rclcpp" ]]; then
    # For C++ use //
    sed 's/^/\/\/ /' "$OUTPUT_DIR/LICENSE.md" > /tmp/license_header
    find "$OUTPUT_DIR" -type f \( -name "*.cpp" -o -name "*.hpp" \) -exec sh -c '
        printf "%s\n\n" "$(cat /tmp/license_header)" > "$1.tmp"
        cat "$1" >> "$1.tmp"
        mv "$1.tmp" "$1"
    ' _ {} \;
elif [[ "$PKG_TYPE" == "rclpy" ]]; then
    # For Python use #
    sed 's/^/# /' "$OUTPUT_DIR/LICENSE.md" > /tmp/license_header
    find "$OUTPUT_DIR" -type f -name "*.py" -exec sh -c '
        printf "%s\n\n" "$(cat /tmp/license_header)" > "$1.tmp"
        cat "$1" >> "$1.tmp"
        mv "$1.tmp" "$1"
    ' _ {} \;
fi
rm -f /tmp/license_header

# --- Rename files containing __NODE_NAME__ ---
echo "Renaming files..."
find "$OUTPUT_DIR" -type f -name "*__NODE_NAME__*" | while read f; do
    mv "$f" "$(echo $f | sed "s/__NODE_NAME__/$NODE_NAME/")"
done

# --- Rename directories containing __PKG_NAME__ ---
find "$OUTPUT_DIR" -depth -type d -name "*__PKG_NAME__*" | while read d; do
    mv "$d" "$(echo $d | sed "s/__PKG_NAME__/$PKG_NAME/")"
done

echo "---------------------------------"
echo -e "\e[32mPackage $PKG_NAME generated successfully\e[0m"