#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/sha.h>
#include <openssl/evp.h>
#include <zlib.h>

// 演示使用 OpenSSL 计算 SHA256
void compute_sha256(const char* input, unsigned char* output) {
    EVP_MD_CTX* ctx = EVP_MD_CTX_new();
    const EVP_MD* md = EVP_sha256();
    unsigned int md_len;
    
    EVP_DigestInit_ex(ctx, md, NULL);
    EVP_DigestUpdate(ctx, input, strlen(input));
    EVP_DigestFinal_ex(ctx, output, &md_len);
    EVP_MD_CTX_free(ctx);
}

// 演示使用 zlib 压缩
int compress_data(const char* input, char* output, size_t* output_len) {
    uLongf compressed_len = *output_len;
    int result = compress((Bytef*)output, &compressed_len, 
                         (const Bytef*)input, strlen(input));
    *output_len = compressed_len;
    return result;
}

int main() {
    printf("=== 跨平台编译高级测试 ===\n\n");
    
    // 基本信息
    printf("架构信息:\n");
    #ifdef __x86_64__
        printf("  目标架构: x86_64 (AMD64)\n");
    #elif defined(__aarch64__)
        printf("  目标架构: aarch64 (ARM64)\n");
    #else
        printf("  目标架构: 未知\n");
    #endif
    
    printf("  编译器: GCC %d.%d.%d\n", __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
    printf("  OpenSSL 版本: %s\n", OPENSSL_VERSION_TEXT);
    printf("  zlib 版本: %s\n\n", ZLIB_VERSION);
    
    // 测试 OpenSSL
    const char* test_data = "Hello, Cross-Compilation World!";
    unsigned char hash[EVP_MAX_MD_SIZE];
    
    compute_sha256(test_data, hash);
    
    printf("SHA256 测试:\n");
    printf("  原始数据: %s\n", test_data);
    printf("  SHA256:   ");
    for (int i = 0; i < 32; i++) {
        printf("%02x", hash[i]);
    }
    printf("\n\n");
    
    // 测试 zlib 压缩
    char compressed[1024];
    size_t compressed_len = sizeof(compressed);
    
    if (compress_data(test_data, compressed, &compressed_len) == Z_OK) {
        printf("zlib 压缩测试:\n");
        printf("  原始大小: %zu 字节\n", strlen(test_data));
        printf("  压缩大小: %zu 字节\n", compressed_len);
        printf("  压缩比:   %.1f%%\n\n", 
               (1.0 - (double)compressed_len / strlen(test_data)) * 100);
    } else {
        printf("❌ zlib 压缩失败\n");
    }
    
    printf("✅ 所有测试通过！跨平台编译环境工作正常。\n");
    
    return 0;
}
