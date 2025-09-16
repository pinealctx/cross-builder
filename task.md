### Build a cross-compiler environment

#### Overview

我当前的系统是MacOS，对于go，rust，java，python这些语言来说，跨平台编译已经非常成熟了。
但我常常需要在MacOS上编译一些Linux上使用的C/C++程序和库，主要有几个用途：
1. 编译独立的C/C++程序，在Linux上运行
2. 编译C/C++库，供go，rust，java，python等语言封装调用

#### 实现方式

我在本机安装了Docker，我打算利用Docker做一个编译环境，它的基础镜像是ubuntu:24.04，我希望在它里面安装好C/C++编译环境和常用的库，然后我就可以在这个环境里面编译出Linux下的可执行文件和库文件。我的MacOS是Amd64架构的CPU，所以我打算先在Docker中做一个Amd64的Linux编译环境，另外也希望在Docker中安装好可以编译ARM64架构的Linux交叉编译工具链。

我希望把这个Docker做成一个基础镜像，命名为xsyphon/cross-builder:1.0，然后我可以在启动时mount本机的代码目录到容器中，然后在容器中编译代码。

- 先做Dockerfile
- 再做Docker镜像
- 最后测试外加输出一些文档来描述如何在本机使用这个镜像做交叉编译。

#### Toolchain

```# Install build-essential for C/C++ compilation
  build-essential
```

```# 在x64的Linux上的C/C++交叉编译环境(arm64)
  binutils-aarch64-linux-gnu cpp-13-aarch64-linux-gnu cpp-aarch64-linux-gnu
  gcc-13-aarch64-linux-gnu gcc-13-aarch64-linux-gnu-base gcc-13-cross-base
  gcc-14-cross-base libasan8-arm64-cross libatomic1-arm64-cross
  libc6-arm64-cross libc6-dev-arm64-cross libgcc-13-dev-arm64-cross
  libgcc-s1-arm64-cross libgomp1-arm64-cross libhwasan0-arm64-cross
  libitm1-arm64-cross liblsan0-arm64-cross libstdc++6-arm64-cross
  libtsan2-arm64-cross libubsan1-arm64-cross linux-libc-dev-arm64-cross

  binutils-aarch64-linux-gnu cpp-13-aarch64-linux-gnu cpp-aarch64-linux-gnu
  gcc-13-aarch64-linux-gnu gcc-13-aarch64-linux-gnu-base gcc-13-cross-base
  gcc-14-cross-base gcc-aarch64-linux-gnu libasan8-arm64-cross
  libatomic1-arm64-cross libc6-arm64-cross libc6-dev-arm64-cross
  libgcc-13-dev-arm64-cross libgcc-s1-arm64-cross libgomp1-arm64-cross
  libhwasan0-arm64-cross libitm1-arm64-cross liblsan0-arm64-cross
  libstdc++6-arm64-cross libtsan2-arm64-cross libubsan1-arm64-cross
  linux-libc-dev-arm64-cross
```