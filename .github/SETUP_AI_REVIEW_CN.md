# PostgreSQL AI 代码审查 - 集成配置指南

本文档说明如何配置和启用通过 `.github/copilot-instructions.md` 进行的自动 AI 代码审查。

## 📁 文件架构

```
.github/
├── copilot-instructions.md          # AI 审查准则和标准
├── workflows/
│   └── ai-review.yml               # 自动审查工作流
└── README_CN.md                    # 中文系统文档
```

## 🚀 快速开始

### 1️⃣ 基础设置（已完成）

✓ `copilot-instructions.md` - PostgreSQL 代码审查指南  
✓ `workflows/ai-review.yml` - GitHub Actions 工作流

### 2️⃣ 启用 AI 集成（选择一种）

选择下列方案之一来集成 AI:

---

## 方案 A：GitHub Copilot Chat API（⭐ 推荐）

**原因推荐**：
- 与 GitHub 原生集成
- 无需管理额外 API 密钥
- 支持组织级别的 Copilot 订阅

**前提条件**：
- 你的组织已启用 GitHub Copilot
- 对 Copilot Chat API 的访问权限

**配置步骤**：

### 步骤 1：在 GitHub 中启用 Copilot

1. 进入组织设置：`Settings` → `Copilot`
2. 选择要启用 Copilot 的用户或团队
3. 确保已安装 GitHub Copilot 扩展

### 步骤 2：配置工作流

在 `.github/workflows/ai-review.yml` 中，使用 Copilot Chat API：

```yaml
- name: 使用 Copilot 进行代码审查
  env:
    GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  run: |
    # Copilot CLI 自动使用 GITHUB_TOKEN
    gh copilot explain << 'EOF'
    $(git diff origin/${{ github.base_ref }}...HEAD)
    EOF
```

### 步骤 3：测试

创建 PR 并检查输出。

---

## 方案 B：OpenAI API（GPT-4）

**特点**：
- 功能强大的 GPT-4 模型
- 需要独立的 OpenAI 账户
- 按使用量付费

**前提条件**：
- OpenAI API 账户
- 有效的 API 密钥和充足的额度

**配置步骤**：

### 步骤 1：创建 API 密钥

1. 访问 [platform.openai.com](https://platform.openai.com)
2. 登录并进入 `API keys` 部分
3. 点击 "Create new secret key"
4. 复制并安全保存密钥

### 步骤 2：添加 Secret

在 GitHub 仓库中：
1. 进入 `Settings` → `Secrets and variables` → `Actions`
2. 点击 "New repository secret"
3. 名称：`OPENAI_API_KEY`
4. 值：粘贴你的 OpenAI API 密钥
5. 点击 "Add secret"

### 步骤 3：更新工作流

在 `.github/workflows/ai-review.yml` 中添加：

```yaml
- name: 使用 GPT-4 进行代码审查
  env:
    OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
  run: |
    # 调用 OpenAI API 进行代码审查
    curl https://api.openai.com/v1/chat/completions \
      -H "Authorization: Bearer $OPENAI_API_KEY" \
      -H "Content-Type: application/json" \
      -d '{
        "model": "gpt-4",
        "temperature": 0.7,
        "max_tokens": 2000,
        "messages": [
          {
            "role": "system",
            "content": "'"$(cat .github/copilot-instructions.md)"'"
          },
          {
            "role": "user",
            "content": "审查此 PR 的代码变更:\n'"$(git diff origin/${{ github.base_ref }}...HEAD | head -1000)"'"
          }
        ]
      }' > review_result.json
    
    # 提取并发表评论
    cat review_result.json | jq -r '.choices[0].message.content' > review.md
```

### 步骤 4：测试

创建 PR 并验证审查。

**费用估算**：
- 2,000 字的输入：约 $0.01
- 平均 PR 审查成本：$0.02-0.05

---

## 方案 C：Claude API（由 Anthropic）

**特点**：
- 精准的代码分析
- 支持更大的上下文窗口
- 按使用量付费

**前提条件**：
- Anthropic API 账户
- 有效的 API 密钥和额度

**配置步骤**：

### 步骤 1：获取 Claude API 密钥

1. 访问 [console.anthropic.com](https://console.anthropic.com)
2. 登录或注册
3. 进入 `API keys`
4. 创建新密钥
5. 复制密钥

### 步骤 2：添加 Secret

在 GitHub 仓库中：
1. `Settings` → `Secrets and variables` → `Actions`
2. "New repository secret"
3. 名称：`CLAUDE_API_KEY`
4. 值：粘贴 Claude API 密钥

### 步骤 3：更新工作流

```yaml
- name: 使用 Claude 进行代码审查
  env:
    CLAUDE_API_KEY: ${{ secrets.CLAUDE_API_KEY }}
  run: |
    # 调用 Claude API
    curl https://api.anthropic.com/v1/messages \
      -H "x-api-key: $CLAUDE_API_KEY" \
      -H "anthropic-version: 2023-06-01" \
      -H "content-type: application/json" \
      -d '{
        "model": "claude-opus",
        "max_tokens": 2000,
        "system": "'"$(cat .github/copilot-instructions.md)"'",
        "messages": [
          {
            "role": "user",
            "content": "审查代码:\n'"$(git diff origin/${{ github.base_ref }}...HEAD | head -1000)"'"
          }
        ]
      }' > review.json
```

---

## 方案 D：本地工具（无 API 成本）

**特点**：
- 完全免费
- 无需外部 API
- 支持离线使用

**前提条件**：
- 已安装的本地工具：`cppcheck`、`shellcheck` 等

**包含的工具**：
- `cppcheck` - C 代码静态分析
- `shellcheck` - Shell 脚本检查
- `clang-format` - C 代码格式检查

**配置步骤**：

### 步骤 1：安装工具

```bash
# Ubuntu/Debian
sudo apt-get install cppcheck shellcheck clang-format

# macOS
brew install cppcheck shellcheck clang-format

# Windows (Chocolatey)
choco install cppcheck shellcheck clang-format
```

### 步骤 2：工作流已包含

`ai-review.yml` 已经包含本地工具检查：

```yaml
- name: 运行静态分析（cppcheck）
  run: |
    cppcheck --enable=all --suppress=missingIncludeSystem \
      ${{ steps.changed-files.outputs.c_files }}
```

### 步骤 3：验证

工作流将自动运行本地检查，无需额外配置。

---

## 📋 AI 服务对比

| 特性 | Copilot | GPT-4 | Claude | 本地工具 |
|------|---------|-------|--------|---------|
| 成本 | 订阅费 | / 查询 | / 查询 | 免费 |
| 集成难度 | 🟢 简单 | 🟡 中等 | 🟡 中等 | 🟢 简单 |
| 分析能力 | 🟡 中等 | 🟢 优秀 | 🟢 优秀 | 🟡 基础 |
| 上下文大小 | 中等 | 大 | 很大 | 受限 |
| 离线支持 | ❌ | ❌ | ❌ | ✅ |

## 🔧 工作流配置详解

### 监控文件类型

编辑 `ai-review.yml`，修改 `on.pull_request.paths` 部分：

```yaml
on:
  pull_request:
    paths:
      - '**.c'              # C 源文件
      - '**.h'              # 头文件
      - '**.sql'            # SQL 脚本
      - '**/Makefile*'      # Makefile
      - '!doc/**'           # 排除 doc/ 文件夹
      - '!contrib/**'       # 排除 contrib/ 文件夹
```

### 调整触发条件

```yaml
on:
  pull_request:
    types: [opened, synchronize, reopened]  # 何时运行
    branches:
      - main                              # 仅在 main 分支
      - develop
```

### 添加权限

```yaml
permissions:
  pull-requests: write    # 允许发表评论
  contents: read         # 允许读取代码
  checks: write          # 允许创建检查
```

## 📝 发表审查意见

工作流会在 PR 中自动发表评论。审查意见格式：

```markdown
## 🔍 PostgreSQL 代码审查结果

### ✓ 优点
- 内存管理正确
- 错误处理完善

### ⚠ 关注点
- **[严重]** 潜在的 SQL 注入...
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

### API 密钥管理

✅ **正确做法**：
```yaml
env:
  API_KEY: ${{ secrets.MY_API_KEY }}  # 使用 Secrets
```

❌ **错误做法**：
```yaml
env:
  API_KEY: "sk-..."  # 永远不要在代码中硬编码！
```

### Secrets 安全性

1. **不要提交密钥**
   - `.gitignore` 应包含 `.env` 等文件
   - 使用 GitHub Secrets 而不是环境文件

2. **定期轮换**
   - 每 3-6 个月更换一次 API 密钥
   - 如果密钥泄露立即更换

3. **最小权限**
   - 为 API 密钥设置最小必要权限
   - 使用只读权限如果可能

### 代码审查敏感性

⚠ **注意**：
- 不审查包含密码或令牌的代码
- 公开 PR 中谨慎处理敏感信息
- 定期审查 AI 输出的准确性

## 📊 监控和日志

### 查看工作流运行

1. 进入仓库主页
2. 点击 "Actions" 标签
3. 选择 "AI Code Review" 工作流
4. 点击特定的 PR 运行
5. 查看详细日志

### 调试工作流

常见日志位置：
- 工作流初始化错误
- 步骤执行失败
- API 调用错误
- 输出格式问题

### 常见错误和解决方案

**错误**：工作流未运行

**原因**：
- `paths` 配置不匹配你的更改
- 工作流 YAML 语法错误

**解决**：
1. 检查 `paths` 配置
2. 验证 YAML 缩进和语法
3. 查看 Actions 日志

---

**错误**：API 调用失败

**原因**：
- API 密钥不正确或过期
- API 配额已用完
- 网络连接问题

**解决**：
1. 验证 API 密钥在 Secrets 中
2. 检查 API 账户额度
3. 查看 API 返回的错误信息

---

**错误**：审查结果为空

**原因**：
- AI 模型超时
- 提示词不适配

**解决**：
1. 提供更清晰的提示
2. 增加超时时间
3. 检查模型选择

## 🎯 优化建议

### 1. 提高审查质量

- 优化 `copilot-instructions.md` 中的提示
- 为 AI 提供充足的上下文
- 使用更高级的 AI 模型

### 2. 减少成本

- 使用本地工具进行基础检查
- 限制审查文件大小
- 缓存审查结果

### 3. 提升性能

- 并行运行多个审查代理
- 优化代码差异大小
- 缓存分析结果

## 📚 相关资源

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [OpenAI API 文档](https://platform.openai.com/docs)
- [Claude API 文档](https://www.anthropic.com/api)
- [GitHub Copilot 文档](https://docs.github.com/en/copilot)

## 💬 故障排除

### 工作流不触发

```bash
# 检查工作流文件语法
yamllint .github/workflows/ai-review.yml

# 查看完整日志
gh run list --workflow=ai-review.yml
```

### API 连接问题

```bash
# 测试 API 连接
curl -X GET https://api.openai.com/v1/models \
  -H "Authorization: Bearer $OPENAI_API_KEY"
```

## 🎓 下一步

1. ✅ 选择合适的 AI 后端
2. ✅ 按照上述步骤配置
3. ✅ 创建测试 PR 验证
4. ✅ 根据反馈优化设置

---

**版本**: 1.0  
**创建日期**: 2024 年  
**语言**: 中文
