#!/bin/bash
###############################################################################
# DeepSeek-OCR 一键环境安装脚本（增强版）
# 功能：
#  - 自动创建 Conda 环境
#  - 安装 PyTorch + vLLM + Flash-Attn
#  - 自动下载 DeepSeek-OCR 模型
#  - 自动安装 Node.js（离线）
#  - 自动配置 npm 国内镜像
#  - 自动安装前端依赖
#  - 自动创建 .env 文件并写入 MODEL_PATH
###############################################################################

set -e
exec > >(tee setup.log) 2>&1

# 彩色输出
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"

echo -e "${GREEN}============================================================${RESET}"
echo -e "🚀 ${YELLOW}DeepSeek-OCR-Web 环境初始化开始...${RESET}"
echo -e "${GREEN}============================================================${RESET}"

# 检查 Conda
if ! command -v conda &> /dev/null; then
    echo -e "${RED}❌ 未检测到 Conda，请先安装 Miniconda 或 Anaconda。${RESET}"
    exit 1
fi

# 初始化 Conda
source $(conda info --base)/etc/profile.d/conda.sh

# 1️⃣ 创建虚拟环境
echo -e "${YELLOW}>>> Step 1. 创建 Conda 环境 deepseek-ocr${RESET}"
conda create -n deepseek-ocr python=3.12.9 -y
conda activate deepseek-ocr

# 2️⃣ 安装 PyTorch (CUDA 11.8)
echo -e "${YELLOW}>>> Step 2. 安装 PyTorch + CUDA 11.8${RESET}"
pip install torch==2.6.0 torchvision==0.21.0 torchaudio==2.6.0 --index-url https://download.pytorch.org/whl/cu118

# 3️⃣ 安装 vLLM
echo -e "${YELLOW}>>> Step 3. 安装本地 vLLM 包${RESET}"
VLLM_PKG="./packages/vllm-0.8.5+cu118-cp38-abi3-manylinux1_x86_64.whl"
if [ -f "$VLLM_PKG" ]; then
    pip install "$VLLM_PKG"
else
    echo -e "${RED}❌ 未找到 $VLLM_PKG 文件，请检查路径是否正确。${RESET}"
    exit 1
fi

# 4️⃣ 安装 Python 项目依赖
echo -e "${YELLOW}>>> Step 4. 安装 requirements.txt + flash-attn${RESET}"
pip install -r requirements.txt
pip install flash-attn==2.7.3 --no-build-isolation

# 5️⃣ 自动下载模型
echo -e "${YELLOW}>>> Step 5. 自动下载 DeepSeek-OCR 模型${RESET}"
pip install modelscope
mkdir -p ./deepseek-ocr
modelscope download --model deepseek-ai/DeepSeek-OCR --local_dir ./deepseek-ocr || {
    echo -e "${RED}⚠️ 模型下载失败，请检查网络或 modelscope 登录状态。${RESET}"
}

# 6️⃣ 安装 Node.js（离线优先）
echo -e "${YELLOW}>>> Step 6. 检查 Node.js 环境${RESET}"
if command -v node >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Node.js 已安装：$(node -v)${RESET}"
else
    NODE_TAR="packages/node-v22.21.0-linux-x64.tar.xz"
    if [ -f "$NODE_TAR" ]; then
        echo -e "${YELLOW}📦 正在从本地包安装 Node.js ...${RESET}"
        $SUDO mkdir -p /usr/local/lib/nodejs
        $SUDO tar -xJvf "$NODE_TAR" -C /usr/local/lib/nodejs
        export PATH=/usr/local/lib/nodejs/node-v22.21.0-linux-x64/bin:$PATH
        echo "export PATH=/usr/local/lib/nodejs/node-v22.21.0-linux-x64/bin:\$PATH" >> ~/.bashrc
        source ~/.bashrc
        echo -e "${GREEN}✅ Node.js 安装成功：$(node -v)${RESET}"
    else
        echo -e "${RED}❌ 未找到 Node.js 安装包，请将 node-v22.21.0-linux-x64.tar.xz 放入 packages/。${RESET}"
        exit 1
    fi
fi

# 7️⃣ 配置 npm 国内镜像 + 安装前端依赖
echo -e "${YELLOW}>>> Step 7. 配置 npm 镜像并安装前端依赖${RESET}"
npm config set registry https://registry.npmmirror.com

if [ -d "frontend" ]; then
    cd frontend
    echo -e "${YELLOW}📦 正在安装前端依赖...${RESET}"
    npm install
    cd ..
    echo -e "${GREEN}✅ 前端依赖安装完成${RESET}"
else
    echo -e "${YELLOW}⚠️ 未找到 frontend 目录，跳过 npm install。${RESET}"
fi


# 8️⃣ 创建 .env 文件

# 获取当前项目根目录的绝对路径
PROJECT_DIR=$(pwd)
MODEL_DIR="${PROJECT_DIR}/deepseek-ocr"

# 创建 .env
echo -e "${YELLOW}>>> Step 8. 检查或创建 .env 文件${RESET}"
if [ ! -f ".env" ]; then
    echo "MODEL_PATH=${MODEL_DIR}" > .env
    echo -e "${GREEN}✅ 已创建 .env 文件并写入绝对路径${RESET}"
else
    if ! grep -q "MODEL_PATH=" .env; then
        echo "MODEL_PATH=${MODEL_DIR}" >> .env
        echo -e "${GREEN}✅ 已向现有 .env 添加 MODEL_PATH（绝对路径）${RESET}"
    else
        echo -e "${YELLOW}ℹ️ 检测到已有 .env 文件，已跳过写入${RESET}"
    fi
fi

# ✅ 安装完成
echo -e "${GREEN}============================================================${RESET}"
echo -e "🎉 所有依赖和模型已安装完成！"
echo -e "📦 模型路径：./deepseek-ocr"
echo -e "⚙️  环境配置文件：.env"
echo -e "🧾 安装日志：setup.log"
echo -e "${GREEN}============================================================${RESET}"
