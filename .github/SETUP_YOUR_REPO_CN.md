# 个人仓库设置与测试指南

本指南帮助你创建自己的 GitHub 仓库，推送代码，并验证 AI 自动审查 PR 功能。

## 📋 前置条件

- ✅ GitHub 账户（免费账户即可）
- ✅ Git 已安装在本地
- ✅ 已有 PostgreSQL 代码（或本指南的 .github 配置）

## 🚀 第 1 步：在 GitHub 上创建仓库

### 方法 A：通过网页创建（推荐）

1. **登录 GitHub**
   - 打开 https://github.com
   - 登录你的账户

2. **创建新仓库**
   - 点击右上角 `+` 图标
   - 选择 "New repository"

3. **仓库设置**
   ```
   Repository name: postgres-ai-review
   Description: PostgreSQL with AI-powered code review
   Visibility: Public 或 Private（任意）
   ☐ Initialize with README（先不选）
   ☐ Add .gitignore（先不选）
   ☐ Add license（先不选）
   ```

4. **创建**
   - 点击 "Create repository"
   - 你会看到一个空仓库页面，显示推送指令

5. **记录仓库 URL**
   ```
   https://github.com/YOUR_USERNAME/postgres-ai-review.git
   ```

### 方法 B：通过 GitHub CLI 创建

```bash
# 安装 GitHub CLI（如果还没有）
# https://cli.github.com

# 登录 GitHub
gh auth login

# 创建仓库
gh repo create postgres-ai-review --public --source=. --remote=origin --push
```

---

## 🔧 第 2 步：配置本地 Git 仓库

### 步骤 1：进入 PostgreSQL 目录

```bash
cd c:\data\code\postgres-9.4.24
```

### 步骤 2：初始化 Git（如果还没有）

```bash
# 检查是否已经是 git 仓库
git status

# 如果提示 "fatal: not a git repository"，执行：
git init
```

### 步骤 3：配置用户信息

```bash
# 设置用户名
git config user.name "Your Name"

# 设置邮箱
git config user.email "your.email@example.com"

# 查看配置
git config --list
```

### 步骤 4：添加 Remote（关联远程仓库）

```bash
# 添加你自己的仓库作为 origin
git remote add origin https://github.com/YOUR_USERNAME/postgres-ai-review.git

# 如果已经有 origin，先删除再添加
git remote remove origin
git remote add origin https://github.com/YOUR_USERNAME/postgres-ai-review.git

# 验证配置
git remote -v
# 应该显示：
# origin  https://github.com/YOUR_USERNAME/postgres-ai-review.git (fetch)
# origin  https://github.com/YOUR_USERNAME/postgres-ai-review.git (push)
```

### 步骤 5：添加所有文件

```bash
# 添加所有文件到暂存区
git add .

# 查看要提交的文件
git status

# 应该看到包括：
# - .github/copilot-instructions.md
# - .github/workflows/ai-review.yml
# - .github/agents/*.md
# - src/ 目录下的 PostgreSQL 源代码
```

### 步骤 6：创建初始提交

```bash
# 提交
git commit -m "Initial commit: PostgreSQL with AI-powered code review system"

# 查看提交历史
git log --oneline
```

### 步骤 7：推送到 GitHub

```bash
# 首次推送需要设置上游分支
git push -u origin master

# 或者如果默认分支是 main
git push -u origin main

# 下次推送可以简写
git push
```

如果出现认证问题，使用个人访问令牌：

```bash
# 1. 在 GitHub 创建 Personal Access Token
#    Settings → Developer settings → Personal access tokens → Tokens (classic)
#    权限选择：repo (完整 repo 访问)

# 2. 复制令牌

# 3. 推送时粘贴令牌作为密码
git push -u origin master
# 输入用户名：YOUR_USERNAME
# 输入密码：粘贴令牌
```

**推送成功后**应该看到：
```
Enumerating objects: 123, done.
Counting objects: 100% (123/123), done.
...
 * [new branch]      master -> master
Branch 'master' set to track remote branch 'master' from 'origin'.
```

---

## ✅ 第 3 步：在 GitHub 启用 Actions

### 步骤 1：打开仓库设置

1. 打开你的仓库：`https://github.com/YOUR_USERNAME/postgres-ai-review`
2. 点击 "Settings" 标签
3. 左侧菜单选择 "Actions"

### 步骤 2：启用 GitHub Actions

```
General → Actions → Permissions

选择：
• All actions and reusable workflows are allowed
```

### 步骤 3：允许 Actions 推送

```
Actions → General → Workflow permissions

选择：
• Read and write permissions
☑ Allow GitHub Actions to create and approve pull requests
```

---

## 🧪 第 4 步：创建测试 PR 验证自动审查

### 步骤 1：创建测试分支

```bash
# 创建并切换到新分支
git checkout -b test-ai-review

# 或者分步操作
git branch test-ai-review
git checkout test-ai-review

# 验证分支
git branch -v
```

### 步骤 2：创建测试代码文件

创建一个包含问题的测试文件来验证审查功能：

```bash
# 创建测试文件
cat > src/test_ai_review.c << 'EOF'
#include "postgres.h"
#include <string.h>

/*
 * 这个函数故意包含几个审查会发现的问题
 * 用来验证 AI 自动审查功能是否生效
 */

/* 问题 1：缓冲区溢出风险 */
void vulnerable_strcpy_example(char *user_input) {
    char buffer[256];
    strcpy(buffer, user_input);  // ⚠️ 应该使用 strncpy
    printf("Data: %s\n", buffer);
}

/* 问题 2：内存泄漏 */
char* memory_leak_example() {
    char *data = palloc(1024);
    data[0] = 'a';
    return data;  // 缺少 pfree - 内存泄漏
}

/* 问题 3：O(n²) 算法 */
void inefficient_algorithm(int *array, int size) {
    // N^2 复杂度 - 在大数据集上效率低
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            if (array[i] == array[j] && i != j) {
                printf("Duplicate found\n");
            }
        }
    }
}

/* 问题 4：无效的错误处理 */
void bad_error_handling() {
    FILE *f = fopen("/tmp/test.txt", "r");
    // 缺少 NULL 检查
    fgets(NULL, 100, f);
    fclose(f);
}
EOF
```

### 步骤 3：提交测试文件

```bash
# 添加文件
git add src/test_ai_review.c

# 查看状态
git status

# 提交
git commit -m "test: Add test file for AI code review verification"
```

### 步骤 4：推送分支

```bash
# 推送新分支
git push -u origin test-ai-review

# 输出应该显示：
# * [new branch]      test-ai-review -> test-ai-review
# Branch 'test-ai-review' set to track remote branch...
```

### 步骤 5：在 GitHub 创建 PR

1. **打开你的仓库页面**
   ```
   https://github.com/YOUR_USERNAME/postgres-ai-review
   ```

2. **创建 PR**
   - 你应该看到一个黄色通知栏："test-ai-review had recent pushes"
   - 点击 "Compare & pull request"
   - 或者点击 "Pull requests" 标签 → "New pull request"

3. **填写 PR 信息**
   ```
   Base: master (或 main)
   Compare: test-ai-review
   
   Title: test: Verify AI code review functionality
   
   Description:
   This PR is for testing the AI-powered code review system.
   The code intentionally contains issues to verify the review works.
   ```

4. **创建 PR**
   - 点击 "Create pull request"

---

## 🔍 第 5 步：验证自动审查是否生效

### 立即检查

**创建 PR 后立即查看（等待几秒）：**

1. **查看 PR 评论**
   ```
   PR 页面 → Conversation 标签
   应该看到来自 github-actions 的评论
   ```

2. **查看工作流状态**
   ```
   PR 页面 → Checks 标签
   应该看到 "AI Code Review" 工作流
   ```

### 详细检查

**查看工作流运行详情：**

```bash
# 使用命令行查看
gh pr list
gh run list --workflow=ai-review.yml
gh run view <run-id>
```

**查看 Actions 日志：**

1. 打开仓库
2. 点击 "Actions" 标签
3. 选择 "AI Code Review" 工作流
4. 点击最近的运行
5. 查看各步骤的输出

### ✅ 预期结果

如果一切正常，应该看到：

```
✅ 工作流状态：Completed
   ├─ Checkout PR branch
   ├─ Get changed files
   ├─ Static analysis (cppcheck)
   ├─ Post review comment
   └─ Summary

✅ PR 评论包含：
   ├─ 🤖 AI Code Review Starting
   ├─ [严重] 缓冲区溢出风险 (strcpy)
   ├─ [中等] 内存泄漏风险 (palloc)
   ├─ [中等] 性能问题 (O(n²) 算法)
   ├─ [中等] 缺少错误检查
   └─ 建议和审查清单
```

---

## ⚠️ 常见问题排查

### 问题 1：工作流不运行

**症状**：PR 创建后没有 "Checks" 标签或显示 "No checks have been run yet"

**原因**：
1. Actions 未启用
2. 工作流文件语法错误
3. 分支保护规则阻止

**解决**：
```bash
# 检查工作流文件是否存在
ls .github/workflows/ai-review.yml

# 检查 YAML 语法
cat .github/workflows/ai-review.yml | head -20

# 确认已推送 .github 目录
git log --oneline -- .github/
```

### 问题 2：工作流失败

**症状**：工作流显示为红色 ✗

**查看日志**：
1. PR → Checks → AI Code Review → Details
2. 展开失败的步骤
3. 查看错误信息

**常见错误**：
```
• "File not found" → .github/workflow/ai-review.yml 路径错误
• "YAML syntax error" → 检查缩进
• "Permission denied" → 检查权限配置
```

### 问题 3：审查评论为空

**原因**：
1. AI 后端未配置（当前默认显示模板）
2. 代码变更不匹配监控路径

**检查**：
```bash
# 变更的文件是否在 paths 中？
git diff HEAD~1 --name-only
# 应该包含：.c, .h, .sql, Makefile*

# 工作流完整运行了吗？
# 检查日志的最后一步
```

### 问题 4：无法推送到 GitHub

**错误**: "Permission denied"

**解决**：

```bash
# 方法 1：使用 HTTPS + Personal Access Token
git remote set-url origin https://YOUR_USERNAME:YOUR_TOKEN@github.com/YOUR_USERNAME/postgres-ai-review.git

# 方法 2：使用 SSH
ssh-keygen -t ed25519 -C "your.email@example.com"
# 将公钥添加到 GitHub Settings → SSH and GPG keys
git remote set-url origin git@github.com:YOUR_USERNAME/postgres-ai-review.git

# 方法 3：使用 GitHub CLI
gh auth refresh
gh repo set-default YOUR_USERNAME/postgres-ai-review
```

---

## 📊 完整工作流演示

### 从创建仓库到验证的完整命令

```bash
# 1. 创建仓库（GitHub 网页）
# 2. 配置本地
cd c:\data\code\postgres-9.4.24
git init
git config user.name "Your Name"
git config user.email "your@email.com"
git remote add origin https://github.com/YOUR_USERNAME/postgres-ai-review.git

# 3. 提交初始代码
git add .
git commit -m "Initial commit with AI review system"
git push -u origin master

# 4. 启用 Actions（GitHub 网页）
# Settings → Actions → Permissions

# 5. 创建测试分支和 PR
git checkout -b test-ai-review
cat > src/test_ai_review.c << 'EOF'
#include "postgres.h"
#include <string.h>
void test() {
    char buf[256];
    strcpy(buf, "test");  // 问题代码
}
EOF
git add src/test_ai_review.c
git commit -m "test: Verify AI review"
git push -u origin test-ai-review

# 6. 创建 PR（GitHub 网页）
# Compare & pull request → Create pull request

# 7. 等待 AI 审查（30 秒 - 2 分钟）

# 8. 查看结果
# PR → Conversation / Checks

# 9. 查看日志（可选）
gh run list --workflow=ai-review.yml
gh run view <run-id>
```

---

## 🎓 下一步

1. ✅ 创建仓库
2. ✅ 推送代码
3. ✅ 创建测试 PR
4. ✅ 验证自动审查功能
5. ⏭️ 配置 AI 后端（参考 `SETUP_AI_REVIEW_CN.md`）
6. ⏭️ 在真实项目中使用

---

## 📚 快速参考

| 任务 | 命令 |
|------|------|
| 创建分支 | `git checkout -b branch-name` |
| 推送分支 | `git push -u origin branch-name` |
| 创建提交 | `git commit -m "message"` |
| 查看提交 | `git log --oneline` |
| 查看分支 | `git branch -v` |
| 查看远程 | `git remote -v` |

---

**需要帮助？查看 GitHub 文档：**
- [GitHub 入门指南](https://docs.github.com/en/get-started)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [Git 官方文文档](https://git-scm.com/doc)

祝你测试顺利！🚀
