#include <stdio.h>
#include <sys/utsname.h>
#include <unistd.h>

int main() {
    struct utsname sys_info;
    
    printf("=== 交叉编译测试程序 ===\n");
    
    if (uname(&sys_info) == 0) {
        printf("系统信息:\n");
        printf("  操作系统: %s\n", sys_info.sysname);
        printf("  主机名:   %s\n", sys_info.nodename);
        printf("  内核版本: %s\n", sys_info.release);
        printf("  架构:     %s\n", sys_info.machine);
    }
    
    printf("\n编译信息:\n");
    #ifdef __x86_64__
        printf("  目标架构: x86_64 (AMD64)\n");
    #elif defined(__aarch64__)
        printf("  目标架构: aarch64 (ARM64)\n");
    #else
        printf("  目标架构: 未知\n");
    #endif
    
    #ifdef __GNUC__
        printf("  编译器:   GCC %d.%d.%d\n", __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
    #endif
    
    printf("  进程ID:   %d\n", getpid());
    
    printf("\n✅ 交叉编译测试成功！\n");
    
    return 0;
}
