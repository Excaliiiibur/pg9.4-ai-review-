# ✅ 代码已推送！后续步骤

你的仓库：https://github.com/Excaliiiibur/pg9.4test

---

## ⚡ 第 1 步：启用 GitHub Actions

请打开以下链接进行配置（需要登录 GitHub）：

```
https://github.com/Excaliiiibur/pg9.4test/settings/actions
```

### 配置步骤：

1. **页面打开后，在 "Permissions" 部分：**
   ```
   ☑ All actions and reusable workflows are allowed
   ```

2. **继续往下到 "Workflow permissions"：**
   ```
   ☑ Read and write permissions
   ☑ Allow GitHub Actions to create and approve pull requests  
   ```

3. **点击 "Save" 保存**

✅ 完成后，GitHub Actions 就启用了！

---

## ⚡ 第 2 步：创建测试分支和 PR

在你的本地电脑上运行以下命令：

### 2.1 创建测试分支

```powershell
cd c:\data\code\postgres-9.4.24
git checkout -b test-ai-review
```

### 2.2 创建测试文件

创建文件 `src/test_ai_review.c`，包含：

```c
#include "postgres.h"
#include <string.h>

/*
 * 测试文件 - 用于验证 AI 自动审查功能
 * 这个文件故意包含几个问题供 AI 代码审查检测
 */

/* 问题 1: 缓冲区溢出风险 */
void test_strcpy_issue(const char *input) {
    char buffer[256];
    strcpy(buffer, input);  // ⚠️ 没有大小限制，应使用 strncpy
}

/* 问题 2: 内存泄漏 */
char* test_memory_leak() {
    char *ptr = palloc(1024);
    ptr[0] = 'a';
    return ptr;  // 调用者需要 pfree，但没有文档说明
}

/* 问题 3: O(n²) 算法效率低 */
void inefficient_search(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {  // ⚠️ 嵌套循环，O(n²) 复杂度
            if (arr[i] == arr[j]) break;
        }
    }
}
```

### 2.3 创建文件夹（如果不存在）

```powershell
# 如果 src 文件夹不存在，先创建
if (-not (Test-Path src)) {
    New-Item -ItemType Directory -Path src
}

# 创建测试文件
@"
#include "postgres.h"
#include <string.h>

/*
 * 测试文件 - 用于验证 AI 自动审查功能
 * 这个文件故意包含几个问题供 AI 代码审查检测
 */

/* 问题 1: 缓冲区溢出风险 */
void test_strcpy_issue(const char *input) {
    char buffer[256];
    strcpy(buffer, input);  // ⚠️ 没有大小限制，应使用 strncpy
}

/* 问题 2: 内存泄漏 */
char* test_memory_leak() {
    char *ptr = palloc(1024);
    ptr[0] = 'a';
    return ptr;  // 调用者需要 pfree，但没有文档说明
}

/* 问题 3: O(n²) 算法效率低 */
void inefficient_search(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {  // ⚠️ 嵌套循环，O(n²) 复杂度
            if (arr[i] == arr[j]) break;
        }
    }
}
"@ | Out-File -Encoding UTF8 src/test_ai_review.c
```

### 2.4 提交并推送

```powershell
git add src/test_ai_review.c
git commit -m "test: Add file to verify AI code review system"
git push -u origin test-ai-review
```

---

## ⚡ 第 3 步：在 GitHub 创建 PR

1. 打开你的仓库：
   ```
   https://github.com/Excaliiiibur/pg9.4test
   ```

2. 你会看到一个黄色横幅：
   ```
   test-ai-review had recent pushes
   ```

3. 点击 **"Compare & pull request"** 按钮

4. 填写 PR 信息：
   ```
   标题: test: Verify AI-powered code review system
   
   描述:
   This pull request tests the AI-powered code review system.
   The code intentionally includes several issues for the AI to review:
   - Buffer overflow risk (strcpy without size limit)
   - Memory leak (palloc without pfree documentation)
   - Inefficient algorithm (O(n²) nested loop)
   ```

5. 点击 **"Create pull request"**

---

## ⚡ 第 4 步：等待并查看自动审查结果

### ⏱️ 等待时间：30 秒 - 2 分钟

### 📍 查看自动评论

打开你的 PR 页面，点击 **"Conversation"** 标签

你应该看到来自 `github-actions` 的自动评论：

```
🤖 AI Code Review Bot

## 📊 代码审查报告

### 检测到的问题

1. **[严重] 缓冲区溢出风险**
   - 文件: src/test_ai_review.c, 第 12 行
   - 问题: strcpy 没有大小限制
   - 建议: 使用 strncpy 或更安全的函数

2. **[中等] 内存泄漏**
   - 文件: src/test_ai_review.c, 第 18 行
   - 问题: palloc 分配的内存需要 pfree 释放
   - 建议: 在函数文档中明确说明调用者责任

3. **[中等] 性能问题**
   - 文件: src/test_ai_review.c, 第 24 行
   - 问题: O(n²) 嵌套循环
   - 建议: 考虑使用哈希表优化搜索
```

### ✅ 验证成功的标志

检查以下是否都存在：

- [ ] PR 页面打开正常
- [ ] Conversation 标签有自动评论
- [ ] 自动评论提到了代码中的问题（缓冲区溢出、内存泄漏、性能）
- [ ] Checks 标签显示 "AI Code Review" 工作流（状态✅通过）
- [ ] 工作流运行时间在 30 秒 - 2 分钟之间

---

## 🔍 如果没有看到自动评论

### 检查 1：查看 Actions 日志

1. 打开 PR 页面
2. 点击 **"Checks"** 标签
3. 点击 **"AI Code Review"** 工作流
4. 查看每个步骤的日志

### 检查 2：确认 Actions 是否运行

访问你的仓库的 Actions 页面：
```
https://github.com/Excaliiiibur/pg9.4test/actions
```

你应该看到最近的工作流运行记录。

### 检查 3：刷新页面和等待

- 等待 2-3 分钟后，刷新 PR 页面（Ctrl+F5 强制刷新）
- GitHub Actions 有时需要时间来启动

---

## 🚀 快速命令总结

复制即用：

```powershell
# 第 2 步：创建测试分支和文件
cd c:\data\code\postgres-9.4.24
git checkout -b test-ai-review

if (-not (Test-Path src)) {
    New-Item -ItemType Directory -Path src
}

@"
#include "postgres.h"
#include <string.h>

void test_strcpy_issue(const char *input) {
    char buffer[256];
    strcpy(buffer, input);
}

char* test_memory_leak() {
    char *ptr = palloc(1024);
    ptr[0] = 'a';
    return ptr;
}

void inefficient_search(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (arr[i] == arr[j]) break;
        }
    }
}
"@ | Out-File -Encoding UTF8 src/test_ai_review.c

git add src/test_ai_review.c
git commit -m "test: Add file to verify AI code review"
git push -u origin test-ai-review
```

之后打开这个链接查看 PR：
```
https://github.com/Excaliiiibur/pg9.4test/pulls
```

---

## 📝 检查清单

在进行下一步之前，请确认：

- [ ] 代码已推送到 master 分支（仓库网页能看到所有文件）
- [ ] `.github/` 文件夹在仓库中可见
- [ ] 已进入仓库 Settings → Actions，启用权限
- [ ] 已创建 test-ai-review 分支和测试文件
- [ ] 已创建 PR
- [ ] 已看到自动审查评论

---

## ❓ 常见问题

**Q: 为什么没有看到自动评论？**
A: 
1. 等待 2-3 分钟，刷新页面
2. 检查 Actions 标签下是否有工作流运行
3. 检查 Actions 日志中是否有错误

**Q: 推送失败了怎么办？**
A: 如果遇到身份验证错误，可以使用 Personal Access Token：

```powershell
# 在 GitHub Settings → Developer settings → Personal access tokens 生成 token
# 然后运行：
git remote set-url origin "https://Excaliiiibur:YOUR_TOKEN@github.com/Excaliiiibur/pg9.4test.git"
git push -u origin test-ai-review
```

**Q: 自动审查提到的都是什么问题？**
A: AI 会检查：
- 内存安全（缓冲区溢出、内存泄漏）
- 代码性能（算法复杂度）
- 代码质量（命名、结构）
- PostgreSQL 最佳实践

---

## 🎯 下一步

当你成功看到自动审查评论后：

1. ✅ **验证系统工作** - 确认 AI 审查功能已在你的仓库运行
2. 📚 **查看 SETUP_AI_REVIEW_CN.md** - 配置真实的 AI 后端（Copilot/GPT-4/Claude）
3. 🔧 **自定义审查规则** - 编辑 `.github/copilot-instructions.md` 调整审查标准
4. 🚀 **应用到真实代码** - 在你的实际项目中使用 AI code review

---

需要帮助吗？让我知道！ 🎉
