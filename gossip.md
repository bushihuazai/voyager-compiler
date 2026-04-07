# 🗣️ Voyager Compiler — Project Gossip

> A behind-the-scenes look at the interesting architecture, technologies, and design points of the Voyager Compiler.

---

## What Is This Project?

Voyager Compiler is a **hardware-software co-designed ML compiler** that maps PyTorch models onto Voyager-generated DNN accelerators. Think of it as a bridge between the high-level world of PyTorch and the low-level world of custom silicon — it takes neural networks and compiles them into instruction bitstreams that specialized hardware can execute.

The compiler has been validated on a broad roster of model families: CNNs (ResNet, MobileNet, EfficientNet), Transformers (BERT, ViT, MobileBERT), LLMs (GPT-2, LLaMA), detection (YOLO), and even state-space models (Mamba).

---

## 🏗️ Architecture Highlights

### The Pipeline: A Clean Sequential Compilation Flow

The compilation pipeline is refreshingly modular and reads like a recipe:

```
PyTorch Model → PT2E Export → Quantization → Shape Propagation
→ Lowering → Padding → Tiling → Data Layout Transform
→ Operator Fusion → Memory Mapping → Code Generation → IR Serialization
```

Each stage is **independently configurable** — you can swap, skip, or tune any phase without breaking the rest. This is a major architectural win for a research-stage compiler.

### torch.fx as the Central Representation

The entire compiler is built on **torch.fx graphs**. Every transformation pass reads and writes `torch.fx.Node` metadata, which carries tensor shapes, dtypes, quantization parameters, memory allocation info, and hardware-specific hints. This is a smart choice: it keeps the compiler tightly integrated with PyTorch's own graph representation, avoiding a costly translation to a completely custom IR.

### A Purpose-Built Hardware IR

The final compilation output is serialized via **Protocol Buffers** (`param.proto` → `param_pb2.py`). This IR captures operations, tensors, memory locations, and banking information — everything an accelerator backend needs. It decouples the compiler from the actual hardware implementation, so the same compiler can target different Voyager-generated accelerators.

### Memory as a First-Class Citizen

Memory management isn't an afterthought — it's a core pillar:

- **Banking Strategies** (`banking.py`): Different operation types (conv, GEMM, elementwise, pooling) get different memory banking strategies, all managed through a centralized `BankingStrategyRegistry`. The goal is to minimize bank conflicts during execution.
- **Multi-Tier Memory Model**: The compiler explicitly models DRAM, scratchpad/SRAM, and accelerator buffers (ACC), allocating tensors across these tiers based on access patterns.
- **Live-Range Analysis**: A `MemoryAllocator` tracks tensor lifetimes across partitions, and there's even a matplotlib-based memory bank visualizer for debugging.

### L2 Tiling — The Largest Single Module

The tiling pass (`tiling.py`, 1,553 lines) is the single largest module in the codebase. It breaks large operations into cache-friendly chunks optimized for the L2 cache of the target accelerator. There are separate tiling strategies for matrix operations (GEMM) and vector operations, with block-level optimization that's highly parameterized by hardware specs (cache size, unroll dimensions, systolic array shape).

---

## 🔧 Technology Choices

### PyTorch 2 Export (PT2E) — Betting on the New Standard

Rather than using older tracing methods (`torch.jit.trace`, TorchScript), the compiler is built on **PT2E** — PyTorch's modern export protocol for producing static computation graphs. This is a forward-looking bet: PT2E is the sanctioned path for PyTorch compilation going forward, and building on it means the compiler benefits from upstream improvements automatically.

### Quantization: A Deep, Multi-Format System

Quantization isn't just "slap int8 on everything." Voyager Compiler supports an impressive range of number formats:

| Format Category | Supported Types |
|----------------|-----------------|
| Integer | int4, int6, int8, uint variants |
| Floating-Point | fp8 (E4M3, E5M2), custom FP formats |
| Posit | Variable exponent size (hardware-friendly) |
| NormalFloat | NF4, NF6 (from bitsandbytes) |
| Microscaling (MX) | Block-wise with shared exponents |

The system uses a **string-based spec parser** that lets you configure quantization inline:

```
"nf4_6,qs=microscaling,bs=64,ax=-1,scale=fp8_e5m3"
```

This is remarkably expressive — one string controls the data type, quantization scheme, block size, axis, and scale format.

### Protocol Buffers for IR Serialization

Using protobuf for the hardware IR is pragmatic: it's language-neutral, compact, and well-tooled. The auto-generated `param_pb2.py` handles serialization, letting the compiler output binary instruction streams that any protobuf-compatible backend can consume.

### Dependency Choices

The project pins specific versions for stability (`transformers==4.57.1`, `peft==0.6.2`) while keeping PyTorch flexible. Notable dependencies include:

- **`torchao`** — PyTorch's Algorithmic Optimization library (cutting-edge quantization support)
- **`timm`** — Vision model zoo
- **`peft`** — Parameter-Efficient Fine-Tuning (LoRA support)
- **`graphviz`** — For compute graph visualization
- **`wandb`** — Experiment tracking

---

## 🎨 Design Points Worth Talking About

### 1. The FusedAmaxObsFakeQuantize Pattern

The `fake_quantize.py` module (511 lines) implements `FusedAmaxObsFakeQuantize` — a single module that **combines observer and fake quantization**. Most frameworks keep these separate; fusing them allows the compiler to track running statistics (amax) and apply fake quantization in one pass, which is both simpler and more efficient for quantization-aware training.

### 2. Declarative Operator Matching

Operation mapping uses an `OpMatcher` pattern — declarative rules that match PyTorch operations to hardware operation types. This avoids brittle if-else chains and makes it easy to extend support for new operators.

### 3. Fusion Pipelines as Sequences

Operator fusion is defined as **pipelines** — ordered sequences of operations that can be fused into a single hardware instruction. For example:

```
Conv → Dequantize → ReLU → Quantize → Store
```

Different pipelines exist for vector vs. matrix operations, and they're defined declaratively rather than hard-coded.

### 4. LLM-Specific Optimizations

The `llm_utils.py` module (997 lines) is dedicated to LLM-specific graph transformations:

- **Multi-head attention decomposition** — Breaks attention into hardware-friendly primitives
- **Dequantize-quantize fusion** — Eliminates redundant precision conversions
- **LLaMA attention swapping** — Replaces standard attention patterns with hardware-optimized variants

This level of model-family-specific optimization shows the project is serious about LLM deployment, not just CNN compilation.

### 5. Microscaling Quantization with Outlier Filtering

The microscaling (MX) quantization support includes **outlier filtering** — configurable thresholds that identify and handle statistical outliers before applying block-wise quantization with shared exponents. This is particularly important for LLMs where activation distributions can have extreme outliers (a known challenge in quantizing transformer models).

### 6. Custom Quantized Op Library via `torch.library`

The `decomposed.py` module (898 lines) defines a custom operator library (`quantized_decomposed_lib`) using `torch.library`. This registers custom quantized implementations for conv2d, linear, matmul, layer_norm, softmax, and more — making them first-class citizens in the torch.fx graph rather than opaque function calls.

### 7. Complete Model Rewrites for Quantization

The `modules/quantizable/` directory contains **complete model implementations** (BERT, DistilBERT, GPT, LLaMA, MobileBERT, Whisper) rewritten to be quantization-friendly. This is a significant engineering investment — rather than trying to quantize arbitrary models, the compiler ships curated versions where quantization hooks are carefully placed.

---

## 📊 By the Numbers

| Metric | Value |
|--------|-------|
| Total Python source (src/) | ~21,300 lines |
| Compilation passes | 5 (padding, tiling, data layout, lowering, fusion) |
| Supported number formats | 20+ |
| Model families tested | 10+ |
| Example task categories | 7 (vision, NLP, speech, audio, segmentation) |
| Largest single file | `mapping.py` — 1,839 lines |
| License | MIT |

---

## 🧪 Testing Philosophy

The project uses a single comprehensive end-to-end test (`test/test_codegen.py`, ~28 KB) that exercises the full pipeline:

1. Load a model (ResNet, BERT, GPT-2, LLaMA, etc.)
2. Configure quantization from command-line specs
3. Run PT2E export → prepare → convert
4. Apply all compiler passes (padding, tiling, layout)
5. Compile with hardware parameters (cache size, bank count, unroll dims)
6. Generate output artifacts: `model.txt`, `layers.txt`, tensor dumps, `compute_graph.svg`

This integration-test-heavy approach makes sense for a compiler: individual unit tests for graph transformations would be fragile and hard to maintain, while end-to-end tests verify the entire pipeline produces correct output.

---

## 🔮 What Makes This Interesting

Voyager Compiler sits at a fascinating intersection:

1. **It's not just a quantization tool** — it's a full compilation pipeline from PyTorch to hardware instructions.
2. **It's not just a generic compiler** — it has deep, model-family-specific optimizations (especially for LLMs).
3. **It embraces exotic number formats** — posit, NormalFloat, microscaling — that most compilers ignore.
4. **It treats memory as a first-class concern** — with banking strategies, multi-tier allocation, and live-range analysis baked into the core.
5. **It bets on PT2E** — aligning with PyTorch's future rather than legacy tracing infrastructure.

This is a research-grade compiler with production-quality engineering — the kind of project where hardware designers and ML researchers meet in the middle.
