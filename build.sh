#!/bin/bash

# 构建 xsyphon/cross-builder 镜像的脚本

set -e

IMAGE_NAME="xsyphon/cross-builder"
IMAGE_TAG="1.0"
FULL_IMAGE_NAME="${IMAGE_NAME}:${IMAGE_TAG}"

echo "=== 构建 ${FULL_IMAGE_NAME} 镜像 ==="

# 检查 Docker 是否运行
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker 未运行，请先启动 Docker"
    exit 1
fi

# 构建镜像
echo "开始构建镜像..."
docker build -t "$FULL_IMAGE_NAME" .

if [ $? -eq 0 ]; then
    echo "✅ 镜像构建成功: $FULL_IMAGE_NAME"
    
    # 显示镜像信息
    echo ""
    echo "=== 镜像信息 ==="
    docker images "$IMAGE_NAME"
    
    echo ""
    echo "=== 测试镜像 ==="
    docker run --rm "$FULL_IMAGE_NAME" gcc --version
    echo ""
    docker run --rm "$FULL_IMAGE_NAME" aarch64-linux-gnu-gcc --version
    
    echo ""
    echo "🎉 构建完成！"
    echo ""
    echo "使用方法："
    echo "  # 交互式使用"
    echo "  docker run -it --rm -v \$(pwd):/workspace $FULL_IMAGE_NAME"
    echo ""
    echo "  # 直接编译"
    echo "  docker run --rm -v \$(pwd):/workspace $FULL_IMAGE_NAME compile_x64 make"
    echo "  docker run --rm -v \$(pwd):/workspace $FULL_IMAGE_NAME compile_arm64 make"
else
    echo "❌ 镜像构建失败"
    exit 1
fi
