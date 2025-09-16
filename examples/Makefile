# Makefile for cross-compilation testing

# 默认目标
all: x64 arm64 advanced

# x64 (AMD64) 编译
x64: test_x64

test_x64: test.c
	@echo "编译 AMD64 版本..."
	gcc -o test_x64 test.c
	@echo "✅ AMD64 编译完成"

# ARM64 编译
arm64: test_arm64

test_arm64: test.c
	@echo "编译 ARM64 版本..."
	aarch64-linux-gnu-gcc -o test_arm64 test.c
	@echo "✅ ARM64 编译完成"

# 高级测试 (链接 OpenSSL 和 zlib)
advanced: advanced_x64 advanced_arm64

advanced_x64: advanced_test.c
	@echo "编译 AMD64 高级测试..."
	gcc -o advanced_x64 advanced_test.c -lssl -lcrypto -lz
	@echo "✅ AMD64 高级测试编译完成"

advanced_arm64: advanced_test.c
	@echo "编译 ARM64 高级测试..."
	aarch64-linux-gnu-gcc -o advanced_arm64 advanced_test.c -lssl -lcrypto -lz
	@echo "✅ ARM64 高级测试编译完成"

# 运行测试 (只能运行与主机架构匹配的版本)
test: test_x64
	@echo "运行 AMD64 测试..."
	./test_x64

test-advanced: advanced_x64
	@echo "运行 AMD64 高级测试..."
	./advanced_x64

# 显示文件信息
info:
	@echo "=== 编译产物信息 ==="
	@if [ -f test_x64 ]; then \
		echo "AMD64 基础测试:"; \
		file test_x64; \
		ls -la test_x64; \
		echo ""; \
	fi
	@if [ -f test_arm64 ]; then \
		echo "ARM64 基础测试:"; \
		file test_arm64; \
		ls -la test_arm64; \
		echo ""; \
	fi
	@if [ -f advanced_x64 ]; then \
		echo "AMD64 高级测试:"; \
		file advanced_x64; \
		ls -la advanced_x64; \
		echo ""; \
	fi
	@if [ -f advanced_arm64 ]; then \
		echo "ARM64 高级测试:"; \
		file advanced_arm64; \
		ls -la advanced_arm64; \
		echo ""; \
	fi

# 清理
clean:
	rm -f test_x64 test_arm64 advanced_x64 advanced_arm64

# 声明伪目标
.PHONY: all x64 arm64 advanced test test-advanced info clean
