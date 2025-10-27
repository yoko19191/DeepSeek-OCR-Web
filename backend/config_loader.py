"""
config_loader.py
----------------
该模块负责：
1. 从 .env 文件中加载模型路径与基本配置；
2. 自动创建 workspace 目录结构（uploads / results / logs）；
3. 检查配置合法性并输出当前配置状态；
4. 提供全局常量供其他模块导入使用。
"""

import os
from pathlib import Path
from dotenv import load_dotenv


# ========== Step 1. 定义路径常量 ==========
BASE_DIR = Path(__file__).resolve().parent.parent   # 项目根目录（DeepSeek-OCR）
WORKSPACE_PATH = BASE_DIR / "workspace"
UPLOAD_DIR = WORKSPACE_PATH / "uploads"
RESULTS_DIR = WORKSPACE_PATH / "results"
LOGS_DIR = WORKSPACE_PATH / "logs"


# ========== Step 2. 自动创建 .env.example 文件 ==========
ENV_FILE = BASE_DIR / ".env"
EXAMPLE_ENV_FILE = BASE_DIR / ".env.example"

if not EXAMPLE_ENV_FILE.exists():
    with open(EXAMPLE_ENV_FILE, "w", encoding="utf-8") as f:
        f.write(
            "# DeepSeek-OCR 后端配置文件示例\n"
            "# 请复制为 .env 并修改 MODEL_PATH 路径。\n\n"
            "MODEL_PATH=/root/autodl-tmp/deepseek-ocr\n"
            "DEVICE_ID=0\n"
            "MAX_CONCURRENCY=10\n"
        )


# ========== Step 3. 加载 .env 文件 ==========
if not ENV_FILE.exists():
    print("[⚠️ Warning] 未找到 .env 文件，已创建示例 .env.example。")
    print("请复制 .env.example → .env 并填写 MODEL_PATH 后重新启动。")

load_dotenv(ENV_FILE)


# ========== Step 4. 读取配置项 ==========
MODEL_PATH = os.getenv("MODEL_PATH", None)
DEVICE_ID = os.getenv("DEVICE_ID", "0")
MAX_CONCURRENCY = int(os.getenv("MAX_CONCURRENCY", "10"))


# ========== Step 5. 检查模型路径合法性 ==========
if MODEL_PATH is None or MODEL_PATH.strip() == "":
    raise ValueError("❌ 未在 .env 中设置 MODEL_PATH，请填写模型路径后重启服务。")

if not Path(MODEL_PATH).exists():
    print(f"[⚠️ Warning] 指定的模型路径不存在: {MODEL_PATH}")
    print("请确保已下载 DeepSeek-OCR 模型权重。")


# ========== Step 6. 自动创建工作目录 ==========
for directory in [WORKSPACE_PATH, UPLOAD_DIR, RESULTS_DIR, LOGS_DIR]:
    os.makedirs(directory, exist_ok=True)


# ========== Step 7. 调试输出（打印当前有效配置） ==========
print("=" * 60)
print("🔧 DeepSeek-OCR 后端配置加载完成")
print(f"📁 模型路径:      {MODEL_PATH}")
print(f"🖥️  GPU 设备:     {DEVICE_ID}")
print(f"⚙️  最大并发任务数: {MAX_CONCURRENCY}")
print(f"📂 工作区路径:    {WORKSPACE_PATH}")
print("=" * 60)


# ========== Step 8. 导出可供全局调用的常量 ==========
__all__ = [
    "MODEL_PATH",
    "DEVICE_ID",
    "MAX_CONCURRENCY",
    "WORKSPACE_PATH",
    "UPLOAD_DIR",
    "RESULTS_DIR",
    "LOGS_DIR"
]