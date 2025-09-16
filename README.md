# xsyphon/cross-builder:1.0 使用文档

一个基于 Ubuntu 24.04 的跨平台 C/C++ 编译环境，支持 AMD64 native 编译和 ARM64 交叉编译。

## 🚀 快速开始

### 1. 构建镜像

```bash
# 克隆或下载代码到本地
cd cross-builder

# 构建镜像
chmod +x build.sh
./build.sh
```

### 2. 验证安装

```bash
# 检查 AMD64 编译器
docker run --rm xsyphon/cross-builder:1.0 gcc --version

# 检查 ARM64 交叉编译器
docker run --rm xsyphon/cross-builder:1.0 aarch64-linux-gnu-gcc --version
```

## 📖 使用方法

### 交互式使用

```bash
# 启动交互式容器，挂载当前目录
docker run -it --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0

# 在容器内使用帮助命令
help

# 编译 AMD64 版本
compile_x64 gcc -o myapp myapp.c

# 编译 ARM64 版本
compile_arm64 gcc -o myapp_arm64 myapp.c
```

### 非交互式使用

```bash
# 直接执行编译命令
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_x64 gcc -o myapp myapp.c

# 执行 make 构建
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_arm64 make
```

### 使用 CMake

```bash
# 进入容器
docker run -it --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0

# AMD64 构建
mkdir build_x64 && cd build_x64
compile_x64 cmake ..
compile_x64 make

# ARM64 构建
cd ..
mkdir build_arm64 && cd build_arm64
compile_arm64 cmake -DCMAKE_TOOLCHAIN_FILE=/usr/share/cmake/Modules/Platform/Linux-aarch64.cmake ..
compile_arm64 make
```

## 🔧 内置工具

### 编译器和工具链
- **GCC/G++**: AMD64 native 和 ARM64 交叉编译
- **CMake**: 现代 C++ 构建系统
- **Make**: 传统构建工具
- **Ninja**: 快速构建系统
- **pkg-config**: 库配置管理

### 开发工具
- **GDB**: 调试器
- **Valgrind**: 内存检测工具
- **Git**: 版本控制
- **Python3**: 脚本支持

### 常用库
- **OpenSSL**: 加密库 (AMD64 + ARM64)
- **zlib**: 压缩库 (AMD64 + ARM64)
- **libcurl**: HTTP 客户端库
- **SQLite**: 嵌入式数据库
- **JSON-C**: JSON 解析库

## 📝 编译示例

### 简单 C 程序

```c
// hello.c
#include <stdio.h>

int main() {
    printf("Hello from cross-compiler!\n");
    return 0;
}
```

```bash
# 编译 AMD64 版本
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_x64 gcc -o hello_x64 hello.c

# 编译 ARM64 版本
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_arm64 gcc -o hello_arm64 hello.c

# 检查生成的二进制文件
file hello_x64 hello_arm64
```

### 链接外部库

```bash
# 链接 OpenSSL (AMD64)
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_x64 gcc -o myapp myapp.c -lssl -lcrypto

# 链接 OpenSSL (ARM64)
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_arm64 gcc -o myapp_arm64 myapp.c -lssl -lcrypto
```

### 使用 pkg-config

```bash
# 查找库的编译参数
docker run --rm xsyphon/cross-builder:1.0 pkg-config --cflags --libs openssl

# 在编译中使用
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_x64 gcc -o myapp myapp.c $(pkg-config --cflags --libs openssl)
```

## 🔄 常用工作流

### 为 Go 项目编译 C 库

```bash
# 编译 CGO 所需的 ARM64 库
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_arm64 gcc -shared -fPIC -o libmylib_arm64.so mylib.c

# 编译 AMD64 库
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_x64 gcc -shared -fPIC -o libmylib_x64.so mylib.c
```

### 为 Python 编译扩展

```bash
# 编译 Python C 扩展
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_arm64 gcc -shared -fPIC -I/usr/include/python3.12 \
    -o mymodule_arm64.so mymodule.c
```

### 静态链接编译

```bash
# 编译静态链接的可执行文件
docker run --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 \
    compile_arm64 gcc -static -o myapp_static_arm64 myapp.c
```

## 🐛 故障排除

### 常见问题

1. **找不到库文件**
   ```bash
   # 检查可用的库
   docker run --rm xsyphon/cross-builder:1.0 \
       find /usr/lib/aarch64-linux-gnu -name "*.so" | grep yourlib
   ```

2. **头文件缺失**
   ```bash
   # 安装额外的开发包
   docker run --rm xsyphon/cross-builder:1.0 \
       apt-get update && apt-get install -y libfoo-dev:arm64
   ```

3. **pkg-config 配置**
   ```bash
   # 检查 pkg-config 路径
   docker run --rm xsyphon/cross-builder:1.0 \
       echo $PKG_CONFIG_PATH
   ```

### 调试技巧

```bash
# 进入容器调试
docker run -it --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0 /bin/bash

# 查看编译器的详细信息
compile_arm64 gcc -v

# 查看链接器搜索路径
compile_arm64 gcc -print-search-dirs
```

## 📦 扩展镜像

如果需要额外的库或工具，可以基于这个镜像创建自定义版本：

```dockerfile
FROM xsyphon/cross-builder:1.0

# 安装额外的库
RUN apt-get update && apt-get install -y \
    libmylib-dev \
    libmylib-dev:arm64 \
    && rm -rf /var/lib/apt/lists/*

# 添加自定义工具
COPY my-build-script.sh /usr/local/bin/
```

## 🤝 贡献

如果你发现问题或需要添加新功能，欢迎提交 issue 或 pull request。

## 📄 许可证

MIT License
