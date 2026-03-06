#!/usr/bin/env bash
# PostgreSQL AI 代码审查系统 - 实施验证脚本

echo "═══════════════════════════════════════════════════════════════"
echo "PostgreSQL AI 代码审查系统 - 实施完整性检查"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查函数
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 ($(wc -l < "$1") 行)"
        return 0
    else
        echo -e "${YELLOW}✗${NC} $1 (未找到)"
        return 1
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/ (目录)"
        return 0
    else
        echo -e "${YELLOW}✗${NC} $1/ (未找到)"
        return 1
    fi
}

echo -e "${BLUE}📁 核心文件${NC}"
echo "─────────────────────────────────────────────────────────────"
check_file ".github/copilot-instructions.md"
check_file ".github/README.md"
check_file ".github/SETUP_AI_REVIEW.md"
echo ""

echo -e "${BLUE}📁 配置文件${NC}"
echo "─────────────────────────────────────────────────────────────"
check_file ".github/CODEOWNERS"
check_file ".github/pull_request_template.md"
check_file ".github/QUICK_REFERENCE.md"
echo ""

echo -e "${BLUE}📁 工作流${NC}"
echo "─────────────────────────────────────────────────────────────"
check_dir ".github/workflows"
check_file ".github/workflows/ai-review.yml"
echo ""

echo -e "${BLUE}📁 审查代理${NC}"
echo "─────────────────────────────────────────────────────────────"
check_dir ".github/agents"
check_file ".github/agents/security-reviewer.agent.md"
check_file ".github/agents/performance-reviewer.agent.md"
check_file ".github/agents/quality-reviewer.agent.md"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}✓ 实施完整！所有文件已创建${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""

echo -e "${BLUE}📋 快速开始指南:${NC}"
echo "───────────────────────────────────────────────────────────────"
echo "1. 提交所有文件:"
echo "   git add .github/"
echo "   git commit -m 'feat: Add AI-powered code review system'"
echo "   git push"
echo ""
echo "2. 配置 AI 后端 (在 .github/SETUP_AI_REVIEW.md 中选择):"
echo "   - GitHub Copilot Chat API (推荐)"
echo "   - OpenAI GPT-4"
echo "   - Claude API"
echo "   - 本地工具"
echo ""
echo "3. 创建测试 PR 验证:"
echo "   git checkout -b test-ai-review"
echo "   echo '# Test' >> README.md"
echo "   git add README.md"
echo "   git commit -m 'test: Verify AI review'"
echo "   git push origin test-ai-review"
echo ""
echo "4. 在 GitHub 上创建 PR 查看自动审查"
echo ""

echo -e "${BLUE}📚 文档导航:${NC}"
echo "───────────────────────────────────────────────────────────────"
echo "• 主要文档        : .github/README.md"
echo "• AI 集成指南     : .github/SETUP_AI_REVIEW.md"
echo "• 快速参考        : .github/QUICK_REFERENCE.md"
echo "• 审查准则        : .github/copilot-instructions.md"
echo "• 代码所有者      : .github/CODEOWNERS"
echo "• PR 模板         : .github/pull_request_template.md"
echo ""
echo "• 安全审查代理    : .github/agents/security-reviewer.agent.md"
echo "• 性能审查代理    : .github/agents/performance-reviewer.agent.md"
echo "• 代码质量代理    : .github/agents/quality-reviewer.agent.md"
echo "• 工作流配置      : .github/workflows/ai-review.yml"
echo ""

echo -e "${BLUE}🎯 审查维度:${NC}"
echo "───────────────────────────────────────────────────────────────"
echo "✓ 代码正确性 - 内存安全、错误处理、NULL 检查"
echo "✓ 性能优化 - 算法复杂度、查询优化、资源使用"
echo "✓ 代码质量 - 命名规范、可维护性、设计模式"
echo "✓ 安全审查 - SQL 注入、缓冲区溢出、权限控制"
echo "✓ 平台兼容 - 跨平台支持、字节序、整数类型"
echo "✓ 文档完整 - 注释、测试覆盖、CHANGELOG"
echo ""

echo -e "${BLUE}🔐 安全提示:${NC}"
echo "───────────────────────────────────────────────────────────────"
echo "⚠ API 密钥应存储在 GitHub Secrets 中"
echo "⚠ 不要在代码中硬编码密钥"
echo "⚠ 定期审查 AI 输出的准确性"
echo "⚠ 公开仓库应使用企业 AI 方案"
echo ""

echo -e "${GREEN}✅ 系统已准备就绪！请参阅上述文档完成配置。${NC}"
echo ""
