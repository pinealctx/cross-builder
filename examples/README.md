# 交叉编译测试示例

这个目录包含了用于测试交叉编译环境的示例代码。

## 文件说明

- `test.c` - 简单的 C 程序，显示系统和编译信息
- `Makefile` - 编译脚本，支持多架构编译

## 使用方法

### 1. 编译 AMD64 版本

```bash
# 进入交互式容器
docker run -it --rm -v $(pwd):/workspace xsyphon/cross-builder:1.0

# 在容器内编译
cd examples
compile_x64 gcc -o test_x64 test.c

# 运行测试
./test_x64
```

### 2. 编译 ARM64 版本

```bash
# 在容器内编译
compile_arm64 gcc -o test_arm64 test.c

# 查看文件类型
file test_arm64
```

### 3. 使用 Makefile

```bash
# 编译所有版本
make all

# 只编译 x64 版本
make x64

# 只编译 arm64 版本
make arm64

# 清理
make clean
```

## 预期输出

### AMD64 版本输出示例：
```
=== 交叉编译测试程序 ===
系统信息:
  操作系统: Linux
  主机名:   container-id
  内核版本: 5.15.0
  架构:     x86_64
编译信息:
  目标架构: x86_64 (AMD64)
  编译器:   GCC 13.2.0
  进程ID:   123
✅ 交叉编译测试成功！
```

### ARM64 版本（在 x64 系统上无法直接运行，但可以查看文件类型）：
```bash
$ file test_arm64
test_arm64: ELF 64-bit LSB pie executable, ARM aarch64, version 1 (SYSV), dynamically linked
```
