# 快速部署指南 - pg9.4test 仓库

你的仓库：https://github.com/Excaliiiibur/pg9.4test

## ⚡ 第 1 步：配置本地仓库关联

复制并运行以下命令：

```powershell
# 进入 PostgreSQL 目录
cd c:\data\code\postgres-9.4.24

# 检查是否已有 git 仓库
git status

# 如果是新的仓库，初始化
git init

# 配置用户信息
git config user.name "Excaliiiibur"
git config user.email "your.email@example.com"

# 添加你的远程仓库
git remote add origin https://github.com/Excaliiiibur/pg9.4test.git

# 验证配置
git remote -v
# 应该显示：
# origin  https://github.com/Excaliiiibur/pg9.4test.git (fetch)
# origin  https://github.com/Excaliiiibur/pg9.4test.git (push)
```

---

## ⚡ 第 2 步：添加文件并推送

```powershell
# 添加所有文件到暂存区
git add .

# 查看将要提交的文件
git status

# 创建初始提交
git commit -m "Initial commit: PostgreSQL 9.4 with AI-powered code review system"

# 推送到 GitHub（首次需要用 -u 设置上游分支）
git push -u origin master
```

**如果推送失败（Permission denied），使用 Personal Access Token：**

1. 登录 GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. 点击 "Generate new token"
3. 名称填：`git-push-token`
4. 权限选择 `repo` （完整仓库访问）
5. 点击 "Generate token"
6. 复制生成的 token

然后运行：

```powershell
# 使用 token 认证
git remote set-url origin https://Excaliiiibur:YOUR_TOKEN@github.com/Excaliiiibur/pg9.4test.git

# 重新推送
git push -u origin master
```

---

## ⚡ 第 3 步：启用 GitHub Actions

打开你的仓库设置：

```
https://github.com/Excaliiiibur/pg9.4test/settings/actions
```

### 3.1 启用 Actions 权限

在 "Permissions" 部分：
```
☑ All actions and reusable workflows are allowed
```

### 3.2 设置工作流权限

继续往下到 "Workflow permissions"：
```
☑ Read and write permissions
☑ Allow GitHub Actions to create and approve pull requests
```

点击 "Save" 保存配置。

---

## ⚡ 第 4 步：创建测试分支和 PR

```powershell
# 创建测试分支
git checkout -b test-ai-review

# 创建包含示例问题的测试文件
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

# 添加测试文件
git add src/test_ai_review.c

# 提交
git commit -m "test: Add test file for AI code review verification"

# 推送测试分支
git push -u origin test-ai-review
```

**输出应该显示：**
```
* [new branch]      test-ai-review -> test-ai-review
Branch 'test-ai-review' set to track remote branch 'test-ai-review' from 'origin'.
```

---

## ⚡ 第 5 步：在 GitHub 创建 PR

1. 打开你的仓库：https://github.com/Excaliiiibur/pg9.4test

2. 你应该看到一个黄色横幅：
   ```
   test-ai-review had recent pushes
   ```

3. 点击 "Compare & pull request" 按钮

4. 填写 PR 信息：
   ```
   Title: test: Verify AI-powered code review system
   
   Description:
   This pull request tests the AI-powered code review functionality.
   The code deliberately includes several issues for the AI to review:
   - Buffer overflow risk (strcpy)
   - Memory leak (palloc without pfree)
   - Inefficient algorithm (O(n²))
   ```

5. 点击 "Create pull request"

---

## ⚡ 第 6 步：等待并查看自动审查结果

### 等待时间：30 秒 - 2 分钟

### 查看方式 1：PR 页面 - Conversation 标签

打开 PR 页面，看 "Conversation" 标签，应该看到：

```
🤖 github-actions posted a comment X minutes ago

## 🔍 代码审查结果

### ✓ 优点
代码结构清晰

### ⚠ 关注点
- [严重] 第 10 行: strcpy 没有大小限制
- [中等] 第 15 行: 内存泄漏风险
- [中等] 第 20 行: O(n²) 算法效率低

### 💡 建议
1. 使用 strncpy 替代 strcpy
2. 文档说明调用者需要释放返回的内存
3. 考虑使用哈希表优化搜索

### ✓ 审查清单
- [ ] 通过静态分析
- [ ] 内存安全验证
- [ ] 性能可接受
- [ ] 文档充分
```

### 查看方式 2：PR 页面 - Checks 标签

点击 "Checks" 标签，查看工作流状态：

```
AI Code Review ✅ (Completed)
  ├─ Checkout PR branch
  ├─ Get changed files
  ├─ Static analysis with cppcheck
  ├─ Post initial comment
  ├─ Generate detailed review
  └─ Post comprehensive review
```

### 查看方式 3：Actions 标签

仓库 → Actions 标签 → AI Code Review 工作流 → 查看最新运行

---

## ✅ 验证成功的标志

检查以下项目确认成功：

- [ ] 代码已推送到 GitHub（在仓库网页能看到文件）
- [ ] `.github/workflows/ai-review.yml` 在仓库中可见
- [ ] PR 已创建（PR 页面打开正常）
- [ ] PR 的 "Conversation" 标签有自动评论
- [ ] PR 的 "Checks" 标签显示 "AI Code Review" 工作流
- [ ] 自动评论提到了代码中的问题（缓冲区溢出、内存泄漏、性能问题）

---

## 🐛 常见问题排查

### 推送失败：Permission denied

**解决方案**：使用 Personal Access Token

```powershell
# GitHub Settings → Developer settings → Personal access tokens → Generate
git remote set-url origin https://Excaliiiibur:YOUR_TOKEN@github.com/Excaliiiibur/pg9.4test.git
git push -u origin master
```

### 工作流没有运行

**检查清单**：

```powershell
# 1. 确认文件已推送
git log --oneline -- .github/workflows/ai-review.yml
# 应该看到提交记录

# 2. 检查工作流文件是否存在
git ls-tree HEAD .github/workflows/
# 应该显示 ai-review.yml

# 3. 检查 .github 目录是否被 .gitignore 忽略
cat .gitignore | grep ".github"
# 应该没有 .github 的忽略规则
```

### 自动评论没有出现

**等待 1-2 分钟后刷新页面**，如果还是没有：

```
1. 打开 PR 页面
2. 点击 "Checks" 标签
3. 查看 "AI Code Review" 工作流
4. 点击 "Details" 查看运行日志
5. 查看每个步骤的输出，找出问题
```

---

## 📝 完整命令总结

```powershell
# ============ 第 1-2 步：配置和推送 ============
cd c:\data\code\postgres-9.4.24
git init
git config user.name "Excaliiiibur"
git config user.email "your@email.com"
git remote add origin https://github.com/Excaliiiibur/pg9.4test.git
git add .
git commit -m "Initial commit: PostgreSQL 9.4 with AI review"
git push -u origin master

# ============ 第 4 步：创建测试 PR ============
git checkout -b test-ai-review

# 创建测试文件（参考上面的代码）
# ... 创建 src/test_ai_review.c ...

git add src/test_ai_review.c
git commit -m "test: Verify AI code review"
git push -u origin test-ai-review

# ============ 第 3, 5, 6 步：在 GitHub 完成 ============
# 1. 打开 Settings → Actions，启用权限
# 2. 创建 PR（GitHub 网页）
# 3. 等待并查看自动审查结果
```

---

## 🎉 成功后的下一步

当验证 AI 自动审查功能已生效后，你可以：

1. **在真实代码上测试**
   ```bash
   git checkout master
   git checkout -b add-new-feature
   # 修改实际代码
   git push -u origin add-new-feature
   # 创建 PR → 查看审查
   ```

2. **配置真实 AI 后端**
   - 参考 `.github/SETUP_AI_REVIEW_CN.md`
   - 选择 Copilot/GPT-4/Claude/本地工具

3. **自定义审查规则**
   - 编辑 `.github/copilot-instructions.md`
   - 调整优先级和检查项

4. **与团队分享**
   - 分享仓库 URL
   - 让团队成员创建 PR
   - 所有 PR 都会自动审查

---

需要帮你检查什么吗？或者有任何问题？ 🚀
