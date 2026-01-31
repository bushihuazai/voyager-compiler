#!/bin/bash

# Generate PlantUML diagrams for Voyager Compiler documentation
# This script converts all .puml files to SVG and PNG formats

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================="
echo "Voyager Compiler Diagram Generator"
echo "========================================="
echo ""

# Check if plantuml is installed
if ! command -v plantuml &> /dev/null; then
    echo "ERROR: PlantUML is not installed."
    echo ""
    echo "Please install it using one of the following methods:"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  sudo apt-get install plantuml"
    echo ""
    echo "macOS:"
    echo "  brew install plantuml"
    echo ""
    echo "Or use Docker:"
    echo "  docker run --rm -v \$(pwd):/data plantuml/plantuml *.puml"
    echo ""
    exit 1
fi

echo "Found PlantUML: $(which plantuml)"
echo "PlantUML version: $(plantuml -version | head -n 1)"
echo ""

# Count .puml files
PUML_COUNT=$(find . -maxdepth 1 -name "*.puml" | wc -l)

if [ "$PUML_COUNT" -eq 0 ]; then
    echo "No .puml files found in the current directory."
    exit 0
fi

echo "Found $PUML_COUNT PlantUML diagram(s) to generate"
echo ""

# Generate SVG files (vector graphics - recommended)
echo "Generating SVG files..."
plantuml -tsvg *.puml
echo "✓ SVG files generated"
echo ""

# Generate PNG files (raster graphics)
echo "Generating PNG files..."
plantuml -tpng *.puml
echo "✓ PNG files generated"
echo ""

# List generated files
echo "========================================="
echo "Generated files:"
echo "========================================="
echo ""

for puml_file in *.puml; do
    base_name="${puml_file%.puml}"
    echo "  $base_name.puml"
    
    if [ -f "${base_name}.svg" ]; then
        svg_size=$(du -h "${base_name}.svg" | cut -f1)
        echo "    ├── ${base_name}.svg (${svg_size})"
    fi
    
    if [ -f "${base_name}.png" ]; then
        png_size=$(du -h "${base_name}.png" | cut -f1)
        echo "    └── ${base_name}.png (${png_size})"
    fi
    echo ""
done

echo "========================================="
echo "✓ All diagrams generated successfully!"
echo "========================================="
echo ""
echo "Tip: Use SVG files for documentation as they scale better."
echo "Use PNG files for presentations or when SVG is not supported."
