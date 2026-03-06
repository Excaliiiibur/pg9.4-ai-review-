# 🚀 快速启动清单 - 3 分钟完成验证

你的仓库：**https://github.com/Excaliiiibur/pg9.4test**

---

## ✅ 已完成的步骤

- [x] PostgreSQL 代码已推送到 master 分支
- [x] AI 代码审查配置文件已上传 (`.github/workflows/ai-review.yml` 等)
- [x] 用户信息配置完毕：`Excaliiiibur` <excalibur@example.com>
- [x] 远程仓库配置为：https://github.com/Excaliiiibur/pg9.4test.git

---

## ⚡ 现在需要你做的（3-4 分钟）

### 步骤 1：启用 GitHub Actions（1 分钟）

👉 打开这个链接：
```
https://github.com/Excaliiiibur/pg9.4test/settings/actions
```

在页面中找到并勾选：
```
☑ All actions and reusable workflows are allowed
☑ Read and write permissions  
☑ Allow GitHub Actions to create and approve pull requests
```

点击 **Save** ✅

---

### 步骤 2：创建测试 PR（2-3 分钟）

在你的电脑上运行这些命令：

```powershell
cd c:\data\code\postgres-9.4.24

# 创建测试分支
git checkout -b test-ai-review

# 创建测试文件夹
if (-not (Test-Path src)) { New-Item -ItemType Directory -Path src }

# 创建包含问题代码的测试文件
@"
#include "postgres.h"
#include <string.h>

void bad_strcpy(const char *input) {
    char buf[256];
    strcpy(buf, input);  // 缓冲区溢出风险！
}
"@ | Out-File -Encoding UTF8 src/test_ai_review.c

# 提交并推送
git add src/test_ai_review.c
git commit -m "test: Verify AI review"
git push -u origin test-ai-review
```

---

### 步骤 3：在 GitHub 创建 PR（1 分钟）

1. 打开仓库：https://github.com/Excaliiiibur/pg9.4test
2. 你会看到黄色横幅提示 "test-ai-review had recent pushes"
3. 点击 **"Compare & pull request"**
4. 点击 **"Create pull request"**

---

### 步骤 4：等待并查看结果（30 秒 - 2 分钟）

打开你创建的 PR，点击 **Conversation** 标签

你应该看到来自 `github-actions` 的evaluation_metrics自动评论，提到代码中的问题：
- 缓冲区溢出
- 内存管理
- 性能问题等

---

## 📊 成功的标志

如果你看到以下任何一个，说明 AI 审查功能工作正常 ✅：

- [ ] PR 的 Conversation 标签有 github-actions 的评论
- [ ] 评论内容提到了你代码中的具体问题
- [ ] PR 的 Checks 标签显示 "AI Code Review" 工作流已通过
- [ ] 工作流运行时间在 30 秒 - 2 分钟之间

---

## 🆘 如果没看到自动评论

1. **等待 2-3 分钟**，然后刷新页面（Ctrl + F5）
2. **检查 Actions** 日志：打开 PR → Checks 标签 → 查看错误信息
3. **验证文件修改**：确保你的 test PR 修改了 `.c` 或 `.h` 文件

---

## 📱 实时监控

```powershell
# 监控你的 Actions 运行
https://github.com/Excaliiiibur/pg9.4test/actions

# 查看你创建的所有 PR
https://github.com/Excaliiiibur/pg9.4test/pulls

# 查看工作流文件（确认已上传）
https://github.com/Excaliiiibur/pg9.4test/blob/master/.github/workflows/ai-review.yml
```

---

## 🎉 验证成功后

当你看到自动审查评论时，继续：

1. **阅读 `.github/SETUP_AI_REVIEW_CN.md`** - 配置真实 AI 后端
2. **编辑 `.github/copilot-instructions.md`** - 自定义审查规则
3. **在真实代码上测试** - 创建实际功能的 PR 看 AI 的审查

---

需要 5 分钟就能完全验证系统工作！

加油 🚀
