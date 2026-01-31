# Voyager Compiler Architecture Diagrams

This directory contains PlantUML diagrams that illustrate the architecture and design of the Voyager Compiler.

## Available Diagrams

### 1. Quick Reference (`quick-reference.puml`)
A comprehensive one-page overview showing:
- Complete compilation pipeline
- Core components
- Example applications
- Key API reference
- Important parameters

**Best for:** Getting a quick overview of the entire system.

### 2. Architecture Overview (`architecture-overview.puml`)
Detailed component diagram showing:
- All major subsystems
- Data flow between components
- Support modules
- External interfaces
- File organization

**Best for:** Understanding the overall system structure and component relationships.

### 3. Compilation Pipeline (`compilation-pipeline.puml`)
Step-by-step activity diagram showing:
- All 8 compilation stages
- Decision points
- Key functions and APIs
- Notes on each transformation

**Best for:** Understanding the compilation flow and which functions are called at each stage.

### 4. Quantization Framework (`quantization-framework.puml`)
Class diagram and workflow showing:
- Quantization classes and relationships
- Supported data types
- Workflow steps
- Usage examples

**Best for:** Understanding the quantization system and how to configure it.

## Viewing the Diagrams

### Online Viewers

The easiest way to view these diagrams is to use an online PlantUML viewer:

1. **PlantUML Web Server**: https://www.plantuml.com/plantuml/uml/
   - Copy and paste the content of any `.puml` file
   - Or use the URL encoding feature

2. **PlantText**: https://www.planttext.com/
   - Simple interface for quick viewing

### Local Viewing

#### Option 1: VS Code Extension
1. Install the "PlantUML" extension by jebbs
2. Open any `.puml` file
3. Press `Alt+D` to preview

#### Option 2: Command Line
```bash
# Install PlantUML
sudo apt-get install plantuml  # Ubuntu/Debian
brew install plantuml          # macOS

# Generate PNG
plantuml quick-reference.puml

# Generate SVG (recommended for better quality)
plantuml -tsvg quick-reference.puml

# Generate all diagrams
plantuml *.puml
```

#### Option 3: Docker
```bash
# Generate all diagrams using Docker
docker run --rm -v $(pwd):/data plantuml/plantuml *.puml
```

### Markdown Integration

These diagrams are embedded in the architecture documentation using PlantUML code blocks:

- `ARCHITECTURE.md` - English documentation
- `ARCHITECTURE_CN.md` - Chinese documentation

GitHub and many other platforms support rendering PlantUML diagrams directly in Markdown.

## Diagram Export

To export diagrams for presentations or documentation:

### PNG (Raster)
```bash
plantuml -tpng architecture-overview.puml
```

### SVG (Vector - Recommended)
```bash
plantuml -tsvg architecture-overview.puml
```

### PDF
```bash
plantuml -tpdf architecture-overview.puml
```

## Customization

The diagrams use the `plain` theme for maximum compatibility. You can customize them by:

1. **Changing themes**: Modify `!theme plain` to other themes like `!theme bluegray`
2. **Adjusting colors**: Edit the color definitions (e.g., `FRONTEND_COLOR`)
3. **Adding elements**: PlantUML supports various diagram types and elements

### Available PlantUML Diagram Types

- **Component diagrams**: `component`, `package`, `interface`
- **Activity diagrams**: `start`, `stop`, `if`, `partition`
- **Class diagrams**: `class`, `abstract class`, `enum`, `interface`
- **Sequence diagrams**: `participant`, `->`, `-->`, `activate`

## Diagram Dependencies

All diagrams are self-contained and have no external dependencies other than PlantUML itself.

## Regenerating Diagrams

To regenerate all diagrams after making changes:

```bash
# From the figures directory
cd figures/

# Generate all formats
plantuml -tsvg *.puml
plantuml -tpng *.puml

# Or use the included script (if available)
./generate-diagrams.sh
```

## Contributing

When adding new diagrams:

1. Use the `.puml` extension
2. Follow the naming convention: `lowercase-with-hyphens.puml`
3. Include a title using `title Voyager Compiler - Your Title`
4. Add a legend explaining symbols and colors
5. Include relevant notes for key components
6. Update this README with a description

## Diagram Quality Guidelines

For best results:
- Keep diagrams focused on a single aspect
- Use consistent colors across related diagrams
- Add legends for clarity
- Include code examples where helpful
- Avoid overcrowding - split complex diagrams into multiple views

## Additional Resources

- [PlantUML Official Documentation](https://plantuml.com/)
- [PlantUML Guide](https://plantuml-documentation.readthedocs.io/)
- [Real World PlantUML](https://real-world-plantuml.com/)
- [PlantUML Cheat Sheet](https://ogom.github.io/draw_uml/plantuml/)

## License

These diagrams are part of the Voyager Compiler project and are subject to the same license.
