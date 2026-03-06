# 快速参考指南：PostgreSQL AI 代码审查系统（中文）

## 📂 已创建的文件概览

### 核心文件（必需）
| 文件 | 用途 | 优先级 |
|-----|------|--------|
| `copilot-instructions.md` | **主审查准则** - AI 如何审查代码的核心指导 | ⭐⭐⭐ |
| `workflows/ai-review.yml` | **自动化工作流** - 在 PR 时自动触发审查 | ⭐⭐⭐ |

### 审查代理（可选但推荐）
| 文件 | 焦点 | 用途 |
|-----|------|------|
| `agents/security-reviewer.agent.md` | 🔒 安全性 | 检测 SQL 注入、缓冲区溢出、权限问题 |
| `agents/performance-reviewer.agent.md` | ⚡ 性能 | 分析算法、查询优化、资源使用 |
| `agents/quality-reviewer.agent.md` | 🎨 代码质量 | 验证风格、可维护性、PostgreSQL 约定 |

### 配置和文档
| 文件 | 内容 |
|-----|------|
| `README.md` | 📖 英文系统文档 |
| `README_CN.md` | 📖 **中文系统文档** |
| `SETUP_AI_REVIEW.md` | 🔧 英文集成指南 |
| `SETUP_AI_REVIEW_CN.md` | 🔧 **中文集成指南** |
| `CODEOWNERS` | 👥 代码所有者配置 |
| `pull_request_template.md` | 📋 PR 提交模板 |

## 🚀 使用方法

### 1️⃣ 第一次使用？提交代码

```bash
# 添加所有配置文件
git add .github/

# 提交
git commit -m "feat: Add AI-powered code review system"

# 推送
git push origin main
```

### 2️⃣ 配置 AI 后端（可选）

参考 `SETUP_AI_REVIEW_CN.md` 选择一个方案：

| 方案 | 优势 | 成本 |
|------|------|------|
| **Copilot** | 🟢 原生集成 | 组织订阅费 |
| **GPT-4** | 🟢 功能强 | 按使用付费 |
| **Claude** | 🟢 精准分析 | 按使用付费 |
| **本地工具** | 🟢 免费 | 0 元 |

### 3️⃣ 创建测试 PR

```bash
# 创建分支
git checkout -b test-ai-review

# 修改一个文件
echo "# Test" >> README.md

# 提交
git add README.md
git commit -m "test: Verify AI review"

# 推送
git push origin test-ai-review

# 在 GitHub 网页上创建 PR
# → PR 中会自动出现审查评论
```

### 4️⃣ 查看审查结果

在 PR 页面查看自动添加的评论。

## 📊 审查维度

### 🔒 安全性
```
检查项：
✓ SQL 注入漏洞
✓ 缓冲区溢出风险
✓ 权限验证
✓ 加密操作
```

### ⚡ 性能
```
检查项：
✓ 算法复杂度（O(n²) 检测）
✓ N+1 查询问题
✓ 内存使用效率
✓ I/O 操作优化
```

### 🎨 代码质量
```
检查项：
✓ 命名约定（lowercase_with_underscores）
✓ 函数大小（< 100 行）
✓ 代码复用机会
✓ 注释质量
✓ PostgreSQL 最佳实践
```

## 🎯 常见工作流

### 场景 A：自动 PR 审查（默认）
```
创建 PR → 工作流自动运行 → 审查评论出现 → 修改代码 → 自动重审
```

### 场景 B：请求特定审查
在 PR 评论中发表：
```
@github-actions review-security
@github-actions review-performance
@github-actions review-quality
```

### 场景 C：自定义审查准则
编辑 `copilot-instructions.md` 调整：
- 检查项优先级
- PostgreSQL 版本特定检查
- 团队特定约定

## 🔧 配置命令速查

### 编辑审查准则
```bash
code .github/copilot-instructions.md
```

### 编辑工作流
```bash
code .github/workflows/ai-review.yml
```

### 编辑集成指南
```bash
code .github/SETUP_AI_REVIEW_CN.md
```

### 查看工作流运行状态
```bash
# GitHub 网页：
# Repository → Actions → AI Code Review

# 或命令行：
gh run list --workflow=ai-review.yml
```

## ⚡ 快速修改

### 修改监控的文件类型
编辑 `ai-review.yml` 中的 `paths`:
```yaml
paths:
  - '**.c'           # 添加 .c 文件
  - '**.h'           # 添加 .h 文件
  - '**.sql'         # 添加 SQL 文件
  - '**/Makefile*'   # 添加 Makefile
  - '!doc/**'        # 排除 doc 文件夹
```

### 调整审查标准
编辑 `copilot-instructions.md`:
- 第 1-7 部分：各审查维度
- 修改优先级、添加/删除检查项

### 分配代码所有者
编辑 `CODEOWNERS`:
```
/src/backend/storage/ @storage-team
/src/backend/optimizer/ @optimizer-team
```

## 📋 文件完整清单

```
.github/
├── 📄 copilot-instructions.md         ✓ 主审查准则
├── 📄 README.md                       ✓ 英文文档
├── 📄 README_CN.md                    ✓ 中文文档
├── 📄 QUICK_REFERENCE.md              ✓ 快速参考
├── 📄 SETUP_AI_REVIEW.md              ✓ 英文集成指南
├── 📄 SETUP_AI_REVIEW_CN.md           ✓ 中文集成指南
├── 📄 CODEOWNERS                      ✓ 代码所有者
├── 📄 pull_request_template.md        ✓ PR 模板
├── workflows/
│   └── ai-review.yml                  ✓ 工作流
└── agents/
    ├── security-reviewer.agent.md     ✓ 安全代理
    ├── performance-reviewer.agent.md  ✓ 性能代理
    └── quality-reviewer.agent.md      ✓ 质量代理
```

总计: **14 个文件** ✓ 全部已创建

## 🔐 安全检查清单

- [ ] API 密钥存储在 Secrets 中（不在代码中）
- [ ] 工作流只在允许的文件上运行
- [ ] 代码审查注释不包含敏感信息
- [ ] 定期审查 AI 输出的准确性
- [ ] 限制访问权限（如需要）

## ❓ 快速问答

**Q: 工作流不运行怎么办？**
A: 检查 `paths` 配置是否匹配你的更改文件。

**Q: 如何改变审查标准？**
A: 编辑 `copilot-instructions.md`。

**Q: 支持哪些编程语言？**
A: 主要支持 C、SQL、Makefile。

**Q: 如何禁用某个检查？**
A: 在 `copilot-instructions.md` 中注释或删除。

**Q: 成本是多少？**
A: 取决于 AI 后端。Copilot 需订阅，GPT-4/Claude 按使用付费，本地工具免费。

## 📚 详细文档

- **主文档**: `README_CN.md` - 系统架构和使用
- **集成指南**: `SETUP_AI_REVIEW_CN.md` - AI 服务配置
- **主准则**: `copilot-instructions.md` - 审查标准

## 🎓 后续步骤

1. ✅ **基础设置完成** - 所有文件已创建
2. ⏭️ **下一步**: 提交文件（第 1 步）
3. ⏭️ **配置 AI**: 按指南配置（可选）
4. ⏭️ **测试**: 创建测试 PR（第 3 步）
5. ⏭️ **优化**: 根据反馈调整

## 💡 省时技巧

- 使用本地工具节省 API 成本
- 定期审查 AI 输出保证质量
- 更新 PR 模板指引开发者
- 在 CODEOWNERS 中分配审查者

## 📞 需要帮助？

| 问题 | 解决方案 |
|------|---------|
| 工作流错误 | 查看 Actions 日志 |
| API 问题 | 检查 Secrets 和配额 |
| 审查质量 | 优化 copilot-instructions.md |
| 性能问题 | 限制审查文件大小 |

---

**版本**: 1.0  
**最后更新**: 2024 年  
**语言**: 中文  
**系统完整性**: ✓ 全部文件已创建

**🎊 祝你使用愉快！** 🚀
