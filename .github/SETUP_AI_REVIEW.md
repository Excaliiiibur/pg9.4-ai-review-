# GitHub Copilot 代码审查集成指南

此文档说明如何启用通过 `.github/copilot-instructions.md` 进行的自动 AI 代码审查。

## 📁 文件结构

```
.github/
├── copilot-instructions.md          # AI 审查准则和标准
├── workflows/
│   └── ai-review.yml               # 自动审查工作流
└── (可选) 其他配置
    ├── codeowners                  # 代码所有者（用于自动分配）
    └── pull_request_template.md    # PR 模板
```

## 🚀 快速开始

### 1. 基础设置（已完成）

✓ `.github/copilot-instructions.md` - PostgreSQL 代码审查指南
✓ `.github/workflows/ai-review.yml` - GitHub Actions 工作流

### 2. 启用 AI 集成（选择一种）

#### 方案 A: GitHub Copilot Chat API（推荐）

**前提条件**:
- 组织已启用 GitHub Copilot
- 对 Copilot Chat API 的访问权限

**配置步骤**:

1. 在仓库设置中添加 Secret:
   ```
   Settings > Secrets and variables > Actions > New repository secret
   ```
   - 名称: `COPILOT_API_KEY`
   - 值: 您的 GitHub Copilot API 密钥

2. 修改 `.github/workflows/ai-review.yml`，添加以下步骤：

```yaml
  - name: Run Copilot Code Review
    env:
      GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      COPILOT_API_KEY: ${{ secrets.COPILOT_API_KEY }}
    run: |
      # 使用 Copilot Chat API 进行审查
      # 需要使用 GitHub Copilot CLI 或自定义脚本
      gh copilot explain << 'EOF'
      $(git diff origin/${{ github.base_ref }}...HEAD)
      EOF
```

#### 方案 B: OpenAI API（GPT-4）

**前提条件**:
- OpenAI API 账户
- 有效的 API 密钥

**配置步骤**:

1. 添加 Secret:
   ```
   Settings > Secrets and variables > Actions > New repository secret
   ```
   - 名称: `OPENAI_API_KEY`
   - 值: 您的 OpenAI API 密钥

2. 在工作流中使用（示例脚本）：

```bash
#!/bin/bash
# 调用 OpenAI API 进行代码审查
curl https://api.openai.com/v1/chat/completions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4",
    "messages": [{
      "role": "system",
      "content": "$(cat .github/copilot-instructions.md)",
      "role": "user",
      "content": "Review this code:\n$(git diff)"
    }]
  }'
```

#### 方案 C: Claude API（由 Anthropic）

**前提条件**:
- Anthropic API 账户  
- 有效的 API 密钥

**配置步骤**:

1. 添加 Secret:
   ```
   Settings > Secrets and variables > Actions > New repository secret
   ```
   - 名称: `CLAUDE_API_KEY`
   - 值: 您的 Claude API 密钥

2. 使用 Claude 进行审查...

#### 方案 D: 本地规则 + 静态分析

无需外部 API，使用现有工具：

```bash
# 已包含在工作流中的工具：
- cppcheck         # C 代码静态分析
- shellcheck       # Shell 脚本检查  
- clang-format     # 格式检查
- 自定义 linting 规则
```

## 📋 使用指南

### 自动触发

当在以下情况时，工作流自动运行：
- 创建新 Pull Request
- 向现有 PR 推送新提交
- 重新打开已关闭的 PR

**受监控的文件类型**:
- `**.c`, `**.h` - C 源代码和头文件
- `**.sql` - SQL 脚本
- `**/Makefile*` - 构建文件

### 审查标准

工作流应用以下审查维度（来自 `.github/copilot-instructions.md`）：

| 维度 | 内容 | 优先级 |
|------|------|--------|
| 正确性 | 内存管理、错误处理、NULL 检查 | P0 |
| 性能 | 算法复杂度、查询优化、资源使用 | P1 |
| 质量 | 命名、函数大小、代码复用 | P2 |
| 兼容性 | 平台支持、字节序、整数类型 | P1 |
| 安全性 | SQL 注入、缓冲区溢出、权限检查 | P0 |
| 测试 | 测试覆盖率、边界情况、文档 | P2 |

### 手动触发审查

可以在 PR 评论中请求特定的 AI 审查：

```
@github-actions review-performance
@github-actions review-security  
@github-actions review-style
```

## 🔧 自定义配置

### 修改审查范围

编辑 `.github/workflows/ai-review.yml` 中的 `paths` 部分：

```yaml
on:
  pull_request:
    paths:
      - '**.c'           # C 源文件
      - '**.h'           # 头文件
      - '**.sql'         # SQL 文件
      - '**/Makefile*'   # Makefile
      - '!doc/**'        # 排除 doc 文件夹
```

### 修改审查准则

编辑 `.github/copilot-instructions.md`，调整：

- 代码风格偏好
- 性能要求
- 安全审查标准
- 平台兼容性要求
- PostgreSQL 特定的检查

## 📝 审查评论格式

AI 应该提供的审查包括：

```markdown
## 代码审查

### ✓ 优点
- 内存管理正确
- 错误处理完善

### ⚠ 关注点
- **[严重]** 潜在的缓冲区溢出...
- **[中等]** 性能可以优化...

### 💡 建议
1. 使用 snprintf 替代 sprintf
2. 添加边界检查

### ✓ 审查清单
- [ ] 通过静态分析
- [ ] 内存安全
- [ ] 性能可接受
- [ ] 文档充分
```

## 🔐 安全最佳实践

1. **API 密钥管理**
   - 使用 GitHub Secrets，不要提交密钥
   - 定期轮换 API 密钥
   - 使用最小权限原则

2. **代码审查敏感性**
   - 不审查私密信息（密码、令牌）
   - 在公开 PR 中谨慎
   - 定期审查 AI 输出的准确性

3. **访问控制**
   - 限制谁可以触发工作流
   - 监控 API 使用
   - 设置使用配额

## 📊 监控和日志

### 查看工作流运行

1. GitHub 仓库 > `Actions` 标签
2. 选择 "AI Code Review" 工作流
3. 点击特定的 PR 运行
4. 查看步骤日志

### 故障排除

**工作流未运行**:
- 检查 `paths` 配置是否匹配您的更改
- 验证工作流文件语法正确（`.github/workflows/ai-review.yml`）

**API 调用失败**:
- 验证 API 密钥已正确配置
- 检查 API 配额和限制
- 查看 Actions 日志中的错误消息

**审查质量差**:
- 优化 `.github/copilot-instructions.md` 中的提示
- 提供更多上下文信息
- 使用更高级的 AI 模型

## 🎯 下一步

1. **提交更改**
   ```bash
   git add .github/
   git commit -m "feat: Add AI-powered code review with Copilot instructions"
   git push
   ```

2. **测试工作流**
   - 创建测试 PR
   - 验证工作流是否运行
   - 查看审查评论

3. **集成 AI 服务**
   - 选择合适的 AI 提供商
   - 配置 API 密钥
   - 更新工作流步骤

4. **优化审查准则**
   - 收集团队反馈
   - 调整 `copilot-instructions.md`
   - 定期审查工作流有效性

## 📚 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [GitHub Copilot API](https://docs.github.com/en/copilot/overview-of-github-copilot/about-github-copilot-chat-in-the-ides)
- [OpenAI API 文档](https://platform.openai.com/docs)
- [Claude API 文档](https://www.anthropic.com/api)

## 💬 反馈和改进

如发现问题或有改进建议，请：
1. 创建 Issue 描述问题
2. 提交 PR 提出改进
3. 在讨论中分享使用体验

---

**最后更新**: 2024 年
**维护者**: PostgreSQL 开发团队
**许可证**: PostgreSQL 许可证
