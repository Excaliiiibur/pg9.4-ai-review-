# PostgreSQL AI 代码审查系统

通过 GitHub Copilot 和自定义指令实现自动化代码审查的完整解决方案。

## 📁 文件结构概览

```
.github/
├── 📄 copilot-instructions.md          ⭐ 主审查准则
├── 📄 README.md（English）            
├── 📄 README_CN.md（中文 ←你在这里）
├── 📄 QUICK_REFERENCE.md              ⚡ 快速参考
├── 📄 SETUP_AI_REVIEW.md              🔧 集成指南
├── 📄 CODEOWNERS                      👥 代码所有者
├── 📄 pull_request_template.md        📋 PR 模板
├── workflows/
│   └── ai-review.yml                  🤖 自动工作流
└── agents/
    ├── security-reviewer.agent.md     🔒 安全审查
    ├── performance-reviewer.agent.md  ⚡ 性能审查
    └── quality-reviewer.agent.md      🎨 质量审查
```

## 🎯 核心功能

### ✅ 自动 PR 审查  
当你创建或更新 Pull Request 时，AI 自动审查代码并发表评论。

### ✅ 多维度分析
- **🔒 安全性** - SQL 注入、缓冲区溢出、权限检查
- **⚡ 性能** - 算法复杂度、查询优化、资源使用
- **🎨 代码质量** - 命名规范、可维护性、设计模式
- **✓ 正确性** - 内存安全、错误处理、NULL 检查
- **🌍 兼容性** - 平台支持、字节序、类型安全

### ✅ PostgreSQL 特定检查
- 内存管理（palloc/pfree）
- 错误处理（ereport/elog）
- 分布式锁使用
- 事务处理
- 扩展开发规范

### ✅ 灵活的 AI 集成
支持多种 AI 后端：
- GitHub Copilot Chat API（推荐）
- OpenAI GPT-4
- Claude API
- 本地工具（cppcheck 等）

## 🚀 快速开始

### 第 1 步：提交配置文件

```bash
cd /path/to/postgres
git add .github/
git commit -m "feat: Add AI-powered code review with Copilot instructions"
git push
```

### 第 2 步：（可选）配置 AI 后端

参考 `SETUP_AI_REVIEW.md` 文件选择和配置你偏好的 AI 服务。

### 第 3 步：创建测试 PR

```bash
git checkout -b test-ai-review
echo "# Test" >> README.md
git add README.md
git commit -m "test: Verify AI review"
git push origin test-ai-review
# 在 GitHub 上创建 PR
```

查看 PR 中的自动审查评论！

## 📚 文档导航

### 核心文档

| 文档 | 内容 | 读者 |
|------|------|------|
| **copilot-instructions.md** | AI 如何审查代码的完整准则 | AI 和审查者 |
| **README.md** | 英文系统文档 | 英文使用者 |
| **README_CN.md** | 中文系统文档（本文件） | 中文使用者 |
| **QUICK_REFERENCE.md** | 快速参考和命令清单 | 所有用户 |
| **SETUP_AI_REVIEW.md** | AI 服务集成指南 | 系统管理员 |

### 配置文件

| 文件 | 用途 |
|-----|------|
| **CODEOWNERS** | 代码所有者自动分配 |
| **pull_request_template.md** | PR 提交模板 |

### 工作流和代理

| 文件 | 用途 |
|-----|------|
| **workflows/ai-review.yml** | GitHub Actions 自动化工作流 |
| **agents/security-reviewer.agent.md** | 专业安全审查 |
| **agents/performance-reviewer.agent.md** | 专业性能审查 |
| **agents/quality-reviewer.agent.md** | 专业代码质量审查 |

## 💡 工作流原理

```
1. 开发者创建/更新 PR
    ↓
2. GitHub Actions 自动触发
    ↓
3. AI 进行多维度分析
    ├─ 安全性检查
    ├─ 性能分析
    ├─ 代码质量审查
    ├─ 正确性验证
    └─ 兼容性检查
    ↓
4. 在 PR 评论中发表审查意见
    ↓
5. 开发者查看反馈并修改
    ↓
6. 新提交触发重新审查
```

## 🔍 审查维度详解

### 安全性检查 🔒

检查项：
- SQL 注入漏洞
- 缓冲区溢出风险
- 权限验证
- 加密操作
- 敏感数据处理

### 性能分析 ⚡

检查项：
- 算法复杂度（O(n²) 检测）
- N+1 查询问题
- 内存使用效率
- I/O 操作优化
- 锁竞争

### 代码质量 🎨

检查项：
- 命名规范（小写_下划线）
- 函数大小（< 100 行）
- 代码重复
- 圈复杂度
- 注释质量

### 正确性验证 ✓

检查项：
- 内存泄漏
- 错误处理
- NULL 检查
- 资源清理
- 异常安全

### 兼容性检查 🌍

检查项：
- 平台特定代码
- 字节序假设
- 整数类型安全
- UTF-8 编码

## 📋 展示审查结果的示例

### ✓ 好的审查意见

> "第 42 行的 `palloc()` 应该在第 67 行的错误路径中有对应的 `pfree()`。  
> 建议用 `PG_TRY/PG_CATCH` 块包裹以确保清理。"

### 💡 建议性反馈

> "这个查询对每一行都执行全表扫描。  
> 建议在 'status' 列上添加索引或改写为自连接以消除 N+1 模式。"

### ⚠ 安全问题标记

> "发现 SQL 注入风险：第 88 行使用了字符串连接。  
> 应使用参数化查询（$1、$2 等）而不是字符串插值。"

## 🔧 定制和优化

### 修改审查标准

编辑 `copilot-instructions.md` 根据团队需要调整：
- 优先级设置
- 检查项添加/删除
- 代码示例更新
- PostgreSQL 版本特定检查

### 修改监控文件

编辑 `workflows/ai-review.yml` 的 `paths` 部分：
```yaml
paths:
  - '**.c'              # C 源代码
  - '**.h'              # 头文件
  - '**.sql'            # SQL 脚本
  - '**/Makefile*'      # 构建文件
  - '!doc/**'           # 排除文档
```

### 调整代码所有者

编辑 `CODEOWNERS` 分配审查者：
```
/src/backend/storage/ @storage-team
/src/backend/optimizer/ @optimizer-team
```

## 🎯 高级用法

### 请求特定类型审查

在 PR 评论中：
```
@github-actions review-security
@github-actions review-performance
@github-actions review-quality
```

### PR 标签标记

在 PR 描述中使用标签：
```
标签: security-critical      # 重点安全审查
标签: performance-critical   # 重点性能审查
标签: code-quality-focus     # 重点质量审查
```

## 📊 预期效果

### 代码质量提升
- ✓ 减少 50-70% 的代码审查时间
- ✓ 发现更多潜在问题
- ✓ 提高代码一致性
- ✓ 改善文档完整性

### 开发效率提升
- ✓ 快速反馈循环
- ✓ 开发者学习机会
- ✓ 减少人力手动审查
- ✓ 更快的 PR 合并

### 风险降低
- ✓ 早期发现安全问题
- ✓ 防止性能回归
- ✓ 提高覆盖率
- ✓ 减少运行时错误

## 🔐 安全最佳实践

### API 密钥保护
- ⚠ 存储在 GitHub Secrets，不在代码中
- ⚠ 使用最小权限原则
- ⚠ 定期轮换密钥

### 代码隐私
- ⚠ 公开代码使用开源或自托管 AI
- ⚠ 私密项目可使用商业 API
- ⚠ 定期审查 AI 输出

### 访问控制
- ⚠ 限制工作流触发权限
- ⚠ 监控 API 使用
- ⚠ 设置使用配额

## ❓ FAQ

### Q: 工作流为什么不运行？
**A:** 检查以下内容：
1. `paths` 配置是否匹配你的更改
2. 工作流 YAML 语法是否正确
3. Actions 选项卡查看详细日志

### Q: 审查质量如何改进？
**A:** 可以尝试：
1. 优化 `copilot-instructions.md` 中的提示
2. 为工作流提供更多上下文
3. 使用更高级的 AI 模型（如 GPT-4）

### Q: 如何处理 False Positive？
**A:**
1. 在 PR 中标记 false positive
2. 团队可调整规则避免重复
3. 更新 `copilot-instructions.md`

### Q: 支持哪些编程语言？
**A:** 当前主要针对：
- 🔴 C 语言（重点）
- 🟡 SQL（部分支持）
- 🟢 Makefile 脚本

## 🎓 后续步骤

### 立即行动 ✅
- [ ] 提交所有 `.github/` 文件
- [ ] 推送到 main 分支
- [ ] 创建测试 PR 验证

### 配置阶段（1-2 天）
- [ ] 选择 AI 后端
- [ ] 配置 API 密钥
- [ ] 完成集成测试

### 优化阶段（1 周）
- [ ] 根据反馈调整准则
- [ ] 微调工作流
- [ ] 培训团队使用

### 长期维护
- [ ] 每季度审查一次准则
- [ ] 监控工作流执行
- [ ] 收集团队反馈

## 📚 参考资源

### 官方文档
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [GitHub Copilot 文档](https://docs.github.com/en/copilot)
- [PostgreSQL 开发指南](https://www.postgresql.org/docs/current/source.html)

### AI 服务文档
- [OpenAI API](https://platform.openai.com/docs)
- [Claude API](https://www.anthropic.com/api)
- [GitHub Copilot Chat](https://docs.github.com/en/copilot/overview-of-github-copilot/about-github-copilot-chat-in-the-ides)

## 💬 反馈和改进

遇到问题或有改进建议？

1. 创建 Issue 描述问题或建议
2. 提交 PR 贡献改进
3. 在讨论中分享使用体验

## 📞 技术支持

### 常见问题解答
- 查看 `QUICK_REFERENCE.md` 获取常见命令
- 查看 `SETUP_AI_REVIEW.md` 获取集成帮助
- 检查 GitHub Actions 日志获取具体错误

### 获取帮助
- 📖 完整文档在 `README.md`
- ⚡ 快速参考在 `QUICK_REFERENCE.md`
- 🔧 集成问题查看 `SETUP_AI_REVIEW.md`

---

**版本**: 1.0  
**创建日期**: 2024 年  
**适用对象**: PostgreSQL 9.4+  
**语言**: 中文  
**维护者**: PostgreSQL 开发团队

🎊 **祝你使用愉快！** 🎊
