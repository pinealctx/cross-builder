# 跨平台 C/C++ 编译环境
# 基于 Ubuntu 24.04，支持 AMD64 native 编译和 ARM64 交叉编译
FROM ubuntu:24.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# 创建工作目录
WORKDIR /workspace

# 配置国内镜像源加速下载
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's@//.*security.ubuntu.com@//mirrors.aliyun.com@g' /etc/apt/sources.list.d/ubuntu.sources

# 更新包管理器并安装基础工具
RUN apt-get update && apt-get install -y \
    # 基础系统工具
    curl \
    wget \
    git \
    unzip \
    zip \
    tar \
    gzip \
    xz-utils \
    ca-certificates \
    software-properties-common \
    # 编译工具链
    build-essential \
    cmake \
    ninja-build \
    pkg-config \
    autotools-dev \
    automake \
    autoconf \
    libtool \
    # 文本处理
    vim \
    && rm -rf /var/lib/apt/lists/*

# 配置多架构支持 (必须在安装交叉编译包之前)
RUN dpkg --add-architecture arm64

# 安装常用开发库 (AMD64 native)
RUN apt-get update && apt-get install -y \
    # 加密和网络库
    libssl-dev \
    libcurl4-openssl-dev \
    # 压缩库
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    # 数据库
    libsqlite3-dev \
    libpq-dev \
    # JSON 和 XML
    libjson-c-dev \
    libxml2-dev \
    libxslt1-dev \
    # 其他常用库
    libreadline-dev \
    libffi-dev \
    libevent-dev \
    libpcre3-dev \
    # 图形和媒体库
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    # 数学库
    libgsl-dev \
    liblapack-dev \
    libopenblas-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装 ARM64 交叉编译工具链
RUN apt-get update && apt-get install -y \
    # ARM64 交叉编译器
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    # ARM64 系统库
    libc6-dev-arm64-cross \
    linux-libc-dev-arm64-cross \
    # ARM64 标准库
    libstdc++6-arm64-cross \
    && rm -rf /var/lib/apt/lists/*

# 安装 ARM64 版本的库 (分开安装以避免冲突)
RUN apt-get update && apt-get install -y \
    zlib1g-dev:arm64 \
    libssl-dev:arm64 \
    libsqlite3-dev:arm64 \
    libffi-dev:arm64 \
    libbz2-dev:arm64 \
    liblzma-dev:arm64 \
    && rm -rf /var/lib/apt/lists/*

# 设置交叉编译环境变量
ENV CC_aarch64_unknown_linux_gnu=aarch64-linux-gnu-gcc
ENV CXX_aarch64_unknown_linux_gnu=aarch64-linux-gnu-g++
ENV AR_aarch64_unknown_linux_gnu=aarch64-linux-gnu-ar
ENV STRIP_aarch64_unknown_linux_gnu=aarch64-linux-gnu-strip

# 创建便捷的编译脚本
RUN echo '#!/bin/bash\n\
# 编译脚本帮助函数\n\
\n\
compile_x64() {\n\
    echo "编译 AMD64 (x86_64) 版本..."\n\
    export CC=gcc\n\
    export CXX=g++\n\
    export AR=ar\n\
    export STRIP=strip\n\
    export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig\n\
    "$@"\n\
}\n\
\n\
compile_arm64() {\n\
    echo "编译 ARM64 (aarch64) 版本..."\n\
    export CC=aarch64-linux-gnu-gcc\n\
    export CXX=aarch64-linux-gnu-g++\n\
    export AR=aarch64-linux-gnu-ar\n\
    export STRIP=aarch64-linux-gnu-strip\n\
    export PKG_CONFIG_PATH=/usr/lib/aarch64-linux-gnu/pkgconfig\n\
    export PKG_CONFIG_LIBDIR=/usr/lib/aarch64-linux-gnu/pkgconfig\n\
    "$@"\n\
}\n\
\n\
show_help() {\n\
    echo "交叉编译环境使用帮助:"\n\
    echo "  compile_x64 <命令>   - 编译 AMD64 版本"\n\
    echo "  compile_arm64 <命令> - 编译 ARM64 版本"\n\
    echo ""\n\
    echo "示例:"\n\
    echo "  compile_x64 make"\n\
    echo "  compile_arm64 cmake .. && make"\n\
    echo ""\n\
    echo "可用的交叉编译器:"\n\
    echo "  gcc (AMD64): $(gcc --version | head -1)"\n\
    echo "  gcc (ARM64): $(aarch64-linux-gnu-gcc --version | head -1)"\n\
}\n\
' > /usr/local/bin/build-helper && chmod +x /usr/local/bin/build-helper

# 设置 bashrc
RUN echo 'source /usr/local/bin/build-helper' >> /root/.bashrc && \
    echo 'alias help="show_help"' >> /root/.bashrc && \
    echo 'echo "欢迎使用 xsyphon/cross-builder 编译环境!"' >> /root/.bashrc && \
    echo 'echo "输入 help 查看使用帮助"' >> /root/.bashrc

# 设置默认工作目录
VOLUME ["/workspace"]
WORKDIR /workspace

# 默认启动 bash
CMD ["/bin/bash"]
