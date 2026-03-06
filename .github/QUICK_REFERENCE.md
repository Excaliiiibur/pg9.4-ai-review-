# 快速参考指南：PostgreSQL AI 代码审查系统

## 📂 已创建的文件

### 核心文件
| 文件 | 用途 | 优先级 |
|-----|------|--------|
| `.github/copilot-instructions.md` | **主审查准则** - AI 如何审查代码的核心指导 | ⭐⭐⭐ |
| `.github/workflows/ai-review.yml` | **自动化工作流** - 在 PR 时自动触发审查 | ⭐⭐⭐ |

### 审查代理
| 文件 | 焦点 | 用途 |
|-----|------|------|
| `.github/agents/security-reviewer.agent.md` | 🔒 安全性 | 检测 SQL 注入、缓冲区溢出、权限问题 |
| `.github/agents/performance-reviewer.agent.md` | ⚡ 性能 | 分析算法、查询优化、资源使用 |
| `.github/agents/quality-reviewer.agent.md` | 🎨 代码质量 | 验证风格、可维护性、PostgreSQL 约定 |

### 配置和指南
| 文件 | 内容 |
|-----|------|
| `.github/README.md` | 📖 **主文档** - 系统架构和使用指南 |
| `.github/SETUP_AI_REVIEW.md` | 🔧 **集成指南** - 如何启用 AI 服务 |
| `.github/CODEOWNERS` | 👥 **代码所有者** - 自动分配审查者 |
| `.github/pull_request_template.md` | 📋 **PR 模板** - 帮助开发者提供信息 |

## 🚀 如何使用

### 1️⃣ 提交更改并创建 PR

```bash
git add .github/
git commit -m "feat: Add AI-powered code review system"
git push origin your-branch
# 在 GitHub 上创建 PR
```

### 2️⃣ 工作流自动触发

- ✓ PR 创建时自动运行
- ✓ 新提交时自动更新
- ✓ 结果显示在 PR 评论中

### 3️⃣ 配置 AI 后端（可选）

选择一个 AI 服务：
- **推荐**: GitHub Copilot Chat API
- **替代**: OpenAI GPT-4
- **替代**: Claude API
- **本地**: cppcheck 和其他工具

详见 `.github/SETUP_AI_REVIEW.md`

## 📊 审查维度

### 安全性 🔒
```
✓ SQL 注入漏洞
✓ 缓冲区溢出风险
✓ 权限验证
✓ 加密操作
```

### 性能 ⚡
```
✓ 算法复杂度（O(n²) 检测）
✓ N+1 查询问题
✓ 内存使用效率
✓ I/O 操作优化
```

### 代码质量 🎨
```
✓ 命名约定（lowercase_with_underscores）
✓ 函数大小（< 100 行）
✓ 代码复用机会
✓ 注释质量
✓ PostgreSQL 最佳实践
```

## 🎯 常见工作流

### 场景 A: 自动 PR 审查（默认）

```
创建 PR → 工作流自动运行 → 审查评论出现 → 修改代码 → 自动重审
```

### 场景 B: 请求特定审查

在 PR 评论中：
```
@github-actions review-security
@github-actions review-performance
@github-actions review-quality
```

### 场景 C: 自定义准则

编辑 `.github/copilot-instructions.md` 调整：
- 检查项优先级
- PostgreSQL 版本特定检查
- 团队特定约定

## 🔧 配置选项

### 修改监控的文件类型

编辑 `.github/workflows/ai-review.yml`:
```yaml
paths:
  - '**.c'           # C 文件
  - '**.h'           # 头文件
  - '**.sql'         # SQL 文件
  - '**/Makefile*'   # Makefile
  - '!doc/**'        # 排除 doc/
```

### 修改审查标准

编辑 `.github/copilot-instructions.md` 中的相关章节：
- 第 1 部分：代码正确性
- 第 2 部分：性能
- 第 3 部分：代码质量
- 第 4-8 部分：特定领域

## 📋 完整文件列表

```
.github/
├── copilot-instructions.md              ✓ 主审查准则 (7 个部分)
├── README.md                            ✓ 系统文档
├── SETUP_AI_REVIEW.md                   ✓ 集成指南
├── CODEOWNERS                           ✓ 代码所有者配置
├── pull_request_template.md             ✓ PR 模板
├── workflows/
│   └── ai-review.yml                    ✓ 自动化工作流
└── agents/
    ├── security-reviewer.agent.md       ✓ 安全审查代理
    ├── performance-reviewer.agent.md    ✓ 性能审查代理
    └── quality-reviewer.agent.md        ✓ 代码质量审查代理
```

总计: **11 个文件** ✓ 全部已创建

## ⚡ 快速命令

```bash
# 提交所有配置文件
git add .github/
git commit -m "feat: Add AI-powered code review with Copilot instructions"

# 查看工作流状态
git log --oneline .github/workflows/ai-review.yml

# 编辑主审查准则
code .github/copilot-instructions.md

# 编辑集成指南
code .github/SETUP_AI_REVIEW.md

# 查看工作流运行（GitHub Actions）
# GitHub 仓库 → Actions → AI Code Review
```

## 🔐 安全检查清单

- [ ] API 密钥存储在 Secrets 中（不在代码中）
- [ ] 工作流只在允许的文件上运行
- [ ] 代码审查注释不包含敏感信息
- [ ] 定期审查 AI 输出的准确性
- [ ] 限制访问权限（如果需要）

## 📞 故障排除

### 工作流不运行
1. 检查 `paths` 配置是否匹配您的更改
2. 验证工作流 YAML 语法
3. 查看 Actions 选项卡查看运行日志

### 审查质量低
1. 调整 `.github/copilot-instructions.md` 中的提示
2. 为工作流提供更多上下文
3. 使用更高级的 AI 模型

### API 错误
1. 验证 API 密钥已正确配置
2. 检查 API 配额和限制
3. 查看详细的错误日志

## 📚 详细文档

- **主文档**: `.github/README.md` - 完整系统架构
- **集成指南**: `.github/SETUP_AI_REVIEW.md` - AI 服务集成
- **主审查准则**: `.github/copilot-instructions.md` - 审查标准

## 🎓 后续步骤

1. ✅ **基础设置完成** - 所有文件已创建
2. ⏭️ **下一步**: 选择 AI 后端并配置（见 `SETUP_AI_REVIEW.md`）
3. ⏭️ **测试**: 创建 PR 验证工作流
4. ⏭️ **优化**: 根据团队反馈调整准则

## 💡 提示

- **快速查看**: 查看 `.github/README.md` 获得完整概述
- **快速配置**: 查看 `.github/SETUP_AI_REVIEW.md`
- **调整审查**: 编辑 `.github/copilot-instructions.md`
- **特定领域**: 使用 `.github/agents/` 中的代理进行深度分析

---

**版本**: 1.0  
**创建日期**: 2024 年  
**系统完整性**: ✓ 全部文件已创建
