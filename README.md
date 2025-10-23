<div align="center">
  <h1>DeepSeek-OCR Frontend Tool</h1>
  <span><a href="./README_zh.md">中文</a> | English</span>
</div>

## ⚡ Project Overview

This project is a document parsing tool based on DeepSeek-OCR. The tool can efficiently process PDF documents and images, providing powerful Optical Character Recognition (OCR) capabilities, supporting multi-language text recognition, table parsing, chart analysis, and many other features.

### Key Features

- **Multi-format Document Parsing**: Supports uploading and parsing documents in various formats such as PDF and images
- **Intelligent OCR Recognition**: Based on the DeepSeek-OCR model, providing high-precision text recognition
- **Layout Analysis**: Intelligently recognizes document layout structure and accurately extracts content layout
- **Multi-language Support**: Supports text recognition in multiple languages including Chinese and English
- **Table & Chart Parsing**: Professional table recognition and chart data extraction functionality
- **Professional Domain Drawing Recognition**: Supports semantic recognition of various professional domain drawings
- **Data Visualization**: Supports reverse parsing of data analysis visualization charts
- **Markdown Conversion**: Converts PDF content to structured Markdown format

## 👀 Project Demo

<div align="center">

**PDF Document Parsing - Supports complex content including images and tables**

<img src="assets/文档解析.gif" width="600" alt="Document Parsing">

</div>

<div align="center">

| Multi-language Text Parsing | Chart & Table Parsing |
|:---:|:---:|
| <img src="assets/多语种.gif" width="400" alt="Multi-language Text Parsing"> | <img src="assets/表格解析.gif" width="400" alt="Chart & Table Parsing"> |

</div>

<div align="center">

| Professional Domain Drawing Recognition<br/>(CAD, Flowcharts, Decorative Drawings) | Data Visualization Chart<br/>Reverse Parsing |
|:---:|:---:|
| <img src="assets/CAD图纸语义解析.gif" width="400" alt="CAD Drawing Semantic Recognition"> | <img src="assets/图表逆向表格.gif" width="400" alt="Data Visualization Chart Reverse Parsing"> |

</div>

## 🚀 Usage Guide

### System Requirements

⚠️ **Important Notice**:
- **Operating System**: Requires running on Linux system
- **GPU Requirements**: GPU ≥ 7 GB VRAM (16–24 GB recommended for large images/multi-page PDFs)
- **Compatibility Note**: RTX 50 series GPUs are currently not compatible, please use other GPU models
- **Python Version**: 3.10–3.12 (3.10/3.11 recommended)
- **CUDA Version**: 11.8 or 12.1/12.2 (must match GPU driver)
- **PyTorch**: Requires installing pre-compiled version matching CUDA

### Quick Start

#### Step 1: Model Weight Download
First, you need to download the DeepSeek-OCR model weights, which can be obtained from **Hugging Face** or **ModelScope**. The following example uses **ModelScope**:

```bash
pip install modelscope
mkdir ./deepseek-ocr
modelscope download --model deepseek-ai/DeepSeek-OCR --local_dir ./deepseek-ocr
```

#### Step 2: Runtime Environment Setup
Download the official project package

```bash
git clone https://github.com/deepseek-ai/DeepSeek-OCR.git
```

Create a virtual environment to install model runtime dependencies

```bash
conda create -n deepseek-ocr python=3.12.9 -y
conda activate deepseek-ocr
```

Install Jupyter and corresponding kernel

```bash
conda install jupyterlab
conda install ipykernel
python -m ipykernel install --user --name dsocr --display-name "Python (dsocr)"
```

Install PyTorch related components

```bash
pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu118
```

Install vLLM framework officially recommended by DeepSeek-OCR

> Due to different base dependencies, you need to install a specific version of vLLM to run the DeepSeek-OCR model.

Download [specific version of vLLM pre-compiled binary installation package](https://github.com/vllm-project/vllm/releases/download/v0.8.5/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl)

```bash
wget --content-disposition "https://github.com/vllm-project/vllm/releases/download/v0.8.5/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl"
```

Install the downloaded vLLM

```Bash
pip install vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl
```

Install project basic dependencies

```Bash
cd ./DeepSeek-OCR/
pip install -r requirements.txt
```

If dependency conflicts appear during installation as shown in the image, you can ignore them as they won't affect actual operation.

<img src="assets\3b6eecd322d1ac8aa411e53fd8eefc2f.png"/>

Install flash-attn acceleration library.

```Bash
pip install flash-attn==2.7.3 --no-build-isolation
```

Create a `.env` file in the project root directory and enter the model runtime address, for example:
```
MODEL_PATH=/root/autodl-tmp/deepseek-ocr
```

#### Step 3: Start Backend Service

Start the backend
```bash
uvicorn main:app --host 0.0.0.0 --port 8002 --reload
```

#### Step 4: Start Frontend Service
Install frontend dependencies
```bash
npm install
```

Start the frontend
```bash
npm run dev
```

After successful startup, access the frontend address in your browser to use the tool.

## 🙈 Contributing
We welcome contributions to the project through GitHub PR submissions or issues. We very much welcome any form of contribution, including feature improvements, bug fixes, or documentation optimization.

## 😎 Technical Communication
Scan to add our assistant, reply "DeepSeekOCR" to join the technical communication group and exchange learning with other partners.

<div align="center">
<img src="assets\afe0e4d094987b00012c5129a38ade24.png" width="200" alt="Technical Communication Group QR Code">
<div>