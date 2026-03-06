# PostgreSQL AI 代码审查系统

通过 GitHub Copilot 和自定义指令实现自动化代码审查的完整指南。

## 📁 系统架构

```
.github/
├── copilot-instructions.md          # 主审查准则（通用）
├── SETUP_AI_REVIEW.md               # 集成配置指南
├── workflows/
│   └── ai-review.yml               # GitHub Actions 工作流
└── agents/                          # 特定领域的审查代理
    ├── security-reviewer.agent.md   # 安全审查
    ├── performance-reviewer.agent.md # 性能审查
    └── quality-reviewer.agent.md    # 代码质量审查
```

## 🎯 核心功能

### 1. **自动 PR 审查** 
- 当创建或更新 PR 时自动触发
- 应用 `.github/copilot-instructions.md` 中的准则
- 支持多种 AI 后端集成

### 2. **多维度审查**
| 审查类型 | 焦点 | 代理文件 |
|---------|------|--------|
| 安全性 | SQL 注入、缓冲区溢出、权限 | `security-reviewer.agent.md` |
| 性能 | 算法复杂度、查询优化、资源使用 | `performance-reviewer.agent.md` |
| 代码质量 | 命名规范、可维护性、设计模式 | `quality-reviewer.agent.md` |

### 3. **定制化指令** 
- 针对 PostgreSQL 的特定最佳实践
- 内存管理检查（palloc/pfree）
- 并发控制检查
- 平台兼容性验证

## 🚀 快速开始

### 步骤 1: 获取文件（已完成）

所有必要文件已在 `.github/` 目录中创建：

```bash
.github/
├── copilot-instructions.md       # ✓ 已创建
├── SETUP_AI_REVIEW.md            # ✓ 已创建
├── workflows/
│   └── ai-review.yml             # ✓ 已创建
└── agents/
    ├── security-reviewer.agent.md   # ✓ 已创建
    ├── performance-reviewer.agent.md # ✓ 已创建
    └── quality-reviewer.agent.md    # ✓ 已创建
```

### 步骤 2: 配置 AI 后端

选择一个 AI 服务并配置（详见 `SETUP_AI_REVIEW.md`）：

**推荐优先级**:
1. ✅ **GitHub Copilot Chat API** - 最好集成
2. 🔹 **OpenAI GPT-4** - 功能强大
3. 🔹 **Claude API** - 精准分析
4. 🔹 **本地工具** - 无需 API（cppcheck 等）

### 步骤 3: 初始化仓库

```bash
# 提交配置文件
git add .github/
git commit -m "feat: Add AI-powered code review with Copilot instructions"
git push origin main

# 创建测试 PR 验证
git checkout -b test-ai-review
echo "# Test PR" >> README.md
git add README.md
git commit -m "test: Verify AI review workflow"
git push origin test-ai-review
# 在 GitHub 上创建 PR...
```

### 步骤 4: 查看工作流运行

1. 进入仓库 → `Actions` 标签
2. 查看 "AI Code Review" 工作流
3. 检查 PR 中的审查评论

## 📋 文件说明

### `.github/copilot-instructions.md` 
**主文件**，定义 AI 应该如何审查代码。

包含内容：
- 内存管理检查（是否正确使用 palloc/pfree）
- 错误处理验证（ereport 用法）
- 性能分析（是否有 O(n²) 算法）
- 代码质量评估（命名规范、函数大小）
- 平台兼容性检查
- 安全审查清单
- PostgreSQL 特定模式识别

### `.github/workflows/ai-review.yml`
**自动化工作流**，在 PR 事件时运行。

触发条件：
- PR 创建
- PR 更新（新提交）
- PR 重新打开

监控文件类型：
- `*.c` - C 源代码
- `*.h` - 头文件
- `*.sql` - SQL 脚本
- `Makefile*` - 构建文件

### `.github/agents/*.agent.md`
**专业审查代理**，针对特定维度。

使用场景：
- 需要特定领域审查时
- 用户在 PR 评论中请求（例如 `@review-security`）
- 工作流触发特定类型的分析

## 💡 使用示例

### 场景 1: 自动 PR 审查

```
1. 开发者创建 PR 并推送代码
2. GitHub Actions 自动触发 `ai-review.yml`
3. 工作流：
   - 获取变更的文件
   - 运行静态分析（cppcheck）
   - 应用 copilot-instructions.md 的规则
   - 生成审查意见
4. 在 PR 中发表评论，包含审查结果
5. 开发者根据反馈修改代码
```

### 场景 2: 请求特定审查

```
PR 评论中：
@github-actions review-security

工作流：
- 负载 security-reviewer.agent.md
- 重点检查：SQL 注入、缓冲区溢出、权限
- 生成深度安全分析
```

### 场景 3: 性能关键代码

```
PR 描述中标记：
label: performance-critical

工作流：
- 负载 performance-reviewer.agent.md
- 检查算法复杂度
- 分析数据库查询计划
- 验证内存使用
```

## 🔧 配置调整

### 修改审查范围

编辑 `workflows/ai-review.yml`：

```yaml
on:
  pull_request:
    paths:
      - '**.c'              # C 文件
      - '**.h'              # 头文件
      - '**/*.sql'          # SQL 文件
      - '!doc/**'           # 排除 doc/
      - '!contrib/**'       # 排除 contrib/
```

### 自定义审查准则

编辑 `copilot-instructions.md`：

- 修改优先级（从 P0 到 P3）
- 增加/删除检查项
- 调整代码示例
- 适配团队标准

### 添加新的审查类型

在 `agents/` 目录中创建新文件：

```bash
.github/agents/new-reviewer.agent.md
```

使用与现有代理相同的格式。

## 🔐 安全和隐私

### 保护 API 密钥

```yaml
# .github/workflows/ai-review.yml 中：
env:
  OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
  CLAUDE_API_KEY: ${{ secrets.CLAUDE_API_KEY }}
```

**不要**:
- 在代码中硬编码密钥
- 提交密钥到仓库
- 在日志中打印敏感信息

### 代码隐私考虑

- 不要将私有代码发送到公开的 AI API
- 公开仓库应只使用自托管或企业 AI 方案
- 定期审查 AI 输出的准确性

## 📊 监控和调试

### 查看工作流日志

```
GitHub 仓库 → Actions → AI Code Review → 选择运行 → 查看日志
```

### 常见问题

**工作流未运行**:
- 检查 `paths` 配置（是否匹配您的更改）
- 验证工作流 YAML 语法
- 查看仓库的 Actions 权限设置

**审查质量低**:
- 优化 `copilot-instructions.md` 中的提示
- 提供更多上下文
- 使用高级 AI 模型（GPT-4 vs GPT-3.5）

**API 失败**:
- 验证 API 密钥配置
- 检查 API 配额
- 查看 Actions 日志获取错误信息

## 📚 文件清单

### 核心文件（必需）
- ✓ `copilot-instructions.md` - 主审查准则
- ✓ `workflows/ai-review.yml` - 自动化工作流

### 支持文件（推荐）
- ✓ `agents/security-reviewer.agent.md` - 安全审查
- ✓ `agents/performance-reviewer.agent.md` - 性能审查
- ✓ `agents/quality-reviewer.agent.md` - 代码质量审查
- ✓ `SETUP_AI_REVIEW.md` - 集成指南

### 可选文件
- `codeowners` - 自动分配审查者
- `pull_request_template.md` - PR 模板
- `.editorconfig` - 编辑器配置

## 🎓 学习资源

### PostgreSQL 相关
- [PostgreSQL 开发者 Wiki](https://wiki.postgresql.org/)
- [PostgreSQL 编码规范](https://www.postgresql.org/docs/current/source.html)
- [C 编程最佳实践](https://www.postgresql.org/docs/current/source.html)

### AI 代码审查
- [GitHub Copilot 文档](https://docs.github.com/en/copilot)
- [OpenAI API 参考](https://platform.openai.com/docs/api-reference)
- [Claude API 文档](https://www.anthropic.com/api)

### GitHub Actions
- [GitHub Actions 指南](https://docs.github.com/en/actions)
- [工作流语法](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [环境变量和 Secrets](https://docs.github.com/en/actions/security-for-github-actions)

## 🤝 贡献和改进

如有改进建议：

1. 创建 Issue 描述建议
2. 提交 PR 贡献改进
3. 分享使用体验和最佳实践

## 📝 维护说明

### 定期审查

- 每季度查看一次审查准则的有效性
- 根据团队反馈调整规则
- 更新 AI 模型版本

### 版本控制

```bash
# 记录准则变更
git log --oneline .github/copilot-instructions.md

# 查看特定修改
git show commit_hash:.github/copilot-instructions.md
```

## 📞 支持

遇到问题？

1. 检查 `SETUP_AI_REVIEW.md` 中的常见问题
2. 查看 GitHub Actions 日志
3. 查看相关 API 文档
4. 在仓库 Issues 中提问

---

**系统版本**: 1.0  
**创建日期**: 2024 年  
**最后更新**: 2024 年  
**适用版本**: PostgreSQL 9.4+  
**维护者**: PostgreSQL 开发团队
