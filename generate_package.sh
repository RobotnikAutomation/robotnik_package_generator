#!/bin/bash
set -e

# ========================================
# Robotnik ROS2 Package Generator
# ========================================

# Añadir test basico de revisar package.xml

TEMPLATE_DIR="$(dirname "$0")/template"
COMMON_DIR="$TEMPLATE_DIR/common"

echo "============================="
echo "Robotnik ROS2 Package Generator"
echo "============================="

# Check email format

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
echo "2) rclpy"

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
read -p "Node name (ex: laser_scan): " NODE_NAME
read -p "Class name (ex: LaserScan): " CLASS_NAME
read -p "Author name: " AUTHOR_NAME
read -p "Author email: " AUTHOR_EMAIL

# --- Directorio de salida ---
OUTPUT_DIR="./$PKG_NAME"
if [[ -d "$OUTPUT_DIR" ]]; then
    echo "El directorio $OUTPUT_DIR ya existe, abortando"
    exit 1
fi

# --- Copiar template ---
echo "Copiando template $PKG_TYPE..."
cp -r "$TEMPLATE_DIR/$PKG_TYPE/__PKG_NAME__" "$OUTPUT_DIR"

# --- Copiar contenido common ---
echo "Agregando archivos comunes..."
cp -r "$COMMON_DIR/." "$OUTPUT_DIR/"

# --- Copiar la licencia correspondiente ---
echo "Copiando licencia $LICENSE_FILE..."
cp "$COMMON_DIR/licenses/$LICENSE_FILE" "$OUTPUT_DIR/LICENSE.md"

# --- Eliminar la carpeta de licencias ---
rm -rf "$OUTPUT_DIR/licenses"

# --- Función para reemplazar tokens ---
replace_tokens() {
    local dir="$1"
    find "$dir" -type f -exec sed -i \
        -e "s/__PKG_NAME__/$PKG_NAME/g" \
        -e "s/__NODE_NAME__/$NODE_NAME/g" \
        -e "s/__CLASS_NAME__/$CLASS_NAME/g" \
        -e "s/__AUTHOR_NAME__/$AUTHOR_NAME/g" \
        -e "s/__AUTHOR_EMAIL__/$AUTHOR_EMAIL/g" \
				-e "s/__CURRENT_YEAR__/$(date +%Y)/g" \
        -e "s/__LICENSE__/$LICENSE/g" {} +
}

# --- Reemplazar tokens en todos los archivos ---
echo "Reemplazando tokens..."
replace_tokens "$OUTPUT_DIR"


# --- Agregar licencia como header en archivos de código ---
echo "Agregando licencia a archivos de código..."
if [[ "$PKG_TYPE" == "rclcpp" ]]; then
    # Para C++ usar //
    sed 's/^/\/\/ /' "$OUTPUT_DIR/LICENSE.md" > /tmp/license_header
    find "$OUTPUT_DIR" -type f \( -name "*.cpp" -o -name "*.hpp" \) -exec sh -c '(cat /tmp/license_header; echo -e "\n"; cat "$1") > "$1.tmp" && mv "$1.tmp" "$1"' _ {} \;
elif [[ "$PKG_TYPE" == "rclpy" ]]; then
    # Para Python usar #
    sed 's/^/# /' "$OUTPUT_DIR/LICENSE.md" > /tmp/license_header
    find "$OUTPUT_DIR" -type f -name "*.py" -exec sh -c '(cat /tmp/license_header; echo -e "\n"; cat "$1")> "$1.tmp" && mv "$1.tmp" "$1"' _ {} \;
fi
rm -f /tmp/license_header

# --- Renombrar archivos que contengan __NODE_NAME__ ---
echo "Renombrando archivos..."
find "$OUTPUT_DIR" -type f -name "*__NODE_NAME__*" | while read f; do
    mv "$f" "$(echo $f | sed "s/__NODE_NAME__/$NODE_NAME/")"
done

# --- Renombrar carpetas que contengan __PKG_NAME__ ---
find "$OUTPUT_DIR" -depth -type d -name "*__PKG_NAME__*" | while read d; do
    mv "$d" "$(echo $d | sed "s/__PKG_NAME__/$PKG_NAME/")"
done

echo "---------------------------------"
echo "Paquete $PKG_NAME generado correctamente en $OUTPUT_DIR"