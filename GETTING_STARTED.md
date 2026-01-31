# 项目探索快速开始指南 / Quick Start Guide for Project Exploration

[English version below / 英文版本在下方]

---

## 中文版

### 如何开始探索 Voyager Compiler 项目？

本项目现已包含全面的架构文档和可视化图表，帮助您快速理解项目的设计思路、架构和示例应用。

### 📚 文档资源

1. **[架构指南（中文）](ARCHITECTURE_CN.md)**
   - 完整的项目概述和设计理念
   - 系统架构详解
   - 核心组件说明
   - 完整的编译流程
   - 量化框架详解
   - 示例应用说明
   - 快速开始教程

2. **[Architecture Guide (English)](ARCHITECTURE.md)**
   - 英文版架构文档
   - 完整的技术文档和代码示例

### 📊 架构图表

所有图表使用 PlantUML 格式，位于 `figures/` 目录：

1. **[快速参考图](figures/quick-reference.puml)**
   - 一页纸概览整个系统
   - 适合快速了解项目全貌

2. **[架构概览图](figures/architecture-overview.puml)**
   - 详细的组件关系图
   - 数据流向和模块组织

3. **[编译流程图](figures/compilation-pipeline.puml)**
   - 8个编译阶段的详细流程
   - 关键函数和 API 调用

4. **[量化框架图](figures/quantization-framework.puml)**
   - 量化系统的类图和工作流
   - 支持的数据类型

### 🎨 查看图表

#### 在线查看

1. 访问 [PlantUML Web Server](https://www.plantuml.com/plantuml/uml/)
2. 复制粘贴 `.puml` 文件内容
3. 即可查看渲染后的图表

#### 本地生成

```bash
# 进入 figures 目录
cd figures/

# 运行生成脚本
./generate-diagrams.sh

# 或手动生成
plantuml -tsvg *.puml  # 生成 SVG 格式（推荐）
plantuml -tpng *.puml  # 生成 PNG 格式
```

### 🚀 快速开始

1. **阅读架构文档**
   ```bash
   # 在浏览器中打开
   open ARCHITECTURE_CN.md  # macOS
   xdg-open ARCHITECTURE_CN.md  # Linux
   ```

2. **查看示例代码**
   ```bash
   # 查看端到端测试示例
   cat test/test_codegen.py
   
   # 查看 ImageNet 示例
   cat examples/imagenet/README.md
   ```

3. **运行第一个示例**
   ```bash
   # 使用虚拟数据快速测试
   python examples/imagenet/main.py -a resnet18 --dummy --evaluate
   ```

### 📖 学习路径建议

1. **初学者**：
   - 先阅读 `README.md` 了解项目基本信息
   - 查看 `figures/quick-reference.puml` 图表
   - 阅读 `ARCHITECTURE_CN.md` 的"项目概述"和"快速开始"部分

2. **开发者**：
   - 详细阅读 `ARCHITECTURE_CN.md` 所有章节
   - 研究 `figures/compilation-pipeline.puml` 了解编译流程
   - 查看 `test/test_codegen.py` 了解 API 使用
   - 探索 `src/voyager_compiler/` 源代码

3. **研究人员**：
   - 阅读论文引用（arXiv:2509.15205）
   - 研究 `figures/quantization-framework.puml` 了解量化系统
   - 查看 `src/voyager_compiler/codegen/` 了解代码生成细节
   - 研究各种示例应用的实现

### 🔧 项目结构概览

```
voyager-compiler/
├── README.md                    # 项目简介
├── ARCHITECTURE_CN.md           # 中文架构文档 ⭐
├── ARCHITECTURE.md              # 英文架构文档 ⭐
├── figures/                     # 架构图表 ⭐
│   ├── README.md
│   ├── quick-reference.puml    # 快速参考图
│   ├── architecture-overview.puml
│   ├── compilation-pipeline.puml
│   └── quantization-framework.puml
├── src/voyager_compiler/        # 核心编译器代码
│   ├── __init__.py             # 主 API
│   ├── quantize_pt2e.py        # 量化框架
│   └── codegen/                # 代码生成
└── examples/                    # 示例应用
    ├── imagenet/               # 图像分类
    ├── language_modeling/      # 语言模型
    └── ...
```

### 💡 关键概念

1. **硬件-软件协同设计**：编译器与加速器紧密结合
2. **PT2E 量化**：基于 PyTorch 2 Export 的量化框架
3. **FX Graph IR**：灵活的中间表示
4. **多阶段编译**：前端、优化、后端分离
5. **Protocol Buffers**：硬件指令序列化

### 🤝 获取帮助

- 查看 [ARCHITECTURE_CN.md](ARCHITECTURE_CN.md) 获取详细文档
- 查看 [figures/README.md](figures/README.md) 了解图表使用
- 联系维护者：Jeffrey Yu (jeffreyy@stanford.edu)

---

## English Version

### How to Start Exploring Voyager Compiler?

This project now includes comprehensive architecture documentation and visualization diagrams to help you quickly understand the design philosophy, architecture, and example applications.

### 📚 Documentation Resources

1. **[Architecture Guide (English)](ARCHITECTURE.md)**
   - Complete project overview and design philosophy
   - System architecture details
   - Core component descriptions
   - Complete compilation pipeline
   - Quantization framework details
   - Example applications
   - Quick start tutorial

2. **[架构指南（中文）](ARCHITECTURE_CN.md)**
   - Chinese version of architecture documentation
   - Complete technical documentation and code examples

### 📊 Architecture Diagrams

All diagrams are in PlantUML format, located in the `figures/` directory:

1. **[Quick Reference](figures/quick-reference.puml)**
   - One-page overview of the entire system
   - Great for getting a quick understanding

2. **[Architecture Overview](figures/architecture-overview.puml)**
   - Detailed component relationship diagram
   - Data flow and module organization

3. **[Compilation Pipeline](figures/compilation-pipeline.puml)**
   - Detailed flow of 8 compilation stages
   - Key functions and API calls

4. **[Quantization Framework](figures/quantization-framework.puml)**
   - Class diagram and workflow of quantization system
   - Supported data types

### 🎨 Viewing Diagrams

#### Online Viewing

1. Visit [PlantUML Web Server](https://www.plantuml.com/plantuml/uml/)
2. Copy and paste `.puml` file content
3. View the rendered diagram

#### Local Generation

```bash
# Navigate to figures directory
cd figures/

# Run generation script
./generate-diagrams.sh

# Or generate manually
plantuml -tsvg *.puml  # Generate SVG format (recommended)
plantuml -tpng *.puml  # Generate PNG format
```

### 🚀 Quick Start

1. **Read the architecture documentation**
   ```bash
   # Open in browser
   open ARCHITECTURE.md  # macOS
   xdg-open ARCHITECTURE.md  # Linux
   ```

2. **View example code**
   ```bash
   # View end-to-end test example
   cat test/test_codegen.py
   
   # View ImageNet example
   cat examples/imagenet/README.md
   ```

3. **Run your first example**
   ```bash
   # Quick test with dummy data
   python examples/imagenet/main.py -a resnet18 --dummy --evaluate
   ```

### 📖 Recommended Learning Path

1. **Beginners**:
   - Read `README.md` for basic project information
   - View `figures/quick-reference.puml` diagram
   - Read "Project Overview" and "Getting Started" in `ARCHITECTURE.md`

2. **Developers**:
   - Read all chapters of `ARCHITECTURE.md` in detail
   - Study `figures/compilation-pipeline.puml` to understand the compilation flow
   - Review `test/test_codegen.py` for API usage
   - Explore `src/voyager_compiler/` source code

3. **Researchers**:
   - Read the cited paper (arXiv:2509.15205)
   - Study `figures/quantization-framework.puml` for quantization system
   - Review `src/voyager_compiler/codegen/` for code generation details
   - Study various example application implementations

### 🔧 Project Structure Overview

```
voyager-compiler/
├── README.md                    # Project introduction
├── ARCHITECTURE.md              # English architecture docs ⭐
├── ARCHITECTURE_CN.md           # Chinese architecture docs ⭐
├── figures/                     # Architecture diagrams ⭐
│   ├── README.md
│   ├── quick-reference.puml    # Quick reference
│   ├── architecture-overview.puml
│   ├── compilation-pipeline.puml
│   └── quantization-framework.puml
├── src/voyager_compiler/        # Core compiler code
│   ├── __init__.py             # Main API
│   ├── quantize_pt2e.py        # Quantization framework
│   └── codegen/                # Code generation
└── examples/                    # Example applications
    ├── imagenet/               # Image classification
    ├── language_modeling/      # Language models
    └── ...
```

### 💡 Key Concepts

1. **Hardware-Software Co-design**: Tight coupling between compiler and accelerator
2. **PT2E Quantization**: PyTorch 2 Export-based quantization framework
3. **FX Graph IR**: Flexible intermediate representation
4. **Multi-stage Compilation**: Frontend, optimization, backend separation
5. **Protocol Buffers**: Hardware instruction serialization

### 🤝 Getting Help

- See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed documentation
- See [figures/README.md](figures/README.md) for diagram usage
- Contact maintainer: Jeffrey Yu (jeffreyy@stanford.edu)

---

**Note**: Diagrams may show some warnings when generated with older PlantUML versions (< 2021), but they will still render correctly. For best results, use PlantUML version 2021 or later.
